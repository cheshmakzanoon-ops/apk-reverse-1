local SeasonSnowStormDataManager = BaseClass("SeasonSnowStormDataManager")
local Localization = CS.GameEntry.Localization
local SnowStormRewardData = require("DataCenter.SeasonManager.Activity.SnowStormRewardData")
local temperatureRange = {
  [1] = {min = 20, max = 9999},
  [2] = {min = 0, max = 20},
  [3] = {min = -20, max = 0},
  [4] = {min = -9999, max = -20}
}

function SeasonSnowStormDataManager:__init()
  self.curActivity = nil
  self.personList = {}
  self.allMainBuildEnvTemp = {}
  self.allianceMemberEnvTemp = {}
  self.lastTime = 0
  
  function self.timer_action(temp)
    self:Update1000MS()
  end
end

function SeasonSnowStormDataManager:__delete()
  self:DeleteTimer()
  self.activityData = nil
  self.lastTime = nil
  self.personList = nil
end

function SeasonSnowStormDataManager:RequestCurActivityInfo()
  SFSNetwork.SendMessage(MsgDefines.StormActivityInfo)
end

function SeasonSnowStormDataManager:UpdateActivityData(msg)
  if msg.curActivity then
    if self.curActivity == nil then
      self.curActivity = {}
    end
    self.curActivity.stormEndTime = msg.curActivity.stormEndTime
    self.curActivity.startTime = msg.curActivity.startTime
    self.curActivity.endTime = msg.curActivity.endTime
    self.curActivity.cfgId = msg.curActivity.cfgId
    self.curActivity.stormStartTime = msg.curActivity.stormStartTime
    self.curActivity.isEnd = msg.curActivity.isEnd
    self:AddTimer()
  else
    self.curActivity = nil
  end
  if msg.personList then
    for index, value in ipairs(msg.personList) do
      local tmpData = self.personList[value.cfgId]
      if tmpData == nil then
        tmpData = SnowStormRewardData.New(value)
        self.personList[value.cfgId] = tmpData
      else
        tmpData:RefreshData(value)
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonSnowStormActivityDataUpdate)
end

function SeasonSnowStormDataManager:GetTargetReward(msg, isPerson)
  if msg.reward then
    if isPerson then
      local record = self.personList[msg.cfgId]
      if record then
        record.personReward = 1
      end
    else
      local record = self.personList[msg.cfgId]
      if record then
        record.allianceReward = 1
      end
    end
    DataCenter.RewardManager:AddRewardsAndRes(msg)
    DataCenter.RewardManager:ShowCommonReward(msg)
    EventManager:GetInstance():Broadcast(EventId.SeasonSnowStormActivityTargetRewardGetSuccess)
  end
end

function SeasonSnowStormDataManager:GetAllMainBuildingTempData()
  local result = {}
  local count = #temperatureRange
  for i = 1, count do
    result[i] = {index = i, value = 0}
  end
  for key, value in pairs(self.allMainBuildEnvTemp) do
    local temp = tonumber(key)
    local tempIndex = self:GetTemperatureArea(temp)
    if 0 < tempIndex then
      result[tempIndex].value = result[tempIndex].value + value
    end
  end
  return result
end

function SeasonSnowStormDataManager:UpdateAllMainBuildTemp(msg)
  table.clear(self.allMainBuildEnvTemp)
  if msg.tempToNum then
    for key, value in pairs(msg.tempToNum) do
      self.allMainBuildEnvTemp[key] = value
    end
  end
  if msg.rankPercent then
    self.allMainBuildEnvTempPercent = msg.rankPercent
  else
    self.allMainBuildEnvTempPercent = nil
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonSnowStormActivityMainBuildTempUpdate)
end

function SeasonSnowStormDataManager:GetAllianceMemberTempData()
  local result = {}
  local count = #temperatureRange
  for i = 1, count do
    result[i] = {}
  end
  local selfTemp = 0
  local memberCount = 0
  for key, value in pairs(self.allianceMemberEnvTemp) do
    local temp = tonumber(value.curTemp)
    memberCount = memberCount + 1
    local tempIndex = self:GetTemperatureArea(temp)
    if 0 < tempIndex then
      table.insert(result[tempIndex], value)
    end
    if value.uid == LuaEntry.Player.uid then
      selfTemp = temp
    end
  end
  local less = 0
  for key, value in pairs(self.allianceMemberEnvTemp) do
    local temp = tonumber(value.curTemp)
    if selfTemp >= temp then
      less = less + 1
    end
  end
  return result, less, memberCount
end

function SeasonSnowStormDataManager:GetAllianceMemberAssistanceList()
  local result = {}
  for key, value in pairs(self.allianceMemberEnvTemp) do
    local temp = tonumber(value.curTemp)
    if key ~= LuaEntry.Player.uid and temp < 0 then
      table.insert(result, value)
    end
  end
  table.sort(result, function(a, b)
    return a.curTemp < b.curTemp
  end)
  return result
end

