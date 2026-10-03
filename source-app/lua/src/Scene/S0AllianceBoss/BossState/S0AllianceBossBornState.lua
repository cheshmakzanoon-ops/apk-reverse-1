local S0AllianceBossBornState = BaseClass("S0AllianceBossBornState")

function S0AllianceBossBornState:__init(stateMgr)
  self.stateMgr = stateMgr
end

function S0AllianceBossBornState:__delete()
  self:OnExit()
  self.stateMgr = nil
end

function S0AllianceBossBornState:OnEnter()
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:PlayBuildAnimation(stateMgr.BuildingAnim.Born, false, true, nil, function()
      stateMgr:PlayBuildAnimation(stateMgr.BuildingAnim.Idle, true, true)
    end)
    stateMgr:PlayBossAnimation(stateMgr.BossAnim.Born, false, true, nil, function()
      stateMgr:ChangeState(stateMgr.FsmState.Idle)
    end)
  end
end

function S0AllianceBossBornState:OnExit()
end

function S0AllianceBossBornState:OnUpdate(deltaTime)
end

return S0AllianceBossBornState
