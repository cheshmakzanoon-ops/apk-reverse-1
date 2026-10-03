local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)
local MNs = require("DataCenter.LWGateDefenceManager.LWGateDefenceMagicNumbers")

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:OnEnter(dir, force)
  self.delayTimer = 3
  self.disTimer = MNs.FALLING_TIME
  self.owner.animator.enabled = false
  self.owner.unityAnimator.enabled = false
  for i = 0, self.owner.rigidbodys.Length - 1 do
    self.owner.rigidbodys[i].isKinematic = false
  end
  self.owner.rootRigidbody:AddForce(dir * force)
end

function State:OnUpdate(deltaTime)
  if self.delayTimer > 0 then
    self.delayTimer = self.delayTimer - deltaTime
    if self.delayTimer <= 0 and self.owner.transformValid then
      self.fallPos = Vector3(self.owner.transform:Get_position())
      self.disPos = self.fallPos + Vector3(0, -1, 0)
      for i = 0, self.owner.rigidbodys.Length - 1 do
        self.owner.rigidbodys[i].isKinematic = true
      end
    end
  end
  if self.delayTimer <= 0 and 0 < self.disTimer then
    self.disTimer = self.disTimer - deltaTime
    if 0 >= self.disTimer then
      DataCenter.LWGateDefenceManager:DestroyZombie(self.owner.id)
    else
      local t = self.disTimer / MNs.FALLING_TIME
      if self.owner.transformValid then
        self.owner.transform:Set_position(Vector3.Lerp(self.fallPos, self.disPos, 1 - t):Split())
      end
    end
  end
end

function State:OnExit()
end

return State
