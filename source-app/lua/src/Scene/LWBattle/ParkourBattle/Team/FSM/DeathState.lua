local DeathState = BaseClass("DeathState")

function DeathState:__init(unit)
  self.unit = unit
end

function DeathState:__delete()
  self.unit = nil
end

function DeathState:OnEnter()
  self.unit:PlaySimpleAnim(AnimName.Dead)
end

function DeathState:OnExit()
end

function DeathState:OnUpdate()
end

return DeathState
