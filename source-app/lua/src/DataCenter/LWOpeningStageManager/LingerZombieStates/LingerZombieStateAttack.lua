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
  self.owner.animator:Play("idle")
  self.cd = math.random() * 2
  self.animLen = 0
end

function AttackState:OnUpdate(deltaTime)
  if self.animLen > 0 then
    self.animLen = self.animLen - deltaTime
    if self.animLen <= 0 then
      self.owner.animator:Play("idle")
      self.cd = math.random() * 3.2 + 0.5
    end
  else
    self.cd = self.cd - deltaTime
    if 0 >= self.cd then
      self.owner.animator:Play("attack")
      self.animLen = 1
    end
  end
end

return AttackState
