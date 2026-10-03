local SeasonRewardDataManager = BaseClass("SeasonRewardDataManager")
local Localization = CS.GameEntry.Localization
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")
local AllianceSeasonRewardMember = require("DataCenter.AllianceData.AllianceSeasonRewardMember")
local SeasonAchievementTemplate = require("DataCenter.SeasonManager.SeasonAchievementTemplate")

function SeasonRewardDataManager:__init()
  self.seasonAchievementsTemp = {}
  self.seasonAchievementsGroupTemp = nil
  self.personalRewardData = nil
  self.personalOccupyLandCount = nil
  self.occupyLandMax = nil
  self.seasonAllianceReward = nil
  self.seasonAllianceRewardTier = 0
  self.seasonCrossServerForceRankRewardInfo = nil
  self.seasonCampRankRewardInfo = nil
  self.seasonRewardMemeberList = nil
  self.seasonFamerRankRewardInfo = nil
  self.publishRewards = 0
  self.publishTime = nil
  self.curOpenRewardTier = nil
  self.rewardMailIconPath = {}
  self.seasonScoreTabRed = {}
  self.seasonCampRewardTabRed = {}
  self.achievementTempDic = {}
end

function SeasonRewardDataManager:__delete()
  self.personalRewardData = nil
  self.personalOccupyLandCount = nil
  self.occupyLandMax = nil
  self.seasonAchievementsGroupTemp = nil
  self.seasonCrossServerForceRankRewardInfo = nil
  self.seasonAllianceRewardTier = nil
  self.seasonAllianceReward = nil
  self.seasonRewardMemeberList = nil
  self.curOpenRewardTier = nil
  self.publishRewards = nil
  self.publishTime = nil
  self.rewardMailIconPath = nil
  self.seasonCampRewardTabRed = nil
  self.achievementTempDic = nil
end

function SeasonRewardDataManager:OnEnterGame()
  self:InitAchievementsGroupData(false)
end

function SeasonRewardDataManager:InitAchievementsGroupData(forceInit, needRequestData)
  local mainLv = toInt(DataCenter.BuildManager.MainLv)
  if mainLv < 3 or SeasonUtil.GetSeasonType() == SeasonMapType.Nothing then
    return
  end
  if self.seasonAchievementsGroupTemp ~= nil and needRequestData == nil then
    return
  end
  self.seasonAchievementsGroupTemp = {}
  LocalController:instance():visitTable(TableName.LW_Season_Achievements, function(id, lineData)
    local template = SeasonAchievementTemplate.New(lineData)
    self.seasonAchievementsTemp[id] = template
    local groupList = self.seasonAchievementsGroupTemp[template.group]
    if groupList == nil then
      groupList = {}
      self.seasonAchievementsGroupTemp[template.group] = groupList
    end
    table.insert(groupList, template)
  end)
  for key, value in pairs(self.seasonAchievementsGroupTemp) do
    table.sort(value, function(l, r)
      return l.order < r.order
    end)
  end
  local achievementGroup = SeasonUtil.GetSeasonAchievementsGroup()
  if SeasonUtil.IsInSeasonCityStrongholdMode() and achievementGroup == 0 then
    if not self.personalRewardData or not self.personalRewardData[SeasonScoreRewardPanelType.PersonalContributeAchievement] then
      SFSNetwork.SendMessage(MsgDefines.LWSeasonContributeAchievement, 1)
    end
    if (not self.personalRewardData or not self.personalRewardData[SeasonScoreRewardPanelType.AllianceStrongholdAchivement]) and LuaEntry.Player:IsInAlliance() then
      SFSNetwork.SendMessage(MsgDefines.LWSeasonStrongholdAchievement, 1)
    end
    SeasonUtil.SendFarmerAchievementData()
  elseif achievementGroup ~= 0 then
    local achieveData = self.seasonAchievementsGroupTemp[achievementGroup]
    if achieveData then
      for key, value in pairs(achieveData) do
        local id = toInt(value.id)
        if (not self.personalRewardData or not self.personalRewardData[id]) and (value.flag == SeasonAchivementFlag.Personal or value.flag == SeasonAchivementFlag.Alliance and LuaEntry.Player:IsInAlliance() or value.flag == SeasonAchivementFlag.Camp) then
          SFSNetwork.SendMessage(MsgDefines.UserSesaonAchievementV2Info, id)
        end
      end
    end
  end
end

function SeasonRewardDataManager:GetAchievementsGroupData()
  self:InitAchievementsGroupData(true)
  return self.seasonAchievementsGroupTemp
end

function SeasonRewardDataManager:GetAchievementsGroups(flagFilter, group)
  local groups = self:GetAchievementsGroupData()
  local curGroup = group or SeasonUtil.GetSeasonAchievementsGroup()
  local list = groups[curGroup]
  if not list then
    return {}
  end
  if not flagFilter then
    return list
  else
    local rst = {}
    for k, template in ipairs(list) do
      if template and template.flag and flagFilter[template.flag] then
        table.insert(rst, template)
      end
    end
    return rst
  end
end

function SeasonRewardDataManager:CheckAchievementCampType(achievementId)
  local temp = self.achievementTempDic and self.achievementTempDic[achievementId]
  if temp then
    return temp.flag == SeasonAchivementFlag.Camp
  end
  local groups = self:GetAchievementsGroupData()
  local curGroup = SeasonUtil.GetSeasonAchievementsGroup()
  local list = groups[curGroup]
  if not list then
    return false
  end
  local rst = false
  for k, template in ipairs(list) do
    self.achievementTempDic[template.id] = template
    if template.id == achievementId then
      rst = template.flag == SeasonAchivementFlag.Camp
    end
  end
  return rst
end

function SeasonRewardDataManager:SetOpenRewardTier(tier)
  self.curOpenRewardTier = tier
end

function SeasonRewardDataManager:GetOpenRewardTier()
  return self.curOpenRewardTier
end

