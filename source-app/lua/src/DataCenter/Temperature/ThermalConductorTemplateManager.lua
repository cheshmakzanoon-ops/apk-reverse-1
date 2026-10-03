local ThermalConductorTemplateManager = BaseClass("ThermalConductorTemplateManager")
local ThermalConductorTemplate = require("DataCenter.Temperature.ThermalConductorTemplate")

function ThermalConductorTemplateManager:__init()
  if not LocalController:instance():hasTable(TableName.Freeze_Config) then
    return
  end
  self.allMeta = {}
  self.metaByPointType = {}
  LocalController:instance():visitTable(TableName.Freeze_Config, function(id, lineData)
    if lineData ~= nil then
      local meta = ThermalConductorTemplate.New()
      meta:InitConfig(lineData)
      if meta.id ~= nil then
        self.allMeta[meta.type] = meta
      end
    end
  end)
end

function ThermalConductorTemplateManager:__delete()
  self:Destroy()
end

function ThermalConductorTemplateManager:Destroy()
  if self.allMeta then
    for _, v in pairs(self.allMeta) do
      v:Delete()
    end
  end
  self.allMeta = nil
  self.metaByPointType = nil
  self.__plotRateDict = nil
  self.__plotDict = nil
end

function ThermalConductorTemplateManager:GetTemplate(thermalConductorType)
  if self.allMeta == nil then
    return nil
  end
  return self.allMeta[thermalConductorType]
end

function ThermalConductorTemplateManager:GetIcePrefab(thermalConductorType, uuid)
  if self.allMeta == nil then
    return
  end
  if self.allMeta[thermalConductorType] then
    return self.allMeta[thermalConductorType]:GetIcePrefabPath(uuid)
  end
  Logger.LogError("ThermalConductor config not find : thermalConductorType = " .. thermalConductorType)
end

function ThermalConductorTemplateManager:GetDesc(thermalConductorType, config_tip_name)
  if self.allMeta == nil then
    return nil
  end
  if config_tip_name == nil then
    config_tip_name = "freeze_status_info"
  end
  if self.allMeta[thermalConductorType] then
    return self.allMeta[thermalConductorType][config_tip_name]
  end
  return nil
end

function ThermalConductorTemplateManager:ShowPlot(t, buildInfo)
  if not self.__plotDict then
    local rateAttack = LuaEntry.DataConfig:TryGetNum("temperature_plot", "k1", 100)
    local rateWarm = LuaEntry.DataConfig:TryGetNum("temperature_plot", "k2", 100)
    local rateMarch = LuaEntry.DataConfig:TryGetNum("temperature_plot", "k3", 20)
    local rateLandmine = LuaEntry.DataConfig:TryGetNum("temperature_plot", "k4", 100)
    self.__plotRateDict = {
      [TemperatureChangeType.MARCH] = rateMarch,
      [TemperatureChangeType.AttackedByRunningBoss] = rateAttack,
      [TemperatureChangeType.AttackedByZombieRushBoss] = rateAttack,
      [TemperatureChangeType.AttackedByPlayer] = rateAttack,
      [TemperatureChangeType.LANDMINE] = rateLandmine,
      [TemperatureChangeType.WARMING] = rateWarm
    }
    self.__plotDict = {
      [TemperatureChangeType.MARCH] = 8053,
      [TemperatureChangeType.AttackedByRunningBoss] = 8043,
      [TemperatureChangeType.AttackedByZombieRushBoss] = 8043,
      [TemperatureChangeType.AttackedByPlayer] = 8043,
      [TemperatureChangeType.LANDMINE] = 8054,
      [TemperatureChangeType.WARMING] = 8031
    }
  end
  local rate = self.__plotRateDict[t.changeType] or 0
  if rate <= 0 or rate < 100 and rate < math.random(1, 100) then
    return
  end
  local plotId = self.__plotDict[t.changeType] or 0
  if plotId <= 0 then
    return
  end
  EventManager:GetInstance():Broadcast(EventId.WorldBuildTopBubblePlot, {
    bUuid = t.uuid,
    plotId = plotId,
    playerInfo = {
      uid = buildInfo.ownerUid
    }
  })
  return true
end

return ThermalConductorTemplateManager
