local TeamHorizontalRight = BaseClass("TeamHorizontalRight")

function TeamHorizontalRight:__init(team)
  self.team = team
end

function TeamHorizontalRight:__delete()
  self.team = nil
end

function TeamHorizontalRight:OnEnter()
  self.team:PlayTeamHorizontalAnim("run_right")
end

function TeamHorizontalRight:OnTransToSelf()
  self.team:PlayTeamHorizontalAnim("run_right")
end

function TeamHorizontalRight:OnExit()
end

return TeamHorizontalRight
