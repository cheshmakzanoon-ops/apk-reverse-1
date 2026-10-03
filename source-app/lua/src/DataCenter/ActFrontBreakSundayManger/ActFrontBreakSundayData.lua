local ActFrontBreakSundayData = BaseClass("ActFrontBreakSundayData")
local StageState = {
  Start = 1,
  Success = 2,
  Fail = 3
}
local Const = require("Scene.LWBattle.Const")

function ActFrontBreakSundayData:__init(activityId)
  self.activityId = activityId
  self.stageIds = {}
  local stagesStr = LocalController:instance():getValue(TableName.Activity, activityId, "para")
  if not string.IsNullOrEmpty(stagesStr) then
    local stageIdStrs = string.split(stagesStr, "|")
    for i, stageId in ipairs(stageIdStrs) do
      table.insert(self.stageIds, tonumber(stageId))
    end
  end
  self.showRewards = {}
  local rewardsStr = LocalController:instance():getValue(TableName.Activity, activityId, "para_1")
  if not string.IsNullOrEmpty(rewardsStr) then
    local rewardStrVec = string.split(rewardsStr, "|")
    for i, rewardStr in ipairs(rewardStrVec) do
      local item = DataCenter.RewardManager:ParseOneRewardStr(rewardStr)
      if item then
        table.insert(self.showRewards, item)
      end
    end
  end
  self.nextStageId = #self.stageIds > 0 and self.stageIds[1] or -1
  local topRankCriteria = LocalController:instance():getValue(TableName.Activity, activityId, "para_2")
  self.topRankCriteriaStage = 0
  self.topRankCriteriaRemainSolder = 0
  if not string.IsNullOrEmpty(topRankCriteria) then
    local topRankCriteriaStrVec = string.split(topRankCriteria, "|")
    if not string.IsNullOrEmpty(topRankCriteriaStrVec[1]) then
      self.topRankCriteriaStage = tonumber(topRankCriteriaStrVec[1])
    end
    if not string.IsNullOrEmpty(topRankCriteriaStrVec[2]) then
      self.topRankCriteriaRemainSolder = tonumber(topRankCriteriaStrVec[2])
    end
  end
end

function ActFrontBreakSundayData:__delete()
  self.stageIds = {}
  self.showRewards = {}
  self.nextStageId = -1
  self.topRankCriteriaStage = 0
  self.topRankCriteriaRemainSolder = 0
end

function ActFrontBreakSundayData:ParseData(info)
  self.info = info
  self.info.rewardCount = 0
  local taskArr = self.info.taskArr
  if taskArr then
    for _, v in ipairs(taskArr) do
      if v.state == 1 then
        self.info.rewardCount = self.info.rewardCount + 1
      end
    end
  end
  local boxList = self.info.soldierBox
  if boxList then
    table.sort(boxList, function(a, b)
      return a.id < b.id
    end)
    local count = #boxList
    self.maxTargetNum = boxList[count] and boxList[count].target or 0
  end
  self:CalculateNextStageId()
  EventManager:GetInstance():Broadcast(EventId.FrontBreakSundayActivityInfoChanged, self.activityId)
end

function ActFrontBreakSundayData:EnterStage(stageId, cheatCheck)
  local entered = DataCenter.LWBattleManager.logic and DataCenter.LWBattleManager.logic.state == Const.ParkourBattleState.Ready or false
  if entered then
    return
  end
  local param = {}
  param.type = PVEType.Parkour
  param.levelId = tonumber(stageId)
  param.fromActFrontBreakSunday = true
  param.frontBreakSundayActId = self.activityId
  param.cheatCheck = cheatCheck
  param.memRecord = true
  if SceneUtils.GetIsInWorld() then
    SceneUtils.ChangeToCity(function()
      DataCenter.LWBattleManager:Enter(param)
      DataCenter.LWStageFeatureChapterManager.autoOpenMapUIWhenBackToCity = false
    end)
  elseif SceneUtils.GetIsInCity() or SceneUtils.GetIsInPve() then
    DataCenter.LWBattleManager:Enter(param)
    DataCenter.LWStageFeatureChapterManager.autoOpenMapUIWhenBackToCity = false
  end
end

function ActFrontBreakSundayData:RequestToEnterStage(stageId)
  SFSNetwork.SendMessage(MsgDefines.FrontBreakSundayStartChallenge, stageId)
end

function ActFrontBreakSundayData:EnterNextStage()
  if self.nextStageId == -1 then
    return
  end
  self:EnterStage(self.nextStageId)
end

