local ActivityEventInfo = BaseClass("ActivityEventInfo")

local function __init(self)
  self.startTime = 0
  self.endTime = 0
  self.activityId = ""
  self.actId = ""
  self.actName = ""
  self.type = -1
  self.eventId = ""
  self.getScoreMeth = ""
  self.curScore = 0
  self.isCrossFight = false
  self.crossFight = 0
  self.targetServerId = 0
  self.targetAllianceId = ""
  self.hasRewardList = {}
  self.targetReward = {}
  self.rewardScoreIndexArr = {}
  self.cost = {}
  self.weekEndTime = nil
  self.fightStartTime = nil
  self.fightEndTime = nil
  self.stages = {}
  self.curStage = 0
  self.heroTrialCurStageId = 0
  self.stageScores = 0
  self.stageRankings = 0
  self.curStageStartTime = 0
  self.curStageEndTime = 0
  self.exchangeAndRewards = {}
  self.stageArr = {}
end

local function __delete(self)
  self.startTime = nil
  self.endTime = nil
  self.activityId = nil
  self.actId = nil
  self.actName = nil
  self.type = nil
  self.eventId = nil
  self.getScoreMeth = nil
  self.curScore = nil
  self.hasRewardList = nil
  self.targetReward = nil
  self.rewardScoreIndexArr = nil
  self.isCrossFight = nil
  self.cost = nil
  self.weekEndTime = nil
  self.stages = nil
  self.curStage = nil
  self.heroTrialCurStageId = nil
  self.stageScores = nil
  self.stageRankings = nil
  self.curStageStartTime = nil
  self.curStageEndTime = nil
  self.exchangeAndRewards = nil
  self.stageArr = nil
  self.crossFight = nil
  self.targetServerId = nil
  self.targetAllianceId = nil
  self.fightStartTime = nil
  self.fightEndTime = nil
  self.isBye = false
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.begintime ~= nil then
    self.startTime = message.begintime
  end
  if message.endtime ~= nil then
    self.endTime = message.endtime
  end
  if message.rt then
    self.readyTime = message.rt
  end
  if message.weekEndTime then
    self.weekEndTime = message.weekEndTime
  end
  if message.fightStartTime then
    self.fightStartTime = message.fightStartTime
  end
  if message.fightEndTime then
    self.fightEndTime = message.fightEndTime
  end
  if message.crossFight then
    self.crossFight = message.crossFight
  end
  if message.isCrossFight then
    self.isCrossFight = message.isCrossFight
  end
  if message.actName ~= nil then
    self.actName = message.actName
  end
  if message.actDesc ~= nil then
    self.actDesc = message.actDesc
  end
  if message.activityId ~= nil then
    self.activityId = message.activityId
  end
  if message.t ~= nil then
    self.type = message.t
  end
  if message.eventId ~= nil then
    self.eventId = message.eventId
    self:InitRewardScience()
  end
  if message.value ~= nil then
    self.cost = string.split(message.value, "|")
  end
  if message.score ~= nil then
    self.getScoreMeth = {}
    local scoreIds = string.split(message.score, "|")
    self.scoreIdList = scoreIds
    self.scoreIdListNew = {}
    self.groupId2IdList = {}
    for k = 1, #scoreIds do
      local v = scoreIds[k]
      local oneData = {}
      oneData.name = GetTableData(TableName.Score, v, "name")
      local values = GetTableData(TableName.Score, v, "value")
      oneData.point = GetTableData(TableName.Score, v, "points")
      oneData.pointType = GetTableData(TableName.Score, v, "point_type")
      oneData.paramsList = string.split(values, ";")
      oneData.tips = GetTableData(TableName.Score, v, "tips")
      table.insert(self.getScoreMeth, oneData)
      local id = v
      if id ~= nil then
        local scoreTable = LocalController:instance():getLine("score", id)
        if scoreTable == nil then
          Logger.LogError("scoreId\230\137\190\228\184\141\229\136\176" .. id)
        else
          local points = scoreTable:getValue("points")
          local tipsArr = scoreTable:getValue("tips")
          local idData = {}
          idData.id = id
          idData.points = points
          idData.tipsArr = tipsArr
          idData.tips = scoreTable:getValue("tips")
          idData.pic = scoreTable:getValue("pic")
          local effectInfo = scoreTable:getValue("effect_list")
          if effectInfo ~= nil and effectInfo ~= "" then
            idData.effectList = {}
            local effects = string.split(effectInfo, ";")
            for i = 1, #effects do
              idData.effectList[i] = effects[i]
            end
          end
          local group = scoreTable:getValue("group")
          local groupId = string.IsNullOrEmpty(group) and 0 or tonumber(group)
          idData.groupId = groupId
          if groupId ~= 0 then
            if not self.groupId2IdList[groupId] then
              self.groupId2IdList[groupId] = {}
            end
            table.insert(self.groupId2IdList[groupId], idData)
          end
          local name = scoreTable:getValue("name")
          local params = scoreTable:getValue("point")
          local value = scoreTable:getValue("value")
          idData.name = name
          idData.value = value
          table.insert(self.scoreIdListNew, idData)
        end
      end
    end
  end
  if message.value ~= nil then
    self.value = message.value
    self.valueList = string.split(self.value, "|")
  end
  if message.target ~= nil then
    self.target = message.target
    self.targetList = string.split(self.target, "|")
  end
  if message.value ~= nil then
    self.gemPrice = message.value
    self.gemPriceList = string.split(self.gemPrice, "|")
  end
  self.currentScore = 0
  if message.userScore ~= nil then
    local data = message.userScore
    if data.score ~= nil then
      self.curScore = tonumber(data.score)
    end
    if data.newRewardFlagList ~= nil then
      self:RefreshNewRewardFlagList(data.newRewardFlagList)
    end
    if data.newRewardFlagList ~= nil and data.newRewardFlagList ~= "" then
      self.newRewardFlagStr = data.newRewardFlagList
      local arr = string.split(self.newRewardFlagStr, ",")
      self.newRewardFlagList = {}
      for i = 1, #arr do
        local index = tonumber(arr[i])
        self.newRewardFlagList[index] = index
      end
    end
    if data.score ~= nil then
      self.currentScore = data.score
    end
    if data.rewardFlagList ~= nil and data.rewardFlagList ~= "" then
      self.rewardFlagListStr = data.rewardFlagList
      local list = string.split(self.rewardFlagListStr, ",")
      self.rewardFlagList = {}
      for i = 1, #list do
        local ind = tonumber(list[i])
        self.rewardFlagList[ind + 1] = ind + 1
      end
    end
  end
  if message.target ~= nil and message.reward ~= nil then
    self.targetReward = {}
    self.rewardScoreIndexArr = {}
    local targetArr = string.split(message.target, "|")
    local rewardArr = message.reward
    local lastTag = 0
    if table.length(rewardArr) == #targetArr then
      for i = 1, table.length(rewardArr) do
        local tag = tonumber(targetArr[i])
        if self.type and self.type == EnumActivity.AllianceCompete.EventType and tag == lastTag then
          tag = tag + 1
        end
        lastTag = tag
        local reward = DataCenter.RewardManager:ReturnRewardParamForView(rewardArr[i])
        self.targetReward[tag] = reward
        self.rewardScoreIndexArr[i] = tag
      end
    end
  end
  if message.vsAllianceInfo ~= nil then
    self.vsAllianceInfo = message.vsAllianceInfo
    self.isBye = false
    if self.vsAllianceInfo ~= nil then
      self.vsAllianceList = {}
      table.walk(self.vsAllianceInfo, function(k, v)
        local allianceId = v.allianceId
        if allianceId == nil then
          Logger.Log("\229\175\185\230\137\139\232\129\148\231\155\159\228\184\186\231\169\186\239\188\140\229\143\175\232\131\189\230\152\175\232\189\174\231\169\186\228\186\134")
          local fakeAllyId = "0"
          self.vsAllianceList[fakeAllyId] = {}
          self.vsAllianceList[fakeAllyId].alScore = 0
          self.vsAllianceList[fakeAllyId].power = 0
          self.isBye = true
        else
          local myAlId = LuaEntry.Player.allianceId
          self.vsAllianceList[allianceId] = {}
          self.vsAllianceList[allianceId].id = allianceId
          self.vsAllianceList[allianceId].alName = v.alName
          self.vsAllianceList[allianceId].abbr = v.abbr
          self.vsAllianceList[allianceId].icon = v.icon
          self.vsAllianceList[allianceId].alScore = v.alScore
          self.vsAllianceList[allianceId].power = v.power or 0
          self.vsAllianceList[allianceId].win = v.win
          self.vsAllianceList[allianceId].winScore = v.winScore
          self.vsAllianceList[allianceId].serverId = v.serverId
          if myAlId ~= allianceId then
            self.targetServerId = v.serverId
            self.targetAllianceId = allianceId
          end
          if v.mvpPlayer ~= nil then
            self.mvpPlayer = v.mvpPlayer
            self.vsAllianceList[allianceId].mvpPlayer = {}
            self.vsAllianceList[allianceId].mvpPlayer.uid = self.mvpPlayer.uid
            self.vsAllianceList[allianceId].mvpPlayer.pic = self.mvpPlayer.pic
            self.vsAllianceList[allianceId].mvpPlayer.picVer = self.mvpPlayer.picVer
            self.vsAllianceList[allianceId].mvpPlayer.monthCardEndTime = self.mvpPlayer.monthCardEndTime
            self.vsAllianceList[allianceId].mvpPlayer.GetHeadBgImg = function(self)
              local headBgImg
              local serverTimeS = UITimeManager:GetInstance():GetServerSeconds()
              if self.monthCardEndTime and serverTimeS < self.monthCardEndTime then
                headBgImg = "Common_playerbg_golloes"
              end
              if headBgImg and headBgImg ~= "" then
                return string.format(LoadPath.CommonNewPath, headBgImg)
              end
            end
            self.vsAllianceList[allianceId].mvpPlayer.name = self.mvpPlayer.name
          end
        end
      end)
    end
  end
  if message.winReward ~= nil then
    self.winReward = message.winReward
    if self.winReward then
      local cacheReward
      for i, v in ipairs(self.winReward) do
        if v.type == RewardType.GOLD then
          cacheReward = v
          table.remove(self.winReward, i)
          break
        end
      end
      if cacheReward then
        table.insert(self.winReward, 1, cacheReward)
      end
    end
  end
  if message.winWeekReward ~= nil then
    self.winWeekReward = message.winWeekReward
    if self.winWeekReward then
      local cacheReward
      for i, v in ipairs(self.winWeekReward) do
        if v.type == RewardType.GOLD then
          cacheReward = v
          table.remove(self.winWeekReward, i)
          break
        end
      end
      if cacheReward then
        table.insert(self.winWeekReward, 1, cacheReward)
      end
    end
  end
  if message.minDayScore ~= nil then
    self.minDayScore = message.minDayScore
  end
  if message.minWeekScore ~= nil then
    self.minWeekScore = message.minWeekScore
  end
  if message.id ~= nil then
    self.actId = message.id
    self.activityId = message.id
  end
  if message.actId ~= nil then
    self.actId = message.actId
  end
  if message.extra ~= nil then
    local extraData = message.extra
    if extraData.cur_sc ~= nil then
      self.stageScores = extraData.cur_sc
    end
    if extraData.cur_rank ~= nil then
      self.stageRankings = extraData.cur_rank
    end
    if extraData.cur_stage ~= nil then
      self.curStage = extraData.cur_stage
    end
    if extraData.stage_start ~= nil then
      self.curStageStartTime = extraData.stage_start
    end
    if extraData.stage_end ~= nil then
      self.curStageEndTime = extraData.stage_end
    end
    self.extraData = extraData
  end
  if message.stages ~= nil then
    self.stages = message.stages
  end
  if message.exchangeAndRewards ~= nil then
    self.exchangeAndRewards = message.exchangeAndRewards
  end
  if message.stageArr ~= nil then
    self.stageArr = message.stageArr
  end
  if message.cur_stage ~= nil then
    self.heroTrialCurStageId = message.cur_stage
  end
