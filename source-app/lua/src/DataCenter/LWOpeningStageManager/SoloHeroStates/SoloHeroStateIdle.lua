local IdleState = {}
local FSMachine = require("Common.FSMachine")
IdleState.__index = IdleState
setmetatable(IdleState, FSMachine.State)

function IdleState.Create()
  local copy = {}
  setmetatable(copy, IdleState)
  copy:Init()
  return copy
end

function IdleState:OnEnter()
  self.owner.animator:Play("idle")
end

function IdleState:OnUpdate(deltaTime)
  if #self.owner.targets > 0 then
    self.owner.fsm:Switch("Aim", self.owner.targets[1])
  end
end

return IdleState
