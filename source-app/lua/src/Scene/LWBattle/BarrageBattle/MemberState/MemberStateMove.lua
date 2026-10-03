local MemberStateMove = BaseClass("MemberStateMove")

function MemberStateMove:__init(member)
  self.member = member
  self.startPos = Vector3.New(0, 0, 0)
  self.destination = nil
end

function MemberStateMove:__delete()
  self.member = nil
  self.startPos = nil
  self.destination = nil
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
end

function MemberStateMove:OnEnter(destination)
  self:SetDestination(destination)
  if self.member.hero and self.member.hero.appearanceMeta then
    self.soundUid = DataCenter.LWSoundManager:PlaySound(self.member.hero.appearanceMeta.walk_sound, true)
  end
end

function MemberStateMove:OnExit()
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
  DataCenter.LWSoundManager:StopSound(self.soundUid)
end

function MemberStateMove:OnUpdate()
end

function MemberStateMove:OnTransToSelf(destination)
  self:SetDestination(destination)
end

function MemberStateMove:HandleInput(input, param)
end

function MemberStateMove:SetDestination(destination)
  if not destination or self.member.isHuman and self.member:CheckEnemyInAlertRange() then
    return
  end
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
  self.tween = self.member.transform:DOLookAt(destination, 0.5)
end

return MemberStateMove
