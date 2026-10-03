local MemberStateDie = BaseClass("MemberStateDie")

function MemberStateDie:__init(member)
  self.member = member
  self.animLength = self.member:GetAnimLength(MemberAnim.Dead)
  self.animLength = self.animLength > 0 and self.animLength or 2
end

function MemberStateDie:__delete()
  self.member = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function MemberStateDie:OnEnter()
  self.member.logic:OnMemberDeath()
  self.member:RewindAndPlaySimpleAnim(MemberAnim.Dead)
  self.member.transform:SetParent(nil)
  if self.member.squad then
    self.member.squad:RemoveMember(self.member)
  end
  self.timer = TimerManager:DelayInvoke(function()
    if self.member.unitType ~= UnitType.TacticalWeapon then
      self.member.logic:ShowEffectObj("Assets/Main/Prefabs/PVE/Obj_A_build_th_mb.prefab", self.member:GetPosition(), nil, -1)
    end
    self.member.logic:RemoveUnit(self.member)
  end, self.animLength)
end

function MemberStateDie:OnExit()
end

function MemberStateDie:OnUpdate(deltaTime)
end

function MemberStateDie:HandleInput(input, param)
end

return MemberStateDie
