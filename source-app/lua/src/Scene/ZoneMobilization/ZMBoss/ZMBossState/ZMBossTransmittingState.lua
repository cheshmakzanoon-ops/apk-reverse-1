local ZMBuildingTransferIdleState = BaseClass("ZMBuildingTransferIdleState")

function ZMBuildingTransferIdleState:__init(stateMgr)
  self.stateMgr = stateMgr
  self.timer = nil
  self.soundId = nil
end

function ZMBuildingTransferIdleState:__delete()
  self:ClearState()
  self.stateMgr = nil
end

function ZMBuildingTransferIdleState:OnEnter(transferCDTime)
  local stateMgr = self.stateMgr
  if stateMgr then
    local now = UITimeManager:GetInstance():GetServerTime()
    local t = transferCDTime - now
    if t <= -100 then
      self.stateMgr:ChangeToIdleState()
      return
    end
    stateMgr:PlayAnimation(stateMgr.Anim.Transmitting)
    stateMgr:PlayEffect(stateMgr.EffectFlag.Transmitting)
    self.soundId = DataCenter.LWSoundManager:PlaySound(SoundAssetId.feiting_transfer)
    self.transferCDTime = transferCDTime
  end
end

function ZMBuildingTransferIdleState:OnExit()
  local timer = TimerManager:GetInstance():DelayInvoke(function()
    self:ClearState()
  end, 0.2)
  self.timer = timer
end

function ZMBuildingTransferIdleState:OnUpdate()
  if self.transferCDTime and self.transferCDTime > 0 then
    local now = UITimeManager:GetInstance():GetServerTime()
    local t = self.transferCDTime - now
    if t <= 0 then
      if -100 < t then
        if self.stateMgr then
          self.stateMgr:ChangeState(self.stateMgr.ActState.Landing)
        end
      elseif self.stateMgr then
        self.stateMgr:ChangeToIdleState()
      end
    end
  end
end

function ZMBuildingTransferIdleState:ClearState()
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

return ZMBuildingTransferIdleState
