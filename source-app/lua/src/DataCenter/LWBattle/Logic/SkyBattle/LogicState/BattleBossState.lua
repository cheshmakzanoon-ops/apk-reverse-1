local base = require("DataCenter.LWBattle.Logic.SkyBattle.LogicState.BattleBaseState")
local Const = require("Scene.LWBattle.Const")
local BattleBossState = BaseClass("BattleBossState", base)

function BattleBossState:__init(logic)
end

function BattleBossState:__delete()
end

function BattleBossState:OnEnter(state)
  base.OnEnter(self)
  Logger.Log("skyBattle\239\188\154Boss")
end

function BattleBossState:OnUpdate(deltaTime)
  if self.countingToWinTimer then
    return
  end
  self.logic:MoveZDistanceFrame(deltaTime)
end

local interestingWinCondition = {
  Const.ParkourWinType.KillMonster,
  Const.ParkourWinType.Time,
  Const.ParkourWinType.FinishPoint
}

function BattleBossState:GetInterestingWinCondition()
  return interestingWinCondition
end

function BattleBossState:OnConditionMatch()
  self.logic:OnBattleWin()
end

function BattleBossState:OnFingerHold(deltaTime)
  self.logic:OnFingerHoldHorizonAndVertical(deltaTime)
end

function BattleBossState:CanChangeTo(stateIndex)
  return stateIndex == Const.ParkourBattleState.PreExit or stateIndex == Const.ParkourBattleState.Lose
end

return BattleBossState
