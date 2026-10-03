local FireStateBorn = BaseClass("FireStateBorn")

function FireStateBorn:__init(unit)
  self.unit = unit
end

function FireStateBorn:StopCall()
  if self.changeStateCall then
    self.changeStateCall:Stop()
    self.changeStateCall = nil
  end
end

function FireStateBorn:__delete()
  self.unit = nil
  self:StopCall()
end

function FireStateBorn:OnEnter()
  if self.unit:IsMoving() then
    self.unit:Tl_CrossFadeSimpleAnim(AnimName.Run, 0.2, 1, 0.2)
  else
    if not self.unit then
      return
    end
    if not self.unit.fsm then
      return
    end
    local animLength = self.unit:GetAnimLength(AnimName.Born)
    if 0 < animLength then
      self.unit:Tl_RewindAndPlaySimpleAnim(AnimName.Born, animLength)
      self.changeStateCall = TimerManager:GetInstance():DelayInvoke(function()
        self.unit.fsm:ChangeState(SkirmishFireState.Idle)
      end, animLength)
    else
      self.unit.fsm:ChangeState(SkirmishFireState.Idle)
    end
  end
end

function FireStateBorn:OnExit()
  self:StopCall()
end

function FireStateBorn:OnUpdate()
end

return FireStateBorn
