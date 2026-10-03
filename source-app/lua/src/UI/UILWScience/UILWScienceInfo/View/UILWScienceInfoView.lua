local UILWScienceInfoView = BaseClass("UILWScienceInfoView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local Item = require("UI.UILWScience.UILWScienceInfo.Component.UILWScienceInfoItem")
local title_text_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local back_btn_path = "Panel"
local return_btn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local desc_text_path = "Root/Content/Up/DesText"
local mid_title_item_path = "Root/Content/Mid/Item"
local content_path = "Root/Content/Mid/Scroll/Viewport/Content"
local item_path = "Root/Content/Mid/Scroll/Viewport/Item"

function UILWScienceInfoView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWScienceInfoView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWScienceInfoView:ComponentDefine()
  self.titleText = self:AddComponent(UIText, title_text_path)
  self.backBtn = self:AddComponent(UIButton, back_btn_path)
  self.backBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn = self:AddComponent(UIButton, return_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.descText = self:AddComponent(UIText, desc_text_path)
  self.midTitleItem = self:AddComponent(Item, mid_title_item_path)
  self.listContent = self:AddComponent(UIBaseContainer, content_path)
  self.listItemPrefab = self.transform:Find(item_path).gameObject
  self.listItemPrefab:GameObjectCreatePool()
end

function UILWScienceInfoView:ComponentDestroy()
  self.titleText = nil
  self.backBtn = nil
  self.closeBtn = nil
  self.descText = nil
  self.midTitleItem = nil
  self.listContent = nil
  self.listItemPrefab = nil
end

function UILWScienceInfoView:DataDefine()
  self.ctrl:SetView(self)
  self.btnCells = {}
end

function UILWScienceInfoView:DataDestroy()
  self.ctrl:ClearView()
  self.btnCells = nil
end

function UILWScienceInfoView:OnEnable()
  base.OnEnable(self)
  self:ReInit()
end

function UILWScienceInfoView:OnDisable()
  base.OnDisable(self)
end

function UILWScienceInfoView:OnAddListener()
  base.OnAddListener(self)
end

function UILWScienceInfoView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWScienceInfoView:ReInit()
  self.scienceId, self.curLevel, self.maxLevel = self:GetUserData()
  local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.scienceId, 1)
  self.titleText:SetLocalText(template.name)
  self.descText:SetLocalText(template.description)
  local params = {
    name = Localization:GetString(GameDialogDefine.LEVEL),
    value = Localization:GetString(130063),
    power = Localization:GetString(100644),
    showBg = 1
  }
  self.midTitleItem:SetData(params)
  self:RefreshContent()
end

function UILWScienceInfoView:ClearContent()
  self.listContent:RemoveComponents(Item)
end

function UILWScienceInfoView:RefreshContent()
  self:ClearContent()
  self.listItemPrefab.gameObject:GameObjectRecycleAll()
  local list = self:GetAllList()
  for k, v in ipairs(list) do
    local item = self.listItemPrefab:GameObjectSpawn(self.listContent.transform)
    item.name = "item" .. k
    local cell = self.listContent:AddComponent(Item, item.name)
    cell:SetData(v)
    self.btnCells[v] = cell
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.listContent.rectTransform)
end

function UILWScienceInfoView:GetAllList()
  local list = {}
  for i = 1, self.maxLevel do
    local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.scienceId, i)
    local effect = template.effect[1]
    local describe, value = WorkerUtil.GetEffectText(tonumber(effect.effectId), tonumber(effect.effectValue), true)
    local power = template.power
    local showBg = i % 2 == 0 and 1 or 2
    if i == self.curLevel then
      showBg = 3
    end
    local params = {
      name = i,
      value = value,
      power = power and tostring(power) or "",
      showBg = showBg
    }
    table.insert(list, params)
  end
  return list
end

return UILWScienceInfoView
