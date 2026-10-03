local base = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.ColliderMonsterBase")
local ColliderWithSkillMonster = BaseClass("ColliderWithSkillMonster", base)
local SkillManager = require("Scene.LWBattle.Skill.SkillManager")
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")

function ColliderWithSkillMonster:Init(logic, mgr, guid, x, y, monsterMeta)
  base.Init(self, logic, mgr, guid, x, y, monsterMeta)
  self.skillManager = SkillManager.New(self.logic, self)
  self.useHpText = monsterMeta.is_hp_text == 1
  self.bloodDirty = false
end

function ColliderWithSkillMonster:OnLoadComplete()
  base.OnLoadComplete(self)
  if self.useHpText then
    pveUnitViewUtil.InitHpText(self.viewHandle, math.ceil(self.curBlood))
  elseif self.monsterMeta.hp_bar_num > 0 then
    self.hpBarHandle = pveUnitViewUtil.CreateEnemyHpBarWithHandle(self.viewHandle, self.monsterMeta.hp_bar_height * 1.0, nil, self.curBlood, self.maxBlood, nil)
  end
  self:InitSkills()
end

function ColliderWithSkillMonster:InitSkills()
  if self.monsterMeta.skill then
    for _, skillId in pairs(self.monsterMeta.skill) do
      local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
      if skillMeta == nil then
        Logger.LogError("\230\138\128\232\131\189\232\161\168\228\184\173\230\178\161\230\156\137id\228\184\186" .. skillId .. "\231\154\132\230\138\128\232\131\189")
      end
      self.skillManager:AddSkill(skillMeta)
    end
  end
end

function ColliderWithSkillMonster:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, dir)
  base.BeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, dir)
  if self.useHpText then
    if hurt ~= 0 then
      self.bloodDirty = true
    end
  elseif 0 < self.curBlood and self.hpBarHandle then
    pveUnitViewUtil.SetHpBar(self.hpBarHandle, self.curBlood, self.maxBlood, self:GetShieldValue())
  end
end

function ColliderWithSkillMonster:Death()
  if self.curBlood <= 0 then
    self:TriggerSkill(SkillTriggerType.Death)
  end
  base.Death(self)
end

function ColliderWithSkillMonster:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
  if self.useHpText and self.bloodDirty then
    self.bloodDirty = false
    pveUnitViewUtil.SetNumberHpText(self.viewHandle, math.ceil(self.curBlood))
  end
  if self.skillManager then
    self.skillManager:OnUpdate(deltaTime)
  end
end

function ColliderWithSkillMonster:GetFirePointById(id)
  return self:GetFirePoint()
end

function ColliderWithSkillMonster:GetFirePoint()
  return self.transform, false
end

function ColliderWithSkillMonster:TriggerSkill(triggerType, param)
  if self.skillManager then
    self.skillManager:PassiveCast(triggerType, param)
  end
end

function ColliderWithSkillMonster:DestroyView()
  if self.useHpText then
    pveUnitViewUtil.NumberHpTextActive(self.viewHandle, false)
  end
  base.DestroyView(self)
  if self.hpBarHandle then
    pveUnitViewUtil.DestroyHpBar(self.hpBarHandle)
    self.hpBarHandle = nil
  end
  if self.skillManager then
    self.skillManager:DestroyView()
  end
end

function ColliderWithSkillMonster:DestroyData()
  base.DestroyData(self)
  if self.skillManager then
    self.skillManager:DestroyData()
    ObjectPool:GetInstance():Save(self.skillManager)
    self.skillManager = nil
  end
  self.useHpText = nil
  self.bloodDirty = nil
end

return ColliderWithSkillMonster
