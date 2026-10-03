local LWDominatorUpStageManager = BaseClass("LWDominatorUpStageManager")

function LWDominatorUpStageManager:__init()
  self.curStageId = 0
end

function LWDominatorUpStageManager:__delete()
end

function LWDominatorUpStageManager:Startup()
end

function LWDominatorUpStageManager:InitData(msg)
  self.curStageId = msg.dominatorUpStageInfo and msg.dominatorUpStageInfo.dominatorId and tonumber(msg.dominatorUpStageInfo.dominatorId) or 0
  if msg.dominatorUpStageInfo then
    self:UpdateFirstRewardedDict(msg.dominatorUpStageInfo.firstRewardedArr)
  end
end

function LWDominatorUpStageManager:UpdateData(msg)
  if msg.isWin then
    self.curStageId = msg.id and tonumber(msg.id) or 0
  end
end

function LWDominatorUpStageManager:GetCurStageId()
  return self.curStageId
end

function LWDominatorUpStageManager:OnStageWin()
end

function LWDominatorUpStageManager:OnStageLose()
end

function LWDominatorUpStageManager:GetUnGetRewardNum(checkId)
  local num = 0
  local firstRewardStage = DataCenter.DominatorUpTemplateManager:GetFirstRewardStage()
  for i, v in ipairs(firstRewardStage) do
    if checkId < v then
      break
    end
    if self.firstRewardedDict == nil or not self.firstRewardedDict[v] then
      num = num + 1
    end
  end
  return num
end

function LWDominatorUpStageManager:UpdateFirstRewardedDict(firstRewardedArr)
  if firstRewardedArr then
    self.firstRewardedArr = firstRewardedArr
    self.firstRewardedDict = {}
    for i, v in ipairs(firstRewardedArr) do
      self.firstRewardedDict[v] = true
    end
  end
end

function LWDominatorUpStageManager:CanGetFirstReward(checkId)
  local canGet = false
  local firstRewardStage = DataCenter.DominatorUpTemplateManager:GetFirstRewardStage()
  if self.firstRewardedDict == nil or self.firstRewardedDict[checkId] == nil then
    for i, v in ipairs(firstRewardStage) do
      if v == checkId then
        canGet = true
        break
      end
    end
  end
  return canGet
end

function LWDominatorUpStageManager:GetNearlyFirstReward()
  local rewardCfg
  local nowStageId = self:GetCurStageId()
  local firstRewardStage = DataCenter.DominatorUpTemplateManager:GetFirstRewardStage()
  for i, v in ipairs(firstRewardStage) do
    if nowStageId < tonumber(v) then
      rewardCfg = DataCenter.DominatorUpTemplateManager:GetDominatorUpUnlockTemplate(v)
      break
    end
  end
  return rewardCfg
end

function LWDominatorUpStageManager:GetStageFirstRewardType(checkId)
  local type = JeepStageFirstRewardType.NotReached
  local curStageId = self:GetCurStageId()
  if checkId <= curStageId then
    if self.firstRewardedDict and self.firstRewardedDict[checkId] then
      type = JeepStageFirstRewardType.Claimed
    else
      type = JeepStageFirstRewardType.CanClaim
    end
  else
    type = JeepStageFirstRewardType.NotReached
  end
  return type
end

function LWDominatorUpStageManager:GetLastFirstReward()
  local firstRewardStage = DataCenter.TowerUpTemplateManager:GetFirstRewardStage()
  local rewardCfg
  for i = #firstRewardStage, 1, -1 do
    rewardCfg = DataCenter.TowerUpTemplateManager:GetTowerUpUnlockTemplate(firstRewardStage[i])
    if rewardCfg then
      break
    end
  end
  return rewardCfg
end

return LWDominatorUpStageManager
