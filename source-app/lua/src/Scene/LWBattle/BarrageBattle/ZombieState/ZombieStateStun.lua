local Const = require("Scene.LWBattle.Const")
local ZombieStateStun = BaseClass("ZombieStateStun")

function ZombieStateStun:__init(unit)
  self.unit = unit
end

function ZombieStateStun:__delete()
  self.unit = nil
end

function ZombieStateStun:OnEnter()
  self.unit:PlaySimpleAnim(AnimName.Stun, 1)
end

function ZombieStateStun:OnTransToSelf()
end

function ZombieStateStun:OnExit()
end

function ZombieStateStun:OnUpdate()
  if not self.unit:IsStunning() then
    self.unit.fsm:ChangeState(ZombieState.Run)
  end
end

return ZombieStateStun
