local WalkState = {}
local FSMachine = require("Common.FSMachine")
WalkState.__index = WalkState
setmetatable(WalkState, FSMachine.State)

function WalkState.Create()
  local copy = {}
  setmetatable(copy, WalkState)
  copy:Init()
  return copy
end

function WalkState:OnEnter()
  self.timer = 0
  self.owner.animator:SetBool("walking", true)
end

function WalkState:OnUpdate(deltaTime)
  self.timer = self.timer + deltaTime
  if self.timer > self.owner.config.walkTime then
    self.owner.fsm:Switch("Attack")
  end
  self.owner.transform.position = self.owner.transform.position + self.owner.transform.forward * deltaTime * 0.35
end

function WalkState:OnExit()
  self.owner.animator:SetBool("walking", false)
end

return WalkState
