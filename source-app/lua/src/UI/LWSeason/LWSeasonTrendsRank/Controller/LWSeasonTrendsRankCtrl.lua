local CommonRankItemShow = {
  type = CommonRankPanelType.DEFAULT,
  isAlliance = false,
  uid = "",
  firstName = "",
  secondName = "",
  rank = -1,
  power = "",
  allianceName = "",
  icon = ""
}
local Localization = CS.GameEntry.Localization
local LWSeasonTrendsRankCtrl = BaseClass("LWSeasonTrendsRankCtrl", UIBaseCtrl)
local OneData = DataClass("OneData", CommonRankItemShow)

function LWSeasonTrendsRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonTrendsRank)
end

function LWSeasonTrendsRankCtrl:TrendsRankCtrlSetData(type, param)
  self.rankType = type
  self.param = param
end

function LWSeasonTrendsRankCtrl:GetSeasonTrendsRankList(type, param, sendMsg, rankIndex)
  local showList = {}
  if type == CommonRankPanelType.TrendsRank then
    local trendsConfig = LocalController:instance():getLine(TableName.LW_Season_Trends, param)
    local isAlliance = trendsConfig.user_type == 2
    local list = DataCenter.LWSeasonTrendsManager:GetTrendsRankData(param)
    if list then
      table.walk(list, function(k, v)
        local oneData = self:ParseTrendData(v, isAlliance)
        if oneData ~= nil then
          table.insert(showList, oneData)
        end
      end)
    end
    if sendMsg then
      SFSNetwork.SendMessage(MsgDefines.LwSeasonTrendRankInfo, param)
    end
  elseif type == CommonRankPanelType.WastedlandRank then
    local list = DataCenter.LWSeasonTrendsManager:GetWastedlandRankList(param)
    if list then
      table.walk(list, function(k, v)
        local oneData = self:ParseTrendData(v, false)
        oneData.type = CommonRankPanelType.WastedlandRank
        if oneData ~= nil then
          table.insert(showList, oneData)
        end
      end)
    end
    if sendMsg then
      SFSNetwork.SendMessage(MsgDefines.LWSeasonWastedRankInfo, param, CommonActivityRankType.PERSONAL)
    end
  elseif type == CommonRankPanelType.WastedlandRankWithAlliance then
    local list = DataCenter.LWSeasonTrendsManager:GetWastedlandRankList(param, rankIndex)
    if list then
      table.walk(list, function(k, v)
        local oneData = self:ParseTrendData(v, rankIndex == CommonActivityRankType.ALLINCE)
        oneData.type = CommonRankPanelType.WastedlandRankWithAlliance
        if oneData ~= nil then
          table.insert(showList, oneData)
        end
      end)
    end
    if sendMsg then
      SFSNetwork.SendMessage(MsgDefines.LWSeasonWastedRankInfo, param, rankIndex)
    end
  elseif type == CommonRankPanelType.NuclearPlatRank then
    local msgType
    if rankIndex == 1 then
      msgType = NuclearPowerRankType.buildingPerson
    elseif rankIndex == 2 then
      msgType = NuclearPowerRankType.bossHurtPersaon
    end
    if msgType then
      local list = DataCenter.SeasonNuclearPowerPlantDataManager:GetRankData(rankIndex)
      if list then
        table.walk(list, function(k, v)
          local oneData = self:ParseTrendData(v, false)
          oneData.type = CommonRankPanelType.NuclearPlatRank
          if oneData ~= nil then
            table.insert(showList, oneData)
          end
        end)
      end
      if sendMsg then
        SFSNetwork.SendMessage(MsgDefines.NuclearRankView, toInt(param), msgType)
      end
    end
  elseif type == CommonRankPanelType.BloodyNightRank then
    local rankIdList = DataCenter.BloodyNightDataManager:GetStageRankCfgIdList()
    if rankIdList then
      local rankId = rankIdList[rankIndex]
      if sendMsg then
        DataCenter.BloodyNightDataManager:FetchRankData(rankId)
      end
      local rankConfig = LocalController:instance():getLine(TableName.LW_Season_rank, rankId)
      local rankData = DataCenter.BloodyNightDataManager:GetRankData(rankId)
      if rankData and rankData.ranks and rankConfig then
        for rank, v in ipairs(rankData.ranks) do
          local oneData = self:ParseBloodyNightData(v, rankConfig.rank_type == 2, rank)
          table.insert(showList, oneData)
        end
      end
    end
  elseif type == CommonRankPanelType.WestwardExpansionRank then
    local rankId = DataCenter.WestwardExpansionDataManager:GetStageRankId()
    if rankId then
      if sendMsg then
        DataCenter.WestwardExpansionDataManager:FetchRankData(false)
      end
      local rankConfig = LocalController:instance():getLine(TableName.LW_Season_rank, rankId)
      local rankData = DataCenter.WestwardExpansionDataManager:GetRankData()
      if rankData and rankData.ranks and rankConfig then
        for rank, v in ipairs(rankData.ranks) do
          local oneData = self:ParseWestwardExpansionData(v, rankConfig.rank_type == 2, rank)
          table.insert(showList, oneData)
        end
      end
    end
  end
  return showList
