local ZombieCommonAI = require("Scene.LWBattle.AI.ZombieCommonAI")
local ZombieStateIdle = BaseClass("ZombieStateIdle")
local Time = _ENV.Time
local CHECK_TARGET_IN_RANGE_CD = 0.5
local REFRESH_WALK_TARGET_CD = 2
local bornAnimLen = 2.8

function ZombieStateIdle:Init(unit)
  self.unit = unit
  self.bornTime = Time.time + bornAnimLen
  self.unit:PlaySimpleAnim(ZombieAnim.Born, 1)
  self.checkTargetInRangeCd = 0
  self.ai = ObjectPool:GetInstance():Load(ZombieCommonAI)
  self.ai:Init(self.unit)
end

function ZombieStateIdle:__delete()
  self.unit = nil
  if self.ai then
    self.ai:Delete()
    ObjectPool:GetInstance():Save(self.ai)
    self.ai = nil
  end
end

function ZombieStateIdle:OnEnter()
  self.unit:RemoveDestination()
  self.checkTargetInRangeCd = 0
  self.idleCd = 0
end

function ZombieStateIdle:OnExit()
end

function ZombieStateIdle:OnUpdate(deltaTime)
  if Time.time < self.bornTime then
    return
  end
  if self.checkTargetInRangeCd <= 0 then
    self.checkTargetInRangeCd = CHECK_TARGET_IN_RANGE_CD
    if self:CheckTargetInSight() then
      return
    end
  else
    self.checkTargetInRangeCd = self.checkTargetInRangeCd - deltaTime
  end
  if 0 >= self.idleCd then
    self.idleCd = REFRESH_WALK_TARGET_CD
    self:WalkAround()
  else
    self.idleCd = self.idleCd - deltaTime
  end
end

function ZombieStateIdle:CheckTargetInSight()
  if not self.unit.isAlert then
    self.unit.isAlert = self.unit:CheckEnemyInAlertRange()
  end
  if self.unit.isAlert then
    local nextSkill = self.unit.skillManager:GetActiveSkillIgnoreRange()
    if nextSkill then
      local target = self.ai:GetTarget(nextSkill)
      local inRange = nextSkill:IsTargetInRange(target)
      if inRange then
        self.unit.fsm:ChangeState(ZombieState.Attack, nextSkill, target)
      elseif target then
        self.unit.fsm:ChangeState(ZombieState.Run)
      else
        self.unit.fsm:ChangeState(ZombieState.Idle)
      end
    end
  end
  return self.unit.isAlert
end

function ZombieStateIdle:WalkAround()
  if self.unit.logic.GetPVEType and self.unit.logic:GetPVEType() == PVEType.LastStand then
    return
  end
  local pos = self.unit:GetPosition()
  local dir = Vector3.Normalize(Vector3.New(math.random(-10000, 10000), 0, math.random(-10000, 10000)))
  if (not self.unit.IsImprisoning or not self.unit:IsImprisoning()) and self.unit.agent then
    self.unit.agent.speed = 1
  end
  self.unit:PlaySimpleAnim(ZombieAnim.Walk, 1)
  self.unit:SetDestination(pos.x + dir.x * 2, pos.z + dir.z * 2)
end

return ZombieStateIdle