end

local function GetCurStage(self)
  return self.curStage
end

local function IsAtFinishStage(self)
  return self.curStage == -1
end

local function GetStageData(self, stageId)
  local stageTemplateId = self.stages[stageId]
  return DataCenter.ActivityStageTemplateManager:GetTemplate(stageTemplateId)
end

local function GetStageQuests(self, stageId)
  local stageTemplate = self:GetStageData(stageId)
  if stageTemplate then
    return stageTemplate:GetQuests()
  end
  return {}
end

local function GetHeroTrialStageQuests(self)
  local stageTemplate = DataCenter.ActivityStageTemplateManager:GetTemplate(self.heroTrialCurStageId)
  if stageTemplate then
    return stageTemplate:GetQuests()
  end
  return {}
end

local function GetStageScoreMethods(self, stageId)
  if not stageId then
    return {}
  end
  local stageTemplate = self:GetStageData(stageId)
  if stageTemplate then
    return stageTemplate:GetScoreMethods()
  end
  return {}
end

local function GetStageGiftPackGroupId(self, stage)
  if stage then
    local stageTemplate = self:GetStageData(stage)
    if stageTemplate then
      local groupIds = stageTemplate:GetStageGiftPackGroupId()
      for __, groupId in pairs(groupIds) do
        local giftPackGroupId = groupId
        if giftPackGroupId then
          local packs = GiftPackManager.GetPacksByGroupId(giftPackGroupId, false)
          if not table.IsNullOrEmpty(packs) then
            return giftPackGroupId
          end
        end
        return -1
      end
    else
      return -1
    end
  else
    return -1
  end
