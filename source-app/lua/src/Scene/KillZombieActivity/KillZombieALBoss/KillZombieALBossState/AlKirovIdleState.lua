local AlKirovIdleState = BaseClass("AlKirovIdleState")

function AlKirovIdleState:__init(stateMgr)
  self.stateMgr = stateMgr
end

function AlKirovIdleState:__delete()
  self.stateMgr = nil
end

function AlKirovIdleState:OnEnter()
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:PlayAnimation(stateMgr.Anim.Idle)
    stateMgr:PlayEffect(stateMgr.EffectFlag.Airflow)
  end
end

function AlKirovIdleState:OnExit()
end

function AlKirovIdleState:OnUpdate(deltaTime)
end

return AlKirovIdleState
