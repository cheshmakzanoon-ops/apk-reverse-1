local CarIdleState = BaseClass("CarIdleState")
local Time = _ENV.Time
local CHECK_TARGET_IN_RANGE_CD = 0.5
local ZombieCommonAI = require("Scene.LWBattle.AI.ZombieCommonAI")

function CarIdleState:__init(unit)
  self.unit = unit
  self.ai = ObjectPool:GetInstance():Load(ZombieCommonAI)
  self.ai:Init(self.unit)
end

function CarIdleState:__delete()
  self.unit = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.ai then
    self.ai:Delete()
    ObjectPool:GetInstance():Save(self.ai)
    self.ai = nil
  end
end

function CarIdleState:OnEnter()
  local pos = self.unit:GetPosition()
  self.unit.agent:SetCurPosition(pos.x, pos.z)
  self.unit:PlaySimpleAnim(ZombieAnim.Run, 1)
  local curPos = self.unit:GetPosition()
  local posZ = self.unit.logic.team:GetPositionZ()
  self.unit:SetDestination(curPos.x, posZ - 100)
  if not self.unit.IsImprisoning or not self.unit:IsImprisoning() then
    self.unit.agent.speed = self.unit.meta.move_speed * (1 + self.unit:GetProperty(HeroEffectDefine.BattleHeroMoveSpeed))
  end
end

function CarIdleState:OnExit()
  self.unit:RemoveDestination()
end

function CarIdleState:OnUpdate()
  self:CheckCastSkill()
end

function CarIdleState:CheckCastSkill()
  if self.unit.skillManager:GetCastingSkill() then
    return
  end
  local skill, preTarget = self.unit.skillManager:GetActiveSkill(true)
  if skill then
    if skill:IsBuffSkill() then
      self.unit.skillManager:ActiveCast(skill, skill:SearchTarget())
    else
      local target = self.ai:GetTarget(skill, preTarget)
      if target then
        self.unit.skillManager:ActiveCast(skill, target)
      end
    end
  end
end

return CarIdleState
