local UIZoneMobilizationPointsHelpView = BaseClass("UIZoneMobilizationPointsHelpView", UIBaseView)
local base = UIBaseView
local UIZoneMobilizationPointsHelpItem = require("UI.LWUIZoneMobilization.LWUIZoneMobilizationPointsHelp.Component.UIZoneMobilizationPointsHelpItem")
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local list_scroll_path = "Root/ListScroll"
local content_path = "Root/ListScroll/Viewport/Content"
local hint_icon_path = "UICommonPopUpTitle/Common_img_title/titleText/HintIcon"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitListView()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  if self.list_scroll and self.index then
    self.list_scroll:MovePanelToItemIndex(self.index - 1, 0)
  end
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnPanel = self:AddComponent(UIButton, "Panel")
  self.btnPanel:SetOnClick(BindCallback(self, self.OnBtnPanelClick))
  self.textLevel = self:AddComponent(UIText, "Root/TitleItem/LevelText")
  self.textLevel:SetLocalText("zone_mobilization_boss_level_title")
  self.textNeedPoint = self:AddComponent(UIText, "Root/TitleItem/NeedPointText")
  self.textNeedPoint:SetLocalText("zone_mobilization_boss_progress_title")
  self.textHp = self:AddComponent(UIText, "Root/TitleItem/HpText")
  self.textHp:SetLocalText("zone_mobilization_boss_hp_title")
  self.textDamage = self:AddComponent(UIText, "Root/TitleItem/DamageText")
  self.textDamage:SetLocalText("zone_mobilization_boss_attack_title")
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self, self.OnBtnPanelClick))
  self.items = {}
  self.list_scroll = self:AddComponent(UILoopListView2, list_scroll_path)
  self.list_scroll:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.hint_icon = self:AddComponent(UIButton, hint_icon_path)
  self.hint_icon:SetOnClick(BindCallback(self, self.OnHintIconClick))
end

local function ComponentDestroy(self)
  self.btnPanel = nil
  self.textLevel = nil
  self.textNeedPoint = nil
  self.textHp = nil
  self.textDamage = nil
  self.content:RemoveComponents(UIZoneMobilizationPointsHelpItem)
  self.content = nil
  self.close_btn = nil
  self.list_scroll = nil
  self.items = nil
  self.hint_icon = nil
end

local function DataDefine(self)
  self.index = nil
  self.bossIdsArr = nil
  self.scoresArr = nil
  self.isRed = nil
end

local function DataDestroy(self)
  self.index = nil
  self.bossIdsArr = nil
  self.scoresArr = nil
  self.isRed = nil
end

local function OnBtnPanelClick(self)
  self.ctrl:CloseSelf()
end

local function InitListView(self)
  local stageId, bossId, isRed = self:GetUserData()
  self.isRed = isRed
  if stageId and bossId then
    local data = GetTableData(TableName.ZoneMobilizationStage, stageId, "progress_boss_show", "")
    if string.IsNullOrEmpty(data) then
      self.ctrl:CloseSelf()
      return
    end
    local dataArr = string.split(data, ";")
    if dataArr then
      local bossIds, scores = dataArr[1], dataArr[2]
      local bossIdsArr = string.split(bossIds, "|")
      local scoresArr = string.split(scores, "|")
      if bossIdsArr and scoresArr then
        self.bossIdsArr = bossIdsArr
        self.scoresArr = scoresArr
        local monsterId = GetTableData(TableName.ZoneMobilizationBoss, bossId, "world_monster", 0)
        if monsterId and 0 < monsterId then
          local level = GetTableData(TableName.Monster, monsterId, "level", 0)
          self.index = level
          local max = #bossIdsArr > #scoresArr and #scoresArr or #bossIdsArr
          self.list_scroll:SetListItemCount(max, false, false)
        end
      end
    else
      self.ctrl:CloseSelf()
    end
  end
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or self.bossIdsArr == nil or self.scoresArr == nil or index > #self.bossIdsArr or index > #self.scoresArr then
    return nil
  end
  local csItem
  if index == self.index then
    if self.isRed then
      csItem = loopScroll:NewListViewItem("OwnItemRed")
    else
      csItem = loopScroll:NewListViewItem("OwnItem")
    end
  else
    csItem = loopScroll:NewListViewItem("Item")
  end
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local nameStr = "Cell" .. NameCount
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.content:AddComponent(UIZoneMobilizationPointsHelpItem, nameStr)
  end
  if self.items[csItem] ~= nil then
    self.items[csItem]:SetActive(true)
    self.items[csItem]:SetData(self.bossIdsArr[index], self.scoresArr[index], self.isRed)
    if index % 2 == 1 then
      self.items[csItem]:SetBgShow(true)
    elseif index ~= self.index then
      self.items[csItem]:SetBgShow(false)
    end
  end
  return csItem
end

local function ClearScroll(self)
  self.content:RemoveComponents(UIZoneMobilizationPointsHelpItem)
  self.list_scroll:ClearAllItems()
end

local function OnHintIconClick(self)
  local content = CS.GameEntry.Localization:GetString("zone_mobilization_progress_boss_show")
  UIUtil.ShowBubbleTips(content, self.hint_icon.transform.position, 16, -30, 0)
end

UIZoneMobilizationPointsHelpView.OnCreate = OnCreate
UIZoneMobilizationPointsHelpView.OnDestroy = OnDestroy
UIZoneMobilizationPointsHelpView.OnEnable = OnEnable
UIZoneMobilizationPointsHelpView.OnDisable = OnDisable
UIZoneMobilizationPointsHelpView.ComponentDefine = ComponentDefine
UIZoneMobilizationPointsHelpView.ComponentDestroy = ComponentDestroy
UIZoneMobilizationPointsHelpView.DataDefine = DataDefine
UIZoneMobilizationPointsHelpView.DataDestroy = DataDestroy
UIZoneMobilizationPointsHelpView.OnBtnPanelClick = OnBtnPanelClick
UIZoneMobilizationPointsHelpView.InitListView = InitListView
UIZoneMobilizationPointsHelpView.OnGetItemByIndex = OnGetItemByIndex
UIZoneMobilizationPointsHelpView.ClearScroll = ClearScroll
UIZoneMobilizationPointsHelpView.OnHintIconClick = OnHintIconClick
return UIZoneMobilizationPointsHelpView
