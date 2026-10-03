local TeamHorizontalLeft = BaseClass("TeamHorizontalLeft")
local rollAngle = 385
local tiltAngleSide = 25

function TeamHorizontalLeft:__init(team)
  self.team = team
end

function TeamHorizontalLeft:__delete()
  self.team = nil
end

function TeamHorizontalLeft:OnEnter(delta)
  self.statusTime = 0
  self.hasRotated = false
  self.hasRollFull = false
end

function TeamHorizontalLeft:OnTransToSelf(delta)
  if not self.hasRotated and self.statusTime > 0.2 then
    self.hasRotated = true
    self.hasRollFull = self.team:CheckNeedHorizontalRoll(delta)
    local rotateAngle = self.hasRollFull and rollAngle or tiltAngleSide
    self.team:DoDirectionRotate(SkyBattleMoveDirectionState.Left, rotateAngle)
    return
  else
    self.statusTime = self.statusTime + Time.deltaTime
  end
  if self.hasRollFull then
    return
  end
  local needRollFull = self.team:CheckNeedHorizontalRoll(delta)
  if needRollFull then
    self.hasRollFull = true
    self.team:DoDirectionRotate(SkyBattleMoveDirectionState.Left, rollAngle)
  end
end

function TeamHorizontalLeft:OnExit()
end

return TeamHorizontalLeft
