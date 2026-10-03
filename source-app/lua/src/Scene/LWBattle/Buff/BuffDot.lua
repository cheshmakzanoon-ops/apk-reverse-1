local base = require("Scene.LWBattle.Buff.BuffBase")
local BuffDot = BaseClass("BuffDot", base)
local EffectNumSourceType = {Caster = 1, Owner = 2}

function BuffDot:__init(logic, mgr, unit, meta, id, param)
  self.logic = logic
  self.isPVP = PVPType[logic:GetPVEType()]
  if self.isPVP then
    self.damage = param
  elseif meta.para[1] == EffectNumSourceType.Caster then
    self.source = param
  elseif meta.para[2] == EffectNumSourceType.Owner then
    self.source = unit
  end
  if self.meta then
    if self.meta.para and self.meta.para[5] then
      self.damageType = self.meta.para[5]
    else
      self.damageType = DamageType.None
    end
  else
    self.damageType = DamageType.None
  end
end

function BuffDot:__delete()
  self:Destroy()
end

function BuffDot:Destroy()
  base.Destroy(self)
end

function BuffDot:OnStart()
  self.mgr:RegisterDotBuff(self.meta.para[4], self)
end

function BuffDot:OnEnd()
  self.mgr:UnregisterDotBuff(self.meta.para[4], self)
end

function BuffDot:GetDamage()
  if self.isPVP then
    return self.damage
  else
    return math.floor(self.source:GetProperty(self.meta.para[2]) * self.meta.para[3])
  end
end

return BuffDot