function SeasonRewardDataManager:InitPersonalData(msg, type)
  if not self.occupyLandMax then
    self.occupyLandMax = {}
  end
  if not self.personalOccupyLandCount then
    self.personalOccupyLandCount = {}
  end
  if type == SeasonScoreRewardPanelType.PersonalOccupyLand then
    self.personalOccupyLandCount[type] = msg.maxForceValue or 0
    local red = false
    if msg.list then
      if not self.personalRewardData then
        self.personalRewardData = {}
      end
      self.personalRewardData[type] = {}
      for i, v in ipairs(msg.list) do
        local item = {}
        item.score = v.score
        item.id = v.id
        item.rewards = DataCenter.RewardManager:ReturnRewardParamForView(v.reward)
        item.receive = v.receive
        if self.occupyLandMax[type] == nil or self.occupyLandMax[type] < v.score then
          self.occupyLandMax[type] = v.score
        end
        self.personalRewardData[type][i] = item
        if not red and v.score <= msg.maxForceValue and not item.receive then
          red = true
        end
      end
      self.seasonScoreTabRed[type] = red
      EventManager:GetInstance():Broadcast(EventId.LWSeasonPersonalRewardInfo)
      EventManager:GetInstance():Broadcast(EventId.LWSeasonPersonalRewardGetRedPoint, type)
    end
  else
    local userInfo = msg.user
    self.personalOccupyLandCount[type] = userInfo.score
    local red = false
    if msg.rewardInfo then
      if not self.personalRewardData then
        self.personalRewardData = {}
      end
      self.personalRewardData[type] = {}
      local receiveCache = {}
      for key, value in pairs(userInfo.record) do
        receiveCache[value] = true
      end
      for i, v in ipairs(msg.rewardInfo) do
        local item = {}
        item.score = v.score
        item.id = v.id
        item.rewards = DataCenter.RewardManager:ReturnRewardParamForView(v.reward)
        item.receive = receiveCache[v.id]
        if self.occupyLandMax[type] == nil or self.occupyLandMax[type] < v.score then
          self.occupyLandMax[type] = v.score
        end
        self.personalRewardData[type][i] = item
        if not red and v.score <= userInfo.score and not item.receive then
          red = true
        end
      end
    end
    self.seasonScoreTabRed[type] = red
    EventManager:GetInstance():Broadcast(EventId.LWSeasonPersonalRewardInfo)
    EventManager:GetInstance():Broadcast(EventId.LWSeasonPersonalRewardGetRedPoint, type)
    EventManager:GetInstance():Broadcast(EventId.LWSeasonScoreRewardInfo, type)
  end
end

function SeasonRewardDataManager:UpdatePersonalOccupyLandCount(msg, type)
  if not self.personalOccupyLandCount then
    self.personalOccupyLandCount = {}
  end
  if type == SeasonScoreRewardPanelType.PersonalOccupyLand then
    if msg.maxForceValue then
      self.personalOccupyLandCount[type] = msg.maxForceValue
      if self:RefreshRewardTabRed(type) then
        EventManager:GetInstance():Broadcast(EventId.LWSeasonPersonalRewardGetRedPoint, type)
      end
    end
    EventManager:GetInstance():Broadcast(EventId.LWSeasonPersonalRewardInfo)
  else
    self.personalOccupyLandCount[type] = msg.score
    if msg.record and #msg.record > 0 then
      local tRewardData = self.personalRewardData[type]
      local falgMap = {}
      for index, value in ipairs(msg.record) do
        tRewardData[value].receive = true
      end
      if self:RefreshRewardTabRed(type) then
        EventManager:GetInstance():Broadcast(EventId.LWSeasonPersonalRewardGetRedPoint, type)
      end
    end
    EventManager:GetInstance():Broadcast(EventId.LWSeasonPersonalRewardInfo)
  end
end

function SeasonRewardDataManager:GetPersonalRewardData(neddSend, type)
  local msgState, result
  if not self.personalRewardData or not self.personalRewardData[type] then
    msgState = 1
  else
    result = self.personalRewardData[type]
    msgState = 2
  end
  if neddSend or msgState == 1 then
    if type == SeasonScoreRewardPanelType.PersonalOccupyLand then
      SFSNetwork.SendMessage(MsgDefines.LWSeasonUserMaxForceRewardInfo)
    elseif type == SeasonScoreRewardPanelType.PersonalContributeAchievement then
      SFSNetwork.SendMessage(MsgDefines.LWSeasonContributeAchievement, msgState)
    elseif type == SeasonScoreRewardPanelType.AllianceStrongholdAchivement then
      if LuaEntry.Player:IsInAlliance() then
        SFSNetwork.SendMessage(MsgDefines.LWSeasonStrongholdAchievement, msgState)
      else
        return nil
      end
    end
  end
  return result
end

function SeasonRewardDataManager:GetPersonalRewardClaimIndex(type)
  if self.personalRewardData[type] then
    for index, value in ipairs(self.personalRewardData[type]) do
      if value.score <= self.personalOccupyLandCount[type] and not value.receive then
        return index
      end
    end
  end
  return nil
end

function SeasonRewardDataManager:GetPersonalRewardScore(type, index)
  return self.personalRewardData[type][index].score
end

function SeasonRewardDataManager:GetPersonalOccupyLandCount(type)
  if self.personalOccupyLandCount and self.personalOccupyLandCount[type] then
    return self.personalOccupyLandCount[type]
  end
  return 0
end

function SeasonRewardDataManager:GetPersonalRewardProgress(type)
  return self.personalOccupyLandCount[type] / self.occupyLandMax[type]
end

function SeasonRewardDataManager:GetSelectRewardSuccess(message, type)
  local selectId
  if type == SeasonScoreRewardPanelType.PersonalOccupyLand then
    selectId = message.selectId
  else
    selectId = message.id
  end
  local rewardData = self.personalRewardData[type][selectId]
  rewardData.receive = true
  if self:RefreshRewardTabRed(type) then
    EventManager:GetInstance():Broadcast(EventId.LWSeasonPersonalRewardGetRedPoint, type)
  end
  EventManager:GetInstance():Broadcast(EventId.LWSeasonPersonalRewardGetSuccess)
  if message.reward then
    DataCenter.RewardManager:ShowGiftReward(message)
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
end

