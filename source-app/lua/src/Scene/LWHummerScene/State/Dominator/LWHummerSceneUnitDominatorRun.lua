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
    self.data = self.logic.data
    self.player = self.logic.player
    self.owner:PlaySimpleAnim("run")
    self.deltaTime = self.data:GetDominatorAtkCD()
  end
end

function State:OnExit()
end

function State:OnUpdate(deltaTime)
  if self.owner == nil then
    return
  end
  local position = self.owner:GetPosition()
  local moveZ = self.player:GetPosition().z + self.data:GetDominatorOffset()
  self.owner:SetPosition(position.x, moveZ)
  self.deltaTime = self.deltaTime - deltaTime
  if self.deltaTime <= 0 then
    local targetPos = self.owner:GetMoveAtkTargetPos()
    if targetPos then
      self.owner:ChangeState(self.owner.State.MoveAttack, targetPos)
    end
  end
end

return State
