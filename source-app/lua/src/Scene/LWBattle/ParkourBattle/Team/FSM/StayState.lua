local StayState = BaseClass("StayState")

function StayState:__init(unit)
  self.unit = unit
end

function StayState:__delete()
  self.unit = nil
end

function StayState:OnEnter()
  self.unit:PlaySimpleAnim(AnimName.Idle)
end

function StayState:OnExit()
end

function StayState:OnUpdate()
end

return StayState
