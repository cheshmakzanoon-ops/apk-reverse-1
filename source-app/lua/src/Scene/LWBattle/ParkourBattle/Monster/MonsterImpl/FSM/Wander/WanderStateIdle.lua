local ZombieCommonAI = require("Scene.LWBattle.AI.ZombieCommonAI")
local WanderStateIdle = BaseClass("WanderStateIdle")
local Time = _ENV.Time
local CHECK_TARGET_DESTINATION_CD = 0.5

function WanderStateIdle:Init(unit)
  self.unit = unit
  self.ai = ObjectPool:GetInstance():Load(ZombieCommonAI)
  self.ai:Init(self.unit)
  self.checkDestinationCd = 0
end

function WanderStateIdle:__delete()
  self.checkDestinationCd = nil
  self.unit = nil
  if self.ai then
    self.ai:Delete()
    ObjectPool:GetInstance():Save(self.ai)
    self.ai = nil
  end
end

function WanderStateIdle:OnEnter()
  local pos = self.unit:GetPosition()
  self.unit.agent:SetCurPosition(pos.x, pos.z)
  local speedPercent = self.unit:GetMoveSpeedPercent()
  if 1 < speedPercent then
    self.unit:PlaySimpleAnim(ZombieAnim.Run, 1)
  else
    self.unit:PlaySimpleAnim(ZombieAnim.Walk, 1)
  end
end

function WanderStateIdle:OnExit()
end

function WanderStateIdle:OnUpdate(deltaTime)
  if self.checkDestinationCd == nil then
    return
  end
  if self.checkDestinationCd <= 0 then
    self.checkDestinationCd = CHECK_TARGET_DESTINATION_CD
    self:CheckDestination()
  else
    self.checkDestinationCd = self.checkDestinationCd - deltaTime
  end
end

function WanderStateIdle:CheckDestination()
  self.unit.isAlert = self.unit:CheckEnemyInAlertRange()
  if self.unit.isAlert then
    self.unit.fsm:ChangeState(ZombieState.Run)
    return
  end
  local targetPos = self.unit.logic.team:GetPosition()
  self.unit:SetDestination(targetPos.x, targetPos.z)
end

return WanderStateIdle
