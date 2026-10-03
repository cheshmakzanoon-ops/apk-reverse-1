local ZMBossLandingState = BaseClass("ZMBossLandingState")

function ZMBossLandingState:__init(stateMgr)
  self.stateMgr = stateMgr
end

function ZMBossLandingState:__delete()
  self:OnExit()
  self.stateMgr = nil
end

function ZMBossLandingState:OnEnter()
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:PlayEffect(stateMgr.EffectFlag.Landing, 5)
    stateMgr:PlayEffect(stateMgr.EffectFlag.BornFire, 5)
    stateMgr:ChangeModel("A_build_jiluofu_feiting_03_%s")
    stateMgr:PlayAnimation(stateMgr.Anim.Born, function()
      stateMgr:ChangeState(stateMgr.ActState.Idle)
    end)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.feiting_down, false)
  end
end

function ZMBossLandingState:OnExit()
  if self.stateMgr then
    self.stateMgr:RemoveEffect(self.stateMgr.EffectFlag.Landing)
    self.stateMgr:RemoveEffect(self.stateMgr.EffectFlag.BornFire)
  end
end

function ZMBossLandingState:OnUpdate(deltaTime)
end

return ZMBossLandingState
