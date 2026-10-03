local MonsterStateSearchTarget = BaseClass("MonsterStateIdle")
local CHECK_TARGET_IN_RANGE_CD = 0.5

function MonsterStateSearchTarget:Init(unit)
  self.unit = unit
  self.checkTargetInRangeCd = 0
end

function MonsterStateSearchTarget:__delete()
  self.unit = nil
end

function MonsterStateSearchTarget:OnEnter()
  self.checkTargetInRangeCd = 0
  self.unit:PlaySimpleAnim(SkyBattleAnimName.Idle, 1)
end

function MonsterStateSearchTarget:OnExit()
end

function MonsterStateSearchTarget:OnUpdate(deltaTime)
  if self.checkTargetInRangeCd <= 0 then
    self.checkTargetInRangeCd = CHECK_TARGET_IN_RANGE_CD
    local nextSkill = self.unit.skillManager:GetActiveSkillIgnoreRange()
    if nextSkill then
      local target = nextSkill:SearchTargetIgnoreRange()
      if target and 0 < target:GetCurBlood() and nextSkill:IsTargetInRange(target) then
        self.unit.fsm:ChangeState(SkyBattleMonsterStateType.Attack, nextSkill, target)
      end
    end
  else
    self.checkTargetInRangeCd = self.checkTargetInRangeCd - deltaTime
  end
end

return MonsterStateSearchTarget
