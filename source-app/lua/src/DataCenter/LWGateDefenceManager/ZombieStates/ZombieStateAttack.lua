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

function State:OnEnter()
  self.attckCD = 0.1
  self.animTimer = 0
end

function State:OnUpdate(deltaTime)
  if self.animTimer > 0 then
    self.animTimer = self.animTimer - deltaTime
    if self.animTimer <= 0 then
      self.owner.animator:CrossFade("idle", 0.5)
      self.attckCD = math.random() * (MNs.ZombieAttackCDMax - MNs.ZombieAttackCDMin) + MNs.ZombieAttackCDMin
    end
  end
  if 0 < self.attckCD then
    self.attckCD = self.attckCD - deltaTime
    if 0 >= self.attckCD then
      self.owner.animator:CrossFade("attack", 0.5)
      self.animTimer = self.owner.animator:GetClipLength("attack")
    end
  end
end

return State
