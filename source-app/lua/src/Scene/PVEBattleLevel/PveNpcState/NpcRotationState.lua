local NpcRotationState = BaseClass("NpcRotationState")
local RotationAngleSpeed = 540

function NpcRotationState:__init(npc)
  self.npc = npc
end

function NpcRotationState:__delete()
end

function NpcRotationState:OnEnter(param)
  self.param = param
  self.curTime = 0
  self.isRotation = true
  self.startRotation = self.npc:GetRotation()
  self.endRotation = Quaternion.Euler(0, self.param.angle, 0)
  self.rotationTime = math.abs((self.param.angle - self.startRotation.eulerAngles.y) / RotationAngleSpeed)
end

function NpcRotationState:OnExit()
end

function NpcRotationState:OnUpdate(deltaTime)
  self.curTime = self.curTime + deltaTime
  local percent = self.curTime / self.rotationTime
  if 1 <= percent then
    self.curTime = 0
    self.npc:SetRotation(self.endRotation)
    self.npc:CheckNext()
    self.npc:ChangeState(self.npc.State.Idle)
  else
    self.npc:SetRotation(Quaternion.Lerp(self.startRotation, self.endRotation, percent))
  end
end

return NpcRotationState
