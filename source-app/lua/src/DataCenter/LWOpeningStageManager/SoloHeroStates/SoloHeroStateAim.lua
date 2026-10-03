local AimState = {}
local FSMachine = require("Common.FSMachine")
AimState.__index = AimState
setmetatable(AimState, FSMachine.State)

function AimState.Create()
  local copy = {}
  setmetatable(copy, AimState)
  copy:Init()
  return copy
end

function AimState:OnEnter(target)
  self.owner.turret.target = target.transform
  
  function self.owner.turret.OnComplete()
    self.owner.fsm:Switch("Fire", target)
  end
end

function AimState:OnExit()
  self.owner.turret.target = nil
  self.owner.turret.OnComplete = nil
end

return AimState