end

local function RefreshNewRewardFlagList(self, str)
  self.hasRewardList = string.split(str, ",")
end

local function GetStateByScoreIndex(self, scoreIndex)
  local state = TaskState.NoComplete
  if scoreIndex <= self.curScore then
    state = TaskState.CanReceive
  end
  local index = 0
  table.walk(self.rewardScoreIndexArr, function(k, v)
    if scoreIndex == v then
      index = k
    end
  end)
  table.walk(self.hasRewardList, function(k, v)
    if tonumber(v) == index then
      state = TaskState.Received
    end
  end)
  return state
end

local function GetCanReceiveCount(self)
  local count = 0
  if self.type == EnumActivity.AllianceCompete.EventType then
    local maxUnlockIndex = DataCenter.AllianceCompeteDataManager:Get9BoxUnlockMaxIndex()
    table.walk(self.rewardScoreIndexArr, function(k, v)
      if k <= maxUnlockIndex and self:GetStateByScoreIndex(v) == TaskState.CanReceive then
        count = count + 1
      end
    end)
    return count
  end
  if not table.IsNullOrEmpty(self.stages) then
    for stageId, stageTempalteId in pairs(self.stages) do
      local stageQuests = GetStageQuests(self, stageId)
      if stageQuests then
        for __, questId in pairs(stageQuests) do
          local taskDataValue = DataCenter.TaskManager:FindTaskInfo(questId)
          if taskDataValue and taskDataValue.state == TaskState.CanReceive then
            count = count + 1
          end
        end
      end
    end
  end
  return count
