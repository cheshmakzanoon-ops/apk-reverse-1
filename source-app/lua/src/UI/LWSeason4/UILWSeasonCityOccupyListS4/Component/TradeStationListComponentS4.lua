local base = UIBaseContainer
local TradeStationListComponentS4 = BaseClass("TradeStationListComponentS4", base)
local TradeCityListItem = require("UI.LWSeason4.UILWSeasonCityOccupyListS4.Component.TradeCityListItemS4")
local Localization = CS.GameEntry.Localization
local CommonSelectCom = require("UI.LWSeason.LWSeasonRank.Component.CommonSelectCom")
local selecCom_path = "topArea/CommonSelectCom"
local loopGridViewItemHolder_path = "ItemHolder"
local compItemContent_path = "ItemHolder/Viewport/ItemContent"
local topDes_path = "topArea/topDes"

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
  self.selecCom = self:AddComponent(CommonSelectCom, selecCom_path)
  self.loopGridViewItemHolder = self:AddComponent(UILoopGridView, loopGridViewItemHolder_path)
  self.compItemContent = self:AddComponent(UIBaseContainer, compItemContent_path)
  self.topDes = self:AddComponent(UIText, topDes_path)
  self.loopGridViewItemHolder:InitGridView(0, function(loopScroll, index, item)
    return self:OnGetItemByRowColumn(loopScroll, index)
  end)
end

local function ComponentDestroy(self)
  if self.compItemContent then
    self.compItemContent:RemoveComponents(TradeCityListItem)
  end
  if self.loopGridViewItemHolder then
    self.loopGridViewItemHolder:ClearAllItems()
  end
  self.selecCom = nil
  self.loopGridViewItemHolder = nil
  self.compItemContent = nil
  self.topDes = nil
end

local function DataDefine(self)
  self.curSelect = 0
  self.listData = {}
end

local function DataDestroy(self)
end

function TradeStationListComponentS4:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BloodyNightActivityRefresh, self.BloodyNightActivityRefresh)
end

function TradeStationListComponentS4:OnRemoveListener()
  self:RemoveUIListener(EventId.BloodyNightActivityRefresh, self.BloodyNightActivityRefresh)
  base.OnRemoveListener(self)
end

function TradeStationListComponentS4:Init(showType)
  self.showType = showType
  if TradeStationListShowType.Alliance == self.showType then
    local theData = {}
    theData.isTop = false
    theData.itemList = {}
    theData.itemList[1] = {
      type = 1,
      des = Localization:GetString("season_alliance_trade_list_3")
    }
    theData.itemList[2] = {
      type = 2,
      des = Localization:GetString("season_alliance_trade_list_4")
    }
    self.selecCom:Init(theData, function(d, i)
      local result = self:SelectTierChange(d, i)
      return result
    end)
    self.selecCom:SetIndex(1)
    self:SelectTierChange(nil, 1)
  end
end

function TradeStationListComponentS4:SelectTierChange(data, index)
  Logger.Log("SelectTierChange ....." .. tostring(index))
  if self.curSelect == index then
    return true
  end
  self.curSelect = index
  self:RefreshData()
  return true
end

function TradeStationListComponentS4:Show()
  self:SetActive(true)
end

function TradeStationListComponentS4:Hide()
  self:SetActive(false)
end

function TradeStationListComponentS4:RefreshData()
  local tmpList = DataCenter.WorldAllianceCityDataManager:GetAllAllianceTradeStationData()
  if TradeStationListShowType.Alliance == self.showType then
    if self.listData then
      table.clear(self.listData)
    end
    if self.curSelect == 1 then
      for k, v in pairs(tmpList) do
        if v.occupyInfoUserInfo and v.occupyInfoUserInfo.uid == LuaEntry.Player.uid then
          table.insert(self.listData, v)
        end
      end
    elseif self.curSelect == 2 then
      for k, v in pairs(tmpList) do
        table.insert(self.listData, v)
      end
    end
    table.sort(self.listData, function(l, r)
      return l.priority > r.priority
    end)
  end
  self:RefreshView()
end

function TradeStationListComponentS4:RefreshView()
  local dataCount = #self.listData
  self.topDes:SetText(Localization:GetString("season_alliance_trade_list_2") .. " " .. dataCount)
  self.playAnim = true
  self.loopGridViewItemHolder:SetActive(0 < dataCount)
  self.loopGridViewItemHolder:SetListItemCount(dataCount)
  self.loopGridViewItemHolder:RefreshAllShownItem()
  self.playAnim = false
end

function TradeStationListComponentS4:OnGetItemByRowColumn(loopScroll, index)
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
    script:ReInit(index, self.listData[index], true, self.playAnim)
    return item
  end
end

function TradeStationListComponentS4:BloodyNightActivityRefresh(serverId)
  if serverId ~= LuaEntry.Player:GetSourceServerId() then
    return
  end
  self:RefreshView()
end

TradeStationListComponentS4.OnCreate = OnCreate
TradeStationListComponentS4.OnDestroy = OnDestroy
TradeStationListComponentS4.OnEnable = OnEnable
TradeStationListComponentS4.OnDisable = OnDisable
TradeStationListComponentS4.ComponentDefine = ComponentDefine
TradeStationListComponentS4.ComponentDestroy = ComponentDestroy
TradeStationListComponentS4.DataDefine = DataDefine
TradeStationListComponentS4.DataDestroy = DataDestroy
return TradeStationListComponentS4
