local base = require("DataCenter.LWBattle.Logic.SkyBattle.LogicState.BattleBaseState")
local Const = require("Scene.LWBattle.Const")
local BattleProgressMonsterBonusState = BaseClass("BattleProgressMonsterBonusState", base)

function BattleProgressMonsterBonusState:OnEnter(state)
  base.OnEnter(self)
  Logger.Log("skyBattle\239\188\154BattleProgressMonsterBonusState")
  self.logic.team:ChangeStage(state)
  self.logic:OnFingerUp()
end

function BattleProgressMonsterBonusState:GetBonusType()
  return Const.ParkourBattleBonusType.ProgressMonster
end

function BattleProgressMonsterBonusState:OnFingerHold(deltaTime)
  self.logic:OnFingerHoldHorizonAndVertical(deltaTime)
end

local interestingWinCondition = {
  Const.ParkourWinType.KillMonster,
  Const.ParkourWinType.Time
}

function BattleProgressMonsterBonusState:OnConditionMatch()
  self.logic:OnBattleWin()
end

function BattleProgressMonsterBonusState:GetInterestingWinCondition()
  return interestingWinCondition
end

function BattleProgressMonsterBonusState:CanChangeTo(stateIndex)
  return stateIndex == Const.ParkourBattleState.PreExit
end

return BattleProgressMonsterBonusState
