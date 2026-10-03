local SoldierSteerHorizontalLeft = BaseClass("SoldierSteerHorizontalLeft")

function SoldierSteerHorizontalLeft:__init(owner)
  self.owner = owner
end

function SoldierSteerHorizontalLeft:__delete()
  self.owner = nil
end

function SoldierSteerHorizontalLeft:OnEnter()
  self.owner:PlayUnitHorizontalLeft()
end

function SoldierSteerHorizontalLeft:OnTransToSelf()
  self.owner:PlayUnitHorizontalLeft()
end

function SoldierSteerHorizontalLeft:OnExit()
end

return SoldierSteerHorizontalLeft
