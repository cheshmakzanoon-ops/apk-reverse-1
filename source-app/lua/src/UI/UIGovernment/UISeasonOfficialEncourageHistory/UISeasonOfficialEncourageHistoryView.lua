local UISeasonOfficialEncourageHistoryView = BaseClass("UISeasonOfficialEncourageHistoryView", UIBaseView)
local base = UIBaseView
local SeasonOfficialEncourageHistoryItem = require("UI.UIGovernment.UISeasonOfficialEncourageHistory.SeasonOfficialEncourageHistoryItem")
local btn_back_path = "Root/BottomBar/BtnBack"
local text_title_path = "Root/TopBar/TextTitle"
local scroll_view_path = "Root/ScrollView"
local content_path = "Root/ScrollView/Viewport/Content"
local empty_text_path = "Root/EmptyText"
local EMPTY = {
  [GovOfficialType.Outpost] = "outpost_commander_ui_14",
  [GovOfficialType.Center] = "supreme_president_ui_17",
  [GovOfficialType.Destroyer] = "season_s6_zone_government_6"
}

function UISeasonOfficialEncourageHistoryView:OnCreate()
  base.OnCreate(self)
  self.govOfficialType, self.serverId, self.buildingId = self:GetUserData()
  DataCenter.BuildingOfficialManager:FetchKingdomBuildingGetPresentRecord(GovOfficialType2Group[self.govOfficialType], self.serverId, self.buildingId)
  self:ComponentDefine()
  self:UpdateData()
end

function UISeasonOfficialEncourageHistoryView:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISeasonOfficialEncourageHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.KingdomBuildingPositionRewardHistory, self.UpdateData)
end

function UISeasonOfficialEncourageHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.KingdomBuildingPositionRewardHistory, self.UpdateData)
  base.OnRemoveListener(self)
end

function UISeasonOfficialEncourageHistoryView:ComponentDefine()
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText("457024")
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.empty_text = self:AddComponent(UIText, empty_text_path)
  self.empty_text:SetLocalText(EMPTY[self.govOfficialType])
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
end

function UISeasonOfficialEncourageHistoryView:ComponentDestroy()
  self.btn_back = nil
end

function UISeasonOfficialEncourageHistoryView:UpdateData()
  local record = DataCenter.BuildingOfficialManager:GetRewardRecord(self.serverId, self.buildingId)
  if record ~= nil then
    self.kingName = record:GetPresidentName()
    self.rankList = record:GetShowList()
    if #self.rankList > 0 then
      self.count = #self.rankList
      self.ScrollView:SetTotalCount(self.count)
      self.ScrollView:RefillCells()
      self.empty_text:SetActive(false)
    else
      self.empty_text:SetActive(true)
      self:ClearScroll()
    end
  else
    self.empty_text:SetActive(true)
  end
end

function UISeasonOfficialEncourageHistoryView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(SeasonOfficialEncourageHistoryItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.rankList[index], self.kingName, self.govOfficialType)
  end
end

function UISeasonOfficialEncourageHistoryView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, SeasonOfficialEncourageHistoryItem)
end

function UISeasonOfficialEncourageHistoryView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(SeasonOfficialEncourageHistoryItem)
end

return UISeasonOfficialEncourageHistoryView
