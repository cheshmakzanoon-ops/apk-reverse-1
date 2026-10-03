local base = require("DataCenter.LWBattle.Logic.ParkourBattle.ExtendState.ParkourBattleGoldMonsterBonusState")
local Const = require("Scene.LWBattle.Const")
local ParkourBattleProgressMonsterBonusState = BaseClass("ParkourBattleProgressMonsterBonusState", base)

function ParkourBattleProgressMonsterBonusState:GetBonusType()
  return Const.ParkourBattleBonusType.ProgressMonster
end

return ParkourBattleProgressMonsterBonusState
