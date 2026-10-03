local T11IdleGameBossBattleStateMatchStrike = BaseClass("T11IdleGameBossBattleStateMatchStrike")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function T11IdleGameBossBattleStateMatchStrike:__init(logic)
  self.logic = logic
  self.resultData = nil
end

function T11IdleGameBossBattleStateMatchStrike:__delete()
  self.logic = nil
  self.resultData = nil
end

function T11IdleGameBossBattleStateMatchStrike:OnEnter(resultData)
  self.resultData = resultData
  if self.logic == nil or self.resultData == nil then
    return
  end
  self.logic:ChangeSquadState(Const.BossBattleSoldierState.Strike, self.resultData)
  self.logic:PlaySquadAnim("win")
  self.logic:ChangeBossState(Const.BossBattleBossState.Strike, self.resultData, function()
    self:OnStrikeFinish()
  end)
  self.logic:PlaySceneCameraAnim("Attack")
  if self.resultData.win == true then
    DataCenter.LWSoundManager:PlaySound(91015, false)
  else
    DataCenter.LWSoundManager:PlaySound(91016, false)
  end
end

function T11IdleGameBossBattleStateMatchStrike:OnExit()
end

function T11IdleGameBossBattleStateMatchStrike:OnUpdate()
end

function T11IdleGameBossBattleStateMatchStrike:Dispose()
end

function T11IdleGameBossBattleStateMatchStrike:OnStrikeFinish()
  if self.logic then
    self.logic:ChangeState(Const.BossBattleState.Match_End, self.resultData)
  end
end

return T11IdleGameBossBattleStateMatchStrike
