local T11IdleGameIdleBattleMonsterStateIdle = BaseClass("T11IdleGameIdleBattleMonsterStateIdle")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function T11IdleGameIdleBattleMonsterStateIdle:__init(owner)
  self.owner = owner
end

function T11IdleGameIdleBattleMonsterStateIdle:__delete()
  self.owner = nil
end

function T11IdleGameIdleBattleMonsterStateIdle:OnEnter()
  self.owner:CrossFadeAnim(AnimName.Idle)
end

function T11IdleGameIdleBattleMonsterStateIdle:OnExit()
end

function T11IdleGameIdleBattleMonsterStateIdle:OnUpdate(deltaTime)
end

function T11IdleGameIdleBattleMonsterStateIdle:Dispose()
end

return T11IdleGameIdleBattleMonsterStateIdle
