local ReloadState = {}
local FSMachine = require("Common.FSMachine")
ReloadState.__index = ReloadState
setmetatable(ReloadState, FSMachine.State)

function ReloadState.Create()
  local copy = {}
  setmetatable(copy, ReloadState)
  copy:Init()
  return copy
end

function ReloadState:OnEnter()
  self.owner.animator:Play("idle")
  self.timer = 0
end

function ReloadState:OnUpdate(deltaTime)
  self.timer = self.timer + deltaTime
  if self.timer > 1.5 then
    self.owner.fsm:Switch("Idle")
  end
end

return ReloadState
