local TemperatureTemplateManager = BaseClass("TemperatureTemplateManager")
local TemperatureTemplate = require("DataCenter.Temperature.TemperatureTemplate")

function TemperatureTemplateManager:__init()
  self:InitMeta()
end

function TemperatureTemplateManager:__delete()
  self:Destroy()
end

function TemperatureTemplateManager:Destroy()
  for _, v in pairs(self.allMeta) do
    v:Delete()
  end
  self.allMeta = nil
end

function TemperatureTemplateManager:InitMeta()
  if not LocalController:instance():hasTable(TableName.Temperature) then
    return
  end
  self.allMeta = {}
  self.metaByTen = {}
  self.maxTemp = 0
  self.minTemp = 0
  LocalController:instance():visitTable(TableName.Temperature, function(id, lineData)
    if lineData ~= nil then
      local meta = TemperatureTemplate.New()
      meta:InitConfig(lineData)
      if meta.temperature ~= nil then
        self.allMeta[meta.temperature] = meta
        if meta.temperature % 10 == 0 then
          table.insert(self.metaByTen, meta)
        end
        if meta.temperature < self.minTemp then
          self.minTemp = meta.temperature
        end
        if meta.temperature > self.maxTemp then
          self.maxTemp = meta.temperature
        end
      end
    end
  end)
  table.sort(self.metaByTen, function(a, b)
    return a.temperature > b.temperature
  end)
end

function TemperatureTemplateManager:GetTemplate(temperature)
  if self.allMeta == nil then
    return nil
  end
  if temperature > self.maxTemp then
    return self.allMeta[self.maxTemp], 1
  elseif temperature < self.minTemp then
    return self.allMeta[self.minTemp], -1
  end
  return self.allMeta[temperature], 0
end

function TemperatureTemplateManager:GetAllTemplateByTen()
  return self.metaByTen
end

function TemperatureTemplateManager:GetTextColor(temperature)
  if self.allMeta == nil then
    return "#ffffff"
  end
  if temperature > self.maxTemp then
    return self.allMeta[self.maxTemp].text_color
  elseif temperature < self.minTemp then
    return self.allMeta[self.minTemp].text_color
  end
  return self.allMeta[math.floor(temperature)].text_color
end

return TemperatureTemplateManager
