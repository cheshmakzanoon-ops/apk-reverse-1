local MonsterStateAttack = BaseClass("MonsterStateAttack")

function MonsterStateAttack:Init(unit)
  self.unit = unit
end

function MonsterStateAttack:__delete()
  self.unit = nil
end

function MonsterStateAttack:OnEnter(skill, target)
  self.unit.skillManager:ActiveCast(skill, target)
  self.unit:RewindAndPlaySimpleAnim(SkyBattleAnimName.Attack, 1)
end

function MonsterStateAttack:OnExit()
  self.unit.skillManager:Interrupt()
  self.nextSkill = nil
  self.target = nil
end

function MonsterStateAttack:OnUpdate()
  if not self.unit.skillManager:GetCastingSkill() then
    self.unit.fsm:ChangeState(SkyBattleMonsterStateType.SearchTarget)
  end
end

return MonsterStateAttack
