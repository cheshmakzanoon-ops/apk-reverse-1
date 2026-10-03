local AlKirovLaunchRecycleState = BaseClass("AlKirovLaunchRecycleState")

function AlKirovLaunchRecycleState:__init(stateMgr)
  self.stateMgr = stateMgr
end

function AlKirovLaunchRecycleState:__delete()
  self.stateMgr = nil
end

function AlKirovLaunchRecycleState:OnEnter()
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:PlayAnimation(stateMgr.LaunchAnim.Recycle, function()
      stateMgr:ChangeState(stateMgr.FsmState.Born)
    end)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.feiting_build_die, false)
  end
end

function AlKirovLaunchRecycleState:OnExit()
end

function AlKirovLaunchRecycleState:OnUpdate(deltaTime)
end

return AlKirovLaunchRecycleState
