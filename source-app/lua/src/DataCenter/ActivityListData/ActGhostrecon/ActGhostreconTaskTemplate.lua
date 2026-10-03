local ActGhostreconTaskTemplate = BaseClass("ActGhostreconTaskTemplate")
local ActGhostreconTaskConditionTemplate = require("DataCenter.ActivityListData.ActGhostrecon.ActGhostreconTaskConditionTemplate")
local ActGhostreconTaskSuperConditionTemplate = require("DataCenter.ActivityListData.ActGhostrecon.ActGhostreconTaskSuperConditionTemplate")

local function __init(self)
  self.id = 0
  self.nameId = ""
  self.descId = ""
  self.iconPath = ""
  self.modelPath = ""
  self.modelSize = 3
  self.color = GhostreconQuality.Purple
  self.special = false
  self.level = 1
  self.worldOpen = true
  self.showTime = 600000
  self.level = 1
  self.protectTime = 0
  self.conditions = {}
  self.time = 0
  self.stealMaxtimes = 3
  self.reward = {}
  self.superCondions = {}
  self.supreRewardDetail = 0
  self.imgSet = GhostreconQualitySetting[GhostreconQuality.Purple]
  self.supreRewardIcon = ""
end

local function __delete(self)
  self.id = nil
  self.nameId = nil
  self.descId = nil
  self.iconPath = nil
  self.modelPath = nil
  self.modelSize = nil
  self.color = nil
  self.special = nil
  self.level = nil
  self.worldOpen = nil
  self.showTime = nil
  self.level = nil
  self.protectTime = nil
  self.conditions = nil
  self.time = nil
  self.stealMaxtimes = nil
  self.reward = nil
  self.superCondions = nil
  self.supreRewardDetail = nil
  self.imgSet = nil
  self.supreRewardIcon = nil
end

local function InitData(self, cfg)
  if cfg == nil then
    return
  end
  self.id = cfg.id
  self.nameId = cfg.name
  self.descId = cfg.desc
  self.iconPath = cfg.icon
  self.modelPath = cfg.model_name
  self.modelSize = cfg.model_size
  self.special = cfg.is_special == 1
  local color = cfg.color
  if color == 4 then
    self.color = GhostreconQuality.Purple
    self.imgSet = GhostreconQualitySetting[GhostreconQuality.Purple]
  elseif color == 5 then
    if self.special then
      self.imgSet = GhostreconQualitySetting[GhostreconQuality.SuperYellow]
      self.color = GhostreconQuality.SuperYellow
    else
      self.imgSet = GhostreconQualitySetting[GhostreconQuality.Yellow]
      self.color = GhostreconQuality.Yellow
    end
  end
  self.level = cfg.level
  self.worldOpen = cfg.world_open
  self.showTime = cfg.show_time * 1000
  self.level = cfg.level
  self.protectTime = cfg.protect_times
  self.time = cfg.times * 1000
  self.stealMaxtimes = cfg.steal_maxtimes
  self.reward = DataCenter.RewardManager:ParseRewardsStr(cfg.base_reward_show)
  local conditions = cfg.conditions
  self.conditions = {}
  for index, value in ipairs(conditions) do
    local temp = ActGhostreconTaskConditionTemplate.New()
    temp:InitData(value)
    table.insert(self.conditions, temp)
  end
  local superCondions = cfg.super_conditions
  self.superCondions = {}
  for index, value in ipairs(superCondions) do
    local temp = ActGhostreconTaskSuperConditionTemplate.New()
    temp:InitData(value)
    table.insert(self.superCondions, temp)
  end
  self.supreRewardDetail = cfg.super_reward_detail
  self.supreRewardIcon = cfg.super_reward_icon
end

local function GetSuperCondionNumsByHeroList(self, heroList)
  local superCondionsNum = {}
  for i = 1, #self.superCondions do
    local condition = self.superCondions[i]
    superCondionsNum[i] = 0
    if heroList then
      for _, hero in ipairs(heroList) do
        if hero.heroId == condition.heroId and hero.level >= condition.level and hero.rank >= condition.star then
          superCondionsNum[i] = 1
          break
        end
      end
    end
  end
  return superCondionsNum
end

local function GetSuperCondionNumsByMemberList(self, memberList)
  local superCondionsNums = {}
  for i = 1, #self.superCondions do
    superCondionsNums[i] = 0
  end
  for index, value in ipairs(memberList) do
    local superCondionsNum = self:GetSuperCondionNumsByHeroList(value.heroList)
    for i = 1, #superCondionsNum do
      superCondionsNums[i] = superCondionsNums[i] + superCondionsNum[i]
    end
  end
  return superCondionsNums
end

local function CheckHeroMeetSuperCondions(self, hero)
  local isMeet = false
  if self.superCondions ~= nil and #self.superCondions > 0 then
    for index, condition in ipairs(self.superCondions) do
      isMeet = self:CheckHeroMeetSuperCondion(index, hero)
      if isMeet then
        break
      end
    end
  else
    isMeet = false
  end
  return isMeet
end

local function CheckHeroMeetSuperCondion(self, index, hero)
  local isMeet = false
  if self.superCondions ~= nil and index <= #self.superCondions then
    local condition = self.superCondions[index]
    if hero.heroId == condition.heroId and hero.level >= condition.level and hero.rank >= condition.star then
      isMeet = true
    end
  else
    isMeet = false
  end
  return isMeet
end

local function CheckCanShow(self, completionTime)
  local now = UITimeManager:GetInstance():GetServerTime()
  return (completionTime - now) / 1000 >= self.showTime
end

local function CheckCanSteal(self, completionTime)
  local now = UITimeManager:GetInstance():GetServerTime()
  return (now - completionTime) / 1000 >= self.protectTime
end

local function HaveSuperReward(self)
  return not string.IsNullOrEmpty(self.supreRewardDetail)
end

ActGhostreconTaskTemplate.__init = __init
ActGhostreconTaskTemplate.__delete = __delete
ActGhostreconTaskTemplate.InitData = InitData
ActGhostreconTaskTemplate.GetSuperCondionNumsByHeroList = GetSuperCondionNumsByHeroList
ActGhostreconTaskTemplate.GetSuperCondionNumsByMemberList = GetSuperCondionNumsByMemberList
ActGhostreconTaskTemplate.CheckHeroMeetSuperCondions = CheckHeroMeetSuperCondions
ActGhostreconTaskTemplate.CheckHeroMeetSuperCondion = CheckHeroMeetSuperCondion
ActGhostreconTaskTemplate.CheckCanShow = CheckCanShow
ActGhostreconTaskTemplate.CheckCanSteal = CheckCanSteal
ActGhostreconTaskTemplate.HaveSuperReward = HaveSuperReward
return ActGhostreconTaskTemplate
