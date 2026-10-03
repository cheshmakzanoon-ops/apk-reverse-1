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

function State:OnEnter()
  self.owner.animator:Play("Default")
  self.timer = self.owner.animator:GetClipLength("Default")
end

function State:OnUpdate(deltaTime)
  self.timer = self.timer - deltaTime
  if self.timer <= 0 then
    if self.owner.dstGrid then
      self.owner.fsm:Switch("Move")
    else
      self.owner.fsm:Switch("Idle")
    end
  end
end

return State