end

local function GetStageCanReceiveCount(self, stageId)
  local count = 0
  local stageQuests = GetStageQuests(self, stageId)
  if stageQuests then
    for __, questId in pairs(stageQuests) do
      local taskDataValue = DataCenter.TaskManager:FindTaskInfo(questId)
      if taskDataValue and taskDataValue.state == TaskState.CanReceive then
        count = count + 1
      end
    end
  end
  return count
end

local function CheckIfShowCrossServer(self)
  return self.fightStartTime ~= nil and self.fightStartTime > 0 and self.vsAllianceList ~= nil and table.count(self.vsAllianceList) > 1, self.fightStartTime, self.fightEndTime
end

function ActivityEventInfo:IsBye()
  return self.isBye
end

local function GetScoreByStage(self, stage)
  if stage then
    return self.stageScores[stage]
  end
  return 0
end

local function GetSelfRankingByStage(self, stage)
  if stage then
    return self.stageRankings[stage]
  end
  return 0
end

local function GetCurStageStarTime(self)
  return self.curStageStartTime
end

local function GetCurStageEndTime(self)
  return self.curStageEndTime
end

local function GetCurStageRemainTime(self)
  local remainTime = 0
  if self.curStageEndTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    remainTime = self.curStageEndTime - curTime
  end
  if remainTime < 0 then
    remainTime = 0
  end
  return remainTime
end

local function GetStageDesc(self, stage)
  if stage then
    local stageTemplate = self:GetStageData(stage)
    if stageTemplate then
      return stageTemplate.stage_des
    end
  end
  return ""
end

local function GetRewardScience(self, boxIndex)
  if not self.rewardScienceList or boxIndex > #self.rewardScienceList then
    return nil
  end
  local scienceList = self.rewardScienceList[boxIndex]
  for i, v in ipairs(scienceList) do
    local curLevel = DataCenter.ScienceManager:GetScienceLevel(tonumber(v.scienceId))
    local maxLevel = DataCenter.ScienceManager:GetScienceMaxLevel(tonumber(v.scienceId))
    if curLevel < maxLevel then
      return v
    end
  end
  return nil
end

local function InitRewardScience(self)
  local heroEventMeta = LocalController:instance():getLine(TableName.HeroEvent, self.eventId)
  if not heroEventMeta then
    return
  end
  self.rewardScienceList = {}
  local boxStrArr = string.split(heroEventMeta.reward_science, "@")
  for i = 1, #boxStrArr do
    local sciStrArr = string.split(boxStrArr[i], "|")
    self.rewardScienceList[i] = {}
    for j = 1, #sciStrArr do
      local sciStr = string.split(sciStrArr[j], ";")
      self.rewardScienceList[i][j] = {
        scienceId = sciStr[1],
        dialogId = sciStr[2]
      }
    end
  end
  self.effectShowList = DataCenter.AllyDuelConditionTipManager.ParseEffectShow(heroEventMeta)
