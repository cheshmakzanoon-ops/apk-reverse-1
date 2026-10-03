local base = require("Scene.LWBattle.Surfing.Monster.MonsterImpl.SurfingBuffObj")
local SurfingBuffMagnetObj = BaseClass("SurfingBuffMagnetObj", base)

function SurfingBuffMagnetObj:Init(logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  base.Init(self, logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  self._showStaticEffect = true
  self.soundId = 11022
end

function SurfingBuffMagnetObj:ShowStaticEffect()
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
  self.staticEffectId = self.logic:ShowEffectObj("Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_shine.prefab", pos, nil, -1, self.effectParent)
end

function SurfingBuffMagnetObj:OnCollide(target)
  base.OnCollide(self, target)
end

return SurfingBuffMagnetObj
