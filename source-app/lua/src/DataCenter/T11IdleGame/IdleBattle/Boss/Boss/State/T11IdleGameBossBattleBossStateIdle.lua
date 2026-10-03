local T11IdleGameBossBattleBossStateIdle = BaseClass("T11IdleGameBossBattleBossStateIdle")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function T11IdleGameBossBattleBossStateIdle:__init(owner)
  self.owner = owner
end

function T11IdleGameBossBattleBossStateIdle:__delete()
  self.owner = nil
end

function T11IdleGameBossBattleBossStateIdle:OnEnter()
  self.owner:PlayRootAnim("Default")
  self.owner:PlayAnim("Default")
end

function T11IdleGameBossBattleBossStateIdle:OnExit()
end

function T11IdleGameBossBattleBossStateIdle:OnUpdate(deltaTime)
end

function T11IdleGameBossBattleBossStateIdle:Dispose()
end

return T11IdleGameBossBattleBossStateIdle
