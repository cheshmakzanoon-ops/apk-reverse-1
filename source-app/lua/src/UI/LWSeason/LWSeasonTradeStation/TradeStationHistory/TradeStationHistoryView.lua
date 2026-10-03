local base = UIBaseView
local TradeStationHistoryView = BaseClass("TradeStationHistoryView", base)
local TradeStationHistoryItem = require("UI.LWSeason.LWSeasonTradeStation.TradeStationHistory.Component.TradeStationHistoryItem")
local UICommonTabGroup = require("UI.UICommonTabGroup.UICommonTabGroup")
local CommonTabGoupItemTemplate = require("DataCenter.CommonTabGroup.CommonTabGoupItemTemplate")
local Localization = CS.GameEntry.Localization
local TradeHistoryType = {
  War = 1,
  Trade = 2,
  Tax = 3
}
local TabNames = {
  [TradeHistoryType.War] = "season_s3_activity_1000072_desc18",
  [TradeHistoryType.Trade] = "season_s3_activity_1000072_desc19",
  [TradeHistoryType.Tax] = "season_s3_activity_1000072_desc20"
}
local btnBack_path = "safeArea/BottomBar/BtnBack"
local txtTitle_path = "safeArea/TopBar/TextTitle"
local tabGroup_path = "safeArea/MiddleContentContainer/UICommonTabGroup"
local scrollView_path = "safeArea/MiddleContentContainer/ScrollView"
local content_path = "safeArea/MiddleContentContainer/ScrollView/Viewport/Content"
local noLogTxt_path = "safeArea/MiddleContentContainer/noLogTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnBack = self:AddComponent(UIButton, btnBack_path)
  self.txtTitle = self:AddComponent(UIText, txtTitle_path)
  self.tabGroup = self:AddComponent(UIBaseContainer, tabGroup_path)
  self.scrollView = self:AddComponent(UILoopListView2, scrollView_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.noLogTxt = self:AddComponent(UIText, noLogTxt_path)
  self.btnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.txtTitle:SetLocalText("season_alliance_trade_list_12")
  self.scrollView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.noLogTxt:SetLocalText("season_alliance_trade_list_10")
  self.tabGroup = self:AddComponent(UICommonTabGroup, tabGroup_path)
  self:InitTabGroup()
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.btnBack = nil
  self.txtTitle = nil
  self.tabGroup = nil
  self.scrollView = nil
  self.content = nil
  self.noLogTxt = nil
end

local function DataDefine(self)
  self.itemIndex = 0
  self.logDataDic = {}
  self.logList = nil
end

local function DataDestroy(self)
  self.itemIndex = 0
  self.logDataDic = nil
  self.logList = nil
end

function TradeStationHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ViewAllianceTradeLog, self.OnViewAllianceTradeLog)
end

function TradeStationHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.ViewAllianceTradeLog, self.OnViewAllianceTradeLog)
  base.OnRemoveListener(self)
end

function TradeStationHistoryView:RefreshView(isInit)
  self.logList = self.logDataDic[self.selectIndex]
  if self.logList and #self.logList > 0 then
    self.noLogTxt:SetActive(false)
    self.scrollView:SetListItemCount(#self.logList, isInit ~= nil, false)
    self.scrollView:RefreshAllShownItem()
    self.scrollView:SetActive(true)
  else
    self.noLogTxt:SetActive(true)
    self.scrollView:SetActive(false)
  end
end

function TradeStationHistoryView:OnViewAllianceTradeLog(message)
  local isInit = self.logDataDic[message.type] == nil
  self.logDataDic[message.type] = message.allianceTradeLogArr
  if self.selectIndex == message.type then
    self:RefreshView(isInit)
  end
end

function TradeStationHistoryView:ClearScroll()
  self.content:RemoveComponents(TradeStationHistoryItem)
  self.scrollView:ClearAllItems()
end

function TradeStationHistoryView:GetScrollItem(listView, index)
  local count = table.count(self.logList)
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local item = listView:NewListViewItem("TradeStationHistoryItem")
  local script = self.content:GetComponent(item.gameObject.name, TradeStationHistoryItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.content:AddComponent(TradeStationHistoryItem, objectName)
  end
  script:SetActive(true)
  script:ReInit(self.logList[index])
  return item
end

function TradeStationHistoryView:GetTabGroupList()
  local groupList = {}
  for index, value in ipairs(TabNames) do
    local temp = CommonTabGoupItemTemplate.New()
    temp.title = Localization:GetString(value)
    groupList[index] = temp
  end
  return groupList
end

function TradeStationHistoryView:InitTabGroup()
  local groupList = self:GetTabGroupList()
  local bindFunc1 = BindCallback(self, self.OnGroupLoadFinsh)
  local bindFunc2 = BindCallback(self, self.OnClickTab)
  
  local function bindFunc3(index)
  end
  
  self.tabGroup:RefreshGroup(groupList, bindFunc1, bindFunc2, bindFunc3)
end

function TradeStationHistoryView:OnGroupLoadFinsh()
  self.tabGroup:SelectTab(TradeHistoryType.War)
end

function TradeStationHistoryView:OnClickTab(index)
  self.selectIndex = index
  self:RefreshView()
  if not self.logDataDic[index] then
    SFSNetwork.SendMessage(MsgDefines.ViewAllianceTradeLogMessage, index)
  end
end

TradeStationHistoryView.OnCreate = OnCreate
TradeStationHistoryView.OnDestroy = OnDestroy
TradeStationHistoryView.OnEnable = OnEnable
TradeStationHistoryView.OnDisable = OnDisable
TradeStationHistoryView.ComponentDefine = ComponentDefine
TradeStationHistoryView.ComponentDestroy = ComponentDestroy
TradeStationHistoryView.DataDefine = DataDefine
TradeStationHistoryView.DataDestroy = DataDestroy
return TradeStationHistoryView
