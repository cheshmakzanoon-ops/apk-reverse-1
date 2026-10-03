local AisillaBossDiveState = BaseClass("AisillaBossDiveState")
local CHECK_TARGET_IN_RANGE_CD = 0.1

function AisillaBossDiveState:Init(unit)
  self.unit = unit
  self.checkTargetInRangeCd = 0
end

function AisillaBossDiveState:__delete()
  self.unit = nil
end

function AisillaBossDiveState:OnEnter()
  self.unit:EnterDive()
end

function AisillaBossDiveState:OnExit()
  self.unit:ExitDive()
end

function AisillaBossDiveState:OnUpdate(deltaTime)
  if self.checkTargetInRangeCd <= 0 then
    self.checkTargetInRangeCd = CHECK_TARGET_IN_RANGE_CD
    if self:CheckTargetInSight() then
      return
    end
  else
    self.checkTargetInRangeCd = self.checkTargetInRangeCd - deltaTime
  end
end

function AisillaBossDiveState:CheckTargetInSight()
  if self.unit.skillManager:GetCastingSkill() then
    return
  end
  local nextSkill = self.unit:GetSpecialActiveSkillIgnoreRangeLimit()
  if nextSkill then
    local target = nextSkill:SearchTargetIgnoreRange()
    self.unit.skillManager:ActiveCast(nextSkill, target)
  end
end

return AisillaBossDiveState
