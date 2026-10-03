local base = require("DataCenter.ScreenEffectManager.ScreenEffectDataBase")
local ScreenEffectBloodyNightEffect = BaseClass("ScreenEffectBloodyNightEffect", base)

function ScreenEffectBloodyNightEffect:__init()
  self.curActivity = nil
  self.snowStormState = nil
  self.showSceneFilter = ScreenEffectSceneFilter.World
  self.parentType = ScreenEffectParentType.Camera
  self.active = DataCenter.BloodyNightDataManager:IsBloodyNight()
  self.prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/Effect/BloodyNight/Eff_ljw_s4_xueye_pingmu.prefab"
  self:CheckEffect()
  self:RegisterEvent(EventId.BloodyNightActivityRefresh, self.CheckEffect)
end

function ScreenEffectBloodyNightEffect:__delete()
  self.curActivity = nil
  self.snowStormState = nil
  self:UnregisterEvent(EventId.BloodyNightActivityRefresh)
end

function ScreenEffectBloodyNightEffect:CheckEffect()
  if BattleFieldUtil.InBattleField() then
    self.active = false
    self.curScene = ScreenEffectSceneFilter.None
    self:RelaseEffect()
  else
    self.active = DataCenter.BloodyNightDataManager:IsBloodyNight()
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

function ScreenEffectBloodyNightEffect:CheckShowFlag()
  return false
end

return ScreenEffectBloodyNightEffect
