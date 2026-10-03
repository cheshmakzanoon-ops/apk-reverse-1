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
    if not self.owner.active then
      local position = self.owner:GetPosition()
      self.owner:SetPosition(position.x, self.player:GetPosition().z + self.data:GetDominatorSpawnOffset())
      self.owner:SetActive(true)
    end
    self.owner:PlaySimpleAnim("run")
  end
end

function State:OnExit()
end

function State:OnUpdate(deltaTime)
  if self.owner == nil then
    return
  end
  local speed = self.data:GetDominatorSpawnSpeed()
  local position = self.owner:GetPosition()
  local moveZ = position.z + (speed + self.player:GetMoveSpeedVertical()) * deltaTime
  local playerZ = self.player:GetPosition().z + self.data:GetDominatorOffset()
  if moveZ >= playerZ then
    moveZ = playerZ
    self.owner:SetPosition(position.x, moveZ)
    self.owner:ChangeState(self.owner.State.Run)
  else
    self.owner:SetPosition(position.x, moveZ)
  end
end

return State
