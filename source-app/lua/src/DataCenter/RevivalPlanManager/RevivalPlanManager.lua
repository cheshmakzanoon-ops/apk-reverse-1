local RevivalPlanManager = BaseClass("RevivalPlanManager")

function RevivalPlanManager:__init()
  self.rankingData = {}
  self.boxRewardPreviewMap = {}
  self.rankingRewardData = {}
end

function RevivalPlanManager:__delete()
  self.rankingData = nil
  self.boxRewardPreviewMap = nil
  self.tryChangeKeys = nil
  self.rankingRewardData = nil
end

function RevivalPlanManager:OnEnterGame()
  self.keyMap = nil
  self.numberArray = nil
  self.tryChangeKeys = 0
  self.keyCountMap = nil
end

function RevivalPlanManager:OnGetInfo(info)
end

function RevivalPlanManager:GetActivityKeyId(activityInfoData)
  if self.keyMap then
    local map = self.keyMap[activityInfoData.activityId]
    if map ~= nil then
      return map[1], map[2]
    end
    local para = activityInfoData.para_1
    if string.IsNullOrEmpty(para) then
      self.keyMap[activityInfoData.activityId] = {0, 0}
      return 0, 0
    end
    local array = string.split(para, ";")
    if 1 < #array then
      local key = tonumber(array[1]) or 0
      local count = tonumber(array[2]) or 0
      self.keyMap[activityInfoData.activityId] = {key, count}
      return key, count
    end
    self.keyMap[activityInfoData.activityId] = {0, 0}
    return 0, 0
  end
  self.keyMap = {}
  local para = activityInfoData.para_1
  if string.IsNullOrEmpty(para) then
    self.keyMap[activityInfoData.activityId] = {0, 0}
    return 0, 0
  end
  local array = string.split(para, ";")
  if 1 < #array then
    local key = tonumber(array[1]) or 0
    local count = tonumber(array[2]) or 0
    self.keyMap[activityInfoData.activityId] = {key, count}
    return key, count
  end
  self.keyMap[activityInfoData.activityId] = {0, 0}
  return 0, 0
end

function RevivalPlanManager:GetActivityKeyCount(activityInfoData)
  if self.keyCountMap then
    local count = self.keyCountMap[activityInfoData.activityId]
    if count ~= nil then
      return count
    end
    local para = activityInfoData.para
    if string.IsNullOrEmpty(para) then
      count = 0
      self.keyCountMap[activityInfoData.activityId] = count
      return count
    end
    local array = string.split(para, ";")
    if 1 < #array then
      count = tonumber(array[2]) or 0
      self.keyCountMap[activityInfoData.activityId] = count
      return count
    end
    self.keyCountMap[activityInfoData.activityId] = 0
    return 0
  end
  self.keyCountMap = {}
  local para = activityInfoData.para
  if string.IsNullOrEmpty(para) then
    local count = 0
    self.keyCountMap[activityInfoData.activityId] = count
    return count
  end
  local array = string.split(para, ";")
  if 1 < #array then
    local count = tonumber(array[2]) or 0
    self.keyCountMap[activityInfoData.activityId] = count
    return count
  end
  self.keyCountMap[activityInfoData.activityId] = 0
  return 0
end

function RevivalPlanManager:GetRandomNumberShow(activityId, count)
  if not self:PrepareEventInfo(activityId) then
    return ""
  end
  if self.numberArray == nil then
    self.numberArray = {}
    local oriNumber = self.eventInfo.extraData.randomNum or 0
    for i = 1, 5 do
      local remainder = math.fmod(oriNumber, 10)
      oriNumber = math.modf(oriNumber / 10)
      self.numberArray[5 - i + 1] = remainder
    end
  end
  return string.format("%s %s %s %s %s", 1 <= count and self.numberArray[1] or "-", 2 <= count and self.numberArray[2] or "-", 3 <= count and self.numberArray[3] or "-", 4 <= count and self.numberArray[4] or "-", 5 <= count and self.numberArray[5] or "-")
end

function RevivalPlanManager:GetBoxRewardPreview(activityInfoData)
  local activityId = activityInfoData.activityId
  local reward = self.boxRewardPreviewMap[activityId]
  if reward ~= nil then
    return reward
  end
  local para = activityInfoData.para_2
  if not string.IsNullOrEmpty(para) then
    reward = DataCenter.RewardManager:ParseRewardsStr(para)
  else
    reward = {}
  end
  self.boxRewardPreviewMap[activityId] = reward
  return reward
end

