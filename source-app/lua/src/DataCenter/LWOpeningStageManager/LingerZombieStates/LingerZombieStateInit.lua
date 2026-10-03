local InitState = {}
local FSMachine = require("Common.FSMachine")
InitState.__index = InitState
setmetatable(InitState, FSMachine.State)

function InitState.Create()
  local copy = {}
  setmetatable(copy, InitState)
  copy:Init()
  return copy
end

function InitState:OnEnter()
  self.owner.animator:Play("idle")
  self.owner.fsm:Switch(self.owner.state)
end

return InitState
