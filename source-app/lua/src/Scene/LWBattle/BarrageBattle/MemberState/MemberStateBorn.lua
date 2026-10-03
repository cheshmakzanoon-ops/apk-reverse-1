local MemberStateBorn = BaseClass("MemberStateBorn")

function MemberStateBorn:__init(member)
  self.member = member
end

function MemberStateBorn:StopCall()
  if self.changeStateCall then
    self.changeStateCall:Stop()
    self.changeStateCall = nil
  end
end

function MemberStateBorn:__delete()
  self.member = nil
  self:StopCall()
end

function MemberStateBorn:OnEnter()
  if not self.member then
    return
  end
  if not self.member.fsm then
    return
  end
  local animLength = self.member:GetAnimLength(AnimName.Born)
  if 0 < animLength then
    self.member:RewindAndPlaySimpleAnim(AnimName.Born)
    self.changeStateCall = TimerManager:GetInstance():DelayInvoke(function()
      self.member:RewindAndPlaySimpleAnim(AnimName.Idle)
      self.member.fsm:ChangeState(MemberState.Stay)
    end, animLength)
  else
    self.member:RewindAndPlaySimpleAnim(AnimName.Idle)
    self.member.fsm:ChangeState(MemberState.Stay)
  end
end

function MemberStateBorn:OnExit()
  self:StopCall()
end

function MemberStateBorn:OnUpdate(deltaTime)
end

function MemberStateBorn:HandleInput(input, param)
end

return MemberStateBorn