function SeasonRewardDataManager:GetAllRewardSuccess(message, type)
  local flag = false
  if not string.IsNullOrEmpty(message.receiveIds) then
    local ids = string.split(message.receiveIds, ",")
    if ids and 0 < #ids then
      for _, id in ipairs(ids) do
        for index, value in ipairs(self.personalRewardData[type]) do
          if value.id == tonumber(id) then
            flag = true
            value.receive = true
            break
          end
        end
      end
    end
  end
  if message.reward then
    DataCenter.RewardManager:ShowGiftReward(message)
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
  if flag then
    if self:RefreshRewardTabRed(type) then
      EventManager:GetInstance():Broadcast(EventId.LWSeasonPersonalRewardGetRedPoint, type)
    end
    EventManager:GetInstance():Broadcast(EventId.LWSeasonPersonalRewardGetSuccess)
  end
end

function SeasonRewardDataManager:ServerCrossForceRankRewardInfoUpdate(message)
  if self.seasonCrossServerForceRankRewardInfo == nil then
    self.seasonCrossServerForceRankRewardInfo = {}
  end
  local flag = false
  if self.seasonCrossServerForceRankRewardInfo.rewardInfo == nil and message.list then
    self.seasonCrossServerForceRankRewardInfo.rewardInfo = {}
    for index, value in ipairs(message.list) do
      local data = {}
      data.condition = value.condition
      data.reward = DataCenter.RewardManager:ReturnRewardParamForView(value.reward)
      table.insert(self.seasonCrossServerForceRankRewardInfo.rewardInfo, data)
    end
    flag = true
  end
  if flag then
    EventManager:GetInstance():Broadcast(EventId.LWSeasonServerFarmRankRewardInfoUpdate)
  end
end

function SeasonRewardDataManager:GetServerCrossForceRankRewardInfo()
  return self.seasonCrossServerForceRankRewardInfo
end

function SeasonRewardDataManager:SeasonCampInfoUpdate(message)
  if self.seasonCampRankRewardInfo == nil then
    self.seasonCampRankRewardInfo = {}
  end
  if message.rewards then
    self.seasonCampRankRewardInfo.rewardInfo = {}
    local commonId
    for index, value in ipairs(message.rewards) do
      local data = {}
      local condition = 1
      local id = value.id
      if commonId == nil then
        commonId = value.id
      end
      local line = LocalController:instance():getLine(TableName.LW_Season_Camp_Reward, id)
      local titleData = string.split(line.rank_name, ";")
      data.title = Localization:GetString(titleData[1], titleData[2])
      data.titleDes = Localization:GetString(line.rank_dec)
      data.reward = DataCenter.RewardManager:ReturnRewardParamForView(value.reward)
      data.tier = checknumber(line.tier)
      table.insert(self.seasonCampRankRewardInfo.rewardInfo, data)
    end
    table.sort(self.seasonCampRankRewardInfo.rewardInfo, function(a, b)
      return a.tier < b.tier
    end)
    local line = LocalController:instance():getLine(TableName.LW_Season_Camp_Reward, commonId)
    if not line then
      return
    end
    local personDes = string.split(line.group_condition_dec, ";")
    self.seasonCampRankRewardInfo.personalCondition = Localization:GetString(personDes[1], personDes[2])
    self.seasonCampRankRewardInfo.helpDes = Localization:GetString(line.help)
  end
  self.seasonCampRankRewardInfo.tier = checknumber(message.tier)
  EventManager:GetInstance():Broadcast(EventId.LWSeasonCampRankRewardInfoUpdate)
end

function SeasonRewardDataManager:GetSeasonCampRankRewardInfo()
  return self.seasonCampRankRewardInfo
end

function SeasonRewardDataManager:SeasonFamerRankRewardInfoUpdate(message)
  if self.seasonFamerRankRewardInfo == nil then
    self.seasonFamerRankRewardInfo = {}
  end
  if self.seasonFamerRankRewardInfo.rewardInfo == nil and message.ls then
    self.seasonFamerRankRewardInfo.rewardInfo = {}
    for index, value in ipairs(message.ls) do
      local data = {}
      local condition
      if value.min == value.max then
        condition = value.min
      else
        condition = string.format("%d-%d", value.min, value.max)
      end
      data.title = Localization:GetString("season_builders_alliance_UI_61", condition)
      data.titleDes = Localization:GetString("season_builders_alliance_UI_62")
      data.reward = DataCenter.RewardManager:ReturnRewardParamForView(value.reward)
      table.insert(self.seasonFamerRankRewardInfo.rewardInfo, data)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.LWSeasonCampRankRewardInfoUpdate)
end

function SeasonRewardDataManager:GetSeasonFamerRankRewardInfo()
  return self.seasonFamerRankRewardInfo
end

function SeasonRewardDataManager:GetSeasonGreenRankRewardInfo()
  return self.seasonGreenRankRewardInfo
end

function SeasonRewardDataManager:SeasonGreenCityRankRewardInfo(rankReward)
  if not self.seasonGreenRankRewardInfo then
    self.seasonGreenRankRewardInfo = {}
  end
  if self.seasonGreenRankRewardInfo.rewardInfo == nil and rankReward then
    self.seasonGreenRankRewardInfo.rewardInfo = {}
    local desc, title = Localization:GetString("season_oasis_UI_23")
    for index, value in ipairs(rankReward) do
      local data = {}
      if value.rankStart == value.rankEnd then
        title = Localization:GetString("season_oasis_UI_22", value.rankStart)
      else
        title = Localization:GetString("season_oasis_UI_22", string.format("%s-%s", value.rankStart, value.rankEnd))
      end
      data.title = title
      data.titleDes = desc
      data.reward = DataCenter.RewardManager:ReturnRewardParamForView(value.reward)
      table.insert(self.seasonGreenRankRewardInfo.rewardInfo, data)
    end
    self.seasonGreenRankRewardInfo.personalCondition = Localization:GetString("season_oasis_UI_24")
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonGreenCityRankReward)
end

