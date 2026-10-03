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
  local animName = self.owner.AnimType.Hold[self.owner.targetTransDirType]
  self.owner:ResetLocalRotation()
  self.owner:PlaySimpleAnim(animName, 1)
  self.owner.logic:AddOneJumpZombieSpeedBuff(self.owner)
end

function State:OnExit()
end

function State:OnUpdate(deltaTime)
  if self.owner.needDropTime <= 0 then
    self.owner:ChangeState(self.owner.State.Drop)
  end
end

return State
