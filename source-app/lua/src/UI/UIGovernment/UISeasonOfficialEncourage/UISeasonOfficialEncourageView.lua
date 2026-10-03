local UISeasonOfficialEncourageView = BaseClass("UISeasonOfficialEncourageView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SeasonOfficialEncourageItem = require("UI.UIGovernment.UISeasonOfficialEncourage.SeasonOfficialEncourageItem")
local TabName = {
  [ThroneType.Outpost] = "zone_war_government_16",
  [ThroneType.Center] = "zone_war_government_17"
}
local TipStr = {
  [ThroneType.Outpost] = "outpost_commander_help_2",
  [ThroneType.Center] = "supreme_president_help_2"
}
local TITLE = {
  [GovOfficialType.Outpost] = "outpost_commander_ui_15",
  [GovOfficialType.Center] = "supreme_president_ui_18"
}
local RewardType = {
  President = 1,
  Core = 2,
  Cream = 3,
  Common = 4
}
local btn_back_path = "Root/BottomBar/BtnBack"
local text_title_path = "Root/TopBar/TextTitle"
local reward_item_path = "Root/Bg/RewardItem"
local content_path = "Root/Bg/ScrollView/Viewport/Content"
local btn_effect_path = "Root/BottomBar/BtnEffect"
local info_btn_path = "Root/TopBar/InfoBtn"

function UISeasonOfficialEncourageView:OnCreate()
  base.OnCreate(self)
  self.govOfficialType, self.serverId, self.buildingId = self:GetUserData()
  DataCenter.BuildingOfficialManager:FetchKingdomBuildingGetPresentInfo(GovOfficialType2Group[self.govOfficialType], self.serverId, self.buildingId)
  self:ComponentDefine()
  self:Init()
end

function UISeasonOfficialEncourageView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISeasonOfficialEncourageView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.KingdomBuildingPositionRewardUpdate, self.UpdateData)
end

function UISeasonOfficialEncourageView:OnRemoveListener()
  self:RemoveUIListener(EventId.KingdomBuildingPositionRewardUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function UISeasonOfficialEncourageView:ComponentDefine()
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText(TITLE[self.govOfficialType])
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.btn_effect = self:AddComponent(UIButton, btn_effect_path)
  self.theItem = self.transform:Find(reward_item_path).gameObject
  self.theItem:GameObjectCreatePool()
  local theItem
  self.ItemList = {}
  for i = 1, 4 do
    theItem = self:AddComponent(SeasonOfficialEncourageItem, "Root/Bg/ScrollView/Viewport/Content/cell" .. i)
    table.insert(self.ItemList, theItem)
  end
  self.btn_effect:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialEncourageHistory, {anim = true}, self.govOfficialType, self.serverId, self.buildingId)
  end)
  self.info_btn:SetOnClick(function()
    local param = {}
    param.activityRulesStr = Localization:GetString(TipStr[self.throneType])
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  self.togglesTbN = {}
  for i = 1, 2 do
    local tempPath = "Root/Bg/tabsSv/Viewport/Content/Toggle" .. i
    local toggle = self:AddComponent(UIButton, tempPath)
    toggle:SetOnClick(function()
      self:ChangeShowType(i + 2)
    end)
    local newTog = {}
    newTog.toggleN = toggle
    newTog.chooseN = toggle:AddComponent(UIBaseContainer, "select")
    newTog.redN = toggle:AddComponent(UIBaseContainer, "RedPoint")
    newTog.redNumN = toggle:AddComponent(UIText, "RedPoint/RedNum")
    local nameN = toggle:AddComponent(UIText, "activityName")
    nameN:SetLocalText(TabName[i + 2])
    newTog.showNewN = toggle:AddComponent(UIBaseContainer, "NewDot")
    newTog.showNewN:SetActive(false)
    newTog.ShowNewTxtN = toggle:AddComponent(UIText, "NewDot/Bg/Text")
    self.togglesTbN[i + 2] = newTog
  end
end

function UISeasonOfficialEncourageView:ComponentDestroy()
  self.content:RemoveComponents(SeasonOfficialEncourageItem)
  self.theItem:GameObjectRecycleAll()
  self.content = nil
  self.btn_back = nil
end

function UISeasonOfficialEncourageView:Init()
  self:ChangeShowType(GovOfficialType2ThroneType[self.govOfficialType])
end

function UISeasonOfficialEncourageView:UpdateData()
  for i, v in ipairs(self.ItemList) do
    v:UpdateData()
  end
end

function UISeasonOfficialEncourageView:ChangeShowType(tab)
  self.throneType = tab
  for k, v in pairs(self.togglesTbN) do
    v.chooseN:SetActive(k == tab)
  end
  for i, v in ipairs(self.ItemList) do
    v:ReInit(i, self.govOfficialType, self.serverId, self.buildingId)
  end
end

return UISeasonOfficialEncourageView
