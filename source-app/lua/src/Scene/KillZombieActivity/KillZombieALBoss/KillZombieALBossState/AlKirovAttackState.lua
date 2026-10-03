local AlKirovAttackState = BaseClass("AlKirovAttackState")

function AlKirovAttackState:__init(stateMgr)
  self.stateMgr = stateMgr
  self.soundId = nil
  self.soundTimer = nil
end

function AlKirovAttackState:__delete()
  self:OnExit()
  self.stateMgr = nil
end

function AlKirovAttackState:OnEnter(status)
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:PlayEffect(stateMgr.EffectFlag.Airflow)
    if status == ChallengeZombieAlBossStatus.Frenzy then
      stateMgr:PlayAnimation(stateMgr.Anim.Attack, function()
        stateMgr:ChangeState(stateMgr.FsmState.Idle)
      end)
    else
      stateMgr:PlayAnimation(stateMgr.Anim.Attack, function()
        if status == ChallengeZombieAlBossStatus.Charge or status == ChallengeZombieAlBossStatus.ChargeWaiting then
          stateMgr:ChangeState(stateMgr.FsmState.Charge)
        else
          stateMgr:ChangeState(stateMgr.FsmState.Idle)
        end
      end)
    end
    stateMgr:PlayEffect(stateMgr.EffectFlag.AttackFire)
    self.soundTimer = TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.feiting_attack_up, false)
      self.soundTimer:Stop()
      self.soundTimer = nil
    end, 1.5)
    self.soundId = DataCenter.LWSoundManager:PlaySound(SoundAssetId.feiting_gun)
  end
end

function AlKirovAttackState:OnExit()
  if self.stateMgr then
    self.stateMgr:RemoveEffect(self.stateMgr.EffectFlag.AttackFire)
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

function AlKirovAttackState:OnUpdate(deltaTime)
end

return AlKirovAttackState