function ActFrontBreakSundayData:HandleStartChallengeMessage(message)
  if not message.curStage and not message.state then
    return
  end
  if not self.info or not self.info.extra then
    return
  end
  if message.curStage then
    self.info.extra.curStage = message.curStage
    self.nextStageId = self.info.extra.curStage
  end
  if message.state then
    self.info.extra.state = message.state
  end
  if message.curStage and message.state == 1 then
    self:EnterStage(message.curStage, message.cheatCheck)
  end
end

function ActFrontBreakSundayData:CalculateNextStageId()
  if not self.info or not self.info.extra then
    self.nextStageId = -1
    return
  end
  local curStage = self.info.extra.curStage
  local curStageState = self.info.extra.state
  local stagesCount = #self.stageIds
  if not curStage then
    self.nextStageId = 0 < stagesCount and self.stageIds[1] or -1
    return
  end
  local curStageIndex = table.indexof(self.stageIds, curStage) or 0
  if curStageIndex == stagesCount and curStageState == StageState.Success then
    self.nextStageId = 0 < stagesCount and self.stageIds[1] or -1
  elseif curStageState == StageState.Success then
    local nextStageIndex = math.min(curStageIndex + 1, stagesCount)
    self.nextStageId = self.stageIds[nextStageIndex]
  elseif curStageState == StageState.Fail or curStageState == StageState.Start then
    self.nextStageId = 0 < stagesCount and self.stageIds[1] or -1
  end
end

function ActFrontBreakSundayData:HandleChallengeResultMessage(message)
  if message.curStage and message.state then
    if not self.info or not self.info.extra then
      return
    end
    self.info.extra.curStage = message.curStage
    self.info.extra.state = message.state
    self:CalculateNextStageId()
    EventManager:GetInstance():Broadcast(EventId.FrontBreakSundayActivityInfoChanged, self.activityId)
  end
  EventManager:GetInstance():Broadcast(EventId.FrontBreakSundayChallengeSaveResult, message)
end

function ActFrontBreakSundayData:HandleTaskRewardMessage(message)
  local t = message.reward
  if t then
    DataCenter.RewardManager:ShowCommonReward(message)
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
  if not self.info then
    return
  end
  if tonumber(self.info.activityId) ~= tonumber(message.activityId) then
    return
  end
  local taskId = message.taskId
  local allReceiveId = "0"
  local allClamied = taskId == allReceiveId
  for _, v in ipairs(self.info.taskArr) do
    if v.state == 1 then
      if allClamied then
        v.state = 2
        self.info.rewardCount = math.max(0, self.info.rewardCount - 1)
      elseif v.taskId == taskId then
        v.state = 2
        self.info.rewardCount = math.max(0, self.info.rewardCount - 1)
        break
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.FrontBreakSundayActivityInfoChanged, self.activityId)
  EventManager:GetInstance():Broadcast(EventId.FrontBreakSundayTaskRewardChanged, self.activityId)
end

function ActFrontBreakSundayData:HandleSaveSoliderRewardMessage(message)
  local t = message.reward
  if t then
    DataCenter.RewardManager:ShowCommonReward(message)
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
  local newBoxList = message.soldierBox
  table.sort(newBoxList, function(a, b)
    return a.id < b.id
  end)
  self.info.soldierBox = newBoxList
  EventManager:GetInstance():Broadcast(EventId.FrontBreakSundayGetSaveSoliderReward)
end

function ActFrontBreakSundayData:GetRedDotCount()
  if not self.info then
    return 0, 0, 0
  end
  local rewardCount = self.info.rewardCount or 0
  local tipCount = 0
  if not self:HasPlayed() and self:CanPlay() then
    tipCount = tipCount + 1
  end
  return rewardCount + tipCount, rewardCount, tipCount
end

function ActFrontBreakSundayData:HasPlayed()
  if not self.info then
    return false
  end
  if self.info.extra and not self.info.extra.curStage then
    return false
  else
    return true
  end
end

function ActFrontBreakSundayData:CanPlay()
  if not self.info then
    return false
  end
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if not self.activityData then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.activityData.endTime - curTime
  return 600000 < remainTime
end

function ActFrontBreakSundayData:GetNextStageId()
  return self.nextStageId
end

function ActFrontBreakSundayData:GetStageIndex(stageId)
  return table.indexof(self.stageIds, stageId)
end

function ActFrontBreakSundayData:GetTopRankCriteriaStage()
  return self.topRankCriteriaStage
end

function ActFrontBreakSundayData:GetTopRankCriteriaRemainSolider()
  return self.topRankCriteriaRemainSolder
end

function ActFrontBreakSundayData:IsAllRewardsClaimed()
  if not self.info or not self.info.taskArr then
    return false
  end
  for _, task in ipairs(self.info.taskArr) do
    if task.state ~= 2 then
      return false
    end
  end
  return true
end

return ActFrontBreakSundayData
