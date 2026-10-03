local base = require("DataCenter.LWBattle.Logic.SkyBattle.LogicState.BattleBaseState")
local Const = require("Scene.LWBattle.Const")
local BattleFarmState = BaseClass("BattleFarmState", base)

function BattleFarmState:__init(logic)
end

function BattleFarmState:__delete()
end

function BattleFarmState:OnEnter(state)
  base.OnEnter(self)
  Logger.Log("skyBattle\239\188\154Farm")
  self.logic.team:ChangeStage(state)
end

function BattleFarmState:OnUpdate(deltaTime)
  if self.countingToWinTimer then
    return
  end
  self.logic:MoveZDistanceFrame(deltaTime)
end

local interestingWinCondition = {
  Const.ParkourWinType.KillMonster,
  Const.ParkourWinType.FinishPoint,
  Const.ParkourWinType.Time
}

function BattleFarmState:GetInterestingWinCondition()
  return interestingWinCondition
end

function BattleFarmState:OnConditionMatch()
  self.logic:OnBattleWin()
end

function BattleFarmState:OnFingerHold(deltaTime)
  self.logic:OnFingerHoldHorizonAndVertical(deltaTime)
end

function BattleFarmState:CanChangeTo(stateIndex)
  return stateIndex == Const.ParkourBattleState.PreExit or stateIndex == Const.ParkourBattleState.Lose
end

return BattleFarmState
