local ZMBuildingIdleState = BaseClass("ZMBuildingIdleState")

function ZMBuildingIdleState:__init(stateMgr)
  self.stateMgr = stateMgr
end

function ZMBuildingIdleState:__delete()
  if self.stateMgr then
    self.stateMgr:RemoveEffect(self.stateMgr.EffectFlag.IdleLight)
    self.stateMgr:RemoveEffect(self.stateMgr.EffectFlag.IdleFire)
  end
  self.stateMgr = nil
end

function ZMBuildingIdleState:OnEnter()
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:DoIdleState()
  end
end

function ZMBuildingIdleState:OnExit()
end

function ZMBuildingIdleState:OnUpdate(deltaTime)
end

return ZMBuildingIdleState
