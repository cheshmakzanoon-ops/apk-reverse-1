local AttackState = {}
local FSMachine = require("Common.FSMachine")
AttackState.__index = AttackState
setmetatable(AttackState, FSMachine.State)

function AttackState.Create()
  local copy = {}
  setmetatable(copy, AttackState)
  copy:Init()
  return copy
end

function AttackState:OnEnter()
  self.cd = 0
end

function AttackState:OnUpdate(deltaTime)
  self.cd = self.cd - deltaTime
  if self.cd <= 0 then
    self.owner.animator:SetTrigger("attack")
    self.cd = math.random() * 3.2 + 0.5
  end
end

return AttackState
