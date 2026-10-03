local StrongestCommanderDataManager = BaseClass("StrongestCommanderDataManager")

local function __init(self)
  self.selfCurRank = 0
  self.activityId = ""
  self.eventInfo = nil
  self.eventRewardInfo = nil
  self.selfTotalRank = 0
  self.selfTotalScore = 0
  self.rankingData = {}
  self.rankingRewardData = {}
end

local function __delete(self)
  self.selfCurRank = 0
  self.activityId = ""
  self.eventInfo = nil
  self.selfTotalRank = 0
  self.selfTotalScore = 0
  self.rankingData = nil
  self.rankingRewardData = nil
end

local function SetActivityId(self, id)
  self.activityId = id
end

local function ParseEventData(self, message)
  if message == nil then
    return
  end
  local oneData = ActivityEventInfo.New()
  oneData:ParseData(message)
  self.eventInfo = oneData
end

local function ParseRankingData(self, message)
  if not message then
    return
  end
  local actId = message.activityId
  local stage = message.stage
  local rankingInfo = self.rankingData[stage]
  if rankingInfo == nil then
    rankingInfo = {}
  end
  local playerRankingInfoMsg = message.owner
  if not string.IsNullOrEmpty(playerRankingInfoMsg) then
    local selfPlayerData = BasePlayerInfo.New()
    selfPlayerData:ParseData(playerRankingInfoMsg)
    selfPlayerData.score = playerRankingInfoMsg.score
    selfPlayerData.ranking = playerRankingInfoMsg.rank
    rankingInfo.playerRankingInfo = selfPlayerData
  end
  local rankingList = message.list
  if not string.IsNullOrEmpty(rankingList) then
    rankingInfo.playersInfo = {}
    for i, v in pairs(rankingList) do
      local playerData = BasePlayerInfo.New()
      playerData:ParseData(v)
      playerData.score = v.score
      playerData.ranking = v.rank
      rankingInfo.playersInfo[playerData.ranking] = playerData
    end
  end
  self.rankingData[stage] = rankingInfo
  EventManager:GetInstance():Broadcast(EventId.RefreshRankingData, {actId = actId, stageId = stage})
end

local function GetRankingData(self, stage)
  return self.rankingData[stage]
end

local function ParseRankingRewardData(self, message)
  if not message then
    return
  end
  local actId = message.activityId
  local stage = message.stage
  local rewardData = message.rewardList
  local rewardsInfo = {}
  if not table.IsNullOrEmpty(rewardData) then
    for _, v in pairs(rewardData) do
      local rewardInfo = {}
      rewardInfo.minRanking = v.minLv
      rewardInfo.maxRanking = v.maxLv
      rewardInfo.rewards = DataCenter.RewardManager:ReturnRewardParamForView(v.reward)
      table.insert(rewardsInfo, rewardInfo)
    end
  end
  self.rankingRewardData[stage] = rewardsInfo
  EventManager:GetInstance():Broadcast(EventId.RefreshRankingReward, {actId = actId, stageId = stage})
end

local function GetRankingRewardData(self, stage)
  return self.rankingRewardData[stage]
end

local function GetEventData(self)
  return self.eventInfo
end

local function GetSelfStageRank(self, stage)
  return self.eventInfo:GetSelfRankingByStage(stage)
end

local function GetSelfStageScore(self, stage)
  local score = 0
  if self.eventInfo ~= nil then
    score = math.floor(self.eventInfo:GetScoreByStage(stage))
  end
  return score
end

local function GetTodayScoreMeth(self)
  local meth = {}
  if self.eventInfo ~= nil then
    meth = self.eventInfo:GetStageScoreMethods(self.eventInfo:GetCurStage())
  end
  return meth
end

local function GetEventCanRewardCount(self)
  local num = 0
  if self.eventInfo ~= nil then
    num = self.eventInfo:GetCanReceiveCount()
  end
  return num
end

local function GetStageCanRewardCount(self, stageId)
  local num = 0
  if self.eventInfo ~= nil then
    num = self.eventInfo:GetStageCanReceiveCount(stageId)
  end
  return num
end

local function GetQuests(self, stage)
  local quests = {}
  if self.eventInfo ~= nil then
    quests = self.eventInfo:GetStageQuests(stage)
  end
  return quests
end

local function GetCurStage(self)
  local stage = 0
  if self.eventInfo ~= nil then
    stage = self.eventInfo:GetCurStage()
  end
  return stage
end

local function IsAtFinishStage(self)
  local isFinish = false
  if self.eventInfo ~= nil then
    isFinish = self.eventInfo:IsAtFinishStage()
  end
  return isFinish
end

local function GetCurStageRemainTime(self)
  local remainTime = 0
  if self.eventInfo ~= nil then
    remainTime = self.eventInfo:GetCurStageRemainTime()
  end
  return remainTime
end

local function GetStageGiftPackGroupId(self, stage)
  local giftPackId = -1
  if self.eventInfo ~= nil then
    giftPackId = self.eventInfo:GetStageGiftPackGroupId(stage)
  end
  return giftPackId
end

local function GetStageScoreMethods(self, stage)
  local scoreMethods = {}
  if self.eventInfo ~= nil then
    scoreMethods = self.eventInfo:GetStageScoreMethods(stage)
  end
  return scoreMethods
end

local function GetStageDesc(self, stage)
  local dialogId = ""
  if self.eventInfo ~= nil then
    dialogId = self.eventInfo:GetStageDesc(stage)
  end
  return dialogId
end

StrongestCommanderDataManager.__init = __init
StrongestCommanderDataManager.__delete = __delete
StrongestCommanderDataManager.SetActivityId = SetActivityId
StrongestCommanderDataManager.ParseEventData = ParseEventData
StrongestCommanderDataManager.GetEventData = GetEventData
StrongestCommanderDataManager.GetSelfStageRank = GetSelfStageRank
StrongestCommanderDataManager.GetSelfStageScore = GetSelfStageScore
StrongestCommanderDataManager.GetTodayScoreMeth = GetTodayScoreMeth
StrongestCommanderDataManager.GetEventCanRewardCount = GetEventCanRewardCount
StrongestCommanderDataManager.GetStageCanRewardCount = GetStageCanRewardCount
StrongestCommanderDataManager.ParseRankingData = ParseRankingData
StrongestCommanderDataManager.GetRankingData = GetRankingData
StrongestCommanderDataManager.ParseRankingRewardData = ParseRankingRewardData
StrongestCommanderDataManager.GetRankingRewardData = GetRankingRewardData
StrongestCommanderDataManager.GetQuests = GetQuests
StrongestCommanderDataManager.GetCurStage = GetCurStage
StrongestCommanderDataManager.IsAtFinishStage = IsAtFinishStage
StrongestCommanderDataManager.GetCurStageRemainTime = GetCurStageRemainTime
StrongestCommanderDataManager.GetStageGiftPackGroupId = GetStageGiftPackGroupId
StrongestCommanderDataManager.GetStageScoreMethods = GetStageScoreMethods
StrongestCommanderDataManager.GetStageDesc = GetStageDesc
return StrongestCommanderDataManager
