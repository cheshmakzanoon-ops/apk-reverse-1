local MonsterStateBorn = BaseClass("MonsterStateBorn")
local Time = _ENV.Time

function MonsterStateBorn:Init(unit)
  self.unit = unit
  self.bornAnimLen = self.unit:GetAnimLength(SkyBattleAnimName.Born)
end

function MonsterStateBorn:__delete()
  self.unit = nil
  self.bornAnimLen = 0
end

function MonsterStateBorn:OnEnter()
  self.bornTime = Time.time + self.bornAnimLen
  self.unit:PlaySimpleAnim(SkyBattleAnimName.Born, 1)
  if self.unit.isBoss then
    EventManager:GetInstance():Broadcast(EventId.ParkourBossEnterBattle)
  end
end

function MonsterStateBorn:OnExit()
  if self.unit:HpBarKeepShow() then
    self.unit:InitHpBar()
  end
  self.unit:ForceCurStatusGroupCmpChangeToBorn()
end

function MonsterStateBorn:OnUpdate()
  if Time.time > self.bornTime then
    self.unit.fsm:ChangeState(SkyBattleMonsterStateType.SearchTarget)
  end
end

return MonsterStateBorn
