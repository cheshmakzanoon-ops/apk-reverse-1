local SurfingHunterHuntState = BaseClass("SurfingHunterHuntState")

function SurfingHunterHuntState:__init(unit)
  self.unit = unit
end

function SurfingHunterHuntState:__delete()
  self.unit = nil
end

function SurfingHunterHuntState:OnEnter()
  self.unit:PlaySimpleAnim("hunt")
end

function SurfingHunterHuntState:OnExit()
end

return SurfingHunterHuntState
