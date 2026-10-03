local SoldierSteerHorizontalRight = BaseClass("SoldierSteerHorizontalRight")

function SoldierSteerHorizontalRight:__init(owner)
  self.owner = owner
end

function SoldierSteerHorizontalRight:__delete()
  self.owner = nil
end

function SoldierSteerHorizontalRight:OnEnter()
  self.owner:PlayUnitHorizontalRight()
end

function SoldierSteerHorizontalRight:OnTransToSelf()
  self.owner:PlayUnitHorizontalRight()
end

function SoldierSteerHorizontalRight:OnExit()
end

return SoldierSteerHorizontalRight
