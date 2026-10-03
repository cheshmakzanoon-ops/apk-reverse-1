local ZombieStateRealShow = BaseClass("ZombieStateRealShow")

function ZombieStateRealShow:__init(unit)
  self.unit = unit
end

function ZombieStateRealShow:__delete()
  self.unit = nil
end

function ZombieStateRealShow:OnEnter()
  self.unit:RemoveDestination()
  self.unit:PlaySimpleAnim(ZombieAnim.Walk, 1)
end

function ZombieStateRealShow:OnExit()
end

function ZombieStateRealShow:OnUpdate()
end

return ZombieStateRealShow
