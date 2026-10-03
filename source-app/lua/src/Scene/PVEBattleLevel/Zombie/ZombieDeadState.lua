local ZombieDeadState = BaseClass("ZombieDeadState")

function ZombieDeadState:__init(zombie)
  self.zombie = zombie
end

function ZombieDeadState:__delete()
end

function ZombieDeadState:OnEnter()
  self.zombie:ShowTombstone()
end

function ZombieDeadState:OnExit()
end

function ZombieDeadState:OnUpdate(deltaTime)
end

return ZombieDeadState
