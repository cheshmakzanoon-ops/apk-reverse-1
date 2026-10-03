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

function State:OnUpdate(deltaTime)
  local owner = self.owner
  if not owner then
    return
  end
  local position = owner:GetPosition()
  local add = owner:GetMoveSpeedVertical() * deltaTime
  local z = position.z + add
  owner:SetPosition(position.x, z)
end

function State:OnEnter()
  local owner = self.owner
  if not owner then
    return
  end
  owner:PlayAnim(owner.Anim.Run01)
  owner:InitAttributeShow()
end

function State:Dispose()
end

return State
