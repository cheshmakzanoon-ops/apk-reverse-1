local SurfingPlayerIdleState = BaseClass("SurfingPlayerIdleState")

function SurfingPlayerIdleState:__init(unit)
  self.unit = unit
end

function SurfingPlayerIdleState:__delete()
  self.unit = nil
end

function SurfingPlayerIdleState:OnEnter()
  self.unit:PlaySimpleAnim("Default")
end

function SurfingPlayerIdleState:OnExit()
end

function SurfingPlayerIdleState:OnUpdate(deltaTime)
end

return SurfingPlayerIdleState
