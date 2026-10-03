local ZMBuildingUpgradeState = BaseClass("ZMBuildingUpgradeState")

function ZMBuildingUpgradeState:__init(stateMgr)
  self.stateMgr = stateMgr
end

function ZMBuildingUpgradeState:__delete()
  self:OnExit()
  self.stateMgr = nil
end

function ZMBuildingUpgradeState:OnEnter()
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:ChangeToIdleState()
    stateMgr:PlayEffect(stateMgr.EffectFlag.Upgrade, 5)
  end
end

function ZMBuildingUpgradeState:OnExit()
  if self.stateMgr then
    self.stateMgr:RemoveEffect(self.stateMgr.EffectFlag.Upgrade)
  end
end

function ZMBuildingUpgradeState:OnUpdate(deltaTime)
end

return ZMBuildingUpgradeState
