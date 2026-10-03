local SurfingObjectIdleState = BaseClass("SurfingObjectIdleState")

function SurfingObjectIdleState:Init(unit)
  self.unit = unit
end

function SurfingObjectIdleState:__delete()
  self.unit = nil
  self.move_speed = nil
end

function SurfingObjectIdleState:OnEnter()
end

function SurfingObjectIdleState:OnExit()
end

function SurfingObjectIdleState:OnUpdate(deltaTime)
end

return SurfingObjectIdleState