end

function LWSeasonTrendsRankCtrl:OpenRewardLogic(type, param, rankType)
  if type == CommonRankPanelType.TrendsRank then
    SFSNetwork.SendMessage(MsgDefines.LWSeasonTrendRankReward, param)
  elseif type == CommonRankPanelType.WastedlandRank or type == CommonRankPanelType.WestwardExpansionRank then
    SFSNetwork.SendMessage(MsgDefines.LWSeasonWastedRankShowInfo, param, CommonActivityRankType.PERSONAL)
  elseif type == CommonRankPanelType.WastedlandRankWithAlliance then
    SFSNetwork.SendMessage(MsgDefines.LWSeasonWastedRankShowInfo, param, rankType)
  elseif type == CommonRankPanelType.NuclearPlatRank then
    local msgType
    if rankType == 1 then
      msgType = NuclearPowerRankType.buildingPerson
    elseif rankType == 2 then
      msgType = NuclearPowerRankType.bossHurtPersaon
    end
    if msgType then
      SFSNetwork.SendMessage(MsgDefines.NuclearRankRewardView, toInt(param), msgType)
    end
  end
end

function LWSeasonTrendsRankCtrl:ParseTrendData(item, isAlliance)
  local oneData = OneData.New()
  oneData.isAlliance = isAlliance
  oneData.type = CommonRankPanelType.TrendsRank
  if item ~= nil then
    oneData.uid = item.uid
    oneData.rank = item.rank
    oneData.serverId = item.srcServer
    if isAlliance then
      oneData.allianceName = item.allianceName
      oneData.firstName = "[" .. item.allianceAbbr .. "]" .. item.allianceName
      oneData.icon = item.icon
      oneData.power = string.GetFormattedSeperatorNum(item.score or 0)
    else
      if item.abbr == nil or item.abbr == "" then
        oneData.firstName = item.name
      elseif item.uid == LuaEntry.Player.uid then
        if LuaEntry.Player:IsInAlliance() then
          oneData.firstName = "[" .. item.abbr .. "] " .. item.name
        else
          oneData.firstName = item.name
        end
      else
        oneData.firstName = "[" .. item.abbr .. "] " .. item.name
      end
      oneData.power = string.GetFormattedSeperatorNum(item.score or 0)
      oneData.pic = item.pic
      oneData.picVer = item.picVer
      oneData.headFrame = item:GetHeadBgImg()
    end
  else
    oneData.uid = ""
    oneData.firstName = "-"
    oneData.rank = "-"
    oneData.power = 0
  end
  return oneData
end

function LWSeasonTrendsRankCtrl:GetWasteLandRankRewardList(rankIndex)
  if self.rankType == CommonRankPanelType.TrendsRank then
    return DataCenter.LWSeasonTrendsManager:GetTrendsRankRewardList(self.param)
  elseif self.rankType == CommonRankPanelType.WastedlandRank or self.rankType == CommonRankPanelType.WestwardExpansionRank then
    return DataCenter.LWSeasonTrendsManager:GetWastedlandRankRewardList(self.param, CommonActivityRankType.PERSONAL)
  elseif self.rankType == CommonRankPanelType.WastedlandRankWithAlliance then
    return DataCenter.LWSeasonTrendsManager:GetWastedlandRankRewardList(self.param, rankIndex)
  elseif self.rankType == CommonRankPanelType.NuclearPlatRank then
    local type
    if rankIndex == 1 then
      type = NuclearPowerRankType.buildingPerson
    elseif rankIndex == 2 then
      type = NuclearPowerRankType.bossHurtPersaon
    end
    if type then
      return DataCenter.SeasonNuclearPowerPlantDataManager:GetRankRewardInfo(type)
    end
  end
  return nil
end

function LWSeasonTrendsRankCtrl:GetGlobalByType(rankType)
  if rankType == CommonRankPanelType.DEFAULT or rankType == CommonRankPanelType.NuclearPlatRank then
    return 0
  end
  return 1