function SeasonRewardDataManager:RefreshRewardTabRed(type)
  local preFlag = self.seasonScoreTabRed[type] ~= nil and self.seasonScoreTabRed[type] or false
  self.seasonScoreTabRed[type] = false
  if self.personalRewardData then
    local data = self.personalRewardData[type]
    if data then
      for index, value in ipairs(data) do
        if not value.receive and value.score <= self.personalOccupyLandCount[type] then
          self.seasonScoreTabRed[type] = true
          break
        end
      end
    end
  end
  local newFlag = self.seasonScoreTabRed[type] ~= nil and self.seasonScoreTabRed[type] or false
  return preFlag ~= newFlag
end

function SeasonRewardDataManager:RefreshCampAchievementRewardTabRed(type)
  local preFlag = self.seasonCampRewardTabRed[type] ~= nil and self.seasonCampRewardTabRed[type] or false
  self.seasonCampRewardTabRed[type] = false
  if self.personalRewardData then
    local data = self.personalRewardData[type]
    if data then
      for index, value in ipairs(data) do
        if not value.receive and value.score <= self.personalOccupyLandCount[type] then
          self.seasonCampRewardTabRed[type] = true
          break
        end
      end
    end
  end
  local newFlag = self.seasonCampRewardTabRed[type] ~= nil and self.seasonCampRewardTabRed[type] or false
  return preFlag ~= newFlag
end

function SeasonRewardDataManager:IsGetRewardTabRed(type)
  if type == SeasonScoreRewardPanelType.AllianceStrongholdAchivement and not LuaEntry.Player:IsInAlliance() then
    return false
  end
  if self.seasonScoreTabRed then
    local result = self.seasonScoreTabRed[type]
    return result ~= nil and result or false
  end
  return false
end

function SeasonRewardDataManager:IsCampAchievementRewardTabFuckRed()
  if not self.seasonCampRewardTabRed then
    return false
  end
  for k, v in pairs(self.seasonCampRewardTabRed) do
    if v then
      return true
    end
  end
  return false
end

function SeasonRewardDataManager:GetAllianceRewardConditionData(index)
  local result = {}
  if self.seasonAllianceReward and index <= #self.seasonAllianceReward then
    local rewardData = self.seasonAllianceReward[index]
    if rewardData then
      local configId = self.seasonAllianceReward[index].configId
      local line = LocalController:instance():getLine(TableName.LW_Season_Alliance_Reward, configId)
      if not rewardData.conditionGroups and line and line.rank_condition then
        local conditionGroups = string.split(line.rank_condition, "#")
        if conditionGroups then
          rewardData.conditionGroups = {}
          local taskIndex = 1
          for _, conditionGroup in ipairs(conditionGroups) do
            local groupData = {}
            local conditions = string.split(conditionGroup, "|")
            if conditions then
              for _, condition in ipairs(conditions) do
                local conditionData = self:ParseAllianceRewardCondition(taskIndex, condition)
                table.insert(groupData, conditionData)
                taskIndex = taskIndex + 1
              end
              table.insert(rewardData.conditionGroups, groupData)
            end
          end
        end
      end
      if rewardData.conditionGroups and #rewardData.conditionGroups > 0 then
        local icons = string.split(line.rank_condition_icon, "#")
        local textConst = string.split(line.tier_text, "#")
        local progressConst = {}
        if not string.IsNullOrEmpty(line.schedule_text) then
          progressConst = string.split(line.schedule_text, "#")
        end
        for i = 1, #rewardData.conditionGroups do
          result[i] = {}
          result[i].isFinish = false
          result[i].icon = icons[i]
          result[i].title = textConst[i]
          result[i].progress = progressConst[i]
          result[i].conditions = {}
          if 0 < table.count(rewardData.conditionGroups[i]) then
            result[i].isFinish = true
            for j, condition in ipairs(rewardData.conditionGroups[i]) do
              local curValue = rewardData.progress and rewardData.progress[condition.taskIndex] or 0
              local v = self:GenerateAllianceRewardConditionData(condition, curValue)
              result[i].isFinish = result[i].isFinish and v.isFinish
              table.insert(result[i].conditions, v)
            end
          end
        end
        return result
      end
    end
  end
  return result
end

function SeasonRewardDataManager:GetAllianceRewardData(index)
  local result = {}
  if self.seasonAllianceReward and index <= #self.seasonAllianceReward then
    return self.seasonAllianceReward[index].rewardInfo
  end
  return result
end

function SeasonRewardDataManager:GetAllianceRewardConfigData(index)
  if self.seasonAllianceReward and index <= #self.seasonAllianceReward then
    return self.seasonAllianceReward[index].configId
  end
  return nil
end

function SeasonRewardDataManager:GetRewardRemain(index)
  local result = {}
  if index == nil then
    local rewardInfo = DataCenter.SeasonRewardDataManager:GetAllianceRewardData(1)
    if rewardInfo then
      local size = #rewardInfo
      for i = 1, size - 1 do
        result[i] = 0
      end
    end
    return result
  end
  local rewardInfo = DataCenter.SeasonRewardDataManager:GetAllianceRewardData(index)
  if rewardInfo then
    local size = #rewardInfo
    for i = 1, size - 1 do
      result[i] = rewardInfo[i + 1].rewardCount
    end
  end
  return result
end

function SeasonRewardDataManager:ParseAllianceRewardCondition(taskIndex, condition)
  local par = string.split(condition, ";")
  if par then
    local result = {}
    result.taskIndex = taskIndex
    result.type = tonumber(par[1])
    if 2 <= #par then
      result.param = tonumber(par[2])
    end
    if 3 <= #par then
      result.param1 = tonumber(par[3])
    end
    if 4 <= #par then
      result.param2 = tonumber(par[4])
    end
    if 5 <= #par then
      result.param3 = tonumber(par[5])
    end
    if 6 <= #par then
      result.param4 = tonumber(par[6])
    end
    return result
  end
  return nil
end

