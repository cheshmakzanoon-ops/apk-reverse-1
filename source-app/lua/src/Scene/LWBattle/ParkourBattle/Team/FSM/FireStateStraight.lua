local FORWARD = Vector3.New(0, 0, 25)
local FireStateStraight = BaseClass("FireStateStraight")

function FireStateStraight:__init(unit)
  self.unit = unit
end

function FireStateStraight:__delete()
  self.unit = nil
end

function FireStateStraight:OnEnter()
  if self.unit and not IsNull(self.unit.transform) and self.unit.cannon and not IsNull(self.unit.cannon.transform) then
    self.unit.transform.localRotation = Quaternion.Euler(0, 0, 0)
    self.unit.cannon.transform.localRotation = Quaternion.Euler(0, 0, 0)
  end
  self.unit:PlaySimpleAnim("attack_move")
end

function FireStateStraight:OnExit()
  self.unit.skillManager:Interrupt()
end

function FireStateStraight:OnUpdate()
  local skill = self.unit.skillManager:GetActiveSkillIgnoreRange()
  if skill then
    if skill:IsBuffSkill() then
      self.unit.skillManager:ActiveCast(skill, skill:SearchTarget())
    else
      local target = skill:SearchTargetAroundAimIgnoreRange(self.unit:GetPosition() + FORWARD)
      self.unit.skillManager:ActiveCast(skill, target)
    end
  end
end

return FireStateStraight
