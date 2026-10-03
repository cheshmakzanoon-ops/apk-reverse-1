local SurfingHunterRunState = BaseClass("SurfingHunterRunState")

function SurfingHunterRunState:__init(unit)
  self.unit = unit
end

function SurfingHunterRunState:__delete()
  self.unit = nil
end

function SurfingHunterRunState:OnEnter()
  self.unit:PlaySimpleAnim("run")
end

function SurfingHunterRunState:OnExit()
end

return SurfingHunterRunState
