local FireStateIdle = BaseClass("FireStateIdle")

function FireStateIdle:__init(unit)
  self.unit = unit
end

function FireStateIdle:__delete()
  self.unit = nil
end

function FireStateIdle:OnEnter()
  if self.unit:IsMoving() then
    self.unit:RewindAndPlaySimpleAnim(AnimName.Run, 1, 0.2)
  else
    self.unit:RewindAndPlaySimpleAnim(AnimName.Idle, 1, 0.2)
  end
end

function FireStateIdle:OnExit()
end

function FireStateIdle:OnUpdate()
end

return FireStateIdle
