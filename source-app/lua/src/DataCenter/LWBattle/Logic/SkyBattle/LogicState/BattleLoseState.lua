local base = require("DataCenter.LWBattle.Logic.SkyBattle.LogicState.BattleBaseState")
local Const = require("Scene.LWBattle.Const")
local EffectViewUtil = require("Scene.LWBattle.EffectObj.EffectViewUtil")
local BattleLoseState = BaseClass("BattleLoseState", base)

function BattleLoseState:__init(logic)
end

function BattleLoseState:__delete()
end

function BattleLoseState:OnEnter(state)
  base.OnEnter(self)
  Logger.Log("skyBattle\239\188\154BattleLoseState")
  self.logic.team:ChangeStage(state)
  self.logic.battleMgr:SetGameOver(true)
  EffectViewUtil.Update(Time.deltaTime)
  self.logic:CheckToShowLoseResult()
end

return BattleLoseState
