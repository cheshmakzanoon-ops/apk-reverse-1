local T11IdleGameBossBattleStateMatchInit = BaseClass("T11IdleGameBossBattleStateMatchInit")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function T11IdleGameBossBattleStateMatchInit:__init(logic)
  self.logic = logic
  self.boss = nil
end

function T11IdleGameBossBattleStateMatchInit:__delete()
  self.logic = nil
  self.boss = nil
end

function T11IdleGameBossBattleStateMatchInit:OnEnter(boss, isOpening)
  self.boss = boss
  if not self.logic then
    return
  end
  if isOpening then
    self.logic:PlaySquadAnim("open", function()
      self.logic:ChangeSquadState(Const.BossBattleSoldierState.Idle)
    end)
    self.logic:ChangeSquadState(Const.BossBattleSoldierState.Run)
  else
    self.logic:PlaySquadAnim("Default")
    self.logic:ChangeSquadState(Const.BossBattleSoldierState.Idle)
  end
  self.logic:CreateBoss(boss, function()
    if self.logic then
      self.logic:ShowBossInfoUI(self.boss)
      self.logic:OnMatchInitFinish(self.boss)
    end
  end)
end

function T11IdleGameBossBattleStateMatchInit:OnExit()
end

function T11IdleGameBossBattleStateMatchInit:OnUpdate()
end

function T11IdleGameBossBattleStateMatchInit:Dispose()
end

return T11IdleGameBossBattleStateMatchInit
