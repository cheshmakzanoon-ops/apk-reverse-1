local DefenseRunState = BaseClass("DefenseRunState")
local ZombieCommonAI = require("Scene.LWBattle.AI.ZombieCommonAI")
local CHECK_TARGET_IN_RANGE_CD = 0.5

function DefenseRunState:Init(unit)
  self.unit = unit
  self.checkTargetInRangeCd = 0
  self.ai = ObjectPool:GetInstance():Load(ZombieCommonAI)
  self.ai:Init(self.unit)
end

function DefenseRunState:__delete()
  self.unit = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.unit = nil
  self.checkTargetInRangeCd = 0
  if self.ai then
    self.ai:Delete()
    ObjectPool:GetInstance():Save(self.ai)
    self.ai = nil
  end
  self.idleCd = 0
end

function DefenseRunState:OnEnter()
  local pos = self.unit:GetPosition()
  if self.unit.agent then
    self.unit.agent:SetCurPosition(pos.x, pos.z)
  end
  self.unit:PlaySimpleAnim(ZombieAnim.Run, 1)
  local posZ = self.unit.logic.team:GetPositionZ()
  self.targetPos = Vector3.New(pos.x, 0, posZ)
  self.unit:SetDestination(pos.x, posZ)
  if self.unit.agent and (not self.unit.IsImprisoning or not self.unit:IsImprisoning()) then
    if self.unit.GetMoveSpeedPercent then
      self.unit.agent.speed = self.unit.logic:GetMoveSpeedZ() * self.unit:GetMoveSpeedPercent()
    else
      self.unit.agent.speed = self.unit.logic:GetMoveSpeedZ()
    end
  end
  self.checkTargetInRangeCd = 0
  self.idleCd = 0
end

function DefenseRunState:OnExit()
  self.unit:StopAgent()
end

function DefenseRunState:OnUpdate(deltaTime)
  if self.checkTargetInRangeCd <= 0 then
    self.checkTargetInRangeCd = CHECK_TARGET_IN_RANGE_CD
    local freezeXAxisMoveMinDistance = self.unit:GetFreezeXAxisMoveMinDistance()
    if freezeXAxisMoveMinDistance then
      if not self.unit.isAlert then
        local alert = self:CheckTargetInSightOnly()
        if alert and (not self.unit.IsImprisoning or not self.unit:IsImprisoning() and self.unit.agent) then
          if self.unit.GetMoveSpeedPercent then
            self.unit.agent.speed = self.unit.meta.move_speed * self.unit:GetMoveSpeedPercent()
          else
            self.unit.agent.speed = self.unit.meta.move_speed
          end
        end
      end
      local pos = self.unit:GetPosition()
      local deltaZ = pos.z - self.targetPos.z
      if freezeXAxisMoveMinDistance < deltaZ then
        return
      end
    end
    if self:CheckTargetInSight() then
      return
    end
  else
    self.checkTargetInRangeCd = self.checkTargetInRangeCd - deltaTime
  end
end

function DefenseRunState:CheckTargetInSight()
  if not self.unit.isAlert then
    self.unit.isAlert = self.unit:CheckEnemyInAlertRange()
  end
  if self.unit.isAlert then
    local nextSkill = self.unit.skillManager:GetActiveSkillIgnoreRange()
    if nextSkill then
      local target = self.ai:GetTargetTauntFirst(nextSkill)
      local inRange = nextSkill:IsTargetInRange(target)
      if inRange then
        if nextSkill:IsBuffSkill() then
          if 0 < #target then
            local firstTarget = target[1]
            local firstTargetGuid = firstTarget:GetGuid()
            if firstTargetGuid ~= self.unit:GetGuid() then
              local targetPos = firstTarget:GetPosition()
              self.unit:SetDestination(targetPos.x, targetPos.z)
            end
          end
        elseif target.GetPosition then
          local targetPos = target:GetPosition()
          self.unit:SetDestination(targetPos.x, targetPos.z)
        end
        self.unit.fsm:ChangeState(ZombieState.Attack, nextSkill, target)
      elseif target then
        self.unit.fsm:ChangeState(ZombieState.Run)
      else
        self.unit.fsm:ChangeState(ZombieState.Run)
      end
    end
  end
  return self.unit.isAlert
end

function DefenseRunState:CheckTargetInSightOnly()
  if not self.unit.isAlert then
    self.unit.isAlert = self.unit:CheckEnemyInAlertRange()
  end
  return self.unit.isAlert
end

return DefenseRunState
