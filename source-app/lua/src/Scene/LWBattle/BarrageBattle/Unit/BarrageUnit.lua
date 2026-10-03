local base = require("Scene.LWBattle.UnitBase")
local BarrageUnit = BaseClass("BarrageUnit", base)
local SkillManager = require("Scene.LWBattle.Skill.SkillManager")

function BarrageUnit:Init(battleMgr, guid, meta)
  base.Init(self, battleMgr, guid, meta)
  self.battleMgr = battleMgr
  self.guid = guid
  self.unitType = nil
  self.searchType = nil
  self.meta = meta
  self.isVisible = true
  self.skillManager = SkillManager.New(self.battleMgr, self)
end

function BarrageUnit:DestroyView()
  base.DestroyView(self)
  if self.skillManager then
    self.skillManager:DestroyView()
  end
end

function BarrageUnit:DestroyData()
  base.DestroyData(self)
  if self.skillManager then
    self.skillManager:DestroyData()
    self.skillManager = nil
  end
  self.battleMgr = nil
end

function BarrageUnit:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
  if self.skillManager then
    self.skillManager:OnUpdate(deltaTime)
  end
end

function BarrageUnit:TriggerSkill(triggerType, param)
  if self.skillManager then
    self.skillManager:PassiveCast(triggerType, param)
  end
end

function BarrageUnit:SetVisible(visible)
  self.isVisible = visible
  if self.gameObject then
    self.gameObject:SetActive(visible)
  end
end

function BarrageUnit:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
  base.BeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
  hurt = self:ReduceShieldValue(hurt)
  self.curBlood = math.max(self.curBlood - hurt, 0)
  if self.curBlood <= 0 then
    self:TriggerSkill(SkillTriggerType.Death)
  end
end

function BarrageUnit:GetTeamZeroWorldPos()
  if self.squad then
    return self.squad:GetZeroWorldPos()
  end
  return Vector3.zero
end

return BarrageUnit
