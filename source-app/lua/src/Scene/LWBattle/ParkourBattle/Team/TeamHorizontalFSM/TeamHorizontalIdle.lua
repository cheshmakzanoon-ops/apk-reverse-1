local TeamHorizontalIdle = BaseClass("TeamHorizontalIdle")

function TeamHorizontalIdle:__init(team)
  self.team = team
end

function TeamHorizontalIdle:__delete()
end

function TeamHorizontalIdle:OnEnter()
  self.team:PlayTeamHorizontalAnim(AnimName.Idle)
end

function TeamHorizontalIdle:OnExit()
end

return TeamHorizontalIdle
