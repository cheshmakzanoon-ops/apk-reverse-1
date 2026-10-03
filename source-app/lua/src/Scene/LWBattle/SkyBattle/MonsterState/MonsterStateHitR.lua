local MonsterStateHitR = BaseClass("MonsterStateHitL")
local Time = _ENV.Time

function MonsterStateHitR:Init(unit)
  self.unit = unit
  self.hitRAnimLen = self.unit:GetAnimLength(SkyBattleAnimName.HitR)
end

function MonsterStateHitR:__delete()
  self.unit = nil
end

function MonsterStateHitR:OnEnter()
  self.hitEndTime = Time.time + self.hitRAnimLen
  self.unit:PlaySimpleAnim(SkyBattleAnimName.HitR, 1)
end

function MonsterStateHitR:OnExit()
end

function MonsterStateHitR:OnUpdate(deltaTime)
  if Time.time > self.hitEndTime then
    self.unit.fsm:ChangeState(SkyBattleMonsterStateType.SearchTarget)
  end
end

return MonsterStateHitR
