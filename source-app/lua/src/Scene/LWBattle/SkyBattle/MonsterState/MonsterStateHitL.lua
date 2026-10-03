local MonsterStateHitL = BaseClass("MonsterStateHitL")
local Time = _ENV.Time

function MonsterStateHitL:Init(unit)
  self.unit = unit
  self.hitLAnimLen = self.unit:GetAnimLength(SkyBattleAnimName.HitL)
end

function MonsterStateHitL:__delete()
  self.unit = nil
end

function MonsterStateHitL:OnEnter()
  self.hitEndTime = Time.time + self.hitLAnimLen
  self.unit:PlaySimpleAnim(SkyBattleAnimName.HitL, 1)
end

function MonsterStateHitL:OnExit()
end

function MonsterStateHitL:OnUpdate(deltaTime)
  if Time.time > self.hitEndTime then
    self.unit.fsm:ChangeState(SkyBattleMonsterStateType.SearchTarget)
  end
end

return MonsterStateHitL
