local base = UIBaseView
local TradeStationCityView = BaseClass("TradeStationCityView", base)
local Localization = CS.GameEntry.Localization
local TradeCityListItem = require("UI.LWSeason3.UILWSeasonCityOccupyListS3.Component.TradeCityListItem")
local UICommonTabGroup = require("UI.UICommonTabGroup.UICommonTabGroup")
local CommonTabGoupItemTemplate = require("DataCenter.CommonTabGroup.CommonTabGoupItemTemplate")
local CommonSelectCom = require("UI.LWSeason.LWSeasonRank.Component.CommonSelectCom")
local btnBack_path = "Root/BottomBar/BtnBack"
local loopGridViewItemHolder_path = "Root/ItemHolder"
local compItemContent_path = "Root/ItemHolder/Viewport/ItemContent"
local selecCom_path = "Root/topArea/CommonSelectCom"
local tabGroup_path = "Root/topArea/UICommonTabGroup"
local topDes_path = "Root/topArea/topDes"
local emptyDes_path = "Root/emptyDes"

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
  self.loopGridViewItemHolder = self:AddComponent(UILoopGridView, loopGridViewItemHolder_path)
  self.compItemContent = self:AddComponent(UIBaseContainer, compItemContent_path)
  self.selecCom = self:AddComponent(CommonSelectCom, selecCom_path)
  self.tabGroup = self:AddComponent(UIBaseContainer, tabGroup_path)
  self.topDes = self:AddComponent(UIText, topDes_path)
  self.emptyDes = self:AddComponent(UIText, emptyDes_path)
  self.btnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.loopGridViewItemHolder:InitGridView(0, function(loopScroll, index, item)
    return self:OnGetItemByRowColumn(loopScroll, index)
  end)
  self.tabGroup = self:AddComponent(UICommonTabGroup, tabGroup_path)
  self:Init()
end

local function ComponentDestroy(self)
  if self.compItemContent then
    self.compItemContent:RemoveComponents(TradeCityListItem)
  end
  if self.loopGridViewItemHolder then
    self.loopGridViewItemHolder:ClearAllItems()
  end
  self.btnBack = nil
  self.loopGridViewItemHolder = nil
  self.compItemContent = nil
  self.selecCom = nil
  self.tabGroup = nil
  self.topDes = nil
  self.emptyDes = nil
end

local function DataDefine(self)
  self.listDataDic = {}
  self.listData = nil
  self.defaultServerId = self:GetUserData() or LuaEntry.Player.serverId
end

local function DataDestroy(self)
end

function TradeStationCityView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateAllServerTradeInfoWithServer, self.UpdateAllServerTradeInfoWithServer)
end

function TradeStationCityView:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateAllServerTradeInfoWithServer, self.UpdateAllServerTradeInfoWithServer)
  base.OnRemoveListener(self)
end

function TradeStationCityView:UpdateAllServerTradeInfoWithServer(msg)
  if msg and msg.list and self.selectServerId == msg.serverId then
    self.listDataDic[self.selectServerId] = msg.list
    self:RefreshData(true)
  end
end

function TradeStationCityView:Init()
  local theData = {}
  theData.isTop = false
  theData.itemList = {}
  theData.itemList[1] = {
    type = 1,
    des = Localization:GetString("season_s3_activity_1000072_desc16")
  }
  theData.itemList[2] = {
    type = 2,
    des = Localization:GetString("361058")
  }
  theData.itemList[3] = {
    type = 3,
    des = Localization:GetString("season_s3_activity_1000072_desc15")
  }
  theData.itemList[4] = {
    type = 4,
    des = Localization:GetString("season_alliance_trade_list_13")
  }
  self.selecCom:Init(theData, function(d, i)
    return self:SelectTierChange(d, i)
  end)
  self.selecCom:SetIndex(1)
  self.curSelect = 1
  self:InitTabGroup()
end

function TradeStationCityView:SelectTierChange(data, index)
  if self.curSelect == index then
    return true
  end
  self.curSelect = index
  self:OnClickTabServerId(self.selectServerId)
  return true
end

function TradeStationCityView:RefreshData(isInit)
  if isInit then
    self.listData, self.curSelect = self:GetAvailableListData()
    self.selecCom:SetIndex(self.curSelect)
  else
    self.listData = self:GetListData(self.curSelect, self.listData)
  end
  self.selfCount = 0
  local selfUid = LuaEntry.Player.uid
  for k, v in pairs(self.listData) do
    if v.occupyInfoUserInfo and v.occupyInfoUserInfo.uid == selfUid then
      self.selfCount = self.selfCount + 1
    end
  end
  table.sort(self.listData, function(l, r)
    return l.priority > r.priority
  end)
  self:RefreshView()
end

