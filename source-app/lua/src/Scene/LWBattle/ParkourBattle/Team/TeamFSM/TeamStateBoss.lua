local TeamStateBoss = BaseClass("TeamStateBoss")
local Const = require("Scene.LWBattle.Const")

function TeamStateBoss:__init(team)
  self.team = team
end

function TeamStateBoss:__delete()
  self.team = nil
end

function TeamStateBoss:OnEnter(destination)
end

function TeamStateBoss:OnExit()
end

function TeamStateBoss:OnUpdate(deltaTime)
end

function TeamStateBoss:HandleInput(input, param1, param2)
end

return TeamStateBoss
