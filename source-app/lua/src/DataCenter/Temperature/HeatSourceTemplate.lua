local HeatSourceTemplate = BaseClass("HeatSourceTemplate")

function HeatSourceTemplate:__init()
end

function HeatSourceTemplate:__delete()
  self.effect = nil
end

function HeatSourceTemplate:InitConfig(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id"))
  self.type = row:getIntValue("type")
  self.group = row:getIntValue("group")
  self.level = row:getIntValue("level")
  self.icon = row:getValue("icon")
  self.name = row:getValue("name")
  self.desc = row:getValue("desc")
  self.info = row:getValue("info")
  self.default_temperature = tonumber(row:getValue("default_temperature")) or 0
  self.active_temperature = tonumber(row:getValue("active_temperature")) or 0
  self.overload_temperature = tonumber(row:getValue("overload_temperature")) or 0
  self.active_temperature_original = self.active_temperature
  self.overload_temperature_original = self.overload_temperature
  self.active_temperature = self.default_temperature + self.active_temperature
  self.overload_temperature = self.overload_temperature + self.active_temperature
  self.default_status_name = row:getValue("default_status_name")
  self.default_status_icon = row:getValue("default_status_icon")
  self.active_status_name = row:getValue("active_status_name")
  self.active_status_icon = row:getValue("active_status_icon")
  self.overload_status_name = row:getValue("overload_status_name")
  self.overload_status_icon = row:getValue("overload_status_icon")
end

function HeatSourceTemplate:GetTemperatureByState(state)
  if state == HeatSourceState.Active then
    return self.active_temperature
  elseif state == HeatSourceState.Overload then
    return self.overload_temperature
  end
  return self.default_temperature
end

function HeatSourceTemplate:GetLangKeyByState(state)
  if state == HeatSourceState.Active then
    return self.active_status_name
  elseif state == HeatSourceState.Overload then
    return self.overload_status_name
  end
  return self.default_status_name
end

function HeatSourceTemplate:GetIconPathByState(state)
  if state == HeatSourceState.Active then
    return self.active_status_icon or self.icon
  elseif state == HeatSourceState.Overload then
    return self.overload_status_icon or self.icon
  end
  return self.default_status_icon or self.icon
end

function HeatSourceTemplate:GetStateByTemperature(temp)
  if self.type == HeatSourceType.City and temp > self.default_temperature + 0.01 then
    return HeatSourceState.Active
  end
  return HeatSourceState.Close
end

return HeatSourceTemplate
