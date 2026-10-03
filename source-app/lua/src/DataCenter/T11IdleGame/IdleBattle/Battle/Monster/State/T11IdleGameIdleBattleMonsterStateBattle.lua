local T11IdleGameIdleBattleMonsterStateBattle = BaseClass("T11IdleGameIdleBattleMonsterStateBattle")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function T11IdleGameIdleBattleMonsterStateBattle:__init(owner)
  self.owner = owner
end

function T11IdleGameIdleBattleMonsterStateBattle:__delete()
  self.owner = nil
end

function T11IdleGameIdleBattleMonsterStateBattle:OnEnter()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function T11IdleGameIdleBattleMonsterStateBattle:OnExit()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function T11IdleGameIdleBattleMonsterStateBattle:OnUpdate(deltaTime)
end

function T11IdleGameIdleBattleMonsterStateBattle:Dispose()
end

function T11IdleGameIdleBattleMonsterStateBattle:BeHit()
  if self.timer then
    return
  end
  self.owner:PlayAnim(AnimName.Hurt)
  local length = self.owner:GetAnimLength(AnimName.Hurt)
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self.timer = nil
  end, length)
end

return T11IdleGameIdleBattleMonsterStateBattle
