local ZombieCommonAI = require("Scene.LWBattle.AI.ZombieCommonAI")
local ParkourMonsterRunState = BaseClass("ParkourMonsterRunState")
local CHECK_TARGET_IN_RANGE_CD = 0.5

function ParkourMonsterRunState:Init(unit)
  self.unit = unit
  self.ai = ObjectPool:GetInstance():Load(ZombieCommonAI)
  self.ai:Init(self.unit)
  self.checkTargetInRangeCd = 0
  self.tauntVersion = 0
end

function ParkourMonsterRunState:__delete()
  if self.envSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.envSoundHandle)
    self.envSoundHandle = nil
  end
  if self.ai then
    self.ai:Delete()
    ObjectPool:GetInstance():Save(self.ai)
    self.ai = nil
  end
  self.unit = nil
  self.checkTargetInRangeCd = 0
  self.nextSkill = nil
  self.target = nil
end

function ParkourMonsterRunState:OnEnter()
  local pos = self.unit:GetPosition()
  self.unit.agent:SetCurPosition(pos.x, pos.z)
  if not self.unit.IsImprisoning or not self.unit:IsImprisoning() then
    if self.unit.GetMoveSpeedPercent then
      self.unit.agent.speed = self.unit.meta.move_speed * self.unit:GetMoveSpeedPercent()
    else
      self.unit.agent.speed = self.unit.meta.move_speed
    end
  end
  if self.unit:IsSpecialMoving() then
    self.unit:SetStealth(true)
    self.unit:PlaySimpleAnim(AnimName.SpecialMove, 1)
  else
    self.unit:PlaySimpleAnim(AnimName.Run, 1)
  end
  self.checkTargetInRangeCd = 0
  if not self.envSoundHandle and self.unit.meta.is_boss == 1 and self.unit.logic:GetPVEType() == PVEType.Parkour then
    self.envSoundHandle = DataCenter.LWSoundManager:PlaySound(10035, true, true)
    DataCenter.LWSoundManager:PlaySoundWithLimit(10034, SoundLimitType.BossWarning)
  else
    DataCenter.LWSoundManager:ResumeSound(self.envSoundHandle)
  end
end

function ParkourMonsterRunState:OnExit()
  if self.unit:IsSpecialMoving() then
    self.unit:RemoveAllBuffByType(BuffType.SpecialMove)
    self.unit:SetStealth(false)
  end
  self.nextSkill = nil
  self.target = nil
  self.unit:StopAgent()
  if self.envSoundHandle then
    DataCenter.LWSoundManager:PauseSound(self.envSoundHandle)
  end
end

function ParkourMonsterRunState:OnUpdate(deltaTime)
  if not self.nextSkill then
    self.nextSkill = self.unit.skillManager:GetActiveSkillIgnoreRange()
    return
  end
  if self.unit.logic:GetPVEType() == PVEType.LastStand then
    self.target = self.ai:GetTarget(self.nextSkill)
    if not self.target then
      return
    end
  else
    local tauntChanged, tauntVersion = self.unit.logic:CheckGlobalTauntUnit(self.tauntVersion)
    self.tauntVersion = tauntVersion
    if not self.target or tauntChanged then
      self.target = self.ai:GetTargetTauntFirst(self.nextSkill)
      return
    end
  end
  if self.nextSkill:IsBuffSkill() then
    if #self.target <= 0 then
      self.target = self.ai:GetTarget(self.nextSkill)
      return
    end
    for _, tar in pairs(self.target) do
      if 0 >= tar:GetCurBlood() then
        self.target = self.ai:GetTarget(self.nextSkill)
        return
      end
    end
  elseif 0 >= self.target:GetCurBlood() and not self.target.isSearchPoint then
    self.target = self.ai:GetTargetTauntFirst(self.nextSkill)
    return
  end
  if 0 >= self.checkTargetInRangeCd then
    self.checkTargetInRangeCd = CHECK_TARGET_IN_RANGE_CD
    local inRange = self.nextSkill:IsTargetInRange(self.target)
    if inRange then
      self.unit.fsm:ChangeState(ZombieState.Attack, self.nextSkill, self.target)
    else
      local selfPosition = self.unit:GetPosition()
      local targetPos = selfPosition
      if self.nextSkill:IsBuffSkill() then
        targetPos = self.target[1]:GetPosition()
      else
        targetPos = self.target:GetPosition()
      end
      self.unit:SetDestination(targetPos.x, targetPos.z)
    end
  else
    self.checkTargetInRangeCd = self.checkTargetInRangeCd - deltaTime
  end
end

return ParkourMonsterRunState
