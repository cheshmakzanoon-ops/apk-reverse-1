local TradeStataionPointData = BaseClass("TradeStataionPointData")

local function __init(self)
  self.initData = false
  self.tradeId = nil
  self.uid = nil
  self.lordName = nil
  self.pic = nil
  self.picVer = nil
  self.headSkinId = nil
  self.headSkinET = nil
  self.alAbbr = nil
  self.allianceId = nil
  self.alName = nil
  self.serverId = nil
  self.battleStartTime = nil
  self.battleEndTime = nil
  self.buildPointInfo = nil
  self.tempAlAbbr = nil
  self.tempAllianceId = nil
  self.tempAlName = nil
  self.openTime = nil
  self.giveUpTime = nil
  self.__shopRefreshNum = nil
  self.__shopState = nil
  self.__nightShopRefreshNum = nil
  self.__nightShopState = nil
  self.maxPoint = 600
end

local function __delete(self)
end

local function ParseData(self, rawData, serverId)
  self.initData = true
  self.tradeId = rawData.tradeId or rawData.cityId
  self.uid = rawData.uid
  self.lordName = rawData.userName
  self.pic = rawData.pic
  self.picVer = rawData.picVer
  self.headSkinId = rawData.headSkinId
  self.headSkinET = rawData.headSkinET
  self.alAbbr = rawData.alAbbr
  self.allianceId = rawData.allianceId
  self.alName = rawData.alName
  self.serverId = rawData.serverId or serverId
  self.battleStartTime = rawData.battleStartTime
  self.battleEndTime = rawData.battleEndTime
  self.buildPointInfo = rawData.buildPointInfo
  self.tempAlAbbr = rawData.tempAlAbbr
  self.tempAllianceId = rawData.tempAllianceId
  self.tempAlName = rawData.tempAlName
  self.openTime = rawData.openTime
  self.giveUpTime = rawData.giveUpTime
  self.__shopRefreshNum = toInt(rawData.shopRefreshNum or 0)
  self.__shopState = toInt(rawData.shopState or 0)
  self.__nightShopRefreshNum = toInt(rawData.nightShopRefreshNum or 0)
  self.__nightShopState = toInt(rawData.nightShopState or 0)
  self.maxPoint = 600
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(self.tradeId, serverId or self.serverId)
  if cityTemplate ~= nil and cityTemplate:IsTradingStation() then
    self.maxPoint = toInt(cityTemplate.stronghold_points)
  end
  if self:HasLord() then
    self.occupyInfoUserInfo = {
      uid = self.uid,
      name = self.lordName,
      allianceId = self.allianceId or self.tempAllianceId,
      allianceName = self.alName or self.tempAlName,
      allianceAbbr = self.alAbbr or self.tempAlAbbr,
      headFrame = rawData.headFrame,
      pic = self.pic,
      picVer = self.picVer,
      headSkinId = self.headSkinId,
      headSkinET = self.headSkinET
    }
  else
    self.occupyInfoUserInfo = nil
  end
end

function TradeStataionPointData:GetTimeState()
  if not self.initData then
    return AllianceCityShowTimeState.TradeLock
  end
  local curMillisecond = UITimeManager:GetInstance():GetServerTime()
  if curMillisecond < self.battleStartTime then
    return AllianceCityShowTimeState.TradeLock, self.battleStartTime
  elseif curMillisecond >= self.battleStartTime and curMillisecond < self.battleEndTime then
    return AllianceCityShowTimeState.TradeBattle, self.battleEndTime
  else
    return AllianceCityShowTimeState.TradeOver
  end
end

function TradeStataionPointData:HasLord()
  return not string.IsNullOrEmpty(self.uid) and not string.IsNullOrEmpty(self.lordName)
end

function TradeStataionPointData:CalcPlayerOccupyInfo(playerCount)
  local tmp = {}
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for i, v in ipairs(self.buildPointInfo) do
    local data = {}
    data.buildPointInfo = v
    local priority = TradeStataionPointData.CalcPoint(v, self.maxPoint)
    data.priority = priority
    table.insert(tmp, data)
  end
  table.sort(tmp, function(l, r)
    return l.priority > r.priority
  end)
  local result
  if playerCount and 0 < playerCount then
    if playerCount < #tmp then
      result = {}
      for i = 1, playerCount do
        table.insert(result, tmp[i])
      end
    else
      result = tmp
    end
  else
    result = tmp
  end
  return result
end

function TradeStataionPointData:CalcPlayerOccupyInfoAlive(playerCount)
  local tmp = {}
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for i, v in ipairs(self.buildPointInfo) do
    if v.refreshTime > 0 then
      local data = {}
      data.buildPointInfo = v
      local priority = TradeStataionPointData.CalcPoint(v, self.maxPoint)
      data.priority = priority
      table.insert(tmp, data)
    end
  end
  table.sort(tmp, function(l, r)
    return l.priority > r.priority
  end)
  local result
  if playerCount < #tmp then
    result = {}
    for i = 1, playerCount do
      table.insert(result, tmp[i])
    end
  else
    result = tmp
  end
  return result
end

function TradeStataionPointData.CalcPoint(data, max)
  local score = data.buildPoint
  if data.refreshTime > 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local time = toInt((curTime - data.refreshTime) / 1000)
    if 0 < time then
      score = data.buildPoint + time * data.buildSpeed
    end
  end
  if max and max <= score then
    score = max - 1
  end
  return score
end

function TradeStataionPointData.CalcFinishTime(playerInfo, maxPoint)
  local curScore = TradeStataionPointData.CalcPoint(playerInfo, maxPoint)
  if playerInfo.buildSpeed == 0 then
    return maxPoint - curScore
  end
  local time = math.ceil((maxPoint - curScore) / playerInfo.buildSpeed)
  return time
end

function TradeStataionPointData:GetShopRefreshNum()
  if DataCenter.BloodyNightDataManager:IsBloodyNight() then
    return self.__nightShopRefreshNum
  end
  return self.__shopRefreshNum
end

function TradeStataionPointData:GetShopState()
  if DataCenter.BloodyNightDataManager:IsBloodyNight() then
    return self.__nightShopState
  end
  return self.__shopState
end

function TradeStataionPointData:GetGiveUpTimeLeft()
  if not self.giveUpTime then
    return 0
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local leftTime = self.giveUpTime - curTime
  if leftTime < 0 then
    return 0
  end
  return leftTime * 1000
end

TradeStataionPointData.__init = __init
TradeStataionPointData.__delete = __delete
TradeStataionPointData.ParseData = ParseData
return TradeStataionPointData
