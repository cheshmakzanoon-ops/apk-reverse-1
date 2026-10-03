local FORWARD = Vector3.New(0, 0, 25)
local FireStateMultiSkillStraight = BaseClass("FireStateMultiSkillStraight")

function FireStateMultiSkillStraight:__init(unit)
  self.unit = unit
end

function FireStateMultiSkillStraight:__delete()
  self.unit = nil
end

function FireStateMultiSkillStraight:OnEnter()
  if self.unit and not IsNull(self.unit.transform) and self.unit.cannon and not IsNull(self.unit.cannon.transform) then
    self.unit.transform.localRotation = Quaternion.Euler(0, 0, 0)
    self.unit.cannon.transform.localRotation = Quaternion.Euler(0, 0, 0)
  end
  local cur = self.unit:GetCurAnimName()
  if cur == nil or cur ~= AnimName.Idle then
    self.unit:PlaySimpleAnim(AnimName.Idle)
  end
end

function FireStateMultiSkillStraight:OnExit()
  self.unit.skillManager:Interrupt()
end

function FireStateMultiSkillStraight:OnUpdate()
  local skill
  if self.unit.skillManager:IsSpecialStraightBulletType() then
    local tmpTarget = self.unit.logic.tmpStraightBulletTarget
    if tmpTarget then
      skill = self.unit.skillManager:GetActiveSkillWithTarget(tmpTarget)
    else
      skill = self.unit.skillManager:GetActiveSkill()
    end
  elseif skill == nil then
    skill = self.unit.skillManager:GetActiveSkill()
  end
  if skill then
    if skill:IsBuffSkill() then
      self.unit.skillManager:ActiveCast(skill, skill:SearchTarget())
      if self.unit.unitType and self.unit.unitType == UnitType.TacticalWeapon then
        EventManager:GetInstance():Broadcast(EventId.OnPVETacticalWeaponCastSkill, skill)
      end
    else
      local target = self:GetTarget(skill)
      if target then
        self.unit.skillManager:ActiveCast(skill, target)
        if self.unit.unitType and self.unit.unitType == UnitType.TacticalWeapon then
          EventManager:GetInstance():Broadcast(EventId.OnPVETacticalWeaponCastSkill, skill)
        end
      end
    end
  elseif not self.unit:ForbidSkillAnim() then
    self.unit:CrossFadeSimpleAnim(AnimName.Idle, 1, 0.2)
  end
end

function FireStateMultiSkillStraight:GetTarget(skill)
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
  local ret = skill:SearchTarget()
  if specialStraightBulletType then
    self.unit.logic.tmpStraightBulletTarget = ret
  end
  return ret
end

return FireStateMultiSkillStraight
