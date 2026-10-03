local SkillManagerPVP = BaseClass("SkillManagerPVP")
local Skill = require("Scene.LWBattle.PVP.SkillPVP")

function SkillManagerPVP:__init(logic, owner)
  self.battleMgr = logic
  self.owner = owner
  self.castingActiveSkill = nil
  self.skills = {}
  self.metaId2skills = {}
  self.activeSkills = {}
  self.ultimateSkill = nil
  self.heroAwakenSkill = nil
  self.toDeleteSkills = nil
  self.skillCount = 0
  self.specialStraightBulletType = false
end

function SkillManagerPVP:__delete()
  self:DestroyView()
  self:DestroyData()
end

function SkillManagerPVP:DestroyView()
  self:Interrupt()
  self.toDeleteSkills = {}
  for _, skill in pairs(self.skills) do
    table.insert(self.toDeleteSkills, skill)
  end
  self.skillCount = 0
end

function SkillManagerPVP:DestroyData()
  if self.toDeleteSkills then
    for _, skill in pairs(self.toDeleteSkills) do
      skill:Destroy()
      ObjectPool:GetInstance():Save(skill)
    end
  end
  self.skills = {}
  self.metaId2skills = {}
  self.activeSkills = {}
  self.ultimateSkill = nil
  self.heroAwakenSkill = nil
  self.toDeleteSkills = nil
  self.battleMgr = nil
  self.owner = nil
  self.castingActiveSkill = nil
  self.haloCD = nil
  self.skillCount = 0
  self.specialStraightBulletType = false
end

function SkillManagerPVP:AddSkill(skillMeta, skillInfo, isUltimate, isWorldTroopEffect)
  local meta = skillMeta
  if not meta then
    Logger.LogError("\230\183\187\229\138\160\230\138\128\232\131\189\230\151\182\239\188\140\230\138\128\232\131\189\233\133\141\231\189\174\230\137\190\228\184\141\229\136\176,\229\141\149\228\189\141\239\188\154" .. self.owner.gameObject.name .. ",\232\139\177\233\155\132/\230\128\170\231\137\169id:" .. self.owner.meta.id)
    return
  end
  if meta.triggerType == SkillTriggerType.IdleOutside or meta.triggerType == SkillTriggerType.AlwaysOutside then
    return
  end
  local newSkill = ObjectPool:GetInstance():Load(Skill)
  newSkill:Init(self.battleMgr, self, self.owner, meta, skillInfo, isUltimate)
  table.insert(self.skills, newSkill)
  self.metaId2skills[meta.id] = newSkill
  self.skillCount = #self.skills
  if isUltimate then
    self.ultimateSkill = newSkill
  end
  if newSkill:IsHeroAwakenSkill() and newSkill:IsTimePauseAwakenSkill() then
    self.heroAwakenSkill = newSkill
  end
  return newSkill
end

function SkillManagerPVP:ActiveCast(skill, target)
  self.castingActiveSkill = skill
  skill:Cast(target)
end

function SkillManagerPVP:GetCastingSkill()
  return self.castingActiveSkill
end

function SkillManagerPVP:Interrupt()
  if self.castingActiveSkill then
    self.castingActiveSkill:Interrupt()
    self.castingActiveSkill = nil
  end
end

function SkillManagerPVP:GetUltimateSkill()
  return self.ultimateSkill
end

function SkillManagerPVP:RemoveAllSkills()
  self:Interrupt()
  self.skills = {}
  self.metaId2skills = {}
  self.activeSkills = {}
  self.ultimateSkill = nil
  self.toDeleteSkills = nil
  self.skillCount = 0
  self.specialStraightBulletType = false
end

function SkillManagerPVP:HasSkill(skillId)
  return self.metaId2skills[skillId]
end

function SkillManagerPVP:GetSkillById(skillId)
  return self.metaId2skills[skillId]
end

function SkillManagerPVP:ResetCooldown(skill)
  skill:ResetCooldown()
end

function SkillManagerPVP:ReduceCooldown(skill, reduceValue)
  if not skill then
    return 0
  end
  return skill:ReduceCooldown(reduceValue)
end

function SkillManagerPVP:OnUpdate(deltaTime)
  if deltaTime == nil then
    deltaTime = Time.deltaTime
    Logger.LogError("SkillManagerPVP Need deltaTime !")
  end
  for i = 1, self.skillCount do
    self.skills[i]:OnUpdate(deltaTime)
  end
end

function SkillManagerPVP:AddActiveSkill(meta, newSkill)
  for i, skill in ipairs(self.activeSkills) do
    if meta.priority > skill.meta.priority then
      table.insert(self.activeSkills, i, newSkill)
      return
    end
  end
  table.insert(self.activeSkills, newSkill)
end

function SkillManagerPVP:GetAllSkills()
  return self.skills
end

function SkillManagerPVP:GetHeroAwakenSkill()
  return self.heroAwakenSkill
end

return SkillManagerPVP
