local base = require("DataCenter.LWBattle.Logic.SkyBattle.LogicState.BattleBaseState")
local Const = require("Scene.LWBattle.Const")
local BattleDashBonusExitState = BaseClass("BattleDashBonusExitState", base)

function BattleDashBonusExitState:__init(logic)
end

function BattleDashBonusExitState:__delete()
end

function BattleDashBonusExitState:OnEnter(state)
  self.state = state
  self.logic.team:ChangeStage(state)
end

return BattleDashBonusExitState
