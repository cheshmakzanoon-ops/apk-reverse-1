local LWTrailTowerInfo = BaseClass("LWTrailTowerInfo")

function LWTrailTowerInfo:__init()
  self.trailTowerId = 0
  self.startTime = 0
  self.endTime = 0
  self.curGroup = 0
  self.curStage = 0
  self.passGroup = 0
  self.isFinish = false
  self.heroUuids = {}
  self.heroInfosDic = {}
  self.challengeTimes = 0
  self.chipSetId = 0
  self.challengeLimit = 0
end

function LWTrailTowerInfo:__delete()
  self.trailTowerId = nil
  self.startTime = nil
  self.endTime = nil
  self.curGroup = nil
  self.curStage = nil
  self.passGroup = nil
  self.isFinish = nil
  self.heroUuids = nil
  self.heroInfosDic = nil
  self.challengeTimes = nil
  self.chipSetId = nil
  self.challengeLimit = nil
end

function LWTrailTowerInfo:InitData(message)
  if message.id then
    self.trailTowerId = message.id
  end
  if message.startTime then
    self.startTime = message.startTime
  end
  if message.endTime then
    self.endTime = message.endTime
  end
  if message.currGroup then
    self.curGroup = message.currGroup
  end
  if message.currLv then
    self.curStage = message.currLv
  end
  if message.passGroup then
    self.passGroup = message.passGroup
  end
  if message.isFinish then
    self.isFinish = message.isFinish
    self.curStage = -1
  end
  if message.challengeTimes then
    self.challengeTimes = message.challengeTimes
  end
  if message.heroUuids then
    self.heroUuids = message.heroUuids
  end
  if message.heroInfos then
    self.heroInfosDic = {}
    local heroInfos = message.heroInfos
    for i = 1, #heroInfos do
      local index = heroInfos[i].index
      local heroUuid = heroInfos[i].heroUuid
      self.heroInfosDic[index] = heroUuid
    end
  end
  if message.chipEquipGroup then
    self.chipSetId = message.chipEquipGroup
  end
  if message.challengeLimit then
    self.challengeLimit = message.challengeLimit
  end
end

function LWTrailTowerInfo:RefreshGroupAndLv(message)
  if message.currGroup then
    self.curGroup = message.currGroup
  end
  if message.currLv then
    self.curStage = message.currLv
  end
end

function LWTrailTowerInfo:IsEnd()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local surplusTime = self.endTime - curTime
  return surplusTime <= 0 and curTime >= self.startTime
end

function LWTrailTowerInfo:IsOpen()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local surplusTime = self.startTime - curTime
  return surplusTime <= 0
end

function LWTrailTowerInfo:IsContainsHero(targetHeroUuid)
  local contains = false
  for _, heroUuid in pairs(self.heroUuids) do
    if heroUuid == targetHeroUuid then
      contains = true
      break
    end
  end
  return contains
end

function LWTrailTowerInfo:GetCurCanDoDifficultyGroup()
  if self.curGroup == 0 then
    if self.passGroup == 0 then
      return 1
    else
      local trailTowerTemplate = DataCenter.LWTrailTowerTemplateManager:GetTrailTowerTemplateById(self.trailTowerId)
      local maxValue = trailTowerTemplate ~= nil and trailTowerTemplate.maxDifficultyGroup or 0
      if maxValue <= self.passGroup then
        return self.passGroup
      end
      return self.passGroup + 1
    end
  else
    return self.curGroup
  end
end

function LWTrailTowerInfo:IsAchieveChallengesTimesLimit()
  return self.challengeTimes >= self.challengeLimit
end

function LWTrailTowerInfo:HasStageProgress()
  if self.isFinish then
    return true
  elseif self.curGroup == 0 or self.curStage == 0 then
    return false
  else
    local curCanDoDifficultyGroup = self:GetCurCanDoDifficultyGroup()
    local trailTowerLevelTemplate = DataCenter.LWTrailTowerTemplateManager:GetTrailTowerLevelTemplate(self.trailTowerId, curCanDoDifficultyGroup, self.curStage)
    if trailTowerLevelTemplate ~= nil then
      return trailTowerLevelTemplate.levelOrder > 1
    else
      return false
    end
  end
end

return LWTrailTowerInfo
