local base = require("DataCenter.ScreenEffectManager.ScreenEffectDataBase")
local ScreenEffectWeatherLoopEffect = BaseClass("ScreenEffectWeatherLoopEffect", base)

function ScreenEffectWeatherLoopEffect:__init()
  self.showSceneFilter = ScreenEffectSceneFilter.World
  self.parentType = ScreenEffectParentType.Camera
  self.changeScale = false
  self:CheckEffect()
  self:RegisterEvent(EventId.LWSeasonWeatherInfoUpdate, self.CheckEffect)
  self:RegisterEvent(EventId.WorldMarchUpdateDisplayMode, self.OnDisplayModeUpdate)
end

function ScreenEffectWeatherLoopEffect:__delete()
end

function ScreenEffectWeatherLoopEffect:OnDisplayModeUpdate()
  if DisplaySettings.GetCurrentDisplayLevel() <= -4 then
    self:HideEffect()
  else
    self:CheckEffect()
  end
end

function ScreenEffectWeatherLoopEffect:CheckEffect()
  if not DataCenter.SeasonWeatherManager:IsOpen() then
    self:HideEffect()
    return
  end
  if DisplaySettings.GetCurrentDisplayLevel() <= -4 then
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
  if not typeInfo or string.IsNullOrEmpty(typeInfo.screen_assets_loop) then
    self:HideEffect()
    return
  end
  if self.prefabPath ~= typeInfo.screen_assets_loop then
    self.prefabPath = typeInfo.screen_assets_loop
    self:RelaseEffect()
  end
  self:OnSceneChange(self:GetCurScene())
end

function ScreenEffectWeatherLoopEffect:CheckShowFlag()
  if BattleFieldUtil.InBattleField() then
    return false
  end
  return self.curScene == ScreenEffectSceneFilter.World or self.curScene == ScreenEffectSceneFilter.City
end

function ScreenEffectWeatherLoopEffect:HideEffect()
  self.prefabPath = nil
  self:RelaseEffect()
end

return ScreenEffectWeatherLoopEffect
