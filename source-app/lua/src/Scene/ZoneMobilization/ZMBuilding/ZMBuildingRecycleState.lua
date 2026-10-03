local ZMBuildingRecycleState = BaseClass("ZMBuildingRecycleState")

function ZMBuildingRecycleState:__init(stateMgr)
  self.stateMgr = stateMgr
end

function ZMBuildingRecycleState:__delete()
  self.stateMgr = nil
end

function ZMBuildingRecycleState:OnEnter()
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:RemoveEffect(stateMgr.EffectFlag.IdleLight)
    stateMgr:RemoveEffect(stateMgr.EffectFlag.IdleFire)
    stateMgr:PlayAnimation(stateMgr.Anim.Recycle, function()
      stateMgr:ChangeToTransmittingState()
    end)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.feiting_build_die, false)
  end
end

function ZMBuildingRecycleState:OnExit()
end

function ZMBuildingRecycleState:OnUpdate(deltaTime)
end

return ZMBuildingRecycleState
