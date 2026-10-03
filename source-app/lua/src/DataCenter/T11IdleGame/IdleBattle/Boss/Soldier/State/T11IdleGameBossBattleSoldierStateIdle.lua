local T11IdleGameBossBattleSoldierStateIdle = BaseClass("T11IdleGameBossBattleSoldierStateIdle")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function T11IdleGameBossBattleSoldierStateIdle:__init(owner)
  self.owner = owner
end

function T11IdleGameBossBattleSoldierStateIdle:__delete()
  self.owner = nil
end

function T11IdleGameBossBattleSoldierStateIdle:OnEnter()
  if not self.owner then
    return
  end
  self.owner:PlayAnim("idle_game_idle02", nil, 0.2)
end

function T11IdleGameBossBattleSoldierStateIdle:OnExit()
end

function T11IdleGameBossBattleSoldierStateIdle:OnUpdate()
end

function T11IdleGameBossBattleSoldierStateIdle:Dispose()
end

return T11IdleGameBossBattleSoldierStateIdle
