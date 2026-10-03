local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)
local Const = require("DataCenter/Dominator/Train/DominatorTrainSceneConstant")

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:Init()
end

function State:OnExit()
  local owner = self.owner
  if owner then
    owner:ReleaseDominatorIdle()
  end
end

function State:OnEnter(defaultAnim)
  local owner = self.owner
  if owner then
    owner:SetToFrontAngle()
    owner:ReloadDominatorIdle(defaultAnim)
  end
end

function State:Dispose()
end

return State
