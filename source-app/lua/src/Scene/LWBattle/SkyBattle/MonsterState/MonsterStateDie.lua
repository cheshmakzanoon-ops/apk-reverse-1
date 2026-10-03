local MonsterStateDie = BaseClass("MonsterStateDie")

function MonsterStateDie:Init(unit)
  self.unit = unit
  local animLength = self.unit:GetAnimLength(SkyBattleAnimName.Dead)
  self.animLength = animLength
end

function MonsterStateDie:__delete()
  self.unit = nil
  self.animLength = nil
  self.countdown = nil
end

function MonsterStateDie:OnEnter()
  self.unit:PlaySimpleAnim(SkyBattleAnimName.Dead, 1)
  self.unit.mgr:OnMonsterDeath(self.unit.guid)
  self.unit:FinishFlashCountdown()
  self.countdown = self.animLength
end

function MonsterStateDie:OnExit()
end

function MonsterStateDie:OnUpdate()
  if self.countdown then
    self.countdown = self.countdown - Time.deltaTime
    if self.countdown < 0 then
      self.unit.mgr:RemoveMonster(self.unit.guid)
      self.countdown = nil
    end
  end
end

return MonsterStateDie
