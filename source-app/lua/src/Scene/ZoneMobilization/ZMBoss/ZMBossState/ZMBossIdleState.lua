local ZMBossIdleState = BaseClass("ZMBossIdleState")

function ZMBossIdleState:__init(stateMgr)
  self.stateMgr = stateMgr
end

function ZMBossIdleState:__delete()
  self.stateMgr = nil
end

function ZMBossIdleState:OnEnter()
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:PlayAnimation(stateMgr.Anim.Idle)
  end
end

function ZMBossIdleState:OnExit()
end

function ZMBossIdleState:OnUpdate(deltaTime)
end

return ZMBossIdleState
