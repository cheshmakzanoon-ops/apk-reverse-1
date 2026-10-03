local T11IdleGameBossBattleBossStateBorn = BaseClass("T11IdleGameBossBattleBossStateBorn")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function T11IdleGameBossBattleBossStateBorn:__init(owner)
  self.owner = owner
end

function T11IdleGameBossBattleBossStateBorn:__delete()
  self.owner = nil
end

function T11IdleGameBossBattleBossStateBorn:OnEnter(bornFinishCallback)
  self:ClearDelayTimer()
  local animLength = self.owner:GetAnimLength("t11_idle_game_born")
  if 0 < animLength then
    self.delayFinishTimer = TimerManager:GetInstance():DelayInvoke(function()
      if bornFinishCallback then
        bornFinishCallback()
      end
    end, animLength)
  elseif bornFinishCallback then
    bornFinishCallback()
  end
  self.owner:PlayAnim("t11_idle_game_born")
  self.owner:PlayRootAnim("Default")
  DataCenter.LWSoundManager:PlaySound(91014, false)
end

function T11IdleGameBossBattleBossStateBorn:OnExit()
  self:ClearDelayTimer()
end

function T11IdleGameBossBattleBossStateBorn:OnUpdate(deltaTime)
end

function T11IdleGameBossBattleBossStateBorn:Dispose()
  self:ClearDelayTimer()
end

function T11IdleGameBossBattleBossStateBorn:ClearDelayTimer()
  if self.delayFinishTimer then
    self.delayFinishTimer:Stop()
    self.delayFinishTimer = nil
  end
end

return T11IdleGameBossBattleBossStateBorn
