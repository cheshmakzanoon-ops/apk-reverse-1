local base = UIBaseContainer
local ActivityTradeStationTipLogic = BaseClass("ActivityTradeStationTipLogic", base)
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local ActivityTradeStationBattleMultiPlayer = require("DataCenter.AllianceCityTip.Season.TradeStation.ActivityTradeStationBattleMultiPlayer")
local ActivityTradeStationBattleOnePlayer = require("DataCenter.AllianceCityTip.Season.TradeStation.ActivityTradeStationBattleOnePlayer")
local ActivityTradeStationLordInfo = require("DataCenter.AllianceCityTip.Season.TradeStation.ActivityTradeStationLordInfo")
local TradeStataionPointData = require("DataCenter.AllianceCityTip.Season.TradeStation.TradeStataionPointData")

function ActivityTradeStationTipLogic:__init(gameObject)
  self.gameObject = gameObject
  self.lodCache = 1
  
  function self.timer_action(temp)
    self:TimeAction()
  end
  
  self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  self.timer:Start()
end

function ActivityTradeStationTipLogic:__delete()
  self.timer_action = nil
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
  if self.multiPlayerRoot then
    self.multiPlayerRoot:Delete()
    self.multiPlayerRoot = nil
  end
  if self.lordInfoRoot then
    self.lordInfoRoot:Delete()
    self.lordInfoRoot = nil
  end
  if self.onePlayerRoot then
    self.onePlayerRoot:Delete()
    self.onePlayerRoot = nil
  end
  self.lodCache = 1
end

function ActivityTradeStationTipLogic:SetLod(lod)
  self.lodCache = toInt(lod)
  if self.multiPlayerRoot then
    self.multiPlayerRoot:SetLod(self.lodCache)
  end
  if self.lordInfoRoot then
    self.lordInfoRoot:SetLod(self.lodCache)
  end
  if self.onePlayerRoot then
    self.onePlayerRoot:SetLod(self.lodCache)
  end
end

function ActivityTradeStationTipLogic:CheckLod(lod)
  self.lodCache = toInt(lod)
  if self.multiPlayerRoot then
    self.multiPlayerRoot:SetLod(self.lodCache)
  end
  if self.lordInfoRoot then
    self.lordInfoRoot:SetLod(self.lodCache)
  end
  if self.onePlayerRoot then
    self.onePlayerRoot:SetLod(self.lodCache)
  end
end

function ActivityTradeStationTipLogic:ReInit(data)
  self.data = data
  if data ~= nil then
    self.tradeId = toInt(data.id)
  end
  self:DoRefresh()
end

function ActivityTradeStationTipLogic:OnPointDateUpdate()
  self:DoRefresh()
end

function ActivityTradeStationTipLogic:DoRefresh()
  if self.data == nil then
    if self.multiPlayerRoot then
      self.multiPlayerRoot:Delete()
      self.multiPlayerRoot = nil
    end
    if self.lordInfoRoot then
      self.lordInfoRoot:Delete()
      self.lordInfoRoot = nil
    end
    if self.onePlayerRoot then
      self.onePlayerRoot:Delete()
      self.onePlayerRoot = nil
    end
    return
  end
  self.stateEndTime = nil
  local pointInfo = self.data:GetPointInfo()
  local state = 0
  local pointLord
  local serverId = self.data:GetCurServerId()
  if pointInfo ~= nil then
    local extraInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
    serverId = pointInfo.serverId
    self.tradeData = TradeStataionPointData.New()
    self.tradeData:ParseData(extraInfo, serverId)
    pointLord = self.tradeData.occupyInfoUserInfo
    local timeState = self.tradeData:GetTimeState()
    if timeState == AllianceCityShowTimeState.TradeLock then
      self.stateEndTime = self.tradeData.battleStartTime
      if self.tradeData:HasLord() then
        state = 1
      end
    elseif timeState == AllianceCityShowTimeState.TradeBattle then
      self.stateEndTime = self.tradeData.battleEndTime
      if self.tradeData:HasLord() then
        state = 3
      else
        state = 2
      end
    end
  else
    local tradeInfo = DataCenter.SeasonTradeDataManager:GetServerTradeStationData(self.tradeId, serverId)
    if tradeInfo ~= nil then
      pointLord = tradeInfo.occupyInfoUserInfo
    end
  end
  local lordInfo = false
  if state == 1 then
    lordInfo = true
    if self.multiPlayerRoot then
      self.multiPlayerRoot:Delete()
      self.multiPlayerRoot = nil
    end
    if self.onePlayerRoot then
      self.onePlayerRoot:Delete()
      self.onePlayerRoot = nil
    end
  elseif state == 2 then
    if self.lordInfoRoot then
      self.lordInfoRoot:Delete()
      self.lordInfoRoot = nil
    end
    if self.onePlayerRoot then
      self.onePlayerRoot:Delete()
      self.onePlayerRoot = nil
    end
    if self.multiPlayerRoot == nil then
      self.multiPlayerRoot = ActivityTradeStationBattleMultiPlayer.New(self.gameObject)
      self.multiPlayerRoot:ReInit(self.tradeData, serverId)
    else
      self.multiPlayerRoot:ReInit(self.tradeData, serverId)
    end
  elseif state == 3 then
    if self.multiPlayerRoot then
      self.multiPlayerRoot:Delete()
      self.multiPlayerRoot = nil
    end
    if self.lordInfoRoot then
      self.lordInfoRoot:Delete()
      self.lordInfoRoot = nil
    end
    if self.onePlayerRoot == nil then
      self.onePlayerRoot = ActivityTradeStationBattleOnePlayer.New(self.gameObject)
      self.onePlayerRoot:ReInit(self.tradeData, serverId)
    else
      self.onePlayerRoot:ReInit(self.tradeData, serverId)
    end
  elseif state == 0 then
    if self.multiPlayerRoot then
      self.multiPlayerRoot:Delete()
      self.multiPlayerRoot = nil
    end
    if self.onePlayerRoot then
      self.onePlayerRoot:Delete()
      self.onePlayerRoot = nil
    end
    lordInfo = true
  end
  if not self:UpdateLordInfoRoot(lordInfo, pointLord, serverId) and self.lordInfoRoot then
    self.lordInfoRoot:Delete()
    self.lordInfoRoot = nil
  end
end

function ActivityTradeStationTipLogic:UpdateLordInfoRoot(lordInfo, pointLord, serverId)
  if not lordInfo or not pointLord then
    return false
  end
  if not pointLord or string.IsNullOrEmpty(pointLord.uid) then
    return false
  end
  local state, endTime = self.tradeData and self.tradeData:GetTimeState()
  self.stateEndTime = endTime
  if state and state == AllianceCityShowTimeState.TradeBattle then
    return false
  end
  if self.lordInfoRoot == nil then
    self.lordInfoRoot = ActivityTradeStationLordInfo.New(self.gameObject)
    self.lordInfoRoot:ReInit(pointLord, self.data.id, serverId)
  else
    self.lordInfoRoot:ReInit(pointLord, self.data.id, serverId)
  end
  return true
end

function ActivityTradeStationTipLogic:OnPointOutView()
  self:DoRefresh()
end

function ActivityTradeStationTipLogic:TimeAction()
  if self.stateEndTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < self.stateEndTime then
      self:DoRefresh()
      self.stateEndTime = nil
    end
  end
end

return ActivityTradeStationTipLogic
