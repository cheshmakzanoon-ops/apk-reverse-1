local SeasonLightDataManager = BaseClass("SeasonLightDataManager")

function SeasonLightDataManager:__init()
  self.lightDataDict = {}
  self.lightBuffDict = {}
end

function SeasonLightDataManager:__delete()
  self.lightDataDict = {}
  self.lightBuffDict = {}
end

function SeasonLightDataManager:UpdateLightData(state, light)
  if DataCenter.BloodyNightDataManager:IsSunrise() then
    return
  end
  self.lightDataDict[light.pointId] = light
  EventManager:GetInstance():DelayBroadcast(0.1, EventId.LuaEntryEffectRefreshStatus)
end

function SeasonLightDataManager:AddLightBuff(stateId, lightStatus)
  if DataCenter.BloodyNightDataManager:IsSunrise() then
    return
  end
  if lightStatus and lightStatus.lightPlayer then
    if lightStatus.lightPlayer.uid == LuaEntry.Player.uid then
      return
    end
    self.lightBuffDict[704005] = nil
    self.lightBuffDict[704006] = nil
    self.lightBuffDict[704007] = nil
  elseif stateId == 704005 or stateId == 704006 or stateId == 704007 then
    self.lightBuffDict[704101] = nil
  end
  self.lightBuffDict[stateId] = lightStatus
end

function SeasonLightDataManager:GetBuffValue(effectId)
  local effectValue = 0
  if DataCenter.BloodyNightDataManager:IsSunrise() then
    return 0
  end
  if effectId ~= nil and self.lightBuffDict then
    for k1, v1 in pairs(self.lightBuffDict) do
      if v1 and v1.effects then
        for k2, v2 in pairs(v1.effects) do
          if v2.eff == effectId then
            effectValue = v2.val + effectValue
          end
        end
      end
    end
  end
  return effectValue
end

function SeasonLightDataManager:UpdateLightBuff(mode, lightStatusArr)
  if mode == 2 then
    self.lightBuffDict = {}
  end
  if DataCenter.BloodyNightDataManager:IsSunrise() then
    return
  end
  for k, lightStatus in pairs(lightStatusArr) do
    if lightStatus then
      self:AddLightBuff(lightStatus.stateId, lightStatus)
    end
  end
  EventManager:GetInstance():DelayBroadcast(0.1, EventId.LuaEntryEffectRefreshStatus)
end

function SeasonLightDataManager:DeleteLightBuff(stateIds)
  for k, stateId in pairs(stateIds) do
    self.lightBuffDict[stateId.stateId] = nil
  end
  EventManager:GetInstance():DelayBroadcast(0.1, EventId.LuaEntryEffectRefreshStatus)
end

function SeasonLightDataManager:DeleteAllLightBuff()
  self.lightBuffDict = {}
  EventManager:GetInstance():DelayBroadcast(0.1, EventId.LuaEntryEffectRefreshStatus)
end

function SeasonLightDataManager:GetLightBuff(stateId)
  if DataCenter.BloodyNightDataManager:IsSunrise() then
    return nil
  end
  return self.lightBuffDict[stateId]
end

function SeasonLightDataManager:GetAllLightBuff()
  if DataCenter.BloodyNightDataManager:IsSunrise() then
    return nil
  end
  return self.lightBuffDict
end

function SeasonLightDataManager:GetBloodyNightElectricityUseBuff()
  local electricity_use_add = 0
  if self.lightBuffDict and DataCenter.BloodyNightDataManager:IsBloodyNight() then
    for k1, v1 in pairs(self.lightBuffDict) do
      if v1 and v1.effects then
        for k2, v2 in pairs(v1.effects) do
          if v2.eff == 94127 then
            electricity_use_add = electricity_use_add + (tonumber(v2.val) or 0)
          end
        end
      end
    end
  end
  return electricity_use_add
end

function SeasonLightDataManager:GetMainBaseMaxLightLevel()
  local maxLightLevel = 0
  local otherPlayerLightLevel = 0
  local data = self:GetLightBuff(704101)
  if data ~= nil and data.lightPlayer ~= nil then
    otherPlayerLightLevel = data.lightPlayer.lightLevel
  end
  local selfLightLevel = 0
  local lightHouseStatus = DataCenter.SeasonPowerWorkerManager.lightHouseStatus
  if lightHouseStatus ~= nil and lightHouseStatus.active then
    selfLightLevel = toInt(lightHouseStatus.brightnessLevel)
  end
  if otherPlayerLightLevel > selfLightLevel then
    maxLightLevel = otherPlayerLightLevel
  else
    maxLightLevel = selfLightLevel
  end
  return maxLightLevel
end

return SeasonLightDataManager
