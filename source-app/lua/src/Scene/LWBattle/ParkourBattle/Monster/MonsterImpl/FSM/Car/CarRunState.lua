local CarRunState = BaseClass("CarRunState")
local ZombieCommonAI = require("Scene.LWBattle.AI.ZombieCommonAI")
local CHECK_TARGET_IN_RANGE_CD = 0.5

function CarRunState:Init(unit)
  self.unit = unit
  self.ai = ObjectPool:GetInstance():Load(ZombieCommonAI)
  self.ai:Init(self.unit)
  self.checkTargetInRangeCd = 0
end

function CarRunState:__delete()
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

function CarRunState:OnEnter()
  local pos = self.unit:GetPosition()
  self.unit.agent:SetCurPosition(pos.x, pos.z)
  if self.unit:IsSpecialMoving() then
    self.unit:SetStealth(true)
    self.unit:PlaySimpleAnim(AnimName.SpecialMove, 1)
  else
    self.unit:PlaySimpleAnim(AnimName.Run, 1)
  end
  self.checkTargetInRangeCd = 0
end

function CarRunState:OnExit()
  if self.unit:IsSpecialMoving() then
    self.unit:RemoveAllBuffByType(BuffType.SpecialMove)
    self.unit:SetStealth(false)
  end
  self.nextSkill = nil
  self.target = nil
  self.unit:RemoveDestination()
end

function CarRunState:OnUpdate(deltaTime)
  if not self.nextSkill then
    self.nextSkill = self.unit.skillManager:GetActiveSkillIgnoreRange()
    return
  end
  if not self.target then
    self.target = self.ai:GetTarget(self.nextSkill)
    return
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
  elseif 0 >= self.target:GetCurBlood() then
    self.target = self.ai:GetTarget(self.nextSkill)
    return
  end
  if 0 >= self.checkTargetInRangeCd then
    self.checkTargetInRangeCd = CHECK_TARGET_IN_RANGE_CD
    local selfPosition = self.unit:GetPosition()
    local targetPos = selfPosition
    if self.nextSkill:IsBuffSkill() then
      targetPos = self.target[1]:GetPosition()
    else
      targetPos = self.target:GetPosition()
    end
    self.unit:SetDestination(targetPos.x, targetPos.z)
    local inRange = self.nextSkill:IsTargetInRange(self.target)
    if inRange then
      self.unit.skillManager:ActiveCast(self.nextSkill, self.target)
      self.nextSkill = nil
    end
  else
    self.checkTargetInRangeCd = self.checkTargetInRangeCd - deltaTime
  end
end

return CarRunState
