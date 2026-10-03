local TeamHorizontalBackward = BaseClass("TeamHorizontalBackward")

function TeamHorizontalBackward:__init(team)
  self.team = team
end

function TeamHorizontalBackward:__delete()
  self.team = nil
end

function TeamHorizontalBackward:OnEnter(delta)
  self.statusTime = 0
  self.changedBackward = false
end

function TeamHorizontalBackward:OnTransToSelf(delta)
  if self.changedBackward then
    return
  end
  self.statusTime = self.statusTime + Time.deltaTime
  if self.statusTime > 0.2 then
    self.team:DoDirectionRotate(SkyBattleMoveDirectionState.BackWard, 0)
    self.changedBackward = true
  end
end

function TeamHorizontalBackward:OnExit()
end

return TeamHorizontalBackward