function RevivalPlanManager:PrepareEventInfo(activityId)
  if self.eventInfo == nil then
    self.eventInfo = DataCenter.ActivityListDataManager:GetActEventInfo(activityId)
  end
  if self.eventInfo == nil then
    return false
  end
  return true
end

function RevivalPlanManager:GetCurStage(activityId)
  if not self:PrepareEventInfo(activityId) then
    return 0
  end
  return self.eventInfo:GetCurStage()
end

function RevivalPlanManager:GetCurStageRemainTime(activityId)
  if not self:PrepareEventInfo(activityId) then
    return 0
  end
  return self.eventInfo:GetCurStageRemainTime()
end

function RevivalPlanManager:GetStages(activityId)
  if not self:PrepareEventInfo(activityId) then
    return {}
  end
  return self.eventInfo.stages
end

function RevivalPlanManager:GetStageInfo(activityId, stageIndex)
  if not self:PrepareEventInfo(activityId) then
    return {}
  end
  local infoArray = self.eventInfo.extraData.infoArray
  if infoArray then
    return infoArray[stageIndex]
  end
  return {}
end

function RevivalPlanManager:GetCurStageInfo(activityId)
  if not self:PrepareEventInfo(activityId) then
    return {}
  end
  local infoArray = self.eventInfo.extraData.infoArray
  if infoArray then
    local stages = self.eventInfo.stages
    local curStage = self.eventInfo:GetCurStage()
    if stages then
      local index = table.indexof(stages, curStage)
      if index then
        return infoArray[index]
      end
    end
  end
  return {}
end

function RevivalPlanManager:GetTotalScore(activityId)
  if not self:PrepareEventInfo(activityId) then
    return 0
  end
  return self.eventInfo.extraData.totalScore or 0
end

function RevivalPlanManager:GetTotalRank(activityId)
  if not self:PrepareEventInfo(activityId) then
    return 0
  end
  return self.eventInfo.extraData.totalRank or 0
end

function RevivalPlanManager:GetBoxOpened(activityId)
  if not self:PrepareEventInfo(activityId) then
    return false
  end
  local boxOpen = self.eventInfo.extraData.boxOpen or 0
  return boxOpen == 1
end

function RevivalPlanManager:ClaimReward(index, stageId)
  SFSNetwork.SendMessage(MsgDefines.RevivalClaimScoreReward, index, stageId)
end

function RevivalPlanManager:OnClaimReward(msg)
  self.tryChangeKeys = 0
  local oldHas = -1
  local keyId = -1
  if self.eventInfo then
    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.eventInfo.activityId)
    if activityData then
      keyId = self:GetActivityKeyId(activityData)
      if 0 < keyId then
        oldHas = DataCenter.ItemData:GetItemCount(keyId)
      end
    end
  end
  DataCenter.RewardManager:ShowCommonReward(msg, nil, nil, nil, nil, nil, function()
    DataCenter.RevivalPlanManager:TryChangeKeys()
  end)
  DataCenter.RewardManager:AddRewardsAndRes(msg)
  local newHas = -1
  if 0 < keyId then
    newHas = DataCenter.ItemData:GetItemCount(keyId)
  end
  if -1 < newHas and -1 < oldHas then
    self.tryChangeKeys = newHas - oldHas
  end
  if self.eventInfo == nil then
    return
  end
  local infoArray = self.eventInfo.extraData.infoArray
  local stage = msg.cur_stage
  stage = stage or self.eventInfo:GetCurStage()
  local stages = self.eventInfo.stages
  if stages then
    local index = table.indexof(stages, stage)
    if index then
      local info = infoArray[index]
      if info then
        info.indexList = msg.indexList
        EventManager:GetInstance():Broadcast(EventId.OnRevivalPlanClaimReward)
        EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
      end
    end
  end
end

function RevivalPlanManager:TryChangeKeys()
  if self.tryChangeKeys and self.tryChangeKeys > 0 then
    EventManager:GetInstance():Broadcast(EventId.RevivalPlanTryChangeKeys, self.tryChangeKeys)
  end
end

function RevivalPlanManager:OpenBox()
  SFSNetwork.SendMessage(MsgDefines.RevivalOpenRewardBox)
end

function RevivalPlanManager:OnBoxOpenReward(msg)
  DataCenter.RewardManager:AddRewardsAndRes(msg)
  if msg and msg.reward then
    local rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(msg.reward) or {}
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRevivalPlaneBoxReward, {anim = true}, rewardList)
  end
  if self.eventInfo == nil then
    return
  end
  self.eventInfo.extraData.boxOpen = msg.boxOpen or 0
  EventManager:GetInstance():Broadcast(EventId.OnRevivalPlanBoxOpen)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function RevivalPlanManager:ParseRankingData(message)
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

