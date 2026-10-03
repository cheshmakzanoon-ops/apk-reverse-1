local Const = require("Scene.LWBattle.Const")
local ZombieStateHurt = BaseClass("ZombieStateHurt")

function ZombieStateHurt:__init(unit)
  self.unit = unit
  self.timer = 0
end

function ZombieStateHurt:__delete()
  self.unit = nil
  self.timer = 0
end

function ZombieStateHurt:OnEnter(time)
  self.timer = time
end

function ZombieStateHurt:OnTransToSelf(time)
  self.timer = math.max(self.timer, time)
end

function ZombieStateHurt:OnExit()
  self.timer = 0
end

function ZombieStateHurt:OnUpdate()
  self.timer = self.timer - Time.deltaTime
  if self.timer <= 0 then
    self.unit.fsm:ChangeState(ZombieState.Idle)
  end
end

return ZombieStateHurt
