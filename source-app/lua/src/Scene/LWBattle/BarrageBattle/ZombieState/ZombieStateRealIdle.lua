local ZombieStateRealIdle = BaseClass("ZombieStateRealIdle")

function ZombieStateRealIdle:__init(unit)
  self.unit = unit
end

function ZombieStateRealIdle:__delete()
  self.unit = nil
end

function ZombieStateRealIdle:OnEnter()
  self.unit:RemoveDestination()
  self.unit:PlaySimpleAnim(ZombieAnim.Idle, 1)
end

function ZombieStateRealIdle:OnExit()
end

function ZombieStateRealIdle:OnUpdate()
end

return ZombieStateRealIdle
