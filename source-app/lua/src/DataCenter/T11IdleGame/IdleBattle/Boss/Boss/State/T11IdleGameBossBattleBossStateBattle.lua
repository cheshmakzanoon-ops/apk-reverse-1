local T11IdleGameBossBattleBossStateBattle = BaseClass("T11IdleGameBossBattleBossStateBattle")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function T11IdleGameBossBattleBossStateBattle:__init(owner)
  self.owner = owner
end

function T11IdleGameBossBattleBossStateBattle:__delete()
  self.owner = nil
end

function T11IdleGameBossBattleBossStateBattle:OnEnter()
  self.owner:PlayAnim("t11_idle_game_idle02")
end

function T11IdleGameBossBattleBossStateBattle:OnExit()
end

function T11IdleGameBossBattleBossStateBattle:OnUpdate(deltaTime)
end

function T11IdleGameBossBattleBossStateBattle:Dispose()
end

return T11IdleGameBossBattleBossStateBattle