function TradeStationCityView:RefreshView()
  local dataCount = #self.listData
  self.playAnim = true
  self.topDes:SetText(Localization:GetString("season_s3_activity_1000072_desc14") .. string.format("%s/%s", self.selfCount, dataCount))
  self.loopGridViewItemHolder:SetListItemCount(dataCount, true)
  self.loopGridViewItemHolder:RefreshAllShownItem()
  self.playAnim = false
  if dataCount <= 0 then
    self.emptyDes:SetText(Localization:GetString("season_alliance_trade_list_10"))
    self.emptyDes:SetActive(true)
    self.loopGridViewItemHolder:SetActive(false)
  else
    self.emptyDes:SetActive(false)
    self.loopGridViewItemHolder:SetActive(true)
  end
end

function TradeStationCityView:GetListData(index, list)
  if list then
    table.clear(list)
  else
    list = {}
  end
  local selfUid = LuaEntry.Player.uid
  local tmpList = self.listDataDic[self.selectServerId] or {}
  if index == 1 then
    for k, v in pairs(tmpList) do
      if v.occupyInfoUserInfo and v.occupyInfoUserInfo.uid == selfUid then
        table.insert(list, v)
      end
    end
  elseif index == 2 then
    for k, v in pairs(tmpList) do
      if v.occupyInfoUserInfo and DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(v.occupyInfoUserInfo.uid) then
        table.insert(list, v)
      end
    end
  elseif index == 3 then
    for k, v in pairs(tmpList) do
      if v:GetShopState() == 1 then
        table.insert(list, v)
      end
    end
  else
    for k, v in pairs(tmpList) do
      table.insert(list, v)
    end
  end
  return list
end

function TradeStationCityView:GetAvailableListData()
  local list = self.listData
  for i = 1, 4 do
    list = self:GetListData(i, list)
    if 0 < #list then
      return list, i
    end
  end
  return list, 1
end

function TradeStationCityView:OnGetItemByRowColumn(loopScroll, index)
  if self.listData ~= nil then
    local count = #self.listData
    index = index + 1
    if index < 1 or count < index then
      return nil
    end
    local item = loopScroll:NewListViewItem("TradeCityItem")
    local script = self.compItemContent:GetComponent(item.gameObject.name, TradeCityListItem)
    if script == nil then
      local name = "item_" .. UIUtil.GetLoopListItemIndex()
      item.gameObject.name = name
      script = self.compItemContent:AddComponent(TradeCityListItem, name)
    end
    script:SetActive(true)
    script:ReInit(index, self.listData[index], nil, self.playAnim)
    return item
  end
end

function TradeStationCityView:InitTabGroup()
  local serverListInt = DataCenter.SeasonDataManager:GetServerListInt()
  if serverListInt == nil then
    return
  end
  local groupList = {}
  for index, serverId in ipairs(serverListInt) do
    local temp = CommonTabGoupItemTemplate.New()
    temp.title = string.format("#%s", serverId)
    temp.selectBgPath = string.format(LoadPath.LWCommonPath, "cfm_tongyong_yeqian_yiji_1.png")
    temp.arrowPath = string.format(LoadPath.LWCommonPath, "cfm_tongyong_yeqian_yiji_1_1.png")
    groupList[index] = temp
  end
  local bindFunc1 = BindCallback(self, self.OnGroupLoadFinish)
  local bindFunc2 = BindCallback(self, self.OnClickTab)
  
  local function bindFunc3(index)
  end
  
  self.tabGroup:RefreshGroup(groupList, bindFunc1, bindFunc2, bindFunc3)
end

function TradeStationCityView:OnGroupLoadFinish()
  local serverListInt = DataCenter.SeasonDataManager:GetServerListInt()
  if serverListInt == nil then
    return
  end
  local curIndex = 1
  for index, serverId in ipairs(serverListInt) do
    if serverId == self.defaultServerId then
      curIndex = index
      break
    end
  end
  self.tabGroup:SelectTab(curIndex, true)
end

function TradeStationCityView:OnClickTab(index)
  local serverListInt = DataCenter.SeasonDataManager:GetServerListInt()
  if serverListInt then
    self:OnClickTabServerId(serverListInt[index], true)
  end
end

function TradeStationCityView:OnClickTabServerId(serverId, isInit)
  if isInit and self.selectServerId == serverId then
    return
  end
  self.selectServerId = serverId or 0
  self:RefreshData(isInit)
  if not self.listDataDic[self.selectServerId] then
    SFSNetwork.SendMessage(MsgDefines.GetAllServerTradeMessage, self.selectServerId)
  end
end

TradeStationCityView.OnCreate = OnCreate
TradeStationCityView.OnDestroy = OnDestroy
TradeStationCityView.OnEnable = OnEnable
TradeStationCityView.OnDisable = OnDisable
TradeStationCityView.ComponentDefine = ComponentDefine
TradeStationCityView.ComponentDestroy = ComponentDestroy
TradeStationCityView.DataDefine = DataDefine
TradeStationCityView.DataDestroy = DataDestroy
return TradeStationCityView
