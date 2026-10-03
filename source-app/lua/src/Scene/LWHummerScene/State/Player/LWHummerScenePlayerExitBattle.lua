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
  local random = math.random(1, 2)
  self.owner:PlaySimpleAnim("show3_" .. random)
end

function State:OnExit()
end

function State:OnUpdate(deltaTime)
  if self.owner == nil then
    return
  end
  local speed = self.owner:GetMoveSpeedVertical()
  local position = self.owner:GetPosition()
  local moveZ = position.z + speed * deltaTime
  self.owner:SetPosition(position.x, moveZ)
end

return State
