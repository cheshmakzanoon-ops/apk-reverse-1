local TeamHorizontalLeft = BaseClass("TeamHorizontalLeft")

function TeamHorizontalLeft:__init(team)
  self.team = team
end

function TeamHorizontalLeft:__delete()
  self.team = nil
end

function TeamHorizontalLeft:OnEnter()
  self.team:PlayTeamHorizontalAnim("run_left")
end

function TeamHorizontalLeft:OnTransToSelf()
  self.team:PlayTeamHorizontalAnim("run_left")
end

function TeamHorizontalLeft:OnExit()
end

return TeamHorizontalLeft
