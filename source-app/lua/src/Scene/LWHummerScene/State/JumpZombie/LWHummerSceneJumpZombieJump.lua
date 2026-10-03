local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)
local Constant = require("Scene.LWHummerScene.LWHummerSceneConstant")

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:Init()
end

function State:OnEnter()
  self:PlayAnimByIndex(1)
  local player = self.owner.logic.player
  if self.owner.targetTransDirType == self.owner.DirType.Left then
    player:ShowHit(player.HitState.Left)
  else
    player:ShowHit(player.HitState.Right)
  end
end

function State:PlayAnimByIndex(index)
  local animName = self.owner.AnimType["Jump" .. index][self.owner.targetTransDirType]
  self.animLength = self.owner:GetAnimLength(animName)
  self.animLength = self.animLength > 0 and self.animLength or 2
  self.countdown = self.animLength
  self.index = index
  if index == 2 then
    self.owner:OnChangeJumpParent()
    self.startLocalPos = self.owner:GetLocalPosition()
    self.direction = (Vector3.zero - self.startLocalPos).normalized
    self.moveDelta = Vector3.Distance(Vector3.zero, self.startLocalPos) / Constant.JUMP_ZOMBIE_SPEED
    self.moveFullDelta = self.moveDelta
    self.countdown = nil
  elseif index == 3 then
    self.owner:ResetLocalRotation()
  end
  self.owner:PlaySimpleAnim(animName, 1)
end

function State:OnExit()
end

function State:OnUpdate(deltaTime)
  local index = 0
  if self.countdown then
    self.countdown = self.countdown - deltaTime
    if 0 > self.countdown then
      index = self.index + 1
      if 3 < index then
        self.owner:ChangeState(self.owner.State.Hold)
        self.countdown = nil
      elseif index ~= self.index then
        self:PlayAnimByIndex(index)
      end
    end
  end
  if self.moveDelta then
    self.moveDelta = self.moveDelta - deltaTime
    if 0 >= self.moveDelta then
      self.moveDelta = nil
      self.owner:SetLocalPosition(Vector3.zero)
      self:PlayAnimByIndex(self.index + 1)
    else
      local pos = self.startLocalPos + self.direction * (self.moveFullDelta - self.moveDelta) * Constant.JUMP_ZOMBIE_SPEED
      self.owner:SetLocalPosition(pos)
    end
  end
end

return State
