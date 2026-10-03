local AlKirovChargeState = BaseClass("AlKirovChargeState")

function AlKirovChargeState:__init(stateMgr)
  self.stateMgr = stateMgr
end

function AlKirovChargeState:__delete()
  self:OnExit()
  self.stateMgr = nil
end

function AlKirovChargeState:OnEnter()
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:PlayEffect(stateMgr.EffectFlag.Airflow)
    stateMgr:PlayAnimation(stateMgr.Anim.Charge)
  end
end

function AlKirovChargeState:OnExit()
end

function AlKirovChargeState:OnUpdate(deltaTime)
end

return AlKirovChargeState
