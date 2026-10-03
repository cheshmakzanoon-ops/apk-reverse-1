local SquadStateStay = BaseClass("SquadStateStay")

function SquadStateStay:__init(squad)
  self.squad = squad
end

function SquadStateStay:__delete()
  self.squad = nil
end

function SquadStateStay:OnEnter()
  for _, v in pairs(self.squad.members) do
    v:HandleInput(MemberCommand.Stay)
  end
end

function SquadStateStay:OnExit()
end

function SquadStateStay:OnUpdate()
  if self.squad.destination and not self.squad:CheckNeedStop() then
    self.squad:OnSetDestination(self.squad.destination)
  end
end

function SquadStateStay:HandleInput(input, param)
end

return SquadStateStay