end

function LWSeasonTrendsRankCtrl:GetSelfData(rankType, param, rankIndex)
  local isAlliance = true
  local rank = 0
  local power = 0
  if rankType == CommonRankPanelType.TrendsRank then
    local trendsConfig = LocalController:instance():getLine(TableName.LW_Season_Trends, param)
    isAlliance = trendsConfig.user_type == 2
    local selfData = DataCenter.LWSeasonTrendsManager:GetTrendsSelfRankData(param)
    if selfData then
      rank = selfData.rank
      power = selfData.score
    end
  elseif rankType == CommonRankPanelType.WastedlandRank then
    isAlliance = false
    local selfData = DataCenter.LWSeasonTrendsManager:GetWastedSelfRankData(param)
    if selfData then
      rank = selfData.rank
      power = selfData.score
    end
  elseif rankType == CommonRankPanelType.WastedlandRankWithAlliance then
    isAlliance = rankIndex == 2
    local selfData = DataCenter.LWSeasonTrendsManager:GetWastedSelfRankData(param, rankIndex)
    if selfData then
      rank = selfData.rank
      power = selfData.score
    end
  elseif rankType == CommonRankPanelType.NuclearPlatRank then
    isAlliance = false
    local type
    if rankIndex == 1 then
      type = NuclearPowerRankType.buildingPerson
    elseif rankIndex == 2 then
      type = NuclearPowerRankType.bossHurtPersaon
    end
    rank = 0
    power = 0
    if type then
      local selfData = DataCenter.SeasonNuclearPowerPlantDataManager:GetSelfRankData(type)
      if selfData then
        rank = 0 < selfData.rank and selfData.rank or 0
        power = selfData.score
      end
    end
  elseif rankType == CommonRankPanelType.BloodyNightRank then
    local rankIdList = DataCenter.BloodyNightDataManager:GetStageRankCfgIdList()
    if rankIdList then
      local rankConfig = LocalController:instance():getLine(TableName.LW_Season_rank, rankIdList[rankIndex])
      if rankConfig then
        local rankData = DataCenter.BloodyNightDataManager:GetRankData(rankIdList[rankIndex])
        isAlliance = rankConfig.rank_type == 2
        if rankData then
          rank = rankData.rank
          power = rankData.score
        end
      end
    end
  elseif rankType == CommonRankPanelType.WestwardExpansionRank then
    local rankId = DataCenter.WestwardExpansionDataManager:GetStageRankId()
    if rankId then
      local rankConfig = LocalController:instance():getLine(TableName.LW_Season_rank, rankId)
      if rankConfig then
        local rankData = DataCenter.WestwardExpansionDataManager:GetRankData()
        isAlliance = rankConfig.rank_type == 2
        if rankData and rankData.self then
          rank = rankData.self.rank
          power = rankData.self.score
        end
      end
    end
  end
  local oneData = OneData.New()
  local Player = LuaEntry.Player
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if isAlliance then
    oneData.isAlliance = true
    oneData.serverId = LuaEntry.Player.serverId
    if Player:IsInAlliance() and allianceData ~= nil then
      oneData.rank = rank
      oneData.icon = allianceData.icon
      oneData.uid = Player.allianceId
      oneData.firstName = "[" .. allianceData.abbr .. "]" .. allianceData.allianceName
      oneData.power = power
    else
      oneData.uid = nil
      oneData.firstName = "-"
      oneData.icon = nil
      oneData.power = "0"
      oneData.rank = "50+"
    end
  else
    oneData.isAlliance = false
    oneData.serverId = LuaEntry.Player:GetSourceServerId()
    oneData.rank = rank
    oneData.power = power
    if allianceData == nil or allianceData.abbr == nil or allianceData.abbr == "" then
      oneData.firstName = Player:GetName()
    elseif LuaEntry.Player:IsInAlliance() then
      oneData.firstName = "[" .. allianceData.abbr .. "] " .. Player:GetName()
    else
      oneData.firstName = Player:GetName()
    end
    oneData.uid = Player:GetUid()
    oneData.pic = Player:GetPic()
    oneData.picVer = Player.picVer
    oneData.headFrame = Player:GetHeadBgImg()
  end
  return oneData
end

