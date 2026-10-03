local TeamStateDash = BaseClass("TeamStateDash")

function TeamStateDash:__init(team)
  self.team = team
end

function TeamStateDash:__delete()
  self.team = nil
end

function TeamStateDash:OnEnter()
end

function TeamStateDash:OnExit()
end

function TeamStateDash:OnUpdate(deltaTime)
  local speed = self.team:GetBonusDashSpeedZ()
  if speed <= 0 then
    return
  end
  local position = self.team:GetPosition()
  local add = speed * deltaTime
  local z = position.z + add
  self.team:SetPosition(position.x, z)
end

return TeamStateDash
