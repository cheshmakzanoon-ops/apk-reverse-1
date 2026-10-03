local ZMBossAttackState = BaseClass("ZMBossAttackState")

function ZMBossAttackState:__init(stateMgr)
  self.stateMgr = stateMgr
  self.soundId = nil
  self.soundTimer = nil
end

function ZMBossAttackState:__delete()
  self:OnExit()
  self.stateMgr = nil
end

function ZMBossAttackState:OnEnter()
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:PlayAnimation(stateMgr.Anim.Attack, function()
      stateMgr:ChangeState(stateMgr.ActState.Idle)
    end)
    stateMgr:PlayEffect(stateMgr.EffectFlag.Fire)
    self.soundTimer = TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.feiting_attack_up, false)
      self.soundTimer:Stop()
      self.soundTimer = nil
    end, 1.5)
    self.soundId = DataCenter.LWSoundManager:PlaySound(SoundAssetId.feiting_gun)
  end
end

function ZMBossAttackState:OnExit()
  if self.stateMgr then
    self.stateMgr:RemoveEffect(self.stateMgr.EffectFlag.Fire)
  end
  if self.soundId then
    DataCenter.LWSoundManager:StopSound(self.soundId)
    self.soundId = nil
  end
  if self.soundTimer then
    self.soundTimer:Stop()
    self.soundTimer = nil
  end
end

function ZMBossAttackState:OnUpdate(deltaTime)
end

return ZMBossAttackState
