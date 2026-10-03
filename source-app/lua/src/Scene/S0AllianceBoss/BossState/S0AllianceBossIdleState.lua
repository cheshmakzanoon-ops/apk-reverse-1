local S0AllianceBossIdleState = BaseClass("S0AllianceBossIdleState")

function S0AllianceBossIdleState:__init(stateMgr)
  self.stateMgr = stateMgr
end

function S0AllianceBossIdleState:__delete()
  self.stateMgr = nil
end

function S0AllianceBossIdleState:OnEnter()
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:PlayBossAnimation(stateMgr.BossAnim.Idle, true, true)
    stateMgr:PlayBuildAnimation(stateMgr.BuildingAnim.Idle, true, true)
  end
end

function S0AllianceBossIdleState:OnExit()
end

function S0AllianceBossIdleState:OnUpdate(deltaTime)
end

return S0AllianceBossIdleState
