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
  local owner = self.owner
  if not owner then
    return
  end
  owner:PlayAnim(owner.Anim.DeadIdle)
end

return State