function SeasonRewardDataManager:GenerateAllianceRewardConditionData(condition, curValue)
  local result = {}
  result.progress = checknumber(curValue)
  if condition.type == 1 then
    result.text = Localization:GetString("season_reward_info003", condition.param, curValue)
    result.isFinish = curValue >= condition.param
  elseif condition.type == 2 then
    result.text = Localization:GetString("season_reward_info001", condition.param, curValue)
    result.isFinish = curValue <= condition.param and curValue ~= 0
  elseif condition.type == 3 then
    result.text = Localization:GetString("season_reward_info002", condition.param, condition.param1, curValue)
    result.isFinish = curValue >= condition.param
  elseif condition.type == 4 then
    local paramStr1
    if condition.param == condition.param1 then
      paramStr1 = tostring(condition.param)
    else
      paramStr1 = tostring(condition.param) .. "-" .. tostring(condition.param1)
    end
    result.text = Localization:GetString("season_s2_rank_reward_18", paramStr1, curValue)
    result.isFinish = curValue >= condition.param and curValue <= condition.param1
  elseif condition.type == 5 then
    if condition.param ~= condition.param1 then
      result.text = Localization:GetString("season_s1_rank_reward_08", condition.param .. "-" .. condition.param1, curValue)
    else
      result.text = Localization:GetString("season_s1_rank_reward_08", condition.param, curValue)
    end
    result.isFinish = curValue >= condition.param and curValue <= condition.param1
  elseif condition.type == 6 then
    result.isFinish = curValue >= condition.param
  elseif condition.type == 7 then
    result.isFinish = curValue >= condition.param
  elseif condition.type == 8 then
    result.isFinish = curValue >= condition.param
  elseif condition.type == 9 then
    result.isFinish = 0 < curValue and curValue >= condition.param
  elseif condition.type == 10 then
    result.isFinish = curValue >= condition.param2
  elseif condition.type == 11 then
    result.isFinish = 0 < curValue and curValue >= condition.param2 and curValue <= condition.param3
    result.progress = math.max(0, result.progress)
  elseif condition.type == 12 then
    result.isFinish = 0 < curValue and curValue >= condition.param2 and curValue <= condition.param3
    result.progress = math.max(0, result.progress)
  elseif condition.type == 13 then
    result.isFinish = 0 < curValue and curValue >= condition.param
  else
    result.text = ""
    result.isFinish = false
  end
  return result
end

function SeasonRewardDataManager:InitAllianceRewardData(message)
  local rewardList = message.rewardList
  local progressList = message.progressList
  local top_reward = message.top_reward
  if not table.IsNullOrEmpty(rewardList) and self.seasonAllianceReward == nil then
    self.seasonAllianceReward = {}
    for index, value in ipairs(rewardList) do
      local configId = value.configId
      local line = LocalController:instance():getLine(TableName.LW_Season_Alliance_Reward, configId)
      if line then
        if self.seasonAllianceReward[line.tier] == nil then
          self.seasonAllianceReward[line.tier] = {}
          self.seasonAllianceReward[line.tier].configId = configId
        end
        self.seasonAllianceReward[line.tier].rewardInfo = {}
        local rewardInfo = {}
        rewardInfo.reward = DataCenter.RewardManager:ReturnRewardParamForView(value.leaderReward)
        rewardInfo.rewardCount = value.leaderRewardNum
        rewardInfo.rewardMax = value.leaderRewardNum
        rewardInfo.order = 1
        rewardInfo.rewardIndex = 4
        rewardInfo.tittle = Localization:GetString("season_reward_ui_003")
        table.insert(self.seasonAllianceReward[line.tier].rewardInfo, rewardInfo)
        rewardInfo = {}
        rewardInfo.reward = DataCenter.RewardManager:ReturnRewardParamForView(value.coreReward)
        rewardInfo.rewardCount = value.coreRewardNum
        rewardInfo.rewardMax = value.coreRewardNum
        rewardInfo.tittle = Localization:GetString("season_reward_ui_004")
        rewardInfo.order = 3
        rewardInfo.rewardIndex = 1
        table.insert(self.seasonAllianceReward[line.tier].rewardInfo, rewardInfo)
        rewardInfo = {}
        rewardInfo.reward = DataCenter.RewardManager:ReturnRewardParamForView(value.eliteReward)
        rewardInfo.rewardCount = value.eliteRewardNum
        rewardInfo.rewardMax = value.eliteRewardNum
        rewardInfo.tittle = Localization:GetString("season_reward_ui_005")
        rewardInfo.order = 4
        rewardInfo.rewardIndex = 2
        table.insert(self.seasonAllianceReward[line.tier].rewardInfo, rewardInfo)
        rewardInfo = {}
        rewardInfo.reward = DataCenter.RewardManager:ReturnRewardParamForView(value.memberReward)
        rewardInfo.rewardCount = value.memberRewardNum
        rewardInfo.rewardMax = value.memberRewardNum
        rewardInfo.tittle = Localization:GetString("season_reward_ui_006")
        rewardInfo.order = 5
        rewardInfo.rewardIndex = 3
        table.insert(self.seasonAllianceReward[line.tier].rewardInfo, rewardInfo)
        if value.commanderReward and value.commanderRewardNum then
          local rewardInfo = {}
          rewardInfo.reward = DataCenter.RewardManager:ReturnRewardParamForView(value.commanderReward)
          rewardInfo.rewardCount = value.commanderRewardNum
          rewardInfo.rewardMax = value.commanderRewardNum
          rewardInfo.tittle = Localization:GetString("season_s3_rank_reward_27")
          rewardInfo.order = 2
          rewardInfo.rewardIndex = 5
          table.insert(self.seasonAllianceReward[line.tier].rewardInfo, rewardInfo)
        end
      end
    end
  end
  if not table.IsNullOrEmpty(top_reward) then
    self:SetAllianceRewardData(top_reward)
  end
  if not table.IsNullOrEmpty(progressList) then
    if self.seasonAllianceReward == nil then
    end
    for index, value in ipairs(progressList) do
      local configId = value.configId
      local line = LocalController:instance():getLine(TableName.LW_Season_Alliance_Reward, configId)
      if line and self.seasonAllianceReward and self.seasonAllianceReward[line.tier] ~= nil then
        self.seasonAllianceReward[line.tier].progress = {}
        if value.conditionValue and #value.conditionValue > 0 then
          for index, value in ipairs(value.conditionValue) do
            table.insert(self.seasonAllianceReward[line.tier].progress, toInt(value))
          end
        else
        end
      end
    end
  else
    for key, value in pairs(self.seasonAllianceReward) do
      local configId = value.configId
      local line = LocalController:instance():getLine(TableName.LW_Season_Alliance_Reward, configId)
      self.seasonAllianceReward[key].progress = {}
      if line and line.rank_condition then
        local conditionGroups = string.split(line.rank_condition, "#")
        for _, conditionGroup in pairs(conditionGroups) do
          local c = string.split(conditionGroup, "|")
          if c then
            for i, value in ipairs(c) do
              table.insert(self.seasonAllianceReward[key].progress, 0)
            end
          end
        end
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.LWSeasonAllianceRewardInfoUpdate)
end

