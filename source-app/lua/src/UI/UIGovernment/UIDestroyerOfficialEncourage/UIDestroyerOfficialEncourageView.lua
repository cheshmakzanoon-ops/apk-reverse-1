local UIDestroyerOfficialEncourageView = BaseClass("UIDestroyerOfficialEncourageView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SeasonOfficialEncourageItem = require("UI.UIGovernment.UISeasonOfficialEncourage.SeasonOfficialEncourageItem")
local EncourageItem = require("UI.UIGovernment.Encourage.Component.EncourageItem")
local TabName = {
  [ThroneType.Native] = "zone_war_government_16",
  [ThroneType.Destroyer] = "season_s6_zone_government_4"
}
local TipStr = {
  [ThroneType.Native] = "457088",
  [ThroneType.Destroyer] = "season_s6_zone_government_5"
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
local btn_effect_path = "Root/BottomBar/BtnEffect"
local info_btn_path = "Root/TopBar/InfoBtn"
local scroll_view_path = "Root/Bg/ScrollView"
local scroll_view_destroyer_path = "Root/Bg/ScrollViewDestroyer"

function UIDestroyerOfficialEncourageView:OnCreate()
  base.OnCreate(self)
  self.serverId, self.buildingId = self:GetUserData()
  DataCenter.BuildingOfficialManager:FetchKingdomBuildingGetPresentInfo(GovOfficialType2Group[GovOfficialType.Destroyer], self.serverId, self.buildingId)
  self:ComponentDefine()
  self:Init()
end

function UIDestroyerOfficialEncourageView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDestroyerOfficialEncourageView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GovernmentPresentRefresh, self.UpdateData)
  self:AddUIListener(EventId.KingdomBuildingPositionRewardUpdate, self.UpdateData)
end

function UIDestroyerOfficialEncourageView:OnRemoveListener()
  self:RemoveUIListener(EventId.GovernmentPresentRefresh, self.UpdateData)
  self:RemoveUIListener(EventId.KingdomBuildingPositionRewardUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function UIDestroyerOfficialEncourageView:ComponentDefine()
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText("457007")
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.btn_effect = self:AddComponent(UIButton, btn_effect_path)
  self.scroll_view = self:AddComponent(UIBaseComponent, scroll_view_path)
  self.scroll_view_destroyer = self:AddComponent(UIBaseComponent, scroll_view_destroyer_path)
  self.theItem = self.transform:Find(reward_item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.ItemList = {}
  self.ItemListDestroyer = {}
  for i = 1, 4 do
    local theItem = self:AddComponent(EncourageItem, "Root/Bg/ScrollView/Viewport/Content/cell" .. i)
    table.insert(self.ItemList, theItem)
    local theItem2 = self:AddComponent(SeasonOfficialEncourageItem, "Root/Bg/ScrollViewDestroyer/Viewport/ContentDestroyer/cell" .. i .. "Destroyer")
    table.insert(self.ItemListDestroyer, theItem2)
  end
  self.btn_effect:SetOnClick(function()
    if self.throneType == ThroneType.Destroyer then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialEncourageHistory, {anim = true}, GovOfficialType.Destroyer, self.serverId, self.buildingId)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentEncourageHistory, {anim = true}, self.throneType)
    end
  end)
  self.info_btn:SetOnClick(function()
    local param = {}
    param.activityRulesStr = Localization:GetString(TipStr[self.throneType])
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  self.togglesTbN = {}
  for i, v in pairs(TabName) do
    local tempPath = "Root/Bg/tabsSv/Viewport/Content/Toggle" .. i
    local toggle = self:AddComponent(UIButton, tempPath)
    toggle:SetOnClick(function()
      self:ChangeShowType(i)
    end)
    local newTog = {}
    newTog.toggleN = toggle
    newTog.chooseN = toggle:AddComponent(UIBaseContainer, "select")
    newTog.redN = toggle:AddComponent(UIBaseContainer, "RedPoint")
    newTog.redNumN = toggle:AddComponent(UIText, "RedPoint/RedNum")
    local nameN = toggle:AddComponent(UIText, "activityName")
    nameN:SetLocalText(v)
    newTog.showNewN = toggle:AddComponent(UIBaseContainer, "NewDot")
    newTog.showNewN:SetActive(false)
    newTog.ShowNewTxtN = toggle:AddComponent(UIText, "NewDot/Bg/Text")
    self.togglesTbN[i] = newTog
  end
end

function UIDestroyerOfficialEncourageView:ComponentDestroy()
  self.theItem:GameObjectRecycleAll()
  self.btn_back = nil
  self.info_btn = nil
end

function UIDestroyerOfficialEncourageView:Init()
  if self.serverId == LuaEntry.Player:GetSourceServerId() then
    self.togglesTbN[ThroneType.Native].toggleN:SetActive(true)
    self:ChangeShowType(ThroneType.Native)
  else
    self.togglesTbN[ThroneType.Native].toggleN:SetActive(false)
    self:ChangeShowType(ThroneType.Destroyer)
  end
end

function UIDestroyerOfficialEncourageView:UpdateData()
  for i, v in ipairs(self.ItemList) do
    v:UpdateData()
  end
  for i, v2 in ipairs(self.ItemListDestroyer) do
    v2:UpdateData()
  end
end

function UIDestroyerOfficialEncourageView:ChangeShowType(tab)
  self.throneType = tab
  for i, v in pairs(self.togglesTbN) do
    v.chooseN:SetActive(i == tab)
  end
  if tab == ThroneType.Destroyer then
    for i, v in ipairs(self.ItemListDestroyer) do
      v:ReInit(i, GovOfficialType.Destroyer, self.serverId, self.buildingId)
    end
  else
    for i, v in ipairs(self.ItemList) do
      v:ReInit(i, self.throneType, LuaEntry.Player:GetSourceServerId())
    end
  end
  self.scroll_view:SetActive(tab == ThroneType.Native)
  self.scroll_view_destroyer:SetActive(tab == ThroneType.Destroyer)
end

return UIDestroyerOfficialEncourageView
