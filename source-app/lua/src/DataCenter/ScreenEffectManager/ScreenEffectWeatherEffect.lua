local base = require("DataCenter.ScreenEffectManager.ScreenEffectDataBase")
local ScreenEffectWeatherEffect = BaseClass("ScreenEffectWeatherEffect", base)

function ScreenEffectWeatherEffect:__init()
  self.showSceneFilter = ScreenEffectSceneFilter.World
  self.parentType = ScreenEffectParentType.Camera
  self.lifeTime = 10
  self.changeScale = false
  self:CheckEffect()
  self:RegisterEvent(EventId.LWSeasonWeatherInfoUpdate, self.LWSeasonWeatherInfoUpdate)
end

function ScreenEffectWeatherEffect:__delete()
end

function ScreenEffectWeatherEffect:LWSeasonWeatherInfoUpdate(isChange)
  self:CheckEffect(isChange)
end

function ScreenEffectWeatherEffect:CheckEffect(isChange)
  if not DataCenter.SeasonWeatherManager:IsOpen() then
    self:HideEffect()
    return
  end
  local info = DataCenter.SeasonWeatherManager:GetWeatherInfo()
  if not (info and info.endTime) or UITimeManager:GetInstance():GetServerTime() >= info.endTime then
    self:HideEffect()
    return
  end
  if not isChange and UIUtil.GetMonthActiveCount("ScreenWeather" .. info.uuid, true) > 0 then
    self:HideEffect()
    return
  end
  self.endTime = info.endTime
  local weatherType = info.weatherId or 0
  local typeInfo = DataCenter.SeasonWeatherManager:GetWeatherTypeInfo(weatherType)
  if not typeInfo or string.IsNullOrEmpty(typeInfo.screen_assets) then
    self:HideEffect()
    return
  end
  if self.prefabPath ~= typeInfo.screen_assets then
    self.prefabPath = typeInfo.screen_assets
    self:RelaseEffect()
  end
  self.curScene = self:GetCurScene()
  self.active = self:CheckShowFlag()
  if self.active then
    if self.effectObj then
      self.effectObj:SetActive(true)
    elseif self.active and self.request == nil then
      self:LoadEffect()
    end
  else
    self:RelaseEffect()
  end
end

function ScreenEffectWeatherEffect:CheckShowFlag()
  if BattleFieldUtil.InBattleField() then
    return false
  end
  return self.curScene == ScreenEffectSceneFilter.World or self.curScene == ScreenEffectSceneFilter.City
end

function ScreenEffectWeatherEffect:OnSceneChange(filter)
  return false
end

function ScreenEffectWeatherEffect:HideEffect()
  self.prefabPath = nil
  self:RelaseEffect()
end

return ScreenEffectWeatherEffect
