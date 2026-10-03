local T11IdleGameBossBattleSoldierStateRun = BaseClass("T11IdleGameBossBattleSoldierStateRun")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function T11IdleGameBossBattleSoldierStateRun:__init(owner)
  self.owner = owner
end

function T11IdleGameBossBattleSoldierStateRun:__delete()
  self.owner = nil
end

function T11IdleGameBossBattleSoldierStateRun:OnEnter()
  if not self.owner then
    return
  end
  self.owner:PlayAnim("idle_game_run")
  self.owner:SetSoldierForward(0)
end

function T11IdleGameBossBattleSoldierStateRun:OnExit()
end

function T11IdleGameBossBattleSoldierStateRun:OnUpdate()
end

function T11IdleGameBossBattleSoldierStateRun:Dispose()
end

return T11IdleGameBossBattleSoldierStateRun
