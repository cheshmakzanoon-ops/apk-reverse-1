local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:Init()
end

function State:OnEnter()
  self.owner:SetPosition(self.owner.logic.data:GetSceneCenterX(), self.owner:GetPosition().z)
  self.owner:ResetSpeedBuff()
  self.owner:PlaySimpleAnim("show1")
end

function State:OnExit()
end

function State:OnUpdate(deltaTime)
end

return State
