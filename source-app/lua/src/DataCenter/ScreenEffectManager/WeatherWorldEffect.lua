local base = require("DataCenter.ScreenEffectManager.ScreenEffectDataBase")
local WeatherWorldEffect = BaseClass("WeatherWorldEffect", base)

function WeatherWorldEffect:__init()
  self.showSceneFilter = ScreenEffectSceneFilter.World
  self.parentType = ScreenEffectParentType.WorldCameraPoint
  self.lifeTime = 10
  self:CheckEffect()
  self:RegisterEvent(EventId.LWSeasonWeatherInfoUpdate, self.CheckEffect)
  self:RegisterEvent(EventId.WorldMarchUpdateDisplayMode, self.OnDisplayModeUpdate)
end

function WeatherWorldEffect:__delete()
end

function WeatherWorldEffect:OnDisplayModeUpdate()
  if DisplaySettings.GetCurrentDisplayLevel() <= -2 then
    self:HideEffect()
  else
    self:CheckEffect()
  end
end

function WeatherWorldEffect:CheckEffect()
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
  if not (typeInfo and not string.IsNullOrEmpty(typeInfo.world_assets) and table.IsNullOrEmpty(typeInfo.absolute_xy)) or typeInfo.isFollow then
    self:HideEffect()
    return
  end
  if self.prefabPath ~= typeInfo.world_assets then
    self.prefabPath = typeInfo.world_assets
    self:RelaseEffect()
  end
  self:OnSceneChange(self:GetCurScene())
end

function WeatherWorldEffect:HideEffect()
  self.prefabPath = nil
  self:RelaseEffect()
end

return WeatherWorldEffect
