local SkillManager = BaseClass("SkillManager")
local Skill = require("Scene.LWBattle.Skill.Skill")

function SkillManager:__init(logic, owner)
  self.battleMgr = logic
  self.owner = owner
  self.castingActiveSkill = nil
  self.skills = {}
  self.metaId2skills = {}
  self.activeSkills = {}
  self.haloSkills = {}
  self.passiveSkillsByCondition = {}
  self.ultimateSkill = nil
  self.toDeleteSkills = nil
  self.skillCount = 0
  self.specialStraightBulletType = false
end

function SkillManager:__delete()
  self:DestroyView()
  self:DestroyData()
end

function SkillManager:DestroyView()
  self:Interrupt()
  self.toDeleteSkills = {}
  for _, skill in pairs(self.skills) do
    table.insert(self.toDeleteSkills, skill)
  end
  self.skillCount = 0
end

function SkillManager:DestroyData()
  if self.toDeleteSkills then
    for _, skill in pairs(self.toDeleteSkills) do
      skill:Destroy()
      ObjectPool:GetInstance():Save(skill)
    end
  end
  self.skills = {}
  self.metaId2skills = {}
  self.activeSkills = {}
  self.haloSkills = {}
  self.passiveSkillsByCondition = {}
  self.ultimateSkill = nil
  self.toDeleteSkills = nil
  self.battleMgr = nil
  self.owner = nil
  self.castingActiveSkill = nil
  self.haloCD = nil
  self.skillCount = 0
  self.specialStraightBulletType = false
end

function SkillManager:AddSkill(skillMeta, skillInfo, isUltimate, isWorldTroopEffect)
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
  if isWorldTroopEffect == true then
    newSkill:SwitchToWorldTroopEffect()
  end
  table.insert(self.skills, newSkill)
  self.skillCount = #self.skills
  self.metaId2skills[meta.id] = newSkill
  if isUltimate then
    self.ultimateSkill = newSkill
  elseif meta.apType == SkillAPType.Active then
    self:AddActiveSkill(meta, newSkill)
  elseif meta.actionType == SkillActionType.Halo then
    self:AddHaloSkill(meta, newSkill)
  else
    self:AddPassiveSkill(meta, newSkill)
  end
  return newSkill
end

function SkillManager:PrepareCastUltimate()
  if self.ultimateSkill and self.ultimateSkill.cd <= 0 then
    self:Interrupt()
    return self.ultimateSkill
  end
  return nil
end

function SkillManager:CheckUltimate()
  if self.ultimateSkill and self.ultimateSkill.cd <= 0 and self.ultimateSkill:CheckCondition() then
    return self.ultimateSkill
  end
  return nil
end

function SkillManager:GetUltimateTimeStopDuration()
  if self.ultimateSkill then
    return self.ultimateSkill.meta.time_stop_duration > 0 and self.ultimateSkill.meta.time_stop_duration or TIME_STOP_DURATION
  end
  return 0
end

function SkillManager:ActiveCast(skill, target)
  self.castingActiveSkill = skill
  skill:Cast(target)
  if skill and skill.meta and skill.meta:IsHeroAwakenSkill() then
    EventManager:GetInstance():Broadcast(EventId.OnPVECastHeroAwakenSkill, {
      skill = skill,
      unit = self.owner
    })
  end
end

function SkillManager:PassiveCast(triggerType, param)
  if self.passiveSkillsByCondition[triggerType] then
    for _, skill in pairs(self.passiveSkillsByCondition[triggerType]) do
      if skill.cd <= 0 and skill:CheckTriggerParam(triggerType, param) then
        skill:Cast()
      end
    end
  end
end

function SkillManager:Interrupt()
  if self.castingActiveSkill then
    self.castingActiveSkill:Interrupt()
    self.castingActiveSkill = nil
  end
end

function SkillManager:GetUltimateSkill()
  return self.ultimateSkill
end

function SkillManager:GetAllActiveSkills()
  return self.activeSkills
end

function SkillManager:GetCastingSkill()
  return self.castingActiveSkill
end

function SkillManager:GetActiveSkillIgnoreRange()
  if self.castingActiveSkill then
    return nil
  end
  for _, skill in ipairs(self.activeSkills) do
    if skill.cd <= 0 then
      return skill
    end
  end
  return nil
end

function SkillManager:GetActiveSkillIgnoreRangeLimit(limit)
  if self.castingActiveSkill then
    return nil
  end
  if limit == nil then
    return nil
  end
  for _, metaId in ipairs(limit) do
    local skill = self:GetSkillById(metaId)
    if skill and skill:IsActiveSkill() and skill.cd <= 0 then
      return skill
    end
  end
  return nil
end

function SkillManager:GetFirstActiveSkill()
  local skills = self.activeSkills
  if skills ~= nil and 0 < #skills then
    return skills[1]
  end
  return nil
end

function SkillManager:GetActiveSkill()
  if self.castingActiveSkill then
    return nil
  end
  for _, skill in ipairs(self.activeSkills) do
    if skill.cd <= 0 then
      local target = skill:CheckCondition()
      if target then
        if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
          return skill, target
        else
          return skill
        end
      end
    end
  end
  return nil
end

function SkillManager:GetActiveSkillWithTarget(target)
  if self.castingActiveSkill then
    return nil
  end
  for _, skill in ipairs(self.activeSkills) do
    if skill.cd <= 0 and skill:CheckConditionWithTarget(target) then
      return skill
    end
  end
  return nil
end

