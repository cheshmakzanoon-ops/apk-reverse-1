local SeasonRedPointUtils = {}

local function GetWeekCardTabBtn(cardId)
  return SeasonRedPointUtils.GetWeekFreeGift(cardId) or SeasonRedPointUtils.GetWeekDailyGift(cardId)
end

local function GetWeekFreeGift(cardId)
  local cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(tonumber(cardId))
  if cardData then
    return not cardData:IsTodayClaimedFree()
  end
  return false
end

local function GetWeekDailyGift(cardId)
  local cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(tonumber(cardId))
  if cardData and cardData:IsBought() then
    return not cardData:IsTodayClaimed()
  end
  return false
end

local function SeasonBattlePassTabRedPoint(activityId)
  local actData = DataCenter.ActBattlePassData:GetInfoByActId(tonumber(activityId))
  if actData and actData.GetRedNum then
    for i = 1, 3 do
      local num = actData:GetRedNum(i)
      if 0 < num then
        return true
      end
    end
  end
  return false
end

local function SeasonHeroPromotionRedPoint(activityId, only)
  local activityHeroData = SeasonRedPointUtils.GetConfigData(tostring(activityId))
  if activityHeroData == nil then
    return false
  end
  local maxIndex = activityHeroData.index
  local eachIndex = maxIndex
  for opIndex = eachIndex, maxIndex do
    local heroConfigData = DataCenter.SeasonDataManager:GetHeroCanPromoteDataByIndex(opIndex)
    local canPromote = false
    if heroConfigData then
      do
        local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroConfigData.oldId)
        local newHeroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroConfigData.newId)
        if not newHeroData and heroData then
          do
            local curRankId = heroData:GetRank()
            local maxRankId = heroData:GetMaxRank()
            if curRankId >= maxRankId then
              canPromote = true
              goto lbl_47
            end
          end
        end
      end
    else
      ::lbl_47::
      if canPromote and heroConfigData then
        local item = DataCenter.ItemData:GetItemById(heroConfigData.costItemId)
        if item and heroConfigData.costCount <= item.count then
          return true
        end
      end
    end
  end
  return false
end

local function GetConfigData(activityId)
  local k1 = LuaEntry.DataConfig:TryGetStr("lw_season_hero_promotion", "k1") or ""
  local k2 = LuaEntry.DataConfig:TryGetStr("lw_season_hero_promotion", "k2") or ""
  local k3 = LuaEntry.DataConfig:TryGetStr("lw_season_hero_promotion", "k3") or ""
  local k4 = LuaEntry.DataConfig:TryGetStr("lw_season_hero_promotion", "k4") or ""
  if not string.IsNullOrEmpty(k1) then
    local activityIds = string.split(k1, "|")
    if 0 < #activityIds then
      local dataIndex = -1
      for index, value in ipairs(activityIds) do
        if value == activityId then
          dataIndex = index
          break
        end
      end
      if 0 < dataIndex then
        local oldIds = string.split(k2, "|")
        local newIds = string.split(k3, "|")
        local cost = string.split(k4, "|")
        if dataIndex <= #oldIds and dataIndex <= #newIds and #cost == 2 then
          return {
            index = dataIndex,
            oldId = oldIds[dataIndex],
            newId = newIds[dataIndex],
            costItemId = cost[1],
            costCount = tonumber(cost[2])
          }
        end
      end
    end
  end
  return nil
end

function SeasonRedPointUtils.GetCrossAttackCityRedPoint()
  local count = 0
  local dataList = DataCenter.SeasonDataManager.ActCrossAttackDesertInfo
  if dataList then
    local theSeasonStartTime = DataCenter.SeasonDataManager:GetSeasonStartTime()
    for i, v in ipairs(dataList) do
      if v.serverId and v.pointId and v.buildingId then
        local cnt = UIUtil.GetActiveCount(theSeasonStartTime, "SeasonCrossAttackDesert" .. v.buildingId, false)
        if cnt == 0 then
          count = count + 1
        end
      end
    end
  end
  return count
end

