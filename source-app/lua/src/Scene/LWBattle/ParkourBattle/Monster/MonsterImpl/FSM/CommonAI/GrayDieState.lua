local Const = require("Scene.LWBattle.Const")
local GrayDieState = BaseClass("GrayDieState")

function GrayDieState:Init(unit)
  self.zombie = unit
end

function GrayDieState:__delete()
  self.zombie = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function GrayDieState:OnEnter()
  self.zombie.mgr:OnMonsterDeath(self.zombie.guid)
  self.zombie:RemoveDestination()
  self.zombie:FinishFlashCountdown(true)
  self.zombie:DieGray()
  local stayTime = 2
  if self.zombie.GetDieStayTime then
    stayTime = self.zombie:GetDieStayTime()
  end
  self.timer = TimerManager:DelayInvoke(function()
    self.zombie.mgr:RemoveMonster(self.zombie.guid)
  end, stayTime)
  if self.zombie.monsterMeta.monster_type == Const.MonsterType.Normal and self.zombie.mgr and self.zombie.mgr.GetRandomDeadAnim and self.zombie.mgr:GetRandomDeadAnim() then
    local deadAnim = self.zombie.mgr:GetRandomDeadAnim()
    if self.zombie:GetState(deadAnim) then
      self.zombie:PlaySimpleAnim(deadAnim, 1)
      return
    end
  end
  self.zombie:PlaySimpleAnim(ZombieAnim.Dead, 1)
end

function GrayDieState:OnExit()
end

function GrayDieState:OnUpdate(deltaTime)
end

return GrayDieState
