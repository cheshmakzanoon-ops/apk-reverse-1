local MemberStateStay = BaseClass("MemberStateStay")

function MemberStateStay:__init(member)
  self.member = member
end

function MemberStateStay:__delete()
  self.member = nil
end

function MemberStateStay:OnEnter()
end

function MemberStateStay:OnExit()
end

function MemberStateStay:OnUpdate(deltaTime)
end

function MemberStateStay:HandleInput(input, param)
end

return MemberStateStay
