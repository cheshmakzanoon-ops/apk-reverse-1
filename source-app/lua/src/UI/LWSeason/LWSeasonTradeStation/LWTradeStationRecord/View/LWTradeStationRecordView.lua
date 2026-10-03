local base = UIBaseView
local LWTradeStationRecordView = BaseClass("LWTradeStationRecordView", base)
local Localization = CS.GameEntry.Localization
local TabItem = require("UI.LWSeason.LWSeasonTradeStation.LWTradeStationRecord.Component.UILWTradeRecordTab")
local UILWTradeRecordItem = require("UI.LWSeason.LWSeasonTradeStation.LWTradeStationRecord.Component.UILWTradeRecordItem")
local tabItem_path = "PopUpTitle/Common_bg_orange/TabView/Viewport/TabContent/TabItem"
local tabContent_path = "PopUpTitle/Common_bg_orange/TabView/Viewport/TabContent"
local title_path = "PopUpTitle/Common_img_title/titleText"
local maskBtn_path = "panel"
local closeBtn_path = "PopUpTitle/Common_bg_orange/CloseBtn"
local scrollView_1_path = "PopUpTitle/Common_bg_orange/ScrollView"
local scrollContent_path = "PopUpTitle/Common_bg_orange/ScrollView/Viewport/Content"
local noRecordTip_path = "PopUpTitle/Common_bg_orange/noRecordTip"
local NameCount = 0

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.data = self:GetUserData()
  self:Init()
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
  self.tabItem = self:AddComponent(UIBaseContainer, tabItem_path)
  self.tabContent = self:AddComponent(UIBaseContainer, tabContent_path)
  self.title = self:AddComponent(UIText, title_path)
  self.maskBtn = self:AddComponent(UIButton, maskBtn_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.scrollView_1 = self:AddComponent(UILoopListView2, scrollView_1_path)
  self.scrollContent = self:AddComponent(UIBaseContainer, scrollContent_path)
  self.noRecordTip = self:AddComponent(UIBaseContainer, noRecordTip_path)
  self.theTabItem = self.tabItem.gameObject
  self.theTabItem:GameObjectCreatePool()
  self.scrollView_1:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
  self.maskBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.tabContent:RemoveComponents(TabItem)
  self.theTabItem:GameObjectRecycleAll()
  self.theTabItem = nil
  self:ClearCells()
  self.tabItem = nil
  self.tabContent = nil
  self.title = nil
  self.maskBtn = nil
  self.closeBtn = nil
  self.scrollView_1 = nil
  self.scrollContent = nil
  self.noRecordTip = nil
end

local function DataDefine(self)
  NameCount = 0
  self.cells = {}
  self.curIndex = nil
  self.curDataList = nil
  self.lordDataList = nil
  self.taxDataList = nil
end

local function DataDestroy(self)
  self.curIndex = nil
end

function LWTradeStationRecordView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.TradeStationRecordDataChange, self.TradeStationRecordDataChange)
end

function LWTradeStationRecordView:OnRemoveListener()
  self:RemoveUIListener(EventId.TradeStationRecordDataChange, self.TradeStationRecordDataChange)
  base.OnRemoveListener(self)
end

function LWTradeStationRecordView:Init()
  self.tabContent:RemoveComponents(TabItem)
  self.theTabItem:GameObjectRecycleAll()
  local defaultTab
  local goItem = self.theTabItem:GameObjectSpawn(self.tabContent.transform)
  goItem.name = "item_" .. 1
  goItem:SetActive(true)
  local theItem = self.tabContent:AddComponent(TabItem, goItem.name)
  theItem:ReInit(1, Localization:GetString("season_s3_trade_city034"))
  defaultTab = theItem
  theItem:SetOnValueChanged(function(tf)
    if tf then
      self:SetTabIndex(1)
    end
  end)
  goItem = self.theTabItem:GameObjectSpawn(self.tabContent.transform)
  goItem.name = "item_" .. 2
  goItem:SetActive(true)
  local theItem = self.tabContent:AddComponent(TabItem, goItem.name)
  theItem:ReInit(2, Localization:GetString("season_s3_trade_city035"))
  theItem:SetOnValueChanged(function(tf)
    if tf then
      self:SetTabIndex(2)
    end
  end)
  defaultTab:SetIsOn(true)
  self:SetTabIndex(1)
