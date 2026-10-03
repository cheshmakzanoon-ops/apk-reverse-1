local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)
local Time = _ENV.Time
local bornAnimLen = 2
local animScale = 1.5

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:Init()
end

function State:OnEnter()
  self.owner:PlaySimpleAnim(ZombieAnim.Born, animScale)
  self.bornTime = Time.time + bornAnimLen / animScale
end

function State:OnExit()
end

function State:OnUpdate(deltaTime)
  if Time.time > self.bornTime then
    self.owner:ChangeState(self.owner.State.Run)
  end
end

return State
