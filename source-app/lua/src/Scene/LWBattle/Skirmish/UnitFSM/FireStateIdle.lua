local FireStateIdle = BaseClass("FireStateIdle")

function FireStateIdle:__init(unit)
  self.unit = unit
end

function FireStateIdle:__delete()
  self.unit = nil
end

function FireStateIdle:OnEnter()
  if self.unit:IsMoving() then
    self.unit:Tl_RewindAndPlaySimpleAnim(AnimName.Run, 0, 1, false)
  else
    self.unit:Tl_RewindAndPlaySimpleAnim(AnimName.Idle, 0, 1, false)
  end
end

function FireStateIdle:OnExit()
end

function FireStateIdle:OnUpdate()
end

return FireStateIdle
