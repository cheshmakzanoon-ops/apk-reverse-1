local ZombieStateBorn = BaseClass("ZombieStateBorn")
local Time = _ENV.Time
local bornAnimLen = 2.8

function ZombieStateBorn:__init(unit)
  self.unit = unit
end

function ZombieStateBorn:Init(unit)
  self.unit = unit
end

function ZombieStateBorn:__delete()
  self.unit = nil
end

function ZombieStateBorn:OnEnter()
  self.unit:RemoveDestination()
  self.bornTime = Time.time + bornAnimLen
  self.unit:PlaySimpleAnim(ZombieAnim.Born, 1)
  if self.unit.OnEnterBornState then
    self.unit:OnEnterBornState()
  end
end

function ZombieStateBorn:OnExit()
end

function ZombieStateBorn:OnUpdate()
  if Time.time > self.bornTime then
    self.unit.fsm:ChangeState(ZombieState.Idle)
  end
end

return ZombieStateBorn