end

function LWTradeStationRecordView:SetTabIndex(tabIndex)
  if self.curIndex == tabIndex then
    return
  end
  self.curIndex = tabIndex
  self:ScrollListDataChange()
  Logger.Log("SetTabIndex index: " .. tostring(tabIndex))
end

function LWTradeStationRecordView:ScrollListDataChange()
  if self.curIndex == 1 then
    if self.lordDataList == nil then
      self.curDataList = {}
      SFSNetwork.SendMessage(MsgDefines.ViewTradeLogMessage, self.curIndex, self.data.serverId, self.data.tradeId)
    else
      self.curDataList = self.lordDataList
    end
  elseif self.curIndex == 2 then
    if self.taxDataList == nil then
      self.curDataList = {}
      SFSNetwork.SendMessage(MsgDefines.ViewTradeLogMessage, self.curIndex, self.data.serverId, self.data.tradeId)
    else
      self.curDataList = self.taxDataList
    end
  end
  if self.curDataList then
    self.dataCount = #self.curDataList
    self.scrollView_1:SetListItemCount(self.dataCount, false, false)
    self.scrollView_1:RefreshAllShownItem()
    self.noRecordTip:SetActive(self.dataCount == 0)
  else
    self.noRecordTip:SetActive(true)
  end
end

function LWTradeStationRecordView:TryGetScrollItem(listview, index)
  local dataList = self.curDataList
  index = index + 1
  if index < 1 or dataList == nil or index > #dataList then
    return nil
  end
  local csItem = listview:NewListViewItem("RecordItem")
  local item = self.cells[csItem]
  if item == nil then
    NameCount = NameCount + 1
    local nameStr = "Cell" .. "_" .. tostring(NameCount)
    csItem.gameObject.name = nameStr
    item = self.scrollContent:AddComponent(UILWTradeRecordItem, nameStr)
    self.cells[csItem] = item
  end
  if item ~= nil then
    item:ReInit(index, dataList[index], self.curIndex)
  end
  return csItem
end

function LWTradeStationRecordView:ClearCells()
  self.scrollContent:RemoveComponents(UILWTradeRecordItem)
  self.scrollView_1:ClearAllItems()
  self.cells = {}
end

function LWTradeStationRecordView:TradeStationRecordDataChange(data)
  if data and data.recordType == self.curIndex and data.serverId == self.data.serverId and data.tradeId == self.data.tradeId then
    if data.recordType == 1 then
      self.lordDataList = data.dataList
    elseif data.recordType == 2 then
      self.taxDataList = data.dataList
    end
    self.curDataList = data.dataList
    if self.curDataList then
      self.dataCount = #self.curDataList
      self.scrollView_1:SetListItemCount(self.dataCount, false, false)
      self.scrollView_1:RefreshAllShownItem()
      self.noRecordTip:SetActive(self.dataCount == 0)
    else
      self.noRecordTip:SetActive(true)
    end
  end
end

LWTradeStationRecordView.OnCreate = OnCreate
LWTradeStationRecordView.OnDestroy = OnDestroy
LWTradeStationRecordView.OnEnable = OnEnable
LWTradeStationRecordView.OnDisable = OnDisable
LWTradeStationRecordView.ComponentDefine = ComponentDefine
LWTradeStationRecordView.ComponentDestroy = ComponentDestroy
LWTradeStationRecordView.DataDefine = DataDefine
LWTradeStationRecordView.DataDestroy = DataDestroy
return LWTradeStationRecordView
