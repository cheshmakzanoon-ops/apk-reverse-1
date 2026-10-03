local AlKirovWeaknessState = BaseClass("AlKirovWeaknessState")

function AlKirovWeaknessState:__init(stateMgr)
  self.stateMgr = stateMgr
  self.endTime = nil
end

function AlKirovWeaknessState:__delete()
  if self.stateMgr then
    self.stateMgr:RemoveEffect(self.stateMgr.EffectFlag.Dizziness)
    self.stateMgr:RemoveEffect(self.stateMgr.EffectFlag.DeathBoom)
  end
  self.stateMgr = nil
  if self.effTimer then
    self.effTimer:Stop()
    self.effTimer = nil
  end
  self.endTime = nil
end

function AlKirovWeaknessState:OnEnter(statusStartTime, statusEndTime)
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:RemoveEffect(stateMgr.EffectFlag.Airflow)
    local now = UITimeManager:GetInstance():GetServerTime()
    local length = stateMgr:GetAnimLength(stateMgr.Anim.ChargeFail)
    if 0 < statusStartTime and 0 < length and now - statusStartTime < length * 1000 then
      stateMgr:PlayAnimation(stateMgr.Anim.ChargeFail, function()
        stateMgr:PlayAnimation(stateMgr.Anim.ChargeFailPose)
        stateMgr:PlayEffect(stateMgr.EffectFlag.Dizziness)
      end)
      self.effTimer = TimerManager:GetInstance():DelayInvoke(function()
        if self.stateMgr then
          self.stateMgr:PlayEffect(self.stateMgr.EffectFlag.Boom, 5)
        end
        self.effTimer:Stop()
        self.effTimer = nil
      end, 2.3)
    else
      length = stateMgr:GetAnimLength(stateMgr.Anim.Recover)
      if 0 < statusEndTime and 0 < length and statusEndTime - now > length / 2 * 1000 and statusEndTime - now <= length * 1000 then
        stateMgr:PlayAnimation(stateMgr.Anim.Recover)
        stateMgr:RemoveEffect(stateMgr.EffectFlag.Dizziness)
      else
        stateMgr:PlayAnimation(stateMgr.Anim.ChargeFailPose)
        stateMgr:PlayEffect(stateMgr.EffectFlag.Dizziness)
      end
    end
    self.endTime = statusEndTime - length * 1000
  end
end

function AlKirovWeaknessState:PlayWeakness()
  if self.stateMgr then
    local stateMgr = self.stateMgr
    stateMgr:PlayAnimation(stateMgr.Anim.ChargeFailPose)
    stateMgr:PlayEffect(stateMgr.EffectFlag.Airflow)
  end
end

function AlKirovWeaknessState:OnExit()
  if self.stateMgr then
    self.stateMgr:RemoveEffect(self.stateMgr.EffectFlag.Dizziness)
    self.stateMgr:RemoveEffect(self.stateMgr.EffectFlag.DeathBoom)
  end
  if self.effTimer then
    self.effTimer:Stop()
    self.effTimer = nil
  end
end

function AlKirovWeaknessState:OnUpdate()
  if self.endTime and self.endTime > 0 then
    local now = UITimeManager:GetInstance():GetServerTime()
    local t = (self.endTime - now) * 0.001
    if t <= 0 and self.stateMgr then
      self.stateMgr:PlayAnimation(self.stateMgr.Anim.Recover)
    end
  end
end

return AlKirovWeaknessState
