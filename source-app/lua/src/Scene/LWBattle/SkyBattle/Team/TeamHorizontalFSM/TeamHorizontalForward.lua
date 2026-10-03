local TeamHorizontalForward = BaseClass("TeamHorizontalForward")

function TeamHorizontalForward:__init(team)
  self.team = team
end

function TeamHorizontalForward:__delete()
  self.team = nil
end

function TeamHorizontalForward:OnEnter(delta)
  self.statusTime = 0
  self.changedForward = false
end

function TeamHorizontalForward:OnTransToSelf(delta)
  if self.changedForward then
    return
  end
  self.statusTime = self.statusTime + Time.deltaTime
  if self.statusTime > 0.2 then
    self.team:DoDirectionRotate(SkyBattleMoveDirectionState.Forward, 0)
    self.changedForward = true
  end
end

function TeamHorizontalForward:OnExit()
end

return TeamHorizontalForward
