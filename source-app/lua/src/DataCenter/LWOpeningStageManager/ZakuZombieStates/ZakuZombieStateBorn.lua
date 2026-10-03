local BornState = {}
local FSMachine = require("Common.FSMachine")
BornState.__index = BornState
setmetatable(BornState, FSMachine.State)

function BornState.Create()
  local copy = {}
  setmetatable(copy, BornState)
  copy:Init()
  return copy
end

function BornState:OnEnter()
  self.timer = 0
end

function BornState:OnUpdate(deltaTime)
  self.timer = self.timer + deltaTime
  if self.timer > 2.8 then
    self.owner.fsm:Switch("Walk")
  end
end

return BornState