function SeasonRedPointUtils.GetCrossDeclareWarRedPoint(theType, updateIt)
  local count = 0
  local countALL = 0
  local data = DataCenter.SeasonDataManager.CrossDeclareWarInfo
  if data then
    local theSeasonStartTime = DataCenter.SeasonDataManager:GetSeasonStartTime()
    if data.declareList and (theType == nil or theType == "declareList") then
      for _, v in ipairs(data.declareList) do
        local identify = string.format("DeclareWar_%s_%s_%s", v.serverId, v.cityId, v.startTime)
        local cnt = UIUtil.GetActiveCount(theSeasonStartTime, identify, updateIt)
        if cnt == 0 then
          count = count + 1
        end
        countALL = countALL + 1
      end
    end
    if data.beDeclareList and (theType == nil or theType == "beDeclareList") then
      for _, v in ipairs(data.beDeclareList) do
        local identify = string.format("DeclareWar_%s_%s_%s", v.serverId, v.cityId, v.startTime)
        local cnt = UIUtil.GetActiveCount(theSeasonStartTime, identify, updateIt)
        if cnt == 0 then
          count = count + 1
        end
        countALL = countALL + 1
      end
    end
  end
  return count, countALL
end

function SeasonRedPointUtils.GetVirusResearchRedPoint()
  local levelConfig = DataCenter.LWSpreadResearchDataManager:GetCurrentLevelConfig()
  if levelConfig == nil then
    return false
  end
  local max = DataCenter.LWSpreadResearchDataManager:IsMax()
  if max then
    return false
  end
  local needCost = levelConfig.research_cost
  local hasCount = DataCenter.ItemData:GetItemCount(needCost.itemId)
  local pres = GetTableData(TableName.DataConfig, "s1_pre_activity_config", "k2")
  if pres == nil or string.IsNullOrEmpty(pres) then
    return false
  end
  return hasCount / needCost.count >= toInt(pres)
end

function SeasonRedPointUtils.GetVirusBossRedPoint()
  return DataCenter.LWSeasonBossLoginDataManager:GetReddot()
end

local function SeasonScoreEnterRedState()
  local achievementGroup = SeasonUtil.GetSeasonAchievementsGroup()
  if achievementGroup ~= 0 then
    local AchievementsGroupData = DataCenter.SeasonRewardDataManager:GetAchievementsGroupData()
    if AchievementsGroupData == nil then
      return false
    end
    local achieveData = AchievementsGroupData[achievementGroup]
    if achieveData then
      for key, value in pairs(achieveData) do
        local data = {}
        data.type = toInt(value.id)
        if SeasonRedPointUtils.SeasonPersonalRewardAllGetBtnRedState(data.type) then
          return true
        end
      end
    end
    return false
  end
  return SeasonRedPointUtils.SeasonPersonalRewardAllGetBtnRedState(SeasonScoreRewardPanelType.PersonalContributeAchievement) or SeasonRedPointUtils.SeasonPersonalRewardAllGetBtnRedState(SeasonScoreRewardPanelType.AllianceStrongholdAchivement)
end

local function SeasonAchievementEnterRed(achievementGroup)
  if achievementGroup ~= 0 then
    local AchievementsGroupData = DataCenter.SeasonRewardDataManager:GetAchievementsGroupData()
    local achieveData = AchievementsGroupData[achievementGroup]
    if achieveData then
      for key, value in pairs(achieveData) do
        local data = {}
        data.type = toInt(value.id)
        if SeasonRedPointUtils.SeasonPersonalRewardAllGetBtnRedState(data.type) then
          return true
        end
      end
    end
    return false
  end
end

local function SeasonAllianceRewardDistributeBtnRedState()
  local flag = not DataCenter.SeasonRewardDataManager:SeasonRewardAllPublished() and DataCenter.SeasonRewardDataManager:CheckDistributeAuthority()
  flag = flag and DataCenter.SeasonRewardDataManager:CheckDistributeRewardTimeAndTier()
  return flag
end

local function SeasonPersonalRewardAllGetBtnRedState(type)
  local t = type and type or SeasonScoreRewardPanelType.PersonalOccupyLand
  return DataCenter.SeasonRewardDataManager:IsGetRewardTabRed(t)
end

local function SeasonMainRewardBtnRed()
  return SeasonRedPointUtils.SeasonAllianceRewardDistributeBtnRedState() or SeasonRedPointUtils.SeasonPersonalRewardAllGetBtnRedState(SeasonScoreRewardPanelType.PersonalOccupyLand)
end

