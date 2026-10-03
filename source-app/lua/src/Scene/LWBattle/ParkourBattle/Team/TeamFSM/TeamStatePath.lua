local TeamStatePath = BaseClass("TeamStatePath")
local Const = require("Scene.LWBattle.Const")

function TeamStatePath:__init(team)
  self.team = team
  self.destination = Vector3.New(0, 0, 0)
  self.direction = Vector3.New(0, 0, 0)
end

function TeamStatePath:__delete()
  self.team = nil
  self.destination = nil
  self.destinationQueue = nil
  self.direction = nil
end

function TeamStatePath:OnEnter(destinationQueue)
  self.destinationQueue = destinationQueue
  if #destinationQueue < 1 then
    return
  end
  local destination = table.remove(destinationQueue)
  self:SetDestination(destination)
end

function TeamStatePath:OnExit()
end

function TeamStatePath:OnUpdate()
  local curPos = self.team:GetPosition()
  local delta = self.destination - curPos
  local speed = EXIT_SPEED
  local maxMovement = speed * Time.deltaTime
  if delta:SqrMagnitude() < maxMovement * maxMovement then
    self.team:SetPosition(self.destination.x, self.destination.z)
    if #self.destinationQueue < 1 then
      return
    end
    local destination = table.remove(self.destinationQueue)
    self:SetDestination(destination)
  else
    local newPos = self.direction * maxMovement + curPos
    self.team:SetPosition(newPos.x, newPos.z)
  end
end

function TeamStatePath:HandleInput(input, param)
end

function TeamStatePath:SetDestination(destination)
  self.destination.x = destination.x
  self.destination.z = destination.z
  local curPos = self.team:GetPosition()
  local delta = self.destination - curPos
  self.direction = delta:Normalize()
  for i, v in pairs(self.team.teamUnits) do
    local member = v
    local offset = member.localPosition
    member.moveFsm:ChangeState(Const.ParkourMoveState.Auto, destination + offset)
  end
end

return TeamStatePath
