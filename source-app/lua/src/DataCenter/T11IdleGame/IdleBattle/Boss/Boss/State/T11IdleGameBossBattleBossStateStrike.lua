local T11IdleGameBossBattleBossStateStrike = BaseClass("T11IdleGameBossBattleBossStateStrike")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function T11IdleGameBossBattleBossStateStrike:__init(owner)
  self.owner = owner
end

function T11IdleGameBossBattleBossStateStrike:__delete()
  self.owner = nil
end

function T11IdleGameBossBattleBossStateStrike:OnEnter(resultData, finishCallback)
  self:ClearDelayTimer()
  if not resultData then
    return
  end
  local animLength = 0
  if resultData.win == true then
    self.owner:PlayRootAnim("lose")
    self.owner:PlayAnim("t11_idle_game_zhuangfei")
    animLength = self.owner:GetAnimLength("t11_idle_game_zhuangfei")
  else
    self.owner:PlayRootAnim("win")
    self.owner:PlayAnim("t11_idle_game_fangyu")
    animLength = self.owner:GetAnimLength("t11_idle_game_fangyu")
  end
  self.delayFinishTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.delayFinishTimer = nil
    if finishCallback then
      finishCallback()
    end
  end, animLength)
end

function T11IdleGameBossBattleBossStateStrike:OnExit()
  self:ClearDelayTimer()
end

function T11IdleGameBossBattleBossStateStrike:OnUpdate(deltaTime)
end

function T11IdleGameBossBattleBossStateStrike:Dispose()
  self:ClearDelayTimer()
end

function T11IdleGameBossBattleBossStateStrike:ClearDelayTimer()
  if self.delayFinishTimer then
    self.delayFinishTimer:Stop()
    self.delayFinishTimer = nil
  end
end

return T11IdleGameBossBattleBossStateStrike