function RevivalPlanManager:GetRankingData(stage)
  return self.rankingData[stage]
end

function RevivalPlanManager:GetRedCount(activityId)
  if not self:PrepareEventInfo(activityId) then
    return 0, 0, 0
  end
  local redCount = 0
  local tipCount = 0
  local stages = self:GetStages(activityId)
  local curStage = self:GetCurStage(activityId)
  for index, v in ipairs(stages) do
    local count = self:GetStageRedCount(activityId, index)
    redCount = redCount + count
    if v == curStage then
      break
    end
  end
  local isOpen = self:GetBoxOpened(activityId)
  if isOpen then
    return redCount, redCount, 0
  end
  local activityInfoData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  local needCount = 5
  local keyId = self:GetActivityKeyId(activityInfoData)
  if 0 < keyId then
    local has = DataCenter.ItemData:GetItemCount(keyId)
    if needCount <= has then
      tipCount = 1
    end
  end
  return redCount + tipCount, redCount, tipCount
end

function RevivalPlanManager:GetStageRedCount(activityId, index)
  local redCount = 0
  local curInfo = self:GetStageInfo(activityId, index)
  local score = curInfo.score or 0
  local stages = self:GetStages(activityId)
  local curStage = stages[index]
  if not curStage then
    return 0
  end
  local cfg = DataCenter.ActivityRevivalConfigTemplateManager:GetTemplate(curStage)
  if cfg then
    local score_list = cfg.score_list
    local count = 0
    for i = 1, #score_list do
      if score >= score_list[i] then
        count = count + 1
      else
        break
      end
    end
    local claimCount = 0
    if curInfo.indexList then
      claimCount = #curInfo.indexList
    end
    redCount = count - claimCount
    redCount = Mathf.Max(0, redCount)
  end
  return redCount
end

function RevivalPlanManager:PushRevivalRedPoint(msg)
  if self.eventInfo then
    SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(self.eventInfo.activityId))
  end
end

function RevivalPlanManager:RefreshKeyReplaceState()
  if self.eventInfo == nil then
    return
  end
  local activityInfoData = DataCenter.ActivityListDataManager:GetActivityDataById(self.eventInfo.activityId)
  if activityInfoData == nil then
    return
  end
  local key = self:GetActivityKeyId(activityInfoData)
  local maxCount = self:GetActivityKeyCount(activityInfoData)
  if key == 0 or maxCount == 0 then
    return
  end
  local infoArray = self.eventInfo.extraData.infoArray
  if infoArray == nil then
    return
  end
  local curStage = self.eventInfo:GetCurStage()
  local pink = false
  local curCount = 0
  for i, info in ipairs(infoArray) do
    if i ~= curStage then
      if info.replaceKey == nil then
        info.replaceKey = {}
        local replaceCount = self:CheckKeyReplaceImp(info, i, maxCount - curCount, key)
        curCount = curCount + replaceCount
      end
    elseif i == curStage then
      pink = true
      if info.replaceKey == nil then
        info.replaceKey = {}
      end
      local replaceCount = self:CheckKeyReplaceImp(info, i, maxCount - curCount, key, true)
      curCount = replaceCount + curCount
    elseif pink then
      break
    end
  end
end

function RevivalPlanManager:CheckKeyReplaceImp(info, i, remainCount, key, currentStage)
  local score = info.score
  local replaceCount = 0
  local cfg = DataCenter.ActivityRevivalConfigTemplateManager:GetTemplate(i)
  if cfg ~= nil then
    local score_list = cfg.score_list
    local parsed_base_reward_show = cfg:GetParsedBaseRewardShow()
    for j, tScore in ipairs(score_list) do
      local rewards = parsed_base_reward_show[j]
      if rewards then
        for _, reward in ipairs(rewards) do
          if reward and reward.itemId and reward.itemId == key then
            if tScore <= score then
              if 0 < remainCount then
                info.replaceKey[j] = true
                remainCount = remainCount - 1
                replaceCount = replaceCount + 1
              end
            elseif 0 < remainCount then
              info.replaceKey[j] = true
              if currentStage then
                remainCount = remainCount - 1
                replaceCount = replaceCount + 1
              end
            end
          end
        end
      end
    end
  end
  return replaceCount
end

function RevivalPlanManager:ParseRankingRewardData(message)
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

function RevivalPlanManager:GetRankingRewardData(stage)
  return self.rankingRewardData[stage]
end

return RevivalPlanManager
