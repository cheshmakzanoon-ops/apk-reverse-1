local base = require("Scene.LWBattle.Surfing.Monster.MonsterImpl.SurfingBuffObj")
local SurfingBuffShieldObj = BaseClass("SurfingBuffShieldObj", base)

function SurfingBuffShieldObj:Init(logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  base.Init(self, logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  self._showStaticEffect = true
  self.soundId = 11023
end

function SurfingBuffShieldObj:ShowStaticEffect()
  if self.logic.ignoreSpectacularEffect then
    return
  end
  local pos = self.logic.staticEffectCommonPos
  if self.effectParent == nil then
    pos.x = self.curWorldPos.x
    pos.y = self.curWorldPos.y + 1
    pos.z = self.curWorldPos.z
  else
    pos.x = 0
    pos.y = 1
    pos.z = 0
  end
  self.staticEffectId = self.logic:ShowEffectObj("Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_shine.prefab", pos, nil, -1, self.effectParent)
end

function SurfingBuffShieldObj:ResetEffectPosition()
  if self.effectParent == nil and self.staticEffectId then
    local p = self.curWorldPos
    self.logic:ResetEffectPosition(self.staticEffectId, p.x, p.y + 1, p.z)
  end
end

function SurfingBuffShieldObj:OnCollide(target)
  base.OnCollide(self, target)
end

return SurfingBuffShieldObj
