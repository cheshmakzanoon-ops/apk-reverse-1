local base = require("DataCenter.LWBattle.Logic.SkyBattle.LogicState.BattleBaseState")
local Const = require("Scene.LWBattle.Const")
local BattleGoldMonsterBonusState = BaseClass("BattleGoldMonsterBonusState", base)

function BattleGoldMonsterBonusState:__init(logic)
  self.bonusWinConditions = self.logic.data.bonusWinConditions
end

function BattleGoldMonsterBonusState:__delete()
  self.bonusWinConditions = nil
  self:StopTimer()
end

function BattleGoldMonsterBonusState:OnEnter(state)
  Logger.Log("skyBattle\239\188\154BattleGoldMonsterBonusState")
  self.logic.team:ChangeStage(state)
  self.logic:OnFingerUp()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWarningTip, {anim = true}, WarningTipType.ParkourGoldBonus)
  self.logic:RefreshWinConditions({})
  local delayTime = 2.4
  self.tipTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:OnWarningTipEnd()
  end, delayTime)
end

function BattleGoldMonsterBonusState:OnWarningTipEnd()
  if self.logic and self.logic.monsterMgr then
    self.logic.monsterMgr:ChangeBonus()
    self.logic:RefreshWinConditions(self.bonusWinConditions)
    local param = {}
    param.bonusType = self:GetBonusType()
    param.conditions = self:GetCheckWinConditions()
    param.useTime = self.logic.useTime
    param.extendData = self.logic.data.bonusExtendData
    self.logic.mainUI:OnBonusEnter(param)
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWarningTip)
end

function BattleGoldMonsterBonusState:OnExit()
  base.OnExit(self)
  self:StopTimer()
end

function BattleGoldMonsterBonusState:StopTimer()
  if self.tipTimer then
    self.tipTimer:Stop()
    self.tipTimer = nil
  end
end

local interestingWinCondition = {
  Const.ParkourWinType.KillMonster,
  Const.ParkourWinType.Time
}

function BattleGoldMonsterBonusState:GetInterestingWinCondition()
  return interestingWinCondition
end

function BattleGoldMonsterBonusState:OnFingerHold(deltaTime)
  self.logic:OnFingerHoldHorizonAndVertical(deltaTime)
end

function BattleGoldMonsterBonusState:GetCheckWinConditions()
  return self.bonusWinConditions
end

function BattleGoldMonsterBonusState:OnConditionMatch()
  self.logic:OnBattleWin()
end

function BattleGoldMonsterBonusState:GetBonusType()
  return Const.ParkourBattleBonusType.GoldMonster
end

function BattleGoldMonsterBonusState:CanChangeTo(stateIndex)
  return stateIndex == Const.ParkourBattleState.PreExit
end

return BattleGoldMonsterBonusState
