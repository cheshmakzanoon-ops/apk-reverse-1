local ZMBuildingTransmittingState = BaseClass("ZMBuildingTransmittingState")

function ZMBuildingTransmittingState:__init(stateMgr)
  self.stateMgr = stateMgr
  self.timeMgr = UITimeManager:GetInstance()
  self.soundId = nil
end

function ZMBuildingTransmittingState:__delete()
  self:ClearState()
  self.stateMgr = nil
  self.timeMgr = nil
end

function ZMBuildingTransmittingState:OnEnter()
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:PlayAnimation(stateMgr.Anim.Idle)
    stateMgr:PlayEffect(stateMgr.EffectFlag.Transmitting)
    self.soundId = DataCenter.LWSoundManager:PlaySound(SoundAssetId.feiting_transfer)
  end
  self.transferCDTime = DataCenter.LWZoneMobilizationManager.nextStageTime - 3000
end

function ZMBuildingTransmittingState:OnExit()
  self.transferCDTime = nil
  local timer = TimerManager:GetInstance():DelayInvoke(function()
    self:ClearState()
  end, 0.2)
  self.timer = timer
end

function ZMBuildingTransmittingState:OnUpdate()
  if self.transferCDTime then
    local now = self.timeMgr:GetServerTime()
    local t = (self.transferCDTime - now) * 0.001
    if t <= 0 and self.stateMgr then
      self.stateMgr:ChangeToFlyaway()
    end
  end
end

function ZMBuildingTransmittingState:ClearState()
  if self.soundId then
    DataCenter.LWSoundManager:StopSound(self.soundId)
    self.soundId = nil
  end
  if self.stateMgr then
    self.stateMgr:RemoveEffect(self.stateMgr.EffectFlag.Transmitting)
  end
  if self.timer then
    self.timer:Stop()
  end
  self.timer = nil
end

return ZMBuildingTransmittingState
