local ZMBossDeathState = BaseClass("ZMBossDeathState")

function ZMBossDeathState:__init(stateMgr)
  self.stateMgr = stateMgr
  self.effTimer = nil
end

function ZMBossDeathState:__delete()
  self:OnExit()
  self.stateMgr = nil
end

function ZMBossDeathState:OnEnter()
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:PlayAnimation(stateMgr.Anim.Death)
    stateMgr:PlayEffect(stateMgr.EffectFlag.Death, 5)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.feiting_die, false)
    stateMgr:DisplayDeadTipText("pic_name_02")
    self.effTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.stateMgr then
        self.stateMgr:PlayEffect(self.stateMgr.EffectFlag.DeathBoom, 5)
      end
      self.effTimer:Stop()
      self.effTimer = nil
    end, 2.3)
  end
end

function ZMBossDeathState:OnExit()
  if self.stateMgr then
    self.stateMgr:RemoveEffect(self.stateMgr.EffectFlag.Death)
    self.stateMgr:RemoveEffect(self.stateMgr.EffectFlag.DeathBoom)
  end
  if self.effTimer then
    self.effTimer:Stop()
    self.effTimer = nil
  end
end

function ZMBossDeathState:OnUpdate(deltaTime)
end

return ZMBossDeathState