function LWSeasonTrendsRankCtrl:GetActivityDescription(rankType, param, rankIndex)
  local result = {
    title = "",
    content1 = "",
    content2 = "",
    desc = ""
  }
  if not rankType then
    Logger.LogError("rankType is nil")
    return result
  end
  if rankType == CommonRankPanelType.TrendsRank then
    local trendsConfig = LocalController:instance():getLine(TableName.LW_Season_Trends, param)
    if trendsConfig then
      local rankConfig = LocalController:instance():getLine(TableName.LW_Season_rank, trendsConfig.rank_name)
      if rankConfig then
        result.title = Localization:GetString(rankConfig.name)
        if trendsConfig.user_type == 1 then
          local str = Localization:GetString(100184)
          result.content1 = str
        else
          local str = Localization:GetString(390288)
          result.content1 = str
        end
        result.content2 = Localization:GetString(rankConfig.score_name)
        if not string.IsNullOrEmpty(rankConfig.desc) then
          result.desc = Localization:GetString(rankConfig.desc)
        end
        return result
      end
    else
      Logger.LogError("trendsConfig is nil, id: " .. param)
    end
  elseif rankType == CommonRankPanelType.WastedlandRank or rankType == CommonRankPanelType.WastedlandRankWithAlliance or rankType == CommonRankPanelType.NuclearPlatRank then
    local realIndex = rankIndex
    if rankType == CommonRankPanelType.NuclearPlatRank then
      if rankIndex == 1 then
        realIndex = NuclearPowerRankType.buildingPerson
      elseif rankIndex == 2 then
        realIndex = NuclearPowerRankType.bossHurtPersaon
      end
    end
    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(param)
    local rewardId = activityData.rankRewardParam[realIndex]
    if rewardId then
      local rankConfig = LocalController:instance():getLine(TableName.LW_Season_rank, toInt(rewardId))
      if rankConfig and rankConfig then
        result.title = Localization:GetString(rankConfig.name)
        if rankConfig.rank_type == 1 then
          result.content1 = Localization:GetString(100184)
        else
          result.content1 = Localization:GetString(129046)
        end
        result.content2 = Localization:GetString(rankConfig.score_name)
        if activityData ~= nil and activityData.story ~= nil and not string.IsNullOrEmpty(activityData.story) then
          result.desc = Localization:GetString(activityData.story)
        end
        return result
      end
    end
  elseif rankType == CommonRankPanelType.BloodyNightRank then
    local rankIdList = DataCenter.BloodyNightDataManager:GetStageRankCfgIdList()
    if rankIdList and rankIdList[rankIndex] then
      local rankConfig = LocalController:instance():getLine(TableName.LW_Season_rank, rankIdList[rankIndex])
      if rankConfig then
        result.title = Localization:GetString(rankConfig.name)
        if rankConfig.rank_type == 1 then
          result.content1 = Localization:GetString(100184)
        else
          result.content1 = Localization:GetString(129046)
        end
        result.content2 = Localization:GetString(rankConfig.score_name)
        local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(param)
        if activityData ~= nil and activityData.story ~= nil and not string.IsNullOrEmpty(activityData.story) then
          result.desc = Localization:GetString(activityData.story)
        end
        return result
      end
    end
  elseif rankType == CommonRankPanelType.WestwardExpansionRank then
    local rankId = DataCenter.WestwardExpansionDataManager:GetStageRankId()
    if rankId then
      local rankConfig = LocalController:instance():getLine(TableName.LW_Season_rank, rankId)
      if rankConfig then
        result.title = Localization:GetString(rankConfig.name)
        if rankConfig.rank_type == 1 then
          result.content1 = Localization:GetString(100184)
        else
          result.content1 = Localization:GetString(129046)
        end
        result.content2 = Localization:GetString(rankConfig.score_name)
        local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(param)
        if activityData ~= nil and activityData.story ~= nil and not string.IsNullOrEmpty(activityData.story) then
          result.desc = Localization:GetString(activityData.story)
        end
        return result
      end
    end
  end
  return result
end

