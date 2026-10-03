local ZMBossBeHitState = BaseClass("ZMBossBeHitState")

function ZMBossBeHitState:__init(stateMgr)
  self.stateMgr = stateMgr
end

function ZMBossBeHitState:__delete()
  self.stateMgr = nil
end

function ZMBossBeHitState:OnEnter()
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:PlayAnimation(stateMgr.Anim.BeHit, function()
      stateMgr:ChangeState(stateMgr.ActState.Idle)
    end)
  end
end

function ZMBossBeHitState:OnExit()
end

function ZMBossBeHitState:OnUpdate(deltaTime)
end

return ZMBossBeHitState
