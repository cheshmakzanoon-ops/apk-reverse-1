local AlKirovLaunchBornState = BaseClass("AlKirovLaunchBornState")

function AlKirovLaunchBornState:__init(stateMgr)
  self.stateMgr = stateMgr
end

function AlKirovLaunchBornState:__delete()
  self.stateMgr = nil
end

function AlKirovLaunchBornState:OnEnter(endTime)
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:PlayAnimation(stateMgr.LaunchAnim.Born, function()
      stateMgr:ChangeState(stateMgr.FsmState.LaunchIdle, endTime)
    end)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.feiting_build_bron, false)
  end
end

function AlKirovLaunchBornState:OnExit()
end

function AlKirovLaunchBornState:OnUpdate(deltaTime)
end

return AlKirovLaunchBornState
