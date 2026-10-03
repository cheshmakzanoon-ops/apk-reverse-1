local UILWAlAuthorityInfoView = BaseClass("UILWAlAuthorityInfoView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local Item = require("UI.UILWAlliance.UILWAlAuthorityInfo.Component.UILWAlAuthorityInfoItem")
local txt_title_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local close_btn_path = "Panel"
local return_btn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local mid_title_txt_path = "Root/Content/Mid/Title/Title/MidTitleTxt"
local content_path = "Root/Content/Mid/Scroll/Viewport/Content"
local item_path = "Root/Content/Mid/Scroll/Item"
local TITLE_TXT = 393051
local DESC_TXT = 393052
local MID_TITLE_TXT = 393051

function UILWAlAuthorityInfoView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlAuthorityInfoView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlAuthorityInfoView:ComponentDefine()
  self.titleTxt = self:AddComponent(UIText, txt_title_path)
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.returnBtn = self:AddComponent(UIButton, return_btn_path)
  self.returnBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.midTitleTxt = self:AddComponent(UIText, mid_title_txt_path)
  self.listContent = self:AddComponent(UIBaseContainer, content_path)
  self.listItemPrefab = self.transform:Find(item_path).gameObject
  self.listItemPrefab:GameObjectCreatePool()
  self.titleTxt:SetLocalText(TITLE_TXT)
  self.midTitleTxt:SetLocalText(MID_TITLE_TXT)
end

function UILWAlAuthorityInfoView:ComponentDestroy()
  self.titleTxt = nil
  self.closeBtn = nil
  self.returnBtn = nil
  self.midTitleTxt = nil
  self.listContent = nil
  self.listItemPrefab = nil
end

function UILWAlAuthorityInfoView:DataDefine()
  self.ctrl:SetView(self)
end

function UILWAlAuthorityInfoView:DataDestroy()
  self.ctrl:ClearView()
end

function UILWAlAuthorityInfoView:OnEnable()
  base.OnEnable(self)
  self:RefreshContent()
end

function UILWAlAuthorityInfoView:OnDisable()
  base.OnDisable(self)
end

function UILWAlAuthorityInfoView:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlAuthorityInfoView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlAuthorityInfoView:ClearContent()
  self.listContent:RemoveComponents(Item)
end

function UILWAlAuthorityInfoView:RefreshContent()
  self:ClearContent()
  self.listItemPrefab.gameObject:GameObjectRecycleAll()
  local list = self:GetShowList()
  for k, v in ipairs(list) do
    local item = self.listItemPrefab:GameObjectSpawn(self.listContent.transform)
    item.name = "item" .. k
    local cell = self.listContent:AddComponent(Item, item.name)
    cell:SetData(v, k)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.listContent.rectTransform)
end

function UILWAlAuthorityInfoView:GetShowList()
  local list = {}
  local length = LocalController:instance():GetTableLength(TableName.LW_Alliance_Authority)
  for i = 1, length do
    local line = LocalController:instance():getLine(TableName.LW_Alliance_Authority, i)
    local oneData = {
      title = line.desc,
      icons = {
        line.R5,
        line.R4,
        line.R3,
        line.R2,
        line.R1
      }
    }
    table.insert(list, oneData)
  end
  return list
end

return UILWAlAuthorityInfoView
