local SquadStatePath = BaseClass("SquadStatePath")

function SquadStatePath:__init(squad)
  self.squad = squad
  self.destination = Vector3.New(0, 0, 0)
  self.direction = Vector3.New(0, 0, 0)
end

function SquadStatePath:__delete()
  self.squad = nil
  self.destination = nil
  self.destinationQueue = nil
  self.direction = nil
end

function SquadStatePath:OnEnter(destinationQueue)
  self.destinationQueue = destinationQueue
  if #destinationQueue < 1 then
    return
  end
  local destination = table.remove(destinationQueue)
  self:SetDestination(destination)
end

function SquadStatePath:OnExit()
end

function SquadStatePath:OnUpdate()
  local curPos = self.squad:GetPosition()
  local delta = self.destination - curPos
  local speed = EXIT_SPEED
  local maxMovement = speed * Time.deltaTime
  if delta:SqrMagnitude() < maxMovement * maxMovement then
    self.squad:SetPosition(self.destination)
    if #self.destinationQueue < 1 then
      return
    end
    local destination = table.remove(self.destinationQueue)
    self:SetDestination(destination)
  else
    local newPos = self.direction * maxMovement + curPos
    self.squad:SetPosition(newPos)
  end
end

function SquadStatePath:HandleInput(input, param)
end

function SquadStatePath:SetDestination(destination)
  self.destination.x = destination.x
  self.destination.z = destination.z
  local curPos = self.squad:GetPosition()
  local delta = self.destination - curPos
  self.direction = delta:Normalize()
  for i, v in pairs(self.squad.members) do
    local member = v
    local offset = self.squad.formation:GetOffsetByIndex(member.index)
    member:HandleInput(MemberCommand.Move, destination + offset)
  end
end

return SquadStatePath
