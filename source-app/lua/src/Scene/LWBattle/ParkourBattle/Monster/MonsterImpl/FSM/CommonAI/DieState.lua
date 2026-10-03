local Const = require("Scene.LWBattle.Const")
local DieState = BaseClass("DieState")

function DieState:Init(unit)
  self.zombie = unit
end

function DieState:__delete()
  self.zombie = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function DieState:OnEnter()
  self.zombie.mgr:OnMonsterDeath(self.zombie.guid)
  self.zombie:RemoveDestination()
  self.zombie:FinishFlashCountdown()
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

function DieState:OnExit()
end

function DieState:OnUpdate(deltaTime)
end

return DieState
