local TeamStateBossStay = BaseClass("TeamStateBossStay")

function TeamStateBossStay:__init(team)
  self.team = team
end

function TeamStateBossStay:__delete()
  self.team = nil
end

function TeamStateBossStay:OnEnter(destination)
end

function TeamStateBossStay:OnExit()
end

function TeamStateBossStay:OnUpdate(deltaTime)
end

function TeamStateBossStay:HandleInput(input, param1, param2)
end

return TeamStateBossStay