function SeasonRewardDataManager:SetAllianceRewardData(top_reward, notice)
  local severInfo = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  if severInfo:InPreviewMode() then
    return
  end
  if top_reward and self.seasonAllianceReward then
    local configId = top_reward.top_id
    local core_left = top_reward.core_left or 0
    local elite_left = top_reward.elite_left or 0
    local member_left = top_reward.member_left or 0
    local commander_left = top_reward.commander_left or 0
    if configId then
      local line = LocalController:instance():getLine(TableName.LW_Season_Alliance_Reward, configId)
      if line then
        self.seasonAllianceRewardTier = tonumber(line.tier)
        local rewardData = self.seasonAllianceReward[line.tier]
        if rewardData and rewardData.rewardInfo then
          if rewardData.rewardInfo[2] then
            rewardData.rewardInfo[2].rewardCount = core_left
          end
          if rewardData.rewardInfo[3] then
            rewardData.rewardInfo[3].rewardCount = elite_left
          end
          if rewardData.rewardInfo[4] then
            rewardData.rewardInfo[4].rewardCount = member_left
          end
          if rewardData.rewardInfo[5] then
            rewardData.rewardInfo[5].rewardCount = commander_left
          end
        end
      end
    end
    if top_reward.state then
      self.publishRewards = top_reward.state
    else
      self.publishRewards = 0
    end
    if self.publishRewards == 1 and top_reward.rewardTime and 0 < top_reward.rewardTime then
      self.publishTime = top_reward.rewardTime
    else
      self.publishTime = nil
    end
    if notice then
      EventManager:GetInstance():Broadcast(EventId.LWSeasonAllianceRewardCountUpdate)
    end
  end
end

function SeasonRewardDataManager:RefreshAllianceRewardConditionProgress(message)
  local progressList = message.progressList
  if progressList then
    for index, value in ipairs(progressList) do
      local configId = value.configId
      local line = LocalController:instance():getLine(TableName.LW_Season_Alliance_Reward, configId)
      if line and self.seasonAllianceReward[line.tier] ~= nil then
        self.seasonAllianceReward[line.tier].progress = {}
        if value.conditionValue and #value.conditionValue > 0 then
          for index, value in ipairs(value.conditionValue) do
            table.insert(self.seasonAllianceReward[line.tier].progress, toInt(value))
          end
        else
        end
      end
    end
    EventManager:GetInstance():Broadcast(EventId.LWSeasonAllianceRewardProgressUpdate)
  end
  local top_reward = message.top_reward
  if top_reward then
    self:SetAllianceRewardData(top_reward, true)
  end
end

function SeasonRewardDataManager:GenerateAllianceRewardTier()
  if self.seasonAllianceReward and #self.seasonAllianceReward > 0 then
    for index, v in ipairs(self.seasonAllianceReward) do
      local conditionGroups = self:GetAllianceRewardConditionData(index)
      local flag = false
      for i = 1, #conditionGroups do
        local groupData = conditionGroups[i]
        if groupData.isFinish then
          flag = true
          break
        end
      end
      if flag then
        if index == self.seasonAllianceRewardTier then
          return index
        else
          Logger.Log("inconsistent result between server and client")
          return self.seasonAllianceRewardTier or 0
        end
      end
    end
  end
  return 0
end

function SeasonRewardDataManager:GetAllianceRewardTierCount()
  if self.seasonAllianceReward and #self.seasonAllianceReward > 0 then
    return #self.seasonAllianceReward
  end
  return -1
end

function SeasonRewardDataManager:CheckAllianceRewardData()
  if self.seasonAllianceReward and #self.seasonAllianceReward > 0 then
    SFSNetwork.SendMessage(MsgDefines.LWSeasonAllianceRewardProgress)
    return 1
  else
    SFSNetwork.SendMessage(MsgDefines.LWSeasonAllianceRewardInfo, SeasonUtil.IsInSeasonPrepareMode())
  end
  return 0
end

function SeasonRewardDataManager:FetchAllianceMemberDevotesRank()
  if self.allianceMemberDevotesRank == nil then
    SFSNetwork.SendMessage(MsgDefines.FetchAllianceMemberDevotesRank)
  end
  return self.allianceMemberDevotesRank
end

function SeasonRewardDataManager:UpdateAllianceMemberDevotesRank(message)
  local count = table.count(message)
  if 0 < count and count < 10 then
    self.allianceMemberDevotesRank = message
    EventManager:GetInstance():Broadcast(EventId.LWSeasonAllianceRewardMember)
  end
end

function SeasonRewardDataManager:UpdateAllianceMemberList(message)
  if message.top_reward then
    self:SetAllianceRewardData(message.top_reward, true)
  end
  if message.list ~= nil then
    local preUidMap = {}
    if self.seasonRewardMemeberList == nil then
      self.seasonRewardMemeberList = {}
    end
    for key, value in pairs(self.seasonRewardMemeberList) do
      preUidMap[key] = true
    end
    table.walk(message.list, function(k, v)
      local uid = v.uid
      if uid ~= nil and uid ~= "" then
        local preData = self.seasonRewardMemeberList[uid]
        if preData == nil then
          preData = AllianceSeasonRewardMember.New()
          self.seasonRewardMemeberList[uid] = preData
        end
        preData:ParseData(v)
        preUidMap[uid] = nil
      end
    end)
    for key, value in pairs(preUidMap) do
      self.seasonRewardMemeberList[key] = nil
    end
    EventManager:GetInstance():Broadcast(EventId.LWSeasonAllianceRewardMember)
  end
