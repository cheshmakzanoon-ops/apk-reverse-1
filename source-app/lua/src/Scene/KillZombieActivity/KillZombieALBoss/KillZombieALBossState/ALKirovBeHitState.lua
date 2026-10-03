local ALKirovBeHitState = BaseClass("ALKirovBeHitState")

function ALKirovBeHitState:__init(stateMgr)
  self.stateMgr = stateMgr
end

function ALKirovBeHitState:__delete()
  self.stateMgr = nil
end

function ALKirovBeHitState:OnEnter(charge)
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:PlayEffect(stateMgr.EffectFlag.Airflow)
    if charge then
      stateMgr:PlayEffect(stateMgr.EffectFlag.ShieldBeHit, 3)
    end
    stateMgr:PlayAnimation(stateMgr.Anim.BeHit, function()
      if charge then
        stateMgr:ChangeState(stateMgr.FsmState.Charge)
      else
        stateMgr:ChangeState(stateMgr.FsmState.Idle)
      end
    end)
  end
end

function ALKirovBeHitState:OnExit()
end

function ALKirovBeHitState:OnUpdate(deltaTime)
end

return ALKirovBeHitState
