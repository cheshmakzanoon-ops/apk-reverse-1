local MasteryData = BaseClass("MasteryData")
local MasteryPlanData = require("DataCenter.Mastery.MasteryPlanData")
local SkillChargeData = require("DataCenter.Mastery.SkillChargeData")

function MasteryData:__init()
  self.home_id = 0
  self.plans = {}
  self.planIndex = 0
  self.level = 0
  self.skillChargeDatas = {}
  self.exp = 0
  self.needExp = 0
  self.totalPoint = 0
  self.saveExp = 0
  self.seasonItemCount = {}
  self.newDesertTalentTemplates = {}
end

function MasteryData:__delete()
  for _, v in pairs(self.plans) do
    v:Delete()
  end
  self.plans = {}
  for _, v in pairs(self.skillChargeDatas) do
    v:Delete()
  end
  self.skillChargeDatas = {}
  self.seasonItemCount = {}
  self.newDesertTalentTemplates = {}
end

function MasteryData:ParseServerData(serverData)
  if serverData.exp then
    self.exp = serverData.exp
  end
  if serverData.needExp then
    self.needExp = serverData.needExp
  end
  if serverData.level then
    self.level = serverData.level
  end
  if serverData.totalTalentPoint then
    self.totalPoint = serverData.totalTalentPoint
  end
  if serverData.saveExp then
    self.saveExp = serverData.saveExp
  end
  if serverData.seasonItemCount then
    self.seasonItemCount = serverData.seasonItemCount
  end
  if serverData.newDesertTalentPages then
    self.plans = {}
    for _, v in ipairs(serverData.newDesertTalentPages) do
      local plan = MasteryPlanData.New()
      plan:ParseServerData(v)
      self.plans[plan.index] = plan
    end
    self.needExp = serverData.needExp
  end
  if serverData.newDesertTalentTemplates then
    self.newDesertTalentTemplates = serverData.newDesertTalentTemplates
  end
  if serverData.usePage then
    self.planIndex = serverData.usePage
  end
  if serverData.talentSkill then
    for _, v in ipairs(serverData.talentSkill) do
      self:SetSkillCdAndEffectTime(v)
    end
  end
  if serverData.homeId then
    self.home_id = serverData.homeId
  end
  if serverData.newbieRewardStatus then
    self.newbieRewardStatus = serverData.newbieRewardStatus
  end
end

function MasteryData:GetHomeExpAddMsgHandle(message)
  local exp = message.exp
  local lv = message.level
  local canUse = message.talentPoint
  if exp then
    self.exp = exp
  end
  if lv then
    self.level = lv
  end
  if message.totalTalentPoint then
    self.totalPoint = message.totalTalentPoint
  end
  if message.saveExp then
    self.saveExp = message.saveExp
  end
  if message.seasonItemCount then
    self.seasonItemCount = message.seasonItemCount
  end
  if canUse then
    self:SetCurPlanIdlePoint(canUse)
  end
end

function MasteryData:GetPlan(index)
  if self.plans[index] == nil then
    self.plans[index] = MasteryPlanData.New()
  end
  return self.plans[index]
end

function MasteryData:GetCurPlan()
  return self:GetPlan(self.planIndex)
end

function MasteryData:CleanSkillCdAndEffectTime()
  for _, v in pairs(self.skillChargeDatas) do
    v:Delete()
  end
  self.skillChargeDatas = {}
end

function MasteryData:SetSkillCdAndEffectTime(msg)
  if msg.recover then
    local skillId = tonumber(msg.skillId)
    if skillId ~= nil then
      self.skillChargeDatas[skillId] = SkillChargeData.New(msg.recover)
    end
  end
end

function MasteryData:GetStorageSkillCount(skillId)
  if not skillId then
    return 0, 0
  end
  skillId = tonumber(skillId)
  local data = self.skillChargeDatas[skillId]
  if not data then
    return 0, 0
  end
  return data:GetCurAndMaxCount()
end

function MasteryData:GetSkillAvailableTime(skillId)
  skillId = tonumber(skillId)
  local data = self.skillChargeDatas[skillId]
  if not data then
    return 0
  end
  return data:GetAvailableTime()
end

function MasteryData:GetSkillEffectTime(skillId)
  skillId = tonumber(skillId)
  local data = self.skillChargeDatas[skillId]
  if not data then
    return 0
  end
  local lastUse = data:GetLastUseTime()
  local skillTemp = DataCenter.MasteryManager:GetSkillTemplate(skillId)
  if skillTemp and 0 < skillTemp.duration and not data:IsRealChargeSkill() then
    return lastUse + skillTemp.duration * 60000
  end
  return 0
end

function MasteryData:GetSkillChargeData(skillId)
  return self.skillChargeDatas[skillId]
end

function MasteryData:GetAllSkillChargeData()
  return self.skillChargeDatas
end

function MasteryData:GetCurLvByMasteryId(groupId)
  local lv = 0
  local data = self:GetCurPlan()
  if data then
    lv = data:GetGroupLevel(groupId)
  end
  return lv
end

function MasteryData:GetCurPlanIdlePoint()
  local idlePoint = 0
  local data = self:GetCurPlan()
  if data then
    idlePoint = data.restPoint
  end
  return idlePoint
end

function MasteryData:SetCurPlanIdlePoint(point)
  local data = self:GetCurPlan()
  if data then
    data.restPoint = point
  end
end

return MasteryData
