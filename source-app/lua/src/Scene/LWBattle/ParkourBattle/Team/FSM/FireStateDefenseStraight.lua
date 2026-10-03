local FORWARD = Vector3.New(0, 0, 25)
local FireStateDefenseStraight = BaseClass("FireStateDefenseStraight")

function FireStateDefenseStraight:__init(unit)
  self.unit = unit
end

function FireStateDefenseStraight:__delete()
  self.unit = nil
end

function FireStateDefenseStraight:OnEnter()
  if self.unit and not IsNull(self.unit.transform) and self.unit.cannon and not IsNull(self.unit.cannon.transform) then
    self.unit.transform.localRotation = Quaternion.Euler(0, 0, 0)
    self.unit.cannon.transform.localRotation = Quaternion.Euler(0, 0, 0)
  end
  local cur = self.unit:GetCurAnimName()
  if cur == nil or cur ~= AnimName.Idle then
    self.unit:PlaySimpleAnim(AnimName.Idle)
  end
end

function FireStateDefenseStraight:OnExit()
  self.unit.skillManager:Interrupt()
end

function FireStateDefenseStraight:OnUpdate()
  if self.unit.skillManager:GetCastingSkill() then
    return
  end
  local skill, preTarget
  if self.unit.skillManager:IsSpecialStraightBulletType() then
    local tmpTarget = self.unit.logic.tmpStraightBulletTarget
    if tmpTarget then
      skill = self.unit.skillManager:GetActiveSkillWithTarget(tmpTarget)
    else
      skill, preTarget = self.unit.skillManager:GetActiveSkill()
    end
  elseif skill == nil then
    skill, preTarget = self.unit.skillManager:GetActiveSkill()
  end
  if skill then
    if skill:IsBuffSkill() then
      self.unit.skillManager:ActiveCast(skill, preTarget or skill:SearchTarget())
      if self.unit.unitType and self.unit.unitType == UnitType.TacticalWeapon then
        EventManager:GetInstance():Broadcast(EventId.OnPVETacticalWeaponCastSkill, skill)
      end
    else
      local target = self:GetTarget(skill, preTarget)
      if target then
        self.unit.skillManager:ActiveCast(skill, target)
        if self.unit.unitType and self.unit.unitType == UnitType.TacticalWeapon then
          EventManager:GetInstance():Broadcast(EventId.OnPVETacticalWeaponCastSkill, skill)
        end
      end
    end
  elseif not self.unit:ForbidSkillAnim() then
    self.unit:CrossFadeSimpleAnimSafe(AnimName.Idle, 1, 0.2)
  end
end

function FireStateDefenseStraight:GetTarget(skill, preTarget)
  if skill:IsNormalAttack() then
    local tauntTarget = self.unit:GetTauntTarget()
    if tauntTarget then
      return tauntTarget
    end
  end
  local specialStraightBulletType = skill:IsSpecialStraightBulletType()
  if specialStraightBulletType then
    local tmpTarget = self.unit.logic.tmpStraightBulletTarget
    if tmpTarget then
      return tmpTarget
    end
  end
  local ret = preTarget
  if nil == ret then
    ret = skill:SearchTarget()
  end
  if specialStraightBulletType then
    self.unit.logic.tmpStraightBulletTarget = ret
  end
  return ret
end

return FireStateDefenseStraight
