local T11IdleGameBossBattleSoldierStateStrike = BaseClass("T11IdleGameBossBattleSoldierStateStrike")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function T11IdleGameBossBattleSoldierStateStrike:__init(owner)
  self.owner = owner
end

function T11IdleGameBossBattleSoldierStateStrike:__delete()
  self.owner = nil
end

function T11IdleGameBossBattleSoldierStateStrike:OnEnter(resultData)
  if not resultData then
    return
  end
  if resultData.win == true then
    self.owner:PlayAnim("idle_game_impact_success", "idle_game_idle01", 0.2)
  else
    self.owner:PlayAnim("idle_game_impact_failed", "idle_game_idle01", 0.2)
  end
end

function T11IdleGameBossBattleSoldierStateStrike:OnExit()
end

function T11IdleGameBossBattleSoldierStateStrike:OnUpdate()
end

function T11IdleGameBossBattleSoldierStateStrike:Dispose()
end

return T11IdleGameBossBattleSoldierStateStrike
