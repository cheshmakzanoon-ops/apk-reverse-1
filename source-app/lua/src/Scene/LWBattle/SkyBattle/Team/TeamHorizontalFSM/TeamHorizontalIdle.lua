local TeamHorizontalIdle = BaseClass("TeamHorizontalIdle")

function TeamHorizontalIdle:__init(team)
  self.team = team
end

function TeamHorizontalIdle:__delete()
end

function TeamHorizontalIdle:OnEnter()
  self.team:DoDirectionRotate(SkyBattleMoveDirectionState.Idle, 0)
end

function TeamHorizontalIdle:OnExit()
end

return TeamHorizontalIdle
