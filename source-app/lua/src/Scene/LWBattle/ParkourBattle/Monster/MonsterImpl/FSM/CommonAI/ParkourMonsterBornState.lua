local ParkourMonsterBornState = BaseClass("ParkourMonsterBornState")
local Time = _ENV.Time
local bornAnimLen = 2.8

function ParkourMonsterBornState:__init(unit)
  self.unit = unit
end

function ParkourMonsterBornState:Init(unit)
  self.unit = unit
end

function ParkourMonsterBornState:__delete()
  self.unit = nil
end

function ParkourMonsterBornState:OnEnter()
  self.unit:StopAgent()
  self.bornTime = Time.time + bornAnimLen
  self.unit:PlaySimpleAnim(ZombieAnim.Born, 1)
end

function ParkourMonsterBornState:OnExit()
end

function ParkourMonsterBornState:OnUpdate()
  if Time.time > self.bornTime then
    self.unit.fsm:ChangeState(ZombieState.Idle)
  end
end

return ParkourMonsterBornState