function SkillManager:RemoveAllSkills()
  self:Interrupt()
  self.skills = {}
  self.metaId2skills = {}
  self.activeSkills = {}
  self.passiveSkillsByCondition = {}
  self.ultimateSkill = nil
  self.haloSkills = {}
  self.toDeleteSkills = nil
  self.skillCount = 0
  self.specialStraightBulletType = false
end

function SkillManager:HasSkill(skillId)
  return self.metaId2skills[skillId]
end

function SkillManager:GetSkillById(skillId)
  return self.metaId2skills[skillId]
end

function SkillManager:ResetCooldown(skill)
  skill:ResetCooldown()
end

function SkillManager:ReduceCooldown(skill, reduceValue)
  if not skill then
    return 0
  end
  return skill:ReduceCooldown(reduceValue)
end

function SkillManager:SetUnlock(skill)
  skill.lock = false
end

function SkillManager:HaloCastAll()
  for _, skill in pairs(self.haloSkills) do
    skill:Cast()
  end
end

function SkillManager:OnUpdate(deltaTime)
  if deltaTime == nil then
    deltaTime = Time.deltaTime
    Logger.LogError("SkillManager Need deltaTime !")
  end
  for i = 1, self.skillCount do
    self.skills[i]:OnUpdate(deltaTime)
  end
end

function SkillManager:AddHaloSkill(meta, newSkill)
  self.haloCD = 0
  table.insert(self.haloSkills, newSkill)
  newSkill:Cast()
end

function SkillManager:AddActiveSkill(meta, newSkill)
  for i, skill in ipairs(self.activeSkills) do
    if meta.priority > skill.meta.priority then
      table.insert(self.activeSkills, i, newSkill)
      return
    end
  end
  table.insert(self.activeSkills, newSkill)
end

function SkillManager:AddPassiveSkill(meta, newSkill)
  if not self.passiveSkillsByCondition[meta.triggerType] then
    self.passiveSkillsByCondition[meta.triggerType] = {}
  end
  table.insert(self.passiveSkillsByCondition[meta.triggerType], newSkill)
end

function SkillManager:ReplaceNormalAttack(skillMeta, skillInfo)
  local skills = self.activeSkills
  if skills == nil then
    return false
  end
  if #skills == 0 then
    return false
  end
  local normalAttackSkill
  local normalAttackSkillIndex = 0
  for i, skill in ipairs(self.activeSkills) do
    if skill.meta:IsNormalAttack() then
      normalAttackSkill = skill
      normalAttackSkillIndex = i
      break
    end
  end
  if normalAttackSkillIndex == 0 or normalAttackSkill == nil then
    return false
  end
  table.remove(self.activeSkills, normalAttackSkillIndex)
  table.removebyvalue(self.skills, normalAttackSkill)
  self.skillCount = #self.skills
  self.metaId2skills[normalAttackSkill.meta.id] = nil
  if self.ultimateSkill == normalAttackSkill then
    self.ultimateSkill = nil
  end
  if normalAttackSkill == self.castingActiveSkill then
    self:Interrupt()
  end
  self:AddSkill(skillMeta, skillInfo)
  return true
end

function SkillManager:ReplaceActiveAttack(skillMeta, skillInfo, isUltimate)
  local activeSkill
  local activeSkillIndex = 0
  for i, skill in ipairs(self.activeSkills) do
    local isNormalAttack = skill.meta:IsNormalAttack()
    if not isNormalAttack and skill.meta:IsUltimateSkill() then
      activeSkill = skill
      activeSkillIndex = i
      break
    end
  end
  if activeSkillIndex == 0 or activeSkill == nil then
    return false
  end
  if activeSkill == self.castingActiveSkill then
    self:Interrupt()
  end
  table.remove(self.activeSkills, activeSkillIndex)
  table.removebyvalue(self.skills, activeSkill)
  self.skillCount = #self.skills
  self.metaId2skills[activeSkill.meta.id] = nil
  if self.ultimateSkill == activeSkill then
    self.ultimateSkill = nil
  end
  local newSkill = self:AddSkill(skillMeta, skillInfo, isUltimate)
  if newSkill and newSkill.slotIndex == 0 then
    newSkill.slotIndex = ULTIMATE_SKILL_SLOT_INDEX
  end
  return newSkill ~= nil
end

function SkillManager:ReplaceNormalBullet(bulletId)
  local skills = self.activeSkills
  if skills == nil then
    return false
  end
  if #skills == 0 then
    return false
  end
  for _, skill in ipairs(self.activeSkills) do
    local isNormalAttack = skill.meta:IsNormalAttack()
    if isNormalAttack then
      if skill == self.castingActiveSkill then
        self:Interrupt()
      end
      skill:ReplaceBullet(bulletId)
      return true
    end
  end
  return false
end

function SkillManager:ReplaceActiveBullet(bulletId)
  local skills = self.activeSkills
  if skills == nil then
    return false
  end
  if #skills == 0 then
    return false
  end
  for _, skill in ipairs(self.activeSkills) do
    local isNormalAttack = skill.meta:IsNormalAttack()
    if not isNormalAttack then
      if skill == self.castingActiveSkill then
        self:Interrupt()
      end
      skill:ReplaceBullet(bulletId)
    end
  end
  return true
end

function SkillManager:GetAllSkills()
  return self.skills
end

function SkillManager:IsSpecialStraightBulletType()
  return self.specialStraightBulletType
end

function SkillManager:CheckSpecialStraightBulletType()
  local total = 0
  local valid = 0
  for _, v in ipairs(self.activeSkills) do
    total = total + 1
    if v:IsSpecialStraightBulletType() then
      valid = valid + 1
    end
  end
  self.specialStraightBulletType = 0 < total and valid == total
end

return SkillManager
