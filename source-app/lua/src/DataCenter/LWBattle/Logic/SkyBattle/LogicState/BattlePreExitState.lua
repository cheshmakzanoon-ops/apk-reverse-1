local base = require("DataCenter.LWBattle.Logic.SkyBattle.LogicState.BattleBaseState")
local Const = require("Scene.LWBattle.Const")
local BattlePreExitState = BaseClass("BattlePreExitState", base)

function BattlePreExitState:__init(logic)
end

function BattlePreExitState:__delete()
end

function BattlePreExitState:OnEnter(state)
  base.OnEnter(self)
  Logger.Log("skyBattle\239\188\154BattlePreExitState")
  self.logic.team:ChangeStage(state)
  if self.logic.mainUI then
    self.logic.mainUI:OnParkourBattleWin()
    self.logic:DoVibration(0.5, 0.3, 0.3)
  end
  self.logic.winToRemoveEffect = true
  self.logic:ChangeStage(Const.ParkourBattleState.Exit)
end

function BattlePreExitState:CanChangeTo(stateIndex)
  return stateIndex == Const.ParkourBattleState.Exit
end

return BattlePreExitState
