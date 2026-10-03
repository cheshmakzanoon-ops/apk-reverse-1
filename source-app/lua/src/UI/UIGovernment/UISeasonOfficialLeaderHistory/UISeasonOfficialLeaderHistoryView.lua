local UISeasonOfficialLeaderHistoryView = BaseClass("UISeasonOfficialLeaderHistoryView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local SeasonOfficialLeaderHistoryItem = require("UI.UIGovernment.UISeasonOfficialLeaderHistory.SeasonOfficialLeaderHistoryItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local scroll_view_path = "PopUpTitle/ScrollView"
local content_path = "PopUpTitle/ScrollView/Viewport/Content"
local empty_text_path = "PopUpTitle/EmptyText"
local TITLE = {
  [GovOfficialType.Outpost] = "outpost_commander_ui_7",
  [GovOfficialType.Center] = "supreme_president_ui_9"
}

function UISeasonOfficialLeaderHistoryView:OnCreate()
  base.OnCreate(self)
  self.serverId, self.buildingId, self.config = self:GetUserData()
  DataCenter.BuildingOfficialManager:FetchKingdomBuildingPositionRecord(self.serverId, self.buildingId, self.config.id)
  self:ComponentDefine()
  self:Refresh()
end

function UISeasonOfficialLeaderHistoryView:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISeasonOfficialLeaderHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.KingdomBuildingPositionHistory, self.Refresh)
end

function UISeasonOfficialLeaderHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.KingdomBuildingPositionHistory, self.Refresh)
  base.OnRemoveListener(self)
end

function UISeasonOfficialLeaderHistoryView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText(TITLE[self.config.type])
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.empty_text = self:AddComponent(UIText, empty_text_path)
end

function UISeasonOfficialLeaderHistoryView:ComponentDestroy()
  self.btn_back = nil
end

function UISeasonOfficialLeaderHistoryView:Refresh()
  self:ClearScroll()
  self.recordList = DataCenter.BuildingOfficialManager:GetOfficialHistory(self.serverId, self.buildingId, self.config.id)
  if self.recordList and #self.recordList > 0 then
    self.ScrollView:SetTotalCount(#self.recordList)
    self.ScrollView:RefillCells()
    self.empty_text:SetActive(false)
  else
    self.empty_text:SetActive(true)
  end
end

function UISeasonOfficialLeaderHistoryView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(SeasonOfficialLeaderHistoryItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.recordList[index])
  end
end

function UISeasonOfficialLeaderHistoryView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, SeasonOfficialLeaderHistoryItem)
end

function UISeasonOfficialLeaderHistoryView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(SeasonOfficialLeaderHistoryItem)
end

return UISeasonOfficialLeaderHistoryView
