local T11IdleGameBossBattleSoldierStateEnd = BaseClass("T11IdleGameBossBattleSoldierStateEnd")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function T11IdleGameBossBattleSoldierStateEnd:__init(owner)
  self.owner = owner
end

function T11IdleGameBossBattleSoldierStateEnd:__delete()
  self.owner = nil
end

function T11IdleGameBossBattleSoldierStateEnd:OnEnter()
end

function T11IdleGameBossBattleSoldierStateEnd:OnExit()
end

function T11IdleGameBossBattleSoldierStateEnd:OnUpdate()
end

function T11IdleGameBossBattleSoldierStateEnd:Dispose()
end

return T11IdleGameBossBattleSoldierStateEnd
