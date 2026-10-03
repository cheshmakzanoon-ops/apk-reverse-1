local T11IdleGameBossBattleStateMatchReady = BaseClass("T11IdleGameBossBattleStateMatchReady")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function T11IdleGameBossBattleStateMatchReady:__init(logic)
  self.logic = logic
  self.boss = nil
  self.hasSendMsg = false
end

function T11IdleGameBossBattleStateMatchReady:__delete()
  self.logic = nil
  self.boss = nil
  self.hasSendMsg = nil
end

function T11IdleGameBossBattleStateMatchReady:OnEnter(boss)
  self.boss = boss
  self.hasSendMsg = false
  if not self.logic then
    return
  end
  self.logic:ChangeBossState(Const.BossBattleBossState.Idle)
  self.logic:ChangeSquadState(Const.BossBattleSoldierState.Idle)
  self.logic:PlaySquadAnim("Default")
  local isAutoModeOn = self.logic:IsAutoModeOn()
  if isAutoModeOn then
    DataCenter.T11IdleGameDataManager:SendChallengeBossMessage(self.boss.id)
    self.hasSendMsg = true
  else
  end
  self.logic:RefreshUIBottomBtn()
end

function T11IdleGameBossBattleStateMatchReady:OnExit()
  if not self.logic then
    return
  end
  self.logic:RefreshUIBottomBtn()
end

function T11IdleGameBossBattleStateMatchReady:OnUpdate()
end

function T11IdleGameBossBattleStateMatchReady:Dispose()
end

function T11IdleGameBossBattleStateMatchReady:OnAutoModeChanged()
  if not self.logic or not self.boss then
    return
  end
  local isAutoModeOn = self.logic:IsAutoModeOn()
  if isAutoModeOn and not self.hasSendMsg then
    DataCenter.T11IdleGameDataManager:SendChallengeBossMessage(self.boss.id)
    self.hasSendMsg = true
  end
end

function T11IdleGameBossBattleStateMatchReady:ChallengeNow()
  if not self.logic or not self.boss then
    return
  end
  if not self.hasSendMsg then
    DataCenter.T11IdleGameDataManager:SendChallengeBossMessage(self.boss.id)
    self.hasSendMsg = true
  end
end

return T11IdleGameBossBattleStateMatchReady
