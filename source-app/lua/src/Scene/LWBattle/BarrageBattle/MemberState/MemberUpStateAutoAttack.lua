local MemberUpStateAutoAttack = BaseClass("MemberUpStateAutoAttack")
local FORWARD = Vector3.New(0, 0, 25)

function MemberUpStateAutoAttack:__init(unit)
  self.unit = unit
  self.target = nil
end

function MemberUpStateAutoAttack:__delete()
  self.unit = nil
  self.target = nil
  self.prevSkill = nil
  self.nextSkill = nil
end

function MemberUpStateAutoAttack:OnEnter()
  self.target = nil
  self.prevSkill = nil
  self.nextSkill = nil
end

function MemberUpStateAutoAttack:OnExit()
  self.target = nil
  self.prevSkill = nil
  self.nextSkill = nil
  self.unit.skillManager:Interrupt()
end

function MemberUpStateAutoAttack:CheckDirection()
  if self.unit == self.target then
    return true
  end
  return PveUtil.CheckCannonLookAt(self.unit, self.target:GetPosition())
end

function MemberUpStateAutoAttack:OnUpdate()
  if self.unit.skillManager:GetCastingSkill() then
    local curSkill = self.unit.skillManager:GetCastingSkill()
    if (curSkill:GetState() == SkillCastState.FrontSwing or curSkill:GetState() == SkillCastState.Chant) and not curSkill:IsBuffSkill() and not curSkill:HasMovingLogic() then
      if self.target and self.target:GetCurBlood() > 0 then
        self:CheckDirection()
      else
        self.target = self:GetTarget(curSkill)
      end
    end
  else
    if self.unit:IsMoving() then
      self.unit:CrossFadeSimpleAnimSafe(AnimName.Run, 1, 0.2)
    else
      self.unit:CrossFadeSimpleAnimSafe(AnimName.Idle, 1, 0.2)
    end
    if not self.nextSkill then
      local preTarget
      self.nextSkill, preTarget = self.unit.skillManager:GetActiveSkill()
      if self.nextSkill then
        if self.nextSkill:IsBuffSkill() then
          local skill = self.nextSkill
          self.unit.skillManager:ActiveCast(self.nextSkill, self:GetTarget(self.nextSkill, preTarget))
          self.nextSkill = nil
          if self.unit.unitType and self.unit.unitType == UnitType.TacticalWeapon then
            EventManager:GetInstance():Broadcast(EventId.OnPVETacticalWeaponCastSkill, skill)
          end
        else
          self.target = self:GetTarget(self.nextSkill, preTarget)
        end
      end
    end
    if self.nextSkill then
      if not self.target or self.target:GetCurBlood() <= 0 then
        self.target = self:GetTarget(self.nextSkill)
      end
      if self.target and self.target:GetCurBlood() > 0 then
        if self.nextSkill:HasMovingLogic() then
          if self.unit and not IsNull(self.unit.transform) then
            self.unit.transform.localRotation = Quaternion.Euler(0, 0, 0)
          end
          self.unit.skillManager:ActiveCast(self.nextSkill, self.target)
          self.prevSkill = self.nextSkill
          self.nextSkill = nil
        elseif self:CheckDirection() then
          local skill = self.nextSkill
          self.unit.skillManager:ActiveCast(self.nextSkill, self.target)
          self.prevSkill = self.nextSkill
          self.nextSkill = nil
          if self.unit.unitType and self.unit.unitType == UnitType.TacticalWeapon then
            EventManager:GetInstance():Broadcast(EventId.OnPVETacticalWeaponCastSkill, skill)
          end
        end
      end
    elseif self.unit.unitType == UnitType.TacticalWeapon then
      local ultimateSkill = self.unit.skillManager:GetUltimateSkill()
      if ultimateSkill then
        if not self.target or self.target:GetCurBlood() <= 0 then
          self.target = self:GetTarget(ultimateSkill)
        end
        if self.target and self.target:GetCurBlood() > 0 then
          self:CheckDirection()
        end
      end
    end
  end
end

function MemberUpStateAutoAttack:GetTarget(skill, preTarget)
  if skill:IsNormalAttack() then
    local tauntTarget = self.unit:GetTauntTarget()
    if tauntTarget then
      return tauntTarget
    end
  end
  local ret = preTarget
  if ret == nil then
    ret = skill:SearchTarget()
  end
  return ret
end

return MemberUpStateAutoAttack
