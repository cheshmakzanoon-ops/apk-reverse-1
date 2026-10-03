local base = CEventable
local WeatherWorldPoints = BaseClass("WeatherWorldPoints", base)
local worldPoint = require("DataCenter.ScreenEffectManager.WorldPointEffect")

function WeatherWorldPoints:__init(effectMap)
  self.effectMap = effectMap or {}
  self.effectList = {}
  self:CheckEffect()
  self:RegisterEvent(EventId.LWSeasonWeatherInfoUpdate, self.CheckEffect)
  self:RegisterEvent(EventId.WorldMarchUpdateDisplayMode, self.OnDisplayModeUpdate)
end

function WeatherWorldPoints:__delete()
end

function WeatherWorldPoints:OnDisplayModeUpdate()
  if DisplaySettings.GetCurrentDisplayLevel() <= -2 then
    self:HideEffect()
  else
    self:CheckEffect()
  end
end

function WeatherWorldPoints:CheckEffect()
  if not DataCenter.SeasonWeatherManager:IsOpen() then
    self:HideEffect()
    return
  end
  if DisplaySettings.GetCurrentDisplayLevel() <= -2 then
    self:HideEffect()
    return
  end
  local info = DataCenter.SeasonWeatherManager:GetWeatherInfo()
  if not (info and info.endTime) or UITimeManager:GetInstance():GetServerTime() >= info.endTime then
    self:HideEffect()
    return
  end
  self.endTime = info.endTime
  local weatherType = info.weatherId or 0
  local typeInfo = DataCenter.SeasonWeatherManager:GetWeatherTypeInfo(weatherType)
  if not typeInfo or string.IsNullOrEmpty(typeInfo.world_assets) or table.IsNullOrEmpty(typeInfo.absolute_xy) then
    self:HideEffect()
    return
  end
  local weatherServerId = DataCenter.SeasonWeatherManager.data and DataCenter.SeasonWeatherManager.data.serverId
  local offsetX, _, offsetZ = 0, 0, 0
  if weatherServerId and 0 < weatherServerId then
    offsetX, _, offsetZ = SceneUtils.GetNinePalacesOffset(weatherServerId)
  end
  local list = typeInfo.absolute_xy
  for i, v in ipairs(list) do
    local effect = self.effectList[i]
    if not effect then
      effect = worldPoint.New()
      table.insert(self.effectList, effect)
      table.insert(self.effectMap, effect)
    end
    local offsetPos = v
    if offsetX ~= 0 or offsetZ ~= 0 then
      offsetPos = {
        x = v.x + offsetX,
        y = v.y,
        z = (v.z or 0) + offsetZ
      }
    end
    effect:ShowEffect(typeInfo.world_assets, offsetPos)
  end
  for i = #list + 1, #self.effectList do
    local effect = self.effectList[i]
    if effect then
      effect:HideEffect()
    end
  end
end

function WeatherWorldPoints:HideEffect()
  for _, effect in ipairs(self.effectList) do
    if effect then
      effect:HideEffect()
    end
  end
end

function WeatherWorldPoints:OnSceneChange(scene)
  for _, effect in ipairs(self.effectList) do
    if effect then
      effect:OnSceneChange(scene)
    end
  end
end

function WeatherWorldPoints:OnLodChanged(lodLevel)
  for _, effect in ipairs(self.effectList) do
    if effect then
      effect:OnLodChanged(lodLevel)
    end
  end
end

return WeatherWorldPoints