function LWSeasonTrendsRankCtrl:CheckRewardBtnStat(rankIndex)
  local param = self.param
  local configId
  if self.rankType == CommonRankPanelType.TrendsRank then
    local trendsConfig = LocalController:instance():getLine(TableName.LW_Season_Trends, param)
    if trendsConfig then
      configId = trendsConfig.rank_name
    else
      Logger.LogError("trendsConfig is nil, id: " .. param)
    end
  elseif self.rankType == CommonRankPanelType.WastedlandRank or self.rankType == CommonRankPanelType.WastedlandRankWithAlliance then
    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(param)
    rankIndex = rankIndex ~= nil and rankIndex or CommonActivityRankType.PERSONAL
    configId = activityData.rankRewardParam[rankIndex]
  elseif self.rankType == CommonRankPanelType.NuclearPlatRank then
    if rankIndex then
      local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(param)
      if activityData.rankRewardParam then
        local realIndex
        if rankIndex == 1 then
          realIndex = NuclearPowerRankType.buildingPerson
        elseif rankIndex == 2 then
          realIndex = NuclearPowerRankType.bossHurtPersaon
        end
        if realIndex then
          configId = activityData.rankRewardParam[realIndex]
        end
      end
    end
  elseif self.rankType == CommonRankPanelType.BloodyNightRank then
    local rankIdList = DataCenter.BloodyNightDataManager:GetStageRankCfgIdList()
    if rankIdList then
      configId = rankIdList[rankIndex]
    end
  elseif self.rankType == CommonRankPanelType.WestwardExpansionRank then
    configId = DataCenter.WestwardExpansionDataManager:GetStageRankId()
  end
  if configId then
    local rankConfig = LocalController:instance():getLine(TableName.LW_Season_rank, configId)
    return not string.IsNullOrEmpty(rankConfig.reward)
  else
    return false
  end
end

function LWSeasonTrendsRankCtrl:TabState(param)
  if self.rankType == CommonRankPanelType.TrendsRank or self.rankType == CommonRankPanelType.WastedlandRank then
    return nil
  elseif self.rankType == CommonRankPanelType.WastedlandRankWithAlliance then
    local result = {}
    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(param)
    if activityData and activityData.rankRewardParam then
      for index, value in ipairs(activityData.rankRewardParam) do
        table.insert(result, toInt(value))
      end
    else
      Logger.LogError("activityData is nil, activityId: " .. param)
    end
    return result
  elseif self.rankType == CommonRankPanelType.NuclearPlatRank then
    local result = {}
    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(param)
    if activityData and activityData.rankRewardParam then
      if activityData.rankRewardParam[2] then
        table.insert(result, toInt(activityData.rankRewardParam[2]))
      end
      if activityData.rankRewardParam[3] then
        table.insert(result, toInt(activityData.rankRewardParam[3]))
      end
    else
      Logger.LogError("activityData is nil, activityId: " .. param)
    end
    return result
  elseif self.rankType == CommonRankPanelType.BloodyNightRank then
    return DataCenter.BloodyNightDataManager:GetStageRankCfgIdList()
  elseif self.rankType == CommonRankPanelType.WestwardExpansionRank then
    return DataCenter.WestwardExpansionDataManager:GetStageRankCfgIdList()
  end
  return nil
end

function LWSeasonTrendsRankCtrl:ParseBloodyNightData(item, isAlliance, rank)
  local oneData = OneData.New()
  oneData.isAlliance = isAlliance
  oneData.type = CommonRankPanelType.BloodyNightRank
  if item ~= nil then
    oneData.uid = item.uid
    oneData.rank = rank
    oneData.serverId = item.srcServer
    oneData.power = string.GetFormattedSeperatorNum(item.score or 0)
    if isAlliance then
      oneData.allianceName = item.allianceName
      oneData.firstName = UIUtil.FormatAllianceAndName(item.abbr, item.allianceName)
    else
      oneData.firstName = UIUtil.FormatAllianceAndName(item.abbr, item.name, item.uid)
      oneData.pic = item.pic
      oneData.picVer = item.picver
      oneData.headFrame = DataCenter.DecorationDataManager:GetHeadFrame(item.headSkinId, item.headSkinET)
    end
  else
    oneData.uid = ""
    oneData.firstName = "-"
    oneData.rank = "-"
    oneData.power = 0
  end
  return oneData
end

function LWSeasonTrendsRankCtrl:ParseWestwardExpansionData(item, isAlliance, rank)
  local oneData = OneData.New()
  oneData.isAlliance = isAlliance
  oneData.type = CommonRankPanelType.WestwardExpansionRank
  if item ~= nil then
    oneData.uid = item.uid
    oneData.rank = rank
    oneData.serverId = item.srcServer
    oneData.power = string.GetFormattedSeperatorNum(item.score or 0)
    if isAlliance then
      oneData.allianceName = item.allianceName
      oneData.firstName = UIUtil.FormatAllianceAndName(item.abbr, item.allianceName)
    else
      oneData.firstName = UIUtil.FormatAllianceAndName(item.abbr, item.name, item.uid)
      oneData.pic = item.pic
      oneData.picVer = item.picver
      oneData.headFrame = DataCenter.DecorationDataManager:GetHeadFrame(item.headSkinId, item.headSkinET)
    end
  else
    oneData.uid = ""
    oneData.firstName = "-"
    oneData.rank = "-"
    oneData.power = 0
  end
  return oneData
end

return LWSeasonTrendsRankCtrl
