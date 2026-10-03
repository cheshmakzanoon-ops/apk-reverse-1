local ZombieStateHardControl = BaseClass("ZombieStateHardControl")

function ZombieStateHardControl:Init(unit)
  self.unit = unit
  self.controlTime = 0
  self.isStiff = nil
end

function ZombieStateHardControl:__delete()
  self.unit = nil
  self.controlTime = 0
  self.isStiff = nil
end

function ZombieStateHardControl:OnEnter(type, time)
  self.controlTime = time
  self.isStiff = false
  if type == HardControlType.Stiff then
    if self.unit.anim then
      self.unit:PlaySimpleAnim(self.unit:GetCurAnimName(), 0)
    end
    self.isStiff = true
  elseif type == HardControlType.Stun then
    self.unit:PlaySimpleAnim(AnimName.Stun, 1)
  elseif type == HardControlType.Hurt then
    self.unit:PlaySimpleAnim(AnimName.Hurt, 1)
  elseif type == HardControlType.Imprison then
  end
end

function ZombieStateHardControl:OnTransToSelf(type, time)
  self.controlTime = math.max(self.controlTime, time)
end

function ZombieStateHardControl:OnExit()
  if self.isStiff then
    if self.unit.anim then
      self.unit:PlaySimpleAnim(self.unit:GetCurAnimName(), 1)
    end
    self.isStiff = false
  end
end

function ZombieStateHardControl:OnUpdate(deltaTime)
  deltaTime = deltaTime or Time.deltaTime
  self.controlTime = self.controlTime - deltaTime
  if self.controlTime <= 0 then
    self.unit.fsm:ChangeState(ZombieState.Idle)
  end
end

return ZombieStateHardControl