function SeasonSnowStormDataManager:UpdateAllianceMemberTemp(msg)
  local mapFlag = {}
  if msg.list then
    for key, value in pairs(msg.list) do
      local uid = value.uid
      local data = self.allianceMemberEnvTemp[uid]
      if data == nil then
        data = {}
        data.uid = uid
        self.allianceMemberEnvTemp[uid] = data
      end
      data.curTemp = value.curTemp or 0
      data.pointId = value.pointId
      data.name = value.name
      data.headPicVer = value.headPicVer
      data.headPic = value.headPic
      data.abbr = value.abbr
      data.headSkinET = value.headSkinET
      data.headSkinId = value.headSkinId
      mapFlag[uid] = true
    end
    local removeKey = {}
    for key, value in pairs(self.allianceMemberEnvTemp) do
      if mapFlag[key] == nil then
        removeKey[key] = true
      end
    end
    for key, value in pairs(removeKey) do
      self.allianceMemberEnvTemp[key] = nil
    end
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonSnowStormActivityAllianceMemTempUpdate)
end

function SeasonSnowStormDataManager:GetTemperatureArea(temperature)
  local count = #temperatureRange
  for index = 1, count do
    local tempData = temperatureRange[index]
    if temperature >= tempData.min and temperature < tempData.max then
      return index
    end
  end
  return -1
end

function SeasonSnowStormDataManager:GetSelfTemperatureArea()
  local temp = DataCenter.TemperatureManager:GetMyBaseTemperature()
  local index = self:GetTemperatureArea(temp)
  return index
end

function SeasonSnowStormDataManager:GetActivityState()
  if self.curActivity then
    local now = UITimeManager:GetInstance():GetServerTime()
    if now < self.curActivity.startTime then
      return ActivitySnowStormState.NoStart, self.curActivity.startTime
    elseif now >= self.curActivity.startTime and now < self.curActivity.stormStartTime then
      return ActivitySnowStormState.Warning, self.curActivity.stormStartTime
    elseif now >= self.curActivity.stormStartTime and now < self.curActivity.stormEndTime then
      return ActivitySnowStormState.SnowStorm, self.curActivity.stormEndTime
    elseif now >= self.curActivity.stormEndTime and now < self.curActivity.endTime then
      return ActivitySnowStormState.Reward, self.curActivity.endTime
    elseif now >= self.curActivity.endTime then
      return ActivitySnowStormState.End, 0
    end
  end
  return ActivitySnowStormState.NoStart, 0
end

function SeasonSnowStormDataManager:GetActivityStateData()
  local acitvityInfo = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.SnowStormComing.Type)
  local now = UITimeManager:GetInstance():GetServerTime()
  if acitvityInfo[1] and now < acitvityInfo[1].endTime and self.curActivity then
    return self:GetActivityState()
  end
  return ActivitySnowStormState.NoStart, 0
end

function SeasonSnowStormDataManager:NeedShowBlizzardInMainUI()
  local state, ts = self:GetActivityStateData()
  local now = UITimeManager:GetInstance():GetServerTime()
  if (state == ActivitySnowStormState.Warning or state == ActivitySnowStormState.SnowStorm) and ts > now then
    return state, ts
  end
  return false, ts
end

function SeasonSnowStormDataManager:GetCurBlizzardHeatSourceCfg()
  if self.curActivity and self.curActivity.cfgId and self.curActivity.cfgId > 0 then
    local eventConfig = LocalController:instance():getLine(TableName.StormEvent, self.curActivity.cfgId)
    if eventConfig then
      local heatSourceConfig = DataCenter.HeatSourceTemplateManager:GetTemplate(eventConfig.env_temperature)
      return heatSourceConfig
    else
      Logger.LogError("\230\154\180\233\163\142\233\155\170\233\133\141\232\161\168\233\148\153\232\175\175\239\188\129storm_event cant find " .. self.curActivity.cfgId)
    end
  end
end

function SeasonSnowStormDataManager:GetCurBlizzardLevel()
  local heatSourceConfig = self:GetCurBlizzardHeatSourceCfg()
  if heatSourceConfig then
    return heatSourceConfig.level
  end
  return 0
end

function SeasonSnowStormDataManager:AddTimer()
  if not (self.curActivity and self.curActivity.stormStartTime and self.curActivity.stormEndTime) or not self.curActivity.cfgId then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if now > self.curActivity.stormEndTime then
    return
  end
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
    self.timer:Start()
  end
end

function SeasonSnowStormDataManager:DeleteTimer()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function SeasonSnowStormDataManager:Update1000MS()
  if not (self.curActivity and self.curActivity.stormStartTime) or not self.curActivity.stormEndTime then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local stormStartTime = self.curActivity.stormStartTime
  local stormEndTime = self.curActivity.stormEndTime
  if stormStartTime > self.lastTime and now >= stormStartTime and now < stormEndTime then
    local cfg = self:GetCurBlizzardHeatSourceCfg()
    if cfg then
      DataCenter.TemperatureManager:CreateConstHeatSource(cfg.id, cfg.type, cfg.default_temperature)
    end
    EventManager:GetInstance():Broadcast(EventId.SeasonSnowStormStart)
  elseif stormEndTime > self.lastTime and now >= stormEndTime then
    local cfg = self:GetCurBlizzardHeatSourceCfg()
    if cfg then
      DataCenter.TemperatureManager:RemoveConstHeatSource(cfg.id)
    end
    EventManager:GetInstance():Broadcast(EventId.SeasonSnowStormEnd)
  elseif stormEndTime < self.lastTime then
    self:DeleteTimer()
  end
  self.lastTime = now
end

return SeasonSnowStormDataManager
