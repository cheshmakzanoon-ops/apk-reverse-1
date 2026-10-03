local base = require("Scene.LWBattle.Surfing.Monster.MonsterImpl.SurfingBuffObj")
local SurfingBuffDoubleObj = BaseClass("SurfingBuffDoubleObj", base)

function SurfingBuffDoubleObj:Init(logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  base.Init(self, logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  self._showStaticEffect = true
  self.soundId = 11024
end

function SurfingBuffDoubleObj:ShowStaticEffect()
  if self.logic.ignoreSpectacularEffect then
    return
  end
  local pos = self.logic.staticEffectCommonPos
  if self.effectParent == nil then
    pos.x = self.curWorldPos.x
    pos.y = self.curWorldPos.y
    pos.z = self.curWorldPos.z
  else
    pos.x = 0
    pos.y = 0
    pos.z = 0
  end
  self.staticEffectId = self.logic:ShowEffectObj("Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s4_running_goldX4_lizi.prefab", pos, nil, -1, self.effectParent)
end

function SurfingBuffDoubleObj:OnCollide(target)
  base.OnCollide(self, target)
end

return SurfingBuffDoubleObj
