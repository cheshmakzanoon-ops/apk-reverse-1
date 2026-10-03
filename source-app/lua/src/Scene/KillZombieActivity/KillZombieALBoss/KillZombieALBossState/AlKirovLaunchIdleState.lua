local AlKirovLaunchIdleState = BaseClass("AlKirovLaunchIdleState")

function AlKirovLaunchIdleState:__init(stateMgr)
  self.stateMgr = stateMgr
  self.endTime = nil
end

function AlKirovLaunchIdleState:__delete()
  if self.stateMgr then
    self.stateMgr:RemoveEffect(self.stateMgr.EffectFlag.IdleLight)
    self.stateMgr:RemoveEffect(self.stateMgr.EffectFlag.IdleFire)
  end
  self.stateMgr = nil
  self.endTime = nil
end

function AlKirovLaunchIdleState:OnEnter(endTime)
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:ShowKirovNode()
    stateMgr:PlayEffect(stateMgr.EffectFlag.IdleFire, nil, function()
      stateMgr:PlayAnimation(stateMgr.LaunchAnim.Idle)
    end)
    stateMgr:PlayEffect(stateMgr.EffectFlag.IdleLight)
  end
  local length = stateMgr.simpleAnimation:GetClipLength(stateMgr.LaunchAnim.Recycle)
  if endTime and length then
    self.endTime = endTime - length * 1000
  end
end

function AlKirovLaunchIdleState:OnExit()
  if self.stateMgr then
    self.stateMgr:RemoveEffect(self.stateMgr.EffectFlag.IdleLight)
    self.stateMgr:RemoveEffect(self.stateMgr.EffectFlag.IdleFire)
  end
end

function AlKirovLaunchIdleState:OnUpdate()
  if self.endTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    local t = (self.endTime - now) * 0.001
    if t <= 0 and self.stateMgr then
      self.stateMgr:ChangeState(self.stateMgr.FsmState.Recycle)
    end
  end
end

return AlKirovLaunchIdleState
