local base = require("DataCenter.ScreenEffectManager.ScreenEffectDataBase")
local ScreenEffectWhiteNightEffect = BaseClass("ScreenEffectWhiteNightEffect", base)

function ScreenEffectWhiteNightEffect:__init()
  self.curActivity = nil
  self.snowStormState = nil
  self.showSceneFilter = ScreenEffectSceneFilter.World
  self.parentType = ScreenEffectParentType.Camera
  self.bloodyNightState = DataCenter.BloodyNightDataManager:GetBloodyNightState()
  self.active = false
  self.prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/Effect/BloodyNight/Eff_ljw_s4_xueye_pingmu_xiao_san.prefab"
  self:CheckEffect()
  self:RegisterEvent(EventId.BloodyNightActivityRefresh, self.CheckEffect)
end

function ScreenEffectWhiteNightEffect:__delete()
  self.curActivity = nil
  self.snowStormState = nil
  self:UnregisterEvent(EventId.BloodyNightActivityRefresh)
end

function ScreenEffectWhiteNightEffect:CheckEffect()
  if BattleFieldUtil.InBattleField() then
    self.active = false
    self.curScene = ScreenEffectSceneFilter.None
    self:RelaseEffect()
  else
    local oldState = self.bloodyNightState
    self.bloodyNightState = DataCenter.BloodyNightDataManager:GetBloodyNightState()
    self.active = oldState == BloodyNightState.BloodyNight and self.bloodyNightState == BloodyNightState.Silent
    self.curScene = ScreenEffectSceneFilter.World
    if self.active then
      if self.request == nil then
        self:LoadEffect()
      end
    else
      self:RelaseEffect()
    end
  end
end

function ScreenEffectWhiteNightEffect:CheckShowFlag()
  return false
end

return ScreenEffectWhiteNightEffect