end

function SeasonRewardDataManager:UpdateAllianceReweardMemberDetailInfo(message)
  local uid = message.uid
  if uid and self.seasonRewardMemeberList[uid] then
    local memberData = self.seasonRewardMemeberList[uid]
    if message.rank_info then
      memberData:ParseRankData(message)
    end
    if message.settlement then
      memberData:ParseData(message)
    end
    if message.top_reward then
      self:SetAllianceRewardData(message.top_reward, true)
    end
    EventManager:GetInstance():Broadcast(EventId.LWSeasonAllianceRewardMemberDetailInfo, uid)
  end
end

function SeasonRewardDataManager:UpdateAllianceSettlementMemberRewardInfo(message)
  local uid = message.uid
  if uid and self.seasonRewardMemeberList[uid] then
    local memberData = self.seasonRewardMemeberList[uid]
    memberData:SetRewardType(message.type)
    EventManager:GetInstance():Broadcast(EventId.LWSeasonAllianceSettlementMemberRewardInfo, uid)
  end
  if message.top_reward then
    self:SetAllianceRewardData(message.top_reward, true)
  end
end

function SeasonRewardDataManager:UpdateAllianceSettlementMemberRewardCancel(message)
  local uid = message.uid
  if uid and self.seasonRewardMemeberList[uid] then
    local memberData = self.seasonRewardMemeberList[uid]
    memberData:SetRewardType(nil)
    EventManager:GetInstance():Broadcast(EventId.LWSeasonAllianceSettlementMemberRewardInfo, uid)
  end
  if message.top_reward then
    self:SetAllianceRewardData(message.top_reward, true)
  end
end

function SeasonRewardDataManager:UpdateAllianceSettlementAlliRewardAll(message)
  if message.top_reward then
    self:SetAllianceRewardData(message.top_reward, true)
  end
end

function SeasonRewardDataManager:GetAllianceReweardMemberInfo(uid)
  return self.seasonRewardMemeberList[uid]
end

function SeasonRewardDataManager:GetAllianceReweardMemberAssignedRewardIndex(uid)
  local data = self.seasonRewardMemeberList[uid]
  if data then
    return data.rewardIndex
  end
  return 0
end

function SeasonRewardDataManager:GetRewardIndexBySelectIndex(selectIndex)
  local rewardInfo = DataCenter.SeasonRewardDataManager:GetAllianceRewardData(1)
  if rewardInfo and rewardInfo[selectIndex + 1] then
    return rewardInfo[selectIndex + 1].rewardIndex
  end
  return -1
end

function SeasonRewardDataManager:GetRewardSelectByRewardIndex(rewardIndex)
  local rewardInfo = DataCenter.SeasonRewardDataManager:GetAllianceRewardData(1)
  if rewardInfo then
    for i, v in ipairs(rewardInfo) do
      if v.rewardIndex == rewardIndex then
        return i - 1
      end
    end
  end
  return -1
end

function SeasonRewardDataManager:GetAllianceMemberListByRank(rank)
  local list = {}
  local onlineNum = 0
  if self.seasonRewardMemeberList == nil then
    return list, onlineNum
  end
  table.walk(self.seasonRewardMemeberList, function(k, v)
    if v.rank == rank then
      if v.online == true then
        onlineNum = onlineNum + 1
      end
      table.insert(list, v)
    end
  end)
  table.sort(list, function(a, b)
    if a.online ~= b.online then
      return a.online
    elseif a.online then
      return a.uid < b.uid
    elseif a.offLineTime ~= b.offLineTime then
      return a.offLineTime > b.offLineTime
    else
      return a.uid < b.uid
    end
  end)
  return list, onlineNum
end

function SeasonRewardDataManager:CheckDistributeAuthority()
  local selfData = DataCenter.AllianceMemberDataManager:GetAllianceMemberMyself()
  if not selfData then
    return false
  end
  local authority = false
  if selfData.rank == LWAlMemberRankType.R5 then
    authority = true
  end
  if not authority then
    local officialNum = DataCenter.AllianceMemberDataManager:GetOfficialPosByUid(LuaEntry.Player.uid)
    if officialNum and LWAlMemberOffcialType.Al_Ambassadoe == officialNum then
      authority = true
    end
  end
  return authority
end

function SeasonRewardDataManager:SeasonRewardAllPublished()
  return self.publishRewards == 1
end

function SeasonRewardDataManager:SeasonRewardShowPublishedTime()
  return self.publishRewards == 1 and self.publishTime and self.publishTime > 0
end

function SeasonRewardDataManager:SeasonRewardPublishTimeStr()
  if self.publishTime and self.publishTime > 0 then
    return UITimeManager:GetInstance():TimeStampToTimeForLocalMinuteCommon(self.publishTime)
  end
  return ""
end

function SeasonRewardDataManager:CheckDistributeRewardTimeAndTier(notice)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local settleTime = DataCenter.SeasonDataManager:GetSeasonSettleTime()
  local endTime = DataCenter.SeasonDataManager:GetSeasonEndTime()
  local flag = false
  if curTime > settleTime and curTime < endTime then
    flag = true
  end
  if flag then
    local rewardTier = DataCenter.SeasonRewardDataManager:GenerateAllianceRewardTier()
    if rewardTier <= 0 then
      if notice then
        UIUtil.ShowTipsId("season_extra_tips_10")
      end
      return false, 0
    end
    return true, rewardTier
  elseif notice then
    UIUtil.ShowTipsId("season_extra_tips_09")
  end
  return false, 0
end

function SeasonRewardDataManager:CheckAllMemberAssigned()
  if self:SeasonRewardAllPublished() or not self:CheckDistributeAuthority() then
    return false
  end
  if self.seasonRewardMemeberList then
    for key, value in pairs(self.seasonRewardMemeberList) do
      local isNormal = value.seasonRole == nil or value.seasonRole == 0
      if not value:IsAlreadyGetReward() and value.rank ~= LWAlMemberRankType.R5 and (value.rewardIndex == nil or 0 >= value.rewardIndex) and isNormal then
        return false
      end
    end
  end
  return true
end

