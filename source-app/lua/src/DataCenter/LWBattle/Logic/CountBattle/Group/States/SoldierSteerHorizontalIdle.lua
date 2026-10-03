local SoldierSteerHorizontalIdle = BaseClass("SoldierSteerHorizontalIdle")

function SoldierSteerHorizontalIdle:__init(owner)
  self.owner = owner
end

function SoldierSteerHorizontalIdle:__delete()
end

function SoldierSteerHorizontalIdle:OnEnter()
  self.owner:PlayUnitHorizontalIdle()
end

function SoldierSteerHorizontalIdle:OnExit()
end

return SoldierSteerHorizontalIdle