end

local function CheckIfShowCrossDesert(self)
  return self.desertFightStartTime ~= nil and self.desertFightStartTime > 0 and self.vsAllianceList ~= nil and table.count(self.vsAllianceList) > 1, self.desertFightStartTime, self.desertFightEndTime
end

local function CheckBoxHaveNewReward(self, groupIndex)
  local heroEventMeta = LocalController:instance():getLine(TableName.HeroEvent, self.eventId)
  if not heroEventMeta then
    return {}
  end
  local ret = {}
  local openServerDay = UITimeManager:GetInstance():GetOpenServerDay()
  local seasonNum = SeasonUtil.GetSeason()
  local seasonDay = SeasonUtil.GetSeasonDay()
  local openServerWeek = UITimeManager:GetInstance():GetOpenServerWeek()
  local now = UITimeManager:GetInstance():GetServerSeconds()
  local rewardHisStr = CommonUtil.PlayerPrefsGetString("AllyDuelBoxNewRewardFirstShowTime", "")
  local idTimes = string.split(rewardHisStr, "A")
  local rewardHisDic = {}
  for _, idTime in pairs(idTimes) do
    local p = string.split(idTime, "B")
    if #p == 2 then
      rewardHisDic[p[1]] = tonumber(p[2])
    end
  end
  local conditionItems = string.split(heroEventMeta:getValue("reward_addition"), ";")
  for _, conditionItem in ipairs(conditionItems) do
    local para = string.split(conditionItem, "|")
    local spl = string.split(para[1], ",")
    if #spl == 3 then
      local condi = tonumber(spl[1])
      local param
      if condi == 2 then
        param = string.split(spl[2], "#")
        param[1] = tonumber(param[1])
        if param[2] then
          param[2] = tonumber(param[2])
        else
          param[2] = 1
        end
      else
        param = tonumber(spl[2])
      end
      local index = tonumber(spl[3])
      if (index + 2) // 3 == groupIndex and (condi == 1 and openServerDay >= param or condi == 2 and (seasonNum > param[1] or param[1] == seasonNum and seasonDay >= param[2]) or condi == 3 and openServerWeek >= param) then
        if rewardHisDic[conditionItem] then
          local firstShowTime = rewardHisDic[conditionItem]
          if now < firstShowTime + 86400 then
            ret[index] = true
          end
        else
          rewardHisStr = rewardHisStr .. "A" .. conditionItem .. "B" .. now
          ret[index] = true
        end
      end
    end
  end
  CommonUtil.PlayerPrefsSetString("AllyDuelBoxNewRewardFirstShowTime", rewardHisStr)
  return ret
end

ActivityEventInfo.__init = __init
ActivityEventInfo.__delete = __delete
ActivityEventInfo.ParseData = ParseData
ActivityEventInfo.RefreshNewRewardFlagList = RefreshNewRewardFlagList
ActivityEventInfo.GetStateByScoreIndex = GetStateByScoreIndex
ActivityEventInfo.GetCanReceiveCount = GetCanReceiveCount
ActivityEventInfo.GetStageCanReceiveCount = GetStageCanReceiveCount
ActivityEventInfo.CheckIfShowCrossServer = CheckIfShowCrossServer
ActivityEventInfo.GetStageData = GetStageData
ActivityEventInfo.GetScoreByStage = GetScoreByStage
ActivityEventInfo.GetCurStage = GetCurStage
ActivityEventInfo.IsAtFinishStage = IsAtFinishStage
ActivityEventInfo.GetStageQuests = GetStageQuests
ActivityEventInfo.GetStageScoreMethods = GetStageScoreMethods
ActivityEventInfo.GetSelfRankingByStage = GetSelfRankingByStage
ActivityEventInfo.GetCurStageStarTime = GetCurStageStarTime
ActivityEventInfo.GetCurStageEndTime = GetCurStageEndTime
ActivityEventInfo.GetCurStageRemainTime = GetCurStageRemainTime
ActivityEventInfo.GetStageGiftPackGroupId = GetStageGiftPackGroupId
ActivityEventInfo.GetStageDesc = GetStageDesc
ActivityEventInfo.GetRewardScience = GetRewardScience
ActivityEventInfo.InitRewardScience = InitRewardScience
ActivityEventInfo.CheckIfShowCrossDesert = CheckIfShowCrossDesert
ActivityEventInfo.GetHeroTrialStageQuests = GetHeroTrialStageQuests
ActivityEventInfo.CheckBoxHaveNewReward = CheckBoxHaveNewReward
return ActivityEventInfo
