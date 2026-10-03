local base = require("DataCenter.LWBattle.Logic.ParkourBattle.ExtendState.ParkourBattleExtendState")
local Const = require("Scene.LWBattle.Const")
local ParkourBattlePreDashBonusState = BaseClass("ParkourBattlePreDashBonusState", base)

function ParkourBattlePreDashBonusState:__init(logic)
  self.logic = logic
end

function ParkourBattlePreDashBonusState:__delete()
  self.logic = nil
end

function ParkourBattlePreDashBonusState:OnEnter(state)
  self.state = state
  self.logic.team:ChangeStage(state)
end

return ParkourBattlePreDashBonusState
