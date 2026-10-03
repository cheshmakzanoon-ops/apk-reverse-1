local TorchRelayBattleData = BaseClass("TorchRelayBattleData")
local TorchConstant = require("DataCenter/LWBattle/Logic/TorchRelayBattle/TorchRelayBattleConstant")
local TorchRelayBattleStageConfigTemplate = require("DataCenter/LWBattle/Logic/TorchRelayBattle/Config/TorchRelayBattleStageConfigTemplate")

function TorchRelayBattleData:__init(stageId, userData)
  self.rawStageConfigLine = LocalController:instance():getLine(TableName.Activity_Torch_Relay_Stage, tonumber(stageId))
  if not self.rawStageConfigLine then
    Logger.LogError("TorchRelayBattleData stage config error! id not found:" .. stageId)
    return nil
  end
  self.stage = TorchRelayBattleStageConfigTemplate.New()
  self.stage:InitData(self.rawStageConfigLine)
  self.activityId = nil
  self.initStamina = nil
  self.initSpeed = nil
  self.lucky = nil
  self.cheerData = nil
  if userData ~= nil and userData.activityId ~= nil then
    self.activityId = userData.activityId
  end
  if userData ~= nil and userData.cheerData ~= nil then
    self.cheerData = userData.cheerData
  end
end

function TorchRelayBattleData:__delete()
end

function TorchRelayBattleData:GetSceneConfigAtIndex(index)
  if self.stage ~= nil and self.stage.sceneConfigs ~= nil then
    local preZ = 0
    for i, v in pairs(self.stage.sceneConfigs) do
      if index >= v.startIndex and index <= v.endIndex then
        local data = {
          asset = v.asset,
          index = index,
          offset = preZ + (index - v.startIndex) * v.sizeZ,
          sizeZ = v.sizeZ
        }
        return data
      end
      preZ = preZ + (v.endIndex - v.startIndex + 1) * v.sizeZ
    end
  end
end

function TorchRelayBattleData:GetSceneConfigs(startIndex, count)
  local res = {}
  for i = startIndex, startIndex + count - 1 do
    local sceneConfig = self:GetSceneConfigAtIndex(i)
    if sceneConfig ~= nil then
      table.insert(res, sceneConfig)
    end
  end
  return res
end

function TorchRelayBattleData:GetStaminaCostPerSecond()
  if self.stage ~= nil then
    return self.stage.stamina_cost
  end
  return 0
end

function TorchRelayBattleData:GetInitStamina()
  local result = 0
  if self.initStamina ~= nil then
    result = self.initStamina
  else
    local logInfo = "TorchRelay init stamina zero, actId: " .. "" .. tostring(self.activityId) .. ", info:"
    if self.activityId then
      local actData = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
      if actData ~= nil then
        local level = actData:GetGrowUpLevelByType(DataCenter.ActivityTorchRelayManager.GrowUpType.Stamina)
        local levelConfig = actData:GetGrowUpConfig(DataCenter.ActivityTorchRelayManager.GrowUpType.Stamina, level)
        if levelConfig ~= nil then
          self.initStamina = levelConfig.value
          result = self.initStamina
        else
          logInfo = logInfo .. "no levelConfig, level: " .. tostring(level)
        end
      else
        logInfo = logInfo .. "no actData"
      end
    else
      logInfo = logInfo .. "no actId"
    end
    if result == 0 then
      Logger.LogInfo(logInfo)
    end
  end
  return result
end

function TorchRelayBattleData:GetInitVerticalSpeed()
  if self.initSpeed ~= nil then
    return self.initSpeed
  end
  if self.activityId then
    local actData = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
    if actData ~= nil then
      local level = actData:GetGrowUpLevelByType(DataCenter.ActivityTorchRelayManager.GrowUpType.Speed)
      local levelConfig = actData:GetGrowUpConfig(DataCenter.ActivityTorchRelayManager.GrowUpType.Speed, level)
      if levelConfig ~= nil then
        self.initSpeed = levelConfig.value
        return self.initSpeed
      end
    end
  end
  return 0
end

function TorchRelayBattleData:GetLucky()
  if self.lucky ~= nil then
    return self.lucky
  end
  if self.activityId then
    local actData = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
    if actData ~= nil then
      local level = actData:GetGrowUpLevelByType(DataCenter.ActivityTorchRelayManager.GrowUpType.Lucky)
      local levelConfig = actData:GetGrowUpConfig(DataCenter.ActivityTorchRelayManager.GrowUpType.Lucky, level)
      if levelConfig ~= nil then
        self.lucky = levelConfig.value
        return self.lucky
      end
    end
  end
  return 0
end

function TorchRelayBattleData:GetActivityData()
  if self.activityId then
    return DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  end
  return nil
end

function TorchRelayBattleData:GetScoreCoefficient()
  if self.stage ~= nil and self.stage.meter_para then
    return self.stage.meter_para
  end
  return 1
end

function TorchRelayBattleData:GetPlayerBirthPos()
  local res
  if self.stage ~= nil then
    res = self.stage:GetBirthPos()
  end
  if res == nil then
    res = TorchConstant.PLAYER_BIRTH_POS
  end
  return res
end

return TorchRelayBattleData
