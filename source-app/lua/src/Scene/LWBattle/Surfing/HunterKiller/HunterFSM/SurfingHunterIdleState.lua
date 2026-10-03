local SurfingHunterIdleState = BaseClass("SurfingHunterIdleState")

function SurfingHunterIdleState:__init(unit)
  self.unit = unit
end

function SurfingHunterIdleState:__delete()
  self.unit = nil
end

function SurfingHunterIdleState:OnEnter()
  self.unit:PlaySimpleAnim("idle")
end

function SurfingHunterIdleState:OnExit()
end

return SurfingHunterIdleState
