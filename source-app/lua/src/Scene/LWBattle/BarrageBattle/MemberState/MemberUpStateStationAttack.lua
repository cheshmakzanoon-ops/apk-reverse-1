local MemberUpStateStationAttack = BaseClass("MemberUpStateStationAttack")

function MemberUpStateStationAttack:__init(unit)
  self.unit = unit
  self.attackPos = nil
end

function MemberUpStateStationAttack:__delete()
  self.unit = nil
  self.attackPos = nil
end

function MemberUpStateStationAttack:OnEnter(attackPos)
  self.attackPos = attackPos
end

function MemberUpStateStationAttack:OnTransToSelf(attackPos)
  self.attackPos = attackPos
end

function MemberUpStateStationAttack:OnExit()
  self.unit.skillManager:Interrupt()
  self.attackPos = nil
end

function MemberUpStateStationAttack:CheckDirection()
  return PveUtil.CheckCannonLookAt(self.unit, self.attackPos)
end

function MemberUpStateStationAttack:OnUpdate()
  self:CheckDirection()
  local skill = self.unit.skillManager:GetActiveSkillIgnoreRange()
  if skill then
    if skill:IsBuffSkill() then
      self.unit.skillManager:ActiveCast(skill, skill:SearchTarget())
      if self.unit.unitType and self.unit.unitType == UnitType.TacticalWeapon then
        EventManager:GetInstance():Broadcast(EventId.OnPVETacticalWeaponCastSkill, skill)
      end
    else
      local targetPos = skill:SearchTargetAroundAim(self.attackPos)
      self.unit.skillManager:ActiveCast(skill, targetPos)
      if self.unit.unitType and self.unit.unitType == UnitType.TacticalWeapon then
        EventManager:GetInstance():Broadcast(EventId.OnPVETacticalWeaponCastSkill, skill)
      end
    end
    self.isRunOrIdle = false
  end
  if not self.unit.skillManager:GetCastingSkill() and not self.isRunOrIdle then
    self.isRunOrIdle = true
    if self.unit:IsMoving() then
      self.unit:PlaySimpleAnim(AnimName.Run)
    else
      self.unit:PlaySimpleAnim(AnimName.Idle)
    end
  end
end

function MemberUpStateStationAttack:HandleInput(input, param)
end

return MemberUpStateStationAttack
