local TemperatureManager = BaseClass("TemperatureManager")
local Localization = CS.GameEntry.Localization

function TemperatureManager:__init()
  self.achieveList = {}
end

function TemperatureManager:__delete()
  self:Destroy()
end

function TemperatureManager:Destroy()
end

function TemperatureManager:GetAchieveNumById(id)
  if self.achieveList[id] then
    if id == 5 or id == 7 then
      return string.format("%.1f", self.achieveList[id].num / 3600)
    else
      return string.GetFormattedSeparatorNum(self.achieveList[id].num)
    end
  end
  return 0
end

function TemperatureManager:HandleAchieve(msg)
  self.achieveList = {}
  for _, v in pairs(msg) do
    self.achieveList[v.type] = v
  end
  EventManager:GetInstance():Broadcast(EventId.GetTempUserAchievementInfo)
end

function TemperatureManager:OnEnterGame()
  CS.HeatSourceDataManager.GetInstance():OnEnterGame()
end

function TemperatureManager:OnLiteReconnect()
  local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
  if mainBuild then
    CS.HeatSourceDataManager.GetInstance():GetThermalConductorInfo(mainBuild.uuid)
  end
end

function TemperatureManager:GetMyBaseConductor()
  return CS.HeatSourceDataManager.GetInstance():GetMyBaseConductor()
end

function TemperatureManager:GetMyBaseTemperature()
  return CS.HeatSourceDataManager.GetInstance():GetMyBaseTemperature()
end

function TemperatureManager:IsMyBaseFrozen()
  return CS.HeatSourceDataManager.GetInstance():IsMyBaseFrozen()
end

function TemperatureManager:GetAllHeatSourceAffectMe()
  local data = {}
  local csHeatSourceList = CS.HeatSourceDataManager.GetInstance():GetHeatSourceAffectMe()
  local _, tempFurnace, metaFurnace = DataCenter.BuildManager:GetFurnaceStateAndTemp()
  local tempVT, metaVT = DataCenter.BuildManager:GetVictoryTowerTemp()
  for k, v in pairs(csHeatSourceList) do
    table.insert(data, v)
  end
  if metaFurnace then
    table.insert(data, {
      cfgId = metaFurnace.id,
      temperature = tempFurnace
    })
  end
  if metaVT then
    table.insert(data, {
      cfgId = metaVT.id,
      temperature = tempVT
    })
  end
  return data
end

function TemperatureManager:GetMyEnvTemperature()
  local tc = self:GetMyBaseConductor()
  return tc.target
end

function TemperatureManager:GetCityHeatSourceTemperature(cityId)
  return CS.HeatSourceDataManager.GetInstance():GetCityHeatSourceTemperature(cityId)
end

function TemperatureManager:GetTemperatureByIndex(pointIndex)
  return CS.HeatSourceDataManager.GetInstance():GetTemperatureByIndex(pointIndex)
end

function TemperatureManager:GetMyTemperatureBuff()
  if not SeasonUtil.IsInAndAfterSeasonSnowMode() then
    return {}
  end
  local ret = {}
  local temp = DataCenter.TemperatureManager:GetMyBaseTemperature() or 0
  if self:IsMyBaseFrozen() then
    table.insert(ret, {
      icon = "Assets/Main/Sprites/UI/UISeason/UISeason2/Mjc_icon_s2_buff_frozen.png",
      name = Localization:GetString("season_s2_temperature_status_name13"),
      desc = Localization:GetString("season_s2_temperature_status_desc13")
    })
  end
  if SeasonUtil.IsInSeasonSnowMode() then
    local curMeta, mark = DataCenter.TemperatureTemplateManager:GetTemplate(math.floor(temp))
    for i = 1, 4 do
      if not curMeta.effect_value_is_zero[i] then
        table.insert(ret, {
          icon = string.format("Assets/Main/Sprites/UI/UISeason/UISeason2/Mjc_icon_s2_buff_0%s.png", i),
          name = curMeta:GetName(i),
          desc = curMeta:GetDesc(i)
        })
      end
    end
  end
  return ret
end

function TemperatureManager:SetSendCoalTimes(times)
  self.sendCoalTimes = times
end

function TemperatureManager:GetSendCoalConfig()
  if not self.sendCoalTimes then
    self.sendCoalTimes = 0
  end
  local nextTime = self.sendCoalTimes + 1
  if not self.sendCoalConfig then
    self.sendCoalConfig = {}
    LocalController:instance():visitTable(TableName.Temperature_Help, function(id, lineData)
      if lineData ~= nil then
        local daily_number = lineData:getValue("daily_number")
        local resource = lineData:getValue("resource")
        local temperature_add = lineData:getValue("temperature_add")
        local config = {
          from = daily_number[1],
          to = daily_number[2],
          resource = resource,
          temperature_add = temperature_add
        }
        table.insert(self.sendCoalConfig, config)
      end
    end)
    table.sort(self.sendCoalConfig, function(a, b)
      return a.from < b.from
    end)
  end
  local effectValue = 1 + LuaEntry.Effect:GetGameEffect(EffectDefine.SEND_COAL_ADD_94107)
  for _, v in ipairs(self.sendCoalConfig) do
    if nextTime >= v.from and nextTime <= v.to then
      return v.resource[1], v.resource[2], v.temperature_add * effectValue
    end
  end
  local config = self.sendCoalConfig[#self.sendCoalConfig]
  return config.resource[1], config.resource[2], config.temperature_add * effectValue
end

function TemperatureManager:CreateConstHeatSource(cfgId, type, temperature)
  CS.HeatSourceDataManager.GetInstance():CreateConstHeatSource(cfgId, type, temperature)
end

function TemperatureManager:RemoveConstHeatSource(cfgId)
  CS.HeatSourceDataManager.GetInstance():RemoveConstHeatSource(cfgId)
end

function TemperatureManager:FormatTemperature(temp)
  if not temp then
    return 0
  end
  local ten = math.floor(temp * 10 + 0.5)
  local decimal = ten % 10
  return decimal == 0 and math.floor(ten / 10) or ten / 10
end

function TemperatureManager:SetTemperatureHistory(list)
  self.tempHistoryList = list
  EventManager:GetInstance():Broadcast(EventId.MyBaseTempChangeHistory)
end

function TemperatureManager:GetTemperatureHistory()
  return self.tempHistoryList or {}
end

return TemperatureManager
