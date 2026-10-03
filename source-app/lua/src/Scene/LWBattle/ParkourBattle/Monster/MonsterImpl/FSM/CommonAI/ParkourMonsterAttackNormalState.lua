local ZombieCommonAI = require("Scene.LWBattle.AI.ZombieCommonAI")
local ParkourMonsterAttackNormalState = BaseClass("ParkourMonsterAttackNormalState")

function ParkourMonsterAttackNormalState:Init(unit)
  self.unit = unit
  self.ai = ObjectPool:GetInstance():Load(ZombieCommonAI)
  self.ai:Init(self.unit)
end

function ParkourMonsterAttackNormalState:__delete()
  self.unit = nil
  if self.ai then
    self.ai:Delete()
    ObjectPool:GetInstance():Save(self.ai)
    self.ai = nil
  end
  self.nextSkill = nil
  self.target = nil
end

function ParkourMonsterAttackNormalState:OnEnter(skill, target)
  self:CheckDirection(target)
  self.unit.skillManager:ActiveCast(skill, target)
end

function ParkourMonsterAttackNormalState:OnExit()
  self.unit.skillManager:Interrupt()
  self.nextSkill = nil
  self.target = nil
end

function ParkourMonsterAttackNormalState:OnUpdate(deltaTime)
  if not self.unit.skillManager:GetCastingSkill() then
    if self.unit:GetCurAnimName() ~= AnimName.Aim then
      self.unit:PlaySimpleAnim(AnimName.Aim)
    end
    if self.nextSkill then
      if self.target and self.target:GetCurBlood() > 0 then
        if self.nextSkill:IsTargetInRange(self.target) then
          self:CheckDirection(self.target)
          self.unit.skillManager:ActiveCast(self.nextSkill, self.target)
          self.nextSkill = nil
        else
          self.unit.fsm:ChangeState(ZombieState.Run)
        end
      else
        self.target = self.ai:GetTargetTauntFirst(self.nextSkill)
      end
    else
      self.nextSkill = self.unit.skillManager:GetActiveSkillIgnoreRange()
      if self.nextSkill then
        if self.nextSkill:IsBuffSkill() then
          self.unit.skillManager:ActiveCast(self.nextSkill, self.ai:GetTarget(self.nextSkill))
          self.nextSkill = nil
        else
          self.target = self.ai:GetTargetTauntFirst(self.nextSkill)
        end
      end
    end
  end
end

function ParkourMonsterAttackNormalState:CheckDirection(target)
  if not target or not target.GetPosition then
    return
  end
  if self.unit == target then
    return true
  end
  PveUtil.DirectLookAtTarget(self.unit, target:GetPosition())
end

return ParkourMonsterAttackNormalState
