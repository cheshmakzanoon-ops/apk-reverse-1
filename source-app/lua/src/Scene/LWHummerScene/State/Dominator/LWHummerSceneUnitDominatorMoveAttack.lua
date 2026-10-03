local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)
local preCD = 0.1

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:Init()
end

function State:OnEnter(targetPos)
  if self.owner then
    local animName = "attack_move"
    self.logic = self.owner.logic
    self.data = self.logic.data
    self.player = self.logic.player
    self.owner:PlaySimpleAnim(animName)
    self.animLength = self.owner:GetAnimLength(animName)
    self.animLength = self.animLength > 0 and self.animLength or 2
    self.deltaTime = self.animLength
    self.targetPos = targetPos
    self.owner.transform:LookAt(targetPos)
    self.skillDelta = preCD
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
    self.owner:ChangeState(self.owner.State.Run)
  elseif self.skillDelta then
    self.skillDelta = self.skillDelta - deltaTime
    if 0 >= self.skillDelta then
      self.owner:CastSkill(self.targetPos)
      self.skillDelta = nil
    end
  end
end

return State
