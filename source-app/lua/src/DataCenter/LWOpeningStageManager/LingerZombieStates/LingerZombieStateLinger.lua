local LingerState = {}
local FSMachine = require("Common.FSMachine")
LingerState.__index = LingerState
setmetatable(LingerState, FSMachine.State)

function LingerState.Create()
  local copy = {}
  setmetatable(copy, LingerState)
  copy:Init()
  return copy
end

function LingerState:OnEnter()
  self.owner.animator:Play("walk")
end

return LingerState
