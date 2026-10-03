local T11IdleGameBossBattleStateMatchFight = BaseClass("T11IdleGameBossBattleStateMatchFight")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function T11IdleGameBossBattleStateMatchFight:__init(logic)
  self.logic = logic
  self.boss = nil
  self.resultData = nil
  self.timer = nil
end

function T11IdleGameBossBattleStateMatchFight:__delete()
  self.logic = nil
  self.boss = nil
  self.resultData = nil
  self.timer = nil
end

function T11IdleGameBossBattleStateMatchFight:OnEnter(boss, resultData)
  self.boss = boss
  self.resultData = resultData
  if self.boss == nil or self.logic == nil or self.resultData == nil then
    return
  end
  local uiComp = self.logic:GetBattleUIComponent()
  if uiComp then
    uiComp:HideBossInfo()
  end
  self.logic:SoldierEnterFireState(boss)
  self.delayBossEnterBattleTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.logic then
      self.logic:ChangeBossState(Const.BossBattleBossState.Battle)
    end
  end, 0.5)
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    if self.logic then
      self.logic:ChangeState(Const.BossBattleState.Match_Strike, self.resultData)
    end
  end, Const.BossBattleFireTime)
end

function T11IdleGameBossBattleStateMatchFight:OnExit()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function T11IdleGameBossBattleStateMatchFight:OnUpdate()
end

function T11IdleGameBossBattleStateMatchFight:Dispose()
end

return T11IdleGameBossBattleStateMatchFight
