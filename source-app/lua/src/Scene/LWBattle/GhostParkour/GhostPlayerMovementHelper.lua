local GhostPlayerMovementHelper = BaseClass("GhostPlayerMovementHelper")

function GhostPlayerMovementHelper:__init(unit, transform, speedChangeTime)
  self.unit = unit
  self.skinWidth = 0.02
  self.speedChangeTimeConst = speedChangeTime
  self.speedChangeTime = speedChangeTime
  self.groundDetectionHelper = CS.GhostGroundDetectionHelper()
  self.groundDetectionHelper:Init(transform, self.skinWidth, self.unit.flyHeight)
end

function GhostPlayerMovementHelper:__delete()
  self.unit = nil
  self.skinWidth = nil
  self.groundDetectionHelper = nil
end

function GhostPlayerMovementHelper:HandleBasicMovement(deltaTime, totalDeltaTime)
  local position = self.unit:GetPosition()
  local newX = position.x
  local newY = position.y
  local newZ = position.z
  if self.baseTime == nil then
    Logger.LogError("the baseTime is nil")
    return
  end
  local diffTime = totalDeltaTime - self.baseTime
  local diffZ = 0
  local curSpeed = 0
  if diffTime <= self.speedChangeTime then
    diffZ = (self.startSpeed + self.endSpeed) * 0.5 * diffTime
    curSpeed = self.startSpeed + (self.endSpeed - self.startSpeed) * (diffTime / self.speedChangeTime)
  else
    diffZ = self.changeDistance + (diffTime - self.speedChangeTime) * self.endSpeed
    curSpeed = self.endSpeed
  end
  self.unit:SetMoveSpeed(curSpeed)
  newZ = diffZ + self.baseDistance
  local isGrounded, contactPointY = self.groundDetectionHelper:DetectGround(newX, newY, newZ + self.unit.logic.renderOffsetZ)
  if isGrounded then
    newY = contactPointY
  end
  if self.unit:IsFlying() then
    local deltaY = self.unit.flySpeed * deltaTime
    local tmpNewY = self.unit.flyY + deltaY
    if tmpNewY > self.unit.flyHeight then
      tmpNewY = self.unit.flyHeight
    end
    self.unit.flyY = tmpNewY
    newY = tmpNewY
  elseif not self.unit:IsGrounded() then
    local vert
    self.unit.verticalMoveTimer = self.unit.verticalMoveTimer + deltaTime
    local t = self.unit.verticalMoveTimer
    local vo = self.unit.verticalVelocity
    local a = self.unit.verticalAcceleration
    vert = vo * t + 0.5 * a * t * t
    local tmpNewY = self.unit.verticalMoveStartY + vert
    local tIsGrounded, tContactPointY = self.groundDetectionHelper:DetectGround(newX, tmpNewY, newZ + self.unit.logic.renderOffsetZ)
    if tIsGrounded then
      contactPointY = tContactPointY
    end
    if tmpNewY <= contactPointY then
      self.unit:ChangeBehaviorState(self.unit.BehaviorState.TouchGround)
      tmpNewY = contactPointY
    end
    newY = tmpNewY
  elseif self.unit:IsGrounded() and not isGrounded then
    self.unit:ChangeBehaviorState(self.unit.BehaviorState.FreeFallStart, position.y)
  end
  if self.unit:IsSliding() then
    self.unit.slideTimer = self.unit.slideTimer - deltaTime
    if 0 >= self.unit.slideTimer then
      self.unit:ChangeBehaviorState(self.unit.BehaviorState.SlidingFinish)
    end
  end
  if self.unit.lineChangeTimer then
    self.unit.lineChangeTimer = self.unit.lineChangeTimer - deltaTime
    local curX = Mathf.Lerp(self.unit.targetX, self.unit.curX, self.unit.lineChangeTimer / self.unit.lineChangeTime)
    newX = curX
    if 0 >= self.unit.lineChangeTimer then
      self.unit:ChangeBehaviorState(self.unit.BehaviorState.ChangeLanesFinish)
    end
  end
  self.newX = newX
  self.newY = newY
  self.newZ = newZ + self.unit.logic.renderOffsetZ
  local logic = self.unit.logic
  if logic == nil or not logic.isDebug then
    return
  end
  local time = os.date("%H:%M:%S")
  logic:AppendLog(time .. "[" .. Time.frameCount .. "]" .. " BasicMove")
end

local function ApplyMovement(self, totalDeltaTime)
  local realZ, reset = self.unit.logic:CheckOffsetZ(self.newZ)
  self.unit:SetPositionXYZ(self.newX, self.newY, realZ)
  if reset then
    self.unit.logic:ApplyResetOffsetZ()
  end
end

function GhostPlayerMovementHelper:Update(deltaTime, totalDeltaTime)
  self:HandleBasicMovement(deltaTime, totalDeltaTime)
  ApplyMovement(self, totalDeltaTime)
  return self.newZ
end

function GhostPlayerMovementHelper:UpdateMoveValue(baseTime, baseDistance, startSpeed, endSpeed, speedChangeTime)
  self.baseTime = baseTime
  self.baseDistance = baseDistance
  self.startSpeed = startSpeed
  self.endSpeed = endSpeed
  speedChangeTime = speedChangeTime or self.speedChangeTimeConst
  self.changeDistance = (startSpeed + endSpeed) * 0.5 * speedChangeTime
  self.speedChangeTime = speedChangeTime
end

function GhostPlayerMovementHelper:GetDebugLog()
  return self.groundDetectionHelper:GetDebugLog()
end

return GhostPlayerMovementHelper
