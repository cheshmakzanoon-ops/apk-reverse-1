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
  if self.owner then
    self.logic = self.owner.logic
    self.owner:PlaySimpleAnim("idle")
  end
end

function State:OnExit()
end

function State:OnUpdate(deltaTime)
  if self.owner:GetPosition().z < self.logic:GetFollowCameraTarget().z then
    self.owner:SetActive(false)
  end
end

return State
