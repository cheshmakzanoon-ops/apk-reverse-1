local ZMBuildingBornState = BaseClass("ZMBuildingBornState")

function ZMBuildingBornState:__init(stateMgr)
  self.stateMgr = stateMgr
end

function ZMBuildingBornState:__delete()
  self.stateMgr = nil
end

function ZMBuildingBornState:OnEnter()
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:PlayAnimation(stateMgr.Anim.Born, function()
      stateMgr:ChangeState(stateMgr.State.Idle)
    end)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.feiting_build_bron, false)
  end
end

function ZMBuildingBornState:OnExit()
end

function ZMBuildingBornState:OnUpdate(deltaTime)
end

return ZMBuildingBornState
