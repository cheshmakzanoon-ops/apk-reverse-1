local T11IdleGameIdleBattleMonsterStateDead = BaseClass("T11IdleGameIdleBattleMonsterStateDead")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function T11IdleGameIdleBattleMonsterStateDead:__init(owner)
  self.owner = owner
end

function T11IdleGameIdleBattleMonsterStateDead:__delete()
  self.owner = nil
end

function T11IdleGameIdleBattleMonsterStateDead:OnEnter()
  self.owner:PlayAnim(AnimName.Dead)
  local length = self.owner:GetAnimLength(AnimName.Dead)
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self.timer = nil
    self.owner:SetActive(false)
  end, length)
  local monsterId = self.owner:GetMonsterId()
  if monsterId == Const.NodeBattleMonsterId.ExplodeMan then
    DataCenter.LWSoundManager:PlaySound(91020, false)
  elseif monsterId == Const.NodeBattleMonsterId.StrongMan then
    DataCenter.LWSoundManager:PlaySound(91018, false)
  elseif monsterId == Const.NodeBattleMonsterId.ZombieDog then
    DataCenter.LWSoundManager:PlaySound(91019, false)
  end
end

function T11IdleGameIdleBattleMonsterStateDead:OnExit()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function T11IdleGameIdleBattleMonsterStateDead:OnUpdate(deltaTime)
end

function T11IdleGameIdleBattleMonsterStateDead:Dispose()
end

return T11IdleGameIdleBattleMonsterStateDead
