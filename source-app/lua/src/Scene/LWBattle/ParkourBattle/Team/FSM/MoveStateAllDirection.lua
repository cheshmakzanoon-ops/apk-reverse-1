local MoveStateAllDirection = BaseClass("MoveStateAllDirection")

function MoveStateAllDirection:__init(member)
  self.member = member
  self.startPos = Vector3.New(0, 0, 0)
  self.destination = nil
end

function MoveStateAllDirection:__delete()
  self.member = nil
  self.startPos = nil
  self.destination = nil
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
end

function MoveStateAllDirection:OnEnter(destination)
  self:SetDestination(destination)
end

function MoveStateAllDirection:OnExit()
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
end

function MoveStateAllDirection:OnUpdate()
end

function MoveStateAllDirection:OnTransToSelf(destination)
  self:SetDestination(destination)
end

function MoveStateAllDirection:HandleInput(input, param)
end

function MoveStateAllDirection:SetDestination(destination)
  if not destination or self.member.isHuman and not self.member.isFreeMove then
    return
  end
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
  if self.member.isFreeMove then
    local curSkill = self.member.skillManager:GetCastingSkill()
    if curSkill and (curSkill:GetState() == SkillCastState.FrontSwing or curSkill:GetState() == SkillCastState.Chant) then
      return
    end
  end
  self.tween = self.member.transform:DOLookAt(destination, 0.5)
end

return MoveStateAllDirection
