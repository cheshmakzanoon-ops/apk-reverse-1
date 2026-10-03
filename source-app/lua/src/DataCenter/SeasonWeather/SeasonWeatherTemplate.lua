local SeasonWeatherTemplate = BaseClass("SeasonWeatherTemplate")

local function __SortWeather(a, b)
  return a.weight > b.weight
end

function SeasonWeatherTemplate:__init(info)
  self:UpdateData(info)
end

function SeasonWeatherTemplate:UpdateData(info)
  self.id = info.id
  self.season_group = info:getIntValue("season_group", 0)
  self.last = info:getIntValue("last", 0)
  local weather = info:getValue("weather", "")
  local weather_weight = info:getValue("weather_weight", "")
  self.weatherList = {}
  self.totalWeight = 1
  if weather and weather ~= "" then
    local weatherArray = string.split(weather, "|")
    local weightArray = string.split(weather_weight, "|")
    local totalWeight = 0
    for i, v in ipairs(weightArray) do
      totalWeight = totalWeight + tonumber(v) or 0
    end
    self.totalWeight = math.max(totalWeight, 1)
    local totalRate, count = 0, #weatherArray
    for i, v in ipairs(weatherArray) do
      local weight = tonumber(weightArray[i]) or 0
      local weightRate = 0
      if i < count then
        weightRate = math.floor(weight / totalWeight * 100)
        totalRate = totalRate + weightRate
      else
        weightRate = 100 - totalRate
      end
      self.weatherList[i] = {
        weatherId = tonumber(v) or 0,
        weight = weight,
        weightRate = weightRate
      }
    end
    table.sort(self.weatherList, __SortWeather)
  end
end

function SeasonWeatherTemplate:GetWeatherType()
  if table.IsNullOrEmpty(self.weatherList) then
    return 0
  end
  local maxWeight = 0
  local weatherId = 0
  for i, v in ipairs(self.weatherList) do
    if maxWeight < v.weight then
      maxWeight = v.weight
      weatherId = v.weatherId
    end
  end
  return weatherId
end

function SeasonWeatherTemplate:GetPlot(preWeather)
  if table.IsNullOrEmpty(self.weatherList) then
    return
  end
  local totalWeight = self.totalWeight
  local randomValue = math.random(0, totalWeight)
  local currentWeight = 0
  for i, v in ipairs(self.weatherList) do
    currentWeight = currentWeight + v.weight
    if randomValue <= currentWeight then
      local info = DataCenter.SeasonWeatherManager:GetWeatherTypeInfo(v.weatherId)
      if not info then
        return
      end
      return DataCenter.SeasonWeatherManager:GetWeatherGuiderPlot(preWeather, v.weatherId), info.plot_pre
    end
  end
end

return SeasonWeatherTemplate