function SeasonRewardDataManager:CheckMemberAlreadyGetReward(uid)
  if self.seasonRewardMemeberList and self.seasonRewardMemeberList[uid] then
    return self.seasonRewardMemeberList[uid]:IsAlreadyGetReward()
  end
  return true
end

function SeasonRewardDataManager:GetSeasonAchievementRewardData(needSend, achievementId)
  local configId = toInt(achievementId)
  local msgState, result
  if not self.personalRewardData or not self.personalRewardData[configId] then
    msgState = 1
  else
    result = self.personalRewardData[configId]
    msgState = 2
  end
  if needSend or msgState == 1 then
    local templateData = self.seasonAchievementsTemp[configId]
    if templateData.flag == SeasonAchivementFlag.Personal or templateData.flag == SeasonAchivementFlag.Alliance and LuaEntry.Player:IsInAlliance() or templateData.flag == SeasonAchivementFlag.Camp then
      if msgState == 1 then
        SFSNetwork.SendMessage(MsgDefines.UserSesaonAchievementV2Info, configId)
      elseif msgState == 2 then
        SFSNetwork.SendMessage(MsgDefines.UserSesaonAchievementV2Grade, configId)
      end
    end
  end
  return result
end

function SeasonRewardDataManager:InitSeasonAchievementData(msg)
  if not self.occupyLandMax then
    self.occupyLandMax = {}
  end
  if not self.personalOccupyLandCount then
    self.personalOccupyLandCount = {}
  end
  local id = msg.achievementId
  self.personalOccupyLandCount[id] = msg.gradeValue
  local campAchievement = self:CheckAchievementCampType(id)
  local red = false
  if msg.gradesInfo then
    if not self.personalRewardData then
      self.personalRewardData = {}
    end
    self.personalRewardData[id] = {}
    local receiveCache = {}
    for key, value in pairs(msg.userRewards) do
      receiveCache[value] = true
    end
    for i, v in ipairs(msg.gradesInfo) do
      local item = {}
      item.score = v.grade
      item.rewards = DataCenter.RewardManager:ReturnRewardParamForView(v.reward)
      item.receive = receiveCache[v.grade]
      if self.occupyLandMax[id] == nil or self.occupyLandMax[id] < v.grade then
        self.occupyLandMax[id] = v.grade
      end
      self.personalRewardData[id][i] = item
      if not red and v.grade <= msg.gradeValue and not item.receive then
        red = true
      end
    end
  end
  if campAchievement then
    self.seasonCampRewardTabRed[id] = red
    EventManager:GetInstance():Broadcast(EventId.SeasonCampAchieveRewardRefresh)
  else
    self.seasonScoreTabRed[id] = red
  end
  EventManager:GetInstance():Broadcast(EventId.LWSeasonPersonalRewardGetRedPoint, id)
  EventManager:GetInstance():Broadcast(EventId.LWSeasonScoreRewardInfo)
  EventManager:GetInstance():Broadcast(EventId.LWSeasonPersonalRewardInfo, id)
end

function SeasonRewardDataManager:UpdataAchievementGrade(msg)
  if not self.personalOccupyLandCount then
    self.personalOccupyLandCount = {}
  end
  local id = msg.achievementId
  self.personalOccupyLandCount[id] = msg.gradeValue
  local campAchievement = self:CheckAchievementCampType(id)
  if campAchievement then
    if self:RefreshCampAchievementRewardTabRed(id) then
      EventManager:GetInstance():Broadcast(EventId.SeasonCampAchieveRewardRefresh)
    end
  elseif self:RefreshRewardTabRed(id) then
    EventManager:GetInstance():Broadcast(EventId.LWSeasonPersonalRewardGetRedPoint, id)
  end
  EventManager:GetInstance():Broadcast(EventId.LWSeasonPersonalRewardInfo)
end

function SeasonRewardDataManager:GetAchievementSelectRewardSuccess(msg)
  local selectId
  local id = msg.achievementId
  for key, value in pairs(self.personalRewardData[id]) do
    if value.score == msg.grade then
      value.receive = true
      break
    end
  end
  local campAchieve = self:CheckAchievementCampType(id)
  if campAchieve then
    if self:RefreshCampAchievementRewardTabRed(id) then
      EventManager:GetInstance():Broadcast(EventId.SeasonCampAchieveRewardRefresh)
    end
  elseif self:RefreshRewardTabRed(id) then
    EventManager:GetInstance():Broadcast(EventId.LWSeasonPersonalRewardGetRedPoint, id)
  end
  EventManager:GetInstance():Broadcast(EventId.LWSeasonPersonalRewardGetSuccess)
  if msg.reward then
    DataCenter.RewardManager:ShowGiftReward(msg)
    DataCenter.RewardManager:AddRewardsAndRes(msg)
  end
end

function SeasonRewardDataManager:GetAllianceRewardTierData()
  local result
  if self.seasonAllianceReward and #self.seasonAllianceReward > 0 then
    result = {}
    for i, v in ipairs(self.seasonAllianceReward) do
      local line = LocalController:instance():getLine(TableName.LW_Season_Alliance_Reward, v.configId)
      result[i] = Localization:GetString(line.tier_name)
    end
  end
  return result
end

function SeasonRewardDataManager:GetAlliancerewardMailIconPathByConfigId(configId)
  local result = self.rewardMailIconPath[configId]
  if result == nil then
    local config = LocalController:instance():getLine(TableName.LW_Season_Alliance_Reward, configId)
    local group = config.season_group
    local groupData = {}
    if group then
      LocalController:instance():visitTable(TableName.LW_Season_Alliance_Reward, function(id, line)
        if line.season_group == group then
          table.insert(groupData, line.tier)
        end
      end)
      do
        local rewardTier = 4
        if #groupData == 4 then
          rewardTier = config.tier
        elseif #groupData == 8 then
          rewardTier = math.ceil(config.tier / 2)
        end
        result = string.format("Assets/Main/Sprites/UI/UILWMailSeasonReward/FX_saijibanjiang_xinfeng_0%s.png", rewardTier)
        self.rewardMailIconPath[configId] = result
      end
    end
  end
  return result
end

return SeasonRewardDataManager