local function SeasonMainTab()
  local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  if infoPlayer and (infoPlayer:InSettleTime() or infoPlayer:InIdleTime()) then
    return SeasonRedPointUtils.SeasonMainRewardBtnRed() or SeasonRedPointUtils.SeasonTrendRewardRedPoint()
  end
  return SeasonRedPointUtils.SeasonMainRewardBtnRed() or SeasonRedPointUtils.SeasonTrendRewardRedPoint() or SeasonRedPointUtils.IsShowMasteryRedPoint() or SeasonRedPointUtils.SeasonScoreEnterRedState() or DataCenter.SeasonFarmerManager:CountOfBuildReward() > 0 or SeasonUtil.CheckSeasonFarmerAchievement()
end

local function SeasonMastery()
  local idlePoint = DataCenter.MasteryManager:GetCurPlanIdlePoint()
  local availableSkill = DataCenter.MasteryManager:HaveSkillCanUse()
  return availableSkill or 0 < idlePoint
end

function SeasonRedPointUtils.HideMasteryRedPoint()
  CommonUtil.PlayerPrefsSetLong("HIDE_MASTERY_RED_POINT", UITimeManager:GetInstance():GetServerSeconds())
  EventManager:GetInstance():Broadcast(EventId.SeasonMasteryView)
end

function SeasonRedPointUtils.IsShowMasteryRedPoint()
  local seasonType = SeasonUtil.GetSeasonType()
  if DataCenter.SeasonDataManager:IsTacticalCardOpen(seasonType) then
    return false
  end
  if SeasonRedPointUtils.SeasonMastery() and SeasonUtil.IsInSeason() then
    local lastHideTime = CommonUtil.PlayerPrefsGetLong("HIDE_MASTERY_RED_POINT", 0)
    local now = UITimeManager:GetInstance():GetServerSeconds()
    return not UITimeManager:GetInstance():IsSameDayForServer(lastHideTime, now)
  else
    return false
  end
end

local function SeasonTrendRewardRedPoint()
  if DataCenter.LWSeasonTrendsManager:CheckSeasonTrendRewardFlag() then
    return true
  end
  local donate_red_show_count = UIUtil.GetWeekActiveCount("season_trend_donate_red", false)
  if donate_red_show_count == 0 then
    return SeasonRedPointUtils.SeasonInfoRed()
  end
  return false
end

local function SeasonInfoRed()
  local list = DataCenter.LWSeasonTrendsManager:GetCurOpenList()
  for key, value in pairs(list) do
    if value.type == SeasonTrendTaskType.Dotnate then
      local data = DataCenter.LWSeasonTrendsManager:GetTrendsConfigData(value.groupIndex, value.config_id)
      if data and data.donataData then
        local remainCount = data.donataData.resource.count - value.day_donate
        if 0 < remainCount then
          return true
        end
      end
    end
  end
  return false
end

local function IsShowTetrisRed()
  return not DataCenter.SeasonTetrisManager:IsAllFinished()
end

SeasonRedPointUtils.GetWeekCardTabBtn = GetWeekCardTabBtn
SeasonRedPointUtils.GetWeekFreeGift = GetWeekFreeGift
SeasonRedPointUtils.GetWeekDailyGift = GetWeekDailyGift
SeasonRedPointUtils.SeasonBattlePassTabRedPoint = SeasonBattlePassTabRedPoint
SeasonRedPointUtils.SeasonHeroPromotionRedPoint = SeasonHeroPromotionRedPoint
SeasonRedPointUtils.GetConfigData = GetConfigData
SeasonRedPointUtils.SeasonMainTab = SeasonMainTab
SeasonRedPointUtils.SeasonMastery = SeasonMastery
SeasonRedPointUtils.SeasonPersonalRewardAllGetBtnRedState = SeasonPersonalRewardAllGetBtnRedState
SeasonRedPointUtils.PersonalRewardAllGetBtnRedState = false
SeasonRedPointUtils.SeasonTrendRewardRedPoint = SeasonTrendRewardRedPoint
SeasonRedPointUtils.SeasonAllianceRewardDistributeBtnRedState = SeasonAllianceRewardDistributeBtnRedState
SeasonRedPointUtils.SeasonMainRewardBtnRed = SeasonMainRewardBtnRed
SeasonRedPointUtils.SeasonScoreEnterRedState = SeasonScoreEnterRedState
SeasonRedPointUtils.SeasonInfoRed = SeasonInfoRed
SeasonRedPointUtils.SeasonAchievementEnterRed = SeasonAchievementEnterRed
SeasonRedPointUtils.IsShowTetrisRed = IsShowTetrisRed
return SeasonRedPointUtils
