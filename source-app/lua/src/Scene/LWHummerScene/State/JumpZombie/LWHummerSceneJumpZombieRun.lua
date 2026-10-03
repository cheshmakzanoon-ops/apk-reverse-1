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
  local owner = self.owner
  if owner.agent then
    local pos = owner:GetPosition()
    owner.agent.speed = owner.logic.data:GetZombieSpeed()
    owner.agent:SetCurPosition(pos.x, pos.z)
  end
  owner:PlaySimpleAnim(AnimName.Run, 1)
end

function State:OnExit()
  self.owner:RemoveDestination()
end

function State:OnUpdate(deltaTime)
  local targetPos = self.owner:GetTargetPos()
  if targetPos then
    if self.owner:ArriveJumpDis() then
      self.owner:RemoveDestination()
      self.owner:ChangeState(self.owner.State.Jump)
    else
      self.owner:SetDestination(targetPos.x, targetPos.z)
    end
  end
end

return State
