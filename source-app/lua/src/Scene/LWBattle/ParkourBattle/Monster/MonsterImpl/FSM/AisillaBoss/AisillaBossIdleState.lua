local AisillaBossIdleState = BaseClass("AisillaBossIdleState")
local CHECK_TARGET_IN_RANGE_CD = 0.5

function AisillaBossIdleState:Init(unit)
  self.unit = unit
  self.checkTargetInRangeCd = 0
end

function AisillaBossIdleState:__delete()
  self.unit = nil
end

function AisillaBossIdleState:OnEnter()
  self.unit:SetInvincible(false)
end

function AisillaBossIdleState:OnExit()
end

function AisillaBossIdleState:OnUpdate(deltaTime)
  if self.checkTargetInRangeCd <= 0 then
    self.checkTargetInRangeCd = CHECK_TARGET_IN_RANGE_CD
    if self:CheckTargetInSight() then
      return
    end
  else
    self.checkTargetInRangeCd = self.checkTargetInRangeCd - deltaTime
  end
end

function AisillaBossIdleState:CheckTargetInSight()
  if self.unit.skillManager:GetCastingSkill() then
    return
  end
  local nextSkill = self.unit:GetActiveSkillIgnoreRangeLimit()
  if nextSkill then
    local target = nextSkill:SearchTargetIgnoreRange()
    self.unit.skillManager:ActiveCast(nextSkill, target)
  end
end

return AisillaBossIdleState
