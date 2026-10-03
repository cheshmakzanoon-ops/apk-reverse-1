local base = require("DataCenter.LWBattle.Logic.SkyBattle.LogicState.BattleBaseState")
local Const = require("Scene.LWBattle.Const")
local BattleReadyState = BaseClass("BattleReadyState", base)

function BattleReadyState:__init(logic)
end

function BattleReadyState:__delete()
end

function BattleReadyState:OnEnter(state)
  Logger.Log("skyBattle\239\188\154Ready")
  self.logic:PlayGameStartShow()
end

function BattleReadyState:OnUpdate(deltaTime)
  if self.countingToWinTimer then
    return
  end
  local showFinish = self.logic:UpdateGameStartShow(deltaTime)
  self.logic:MoveZDistanceFrame(deltaTime)
  if showFinish then
    self.logic:ChangeStage(Const.ParkourBattleState.Farm)
  end
end

local interestingWinCondition = {
  Const.ParkourWinType.KillMonster,
  Const.ParkourWinType.FinishPoint
}

function BattleReadyState:GetInterestingWinCondition()
  return interestingWinCondition
end

return BattleReadyState
