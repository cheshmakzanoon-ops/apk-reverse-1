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
  self.owner.animator:CrossFade("idle", 0.5)
  if self.owner.fireEffectContext.bullet == 1 then
    self.cd = math.random() * (MNs.HeroMachineGunCDMax - MNs.HeroMachineGunCDMin) + MNs.HeroMachineGunCDMin
  else
    self.cd = math.random() * (MNs.HeroArtilleryCDMax - MNs.HeroArtilleryCDMin) + MNs.HeroArtilleryCDMin
  end
end

function State:OnUpdate(deltaTime)
  if self.cd > 0 then
    self.cd = self.cd - deltaTime
    if self.cd <= 0 then
      self.owner.fsm:Switch("Search")
    end
  end
end

return State
