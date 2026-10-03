local base = require("Scene.LWBattle.Buff.BuffBase")
local BuffShield = BaseClass("BuffShield", base)

function BuffShield:__init(logic, mgr, unit, meta, id, caster)
  self.logic = logic
  self.caster = caster
  self.subType = self.meta.sub_type
  self.shieldValue = 0
end

function BuffShield:__delete()
  self:Destroy()
end

function BuffShield:Destroy()
  base.Destroy(self)
  self.caster = nil
  self.shieldValue = 0
end

function BuffShield:OnUpdate()
  base.OnUpdate(self)
  if self.shieldValue <= 0 then
    self:Remove()
  end
end

function BuffShield:OnStart()
  local para = self.meta.para
  if self.subType == BuffSubType.ShieldFromValue then
    if para then
      self.shieldValue = para
    end
  elseif self.subType == BuffSubType.ShieldFromCasterHp then
    if self.caster then
      if para and self.caster.maxBlood then
        self.shieldValue = self.caster.maxBlood * para
      end
    else
      Logger.LogError("BuffShield OnStart caster is nil. metaId : " .. self.meta.id)
    end
  end
  self.mgr:RegisterShieldBuff(self)
end

function BuffShield:OnEnd()
  self.shieldValue = 0
  self.mgr:UnregisterShieldBuff(self)
end

function BuffShield:GetShieldValue()
  return self.shieldValue
end

function BuffShield:ReduceShieldValue(hurt)
  if hurt <= self.shieldValue then
    self.shieldValue = self.shieldValue - hurt
    return 0
  end
  local remain = hurt - self.shieldValue
  self.shieldValue = 0
  return remain
end

function BuffShield:ReduceAll()
  self.shieldValue = 0
end

return BuffShield
