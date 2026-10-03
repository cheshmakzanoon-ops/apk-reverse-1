local T11IdleGameIdleBattleMonsterStateRun = BaseClass("T11IdleGameIdleBattleMonsterStateRun")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function T11IdleGameIdleBattleMonsterStateRun:__init(owner)
  self.owner = owner
end

function T11IdleGameIdleBattleMonsterStateRun:__delete()
  self.owner = nil
end

function T11IdleGameIdleBattleMonsterStateRun:OnEnter()
  self.owner:PlayAnim(AnimName.Run)
end

function T11IdleGameIdleBattleMonsterStateRun:OnExit()
end

function T11IdleGameIdleBattleMonsterStateRun:OnUpdate(deltaTime)
end

function T11IdleGameIdleBattleMonsterStateRun:Dispose()
end

return T11IdleGameIdleBattleMonsterStateRun
