local TeamHorizontalRight = BaseClass("TeamHorizontalRight")
local rollAngle = 385
local tiltAngleSide = 25

function TeamHorizontalRight:__init(team)
  self.team = team
end

function TeamHorizontalRight:__delete()
  self.team = nil
end

function TeamHorizontalRight:OnEnter(delta)
  self.statusTime = 0
  self.hasRotated = false
  self.hasRollFull = false
end

function TeamHorizontalRight:OnTransToSelf(delta)
  if not self.hasRotated and self.statusTime > 0.2 then
    self.hasRotated = true
    self.hasRollFull = self.team:CheckNeedHorizontalRoll(delta)
    local rotateAngle = self.hasRollFull and rollAngle or tiltAngleSide
    self.team:DoDirectionRotate(SkyBattleMoveDirectionState.Right, rotateAngle)
    return
  else
    self.statusTime = self.statusTime + Time.deltaTime
  end
  if self.hasRollFull then
    return
  end
  self.hasRollFull = self.team:CheckNeedHorizontalRoll(delta)
  if self.hasRollFull then
    self.team:DoDirectionRotate(SkyBattleMoveDirectionState.Right, rollAngle)
  end
end

function TeamHorizontalRight:OnExit()
end

return TeamHorizontalRight
