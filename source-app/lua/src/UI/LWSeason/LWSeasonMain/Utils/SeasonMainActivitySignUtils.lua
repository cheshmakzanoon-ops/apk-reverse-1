local SeasonMainActivitySignUtils = {}
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")
local Task = SeasonMainActivityRewardSignType.Task
local Duration = SeasonMainActivityRewardSignType.Duration
local TaskOrDurationSign = Task | Duration
SeasonMainActivitySignUtils.ActivitySignMap = {
  [EnumActivity.SeasonStrongholdRank.Type] = {signType = TaskOrDurationSign},
  [EnumActivity.SeasonWarZoneOutpostFix.Type] = {signType = Task},
  [EnumActivity.SeasonWarZoneOutpostAttack.Type] = {signType = Duration},
  [EnumActivity.CounterAttack.Type] = {signType = TaskOrDurationSign},
  [EnumActivity.SeasonCrossDeclareWarActivity.Type] = {signType = TaskOrDurationSign},
  [EnumActivity.HighSpeedRailway.Type] = {signType = Task},
  [EnumActivity.SeasonServerBattleV8Activity.Type] = {signType = Task},
  [EnumActivity.ActHeroLevelReplace.Type] = {signType = Task},
  [EnumActivity.SeasonPeriodicCard.Type] = {signType = Task},
  [EnumActivity.ActHeroPromotion.Type] = {signType = Task},
  [EnumActivity.SeasonLastWar.Type] = {signType = Task},
  [EnumActivity.DarknessSupplies.Type] = {signType = Task},
  [EnumActivity.SeasonFactionBigWarActivity.Type] = {signType = TaskOrDurationSign},
  [EnumActivity.SheepGame.Type] = {signType = Task},
  [EnumActivity.SeasonFactionDeclareWarActivity.Type] = {signType = TaskOrDurationSign},
  [EnumActivity.SeasonFactionDeclareWarActivityMummy.Type] = {signType = TaskOrDurationSign},
  [EnumActivity.TradeStation.Type] = {signType = TaskOrDurationSign},
  [EnumActivity.SeasonAttackCityActivity.Type] = {signType = TaskOrDurationSign},
  [EnumActivity.BloodyNight.Type] = {signType = TaskOrDurationSign},
  [EnumActivity.GoldTree.Type] = {signType = Task},
  [EnumActivity.SeasonCallbackActivity.Type] = {signType = Task},
  [EnumActivity.SeasonHunter.Type] = {signType = TaskOrDurationSign},
  [EnumActivity.ActivityTetris.Type] = {signType = Task},
  [EnumActivity.SeasonAllianceWarTime.Type] = {signType = Task},
  [EnumActivity.BiuBiu.Type] = {signType = Task},
  [EnumActivity.SeasonBountyShop.Type] = {signType = Task},
  [EnumActivity.LimitedTimeFeast.Type] = {signType = Task},
  [EnumActivity.Season6CampDestroy.Type] = {signType = TaskOrDurationSign},
  [EnumActivity.GGGo.Type] = {signType = Task},
  [EnumActivity.SeasonCityAltar.Type] = {signType = TaskOrDurationSign}
}

function SeasonMainActivitySignUtils:GetSignStatus(data)
  local signData = SeasonMainActivitySignUtils.ActivitySignMap[data.type]
  if signData == nil then
    return SeasonMainActivityRewardStatusType.Normal
  end
  return self:OpSignStatus(signData.signType, data)
end

function SeasonMainActivitySignUtils:OpSignStatus(signType, data)
  local finish, doing = false, false
  local flag = SeasonMainActivityRewardSignType.Task
  local check = signType & flag == flag
  if check then
    if data.type == EnumActivity.SheepGame.Type then
      finish = self:GetSheepGameStatus(flag, data)
    elseif data.type == EnumActivity.SeasonPeriodicCard.Type then
      finish = self:GetSeasonPeriodicCardStatus(flag, data)
    elseif data.type == EnumActivity.ActHeroPromotion.Type then
      finish = self:GetHeroPromotionStatus(flag, data.activityId)
    elseif data.type == EnumActivity.SeasonLastWar.Type then
      finish = self:GetSeasonLastWarStatus(flag, data)
    elseif data.type == EnumActivity.DarknessSupplies.Type then
      finish = self:GetDarknessSuppliesStatus(flag, data)
    elseif data.type == EnumActivity.TradeStation.Type then
      finish = self:GetTradeStationStatus(flag, data)
    elseif data.type == EnumActivity.SeasonHunter.Type then
      finish = self:GetHunterStatus(flag, data)
    elseif data.type == EnumActivity.SeasonAttackCityActivity.Type then
      finish = self:GetSeasonAttackCityActivityStatus(flag, data)
    elseif data.type == EnumActivity.BloodyNight.Type then
      finish = self:GetBloodyNightStatus(flag, data)
    elseif data.type == EnumActivity.CounterAttack.Type then
      finish = self:GetCounterAttackStatus(flag, data)
    elseif data.type == EnumActivity.HighSpeedRailway.Type then
      finish = self:GetHighSpeedRailwayStatus(flag, data)
    elseif data.type == EnumActivity.SeasonFactionDeclareWarActivity.Type then
      finish = self:GetSeasonFactionDeclareWarActivityStatus(flag, data)
    elseif data.type == EnumActivity.SeasonFactionDeclareWarActivityMummy.Type then
      finish = self:GetSeasonFactionDeclareWarActivityStatus(flag, data)
    elseif data.type == EnumActivity.SeasonFactionSelectionActivity.Type then
      finish = self:GetSeasonFactionSelectionActivityStatus(flag, data)
    elseif data.type == EnumActivity.SeasonFactionSelectionActivityMummy.Type then
      finish = self:GetSeasonFactionSelectionActivityStatus(flag, data)
    elseif data.type == EnumActivity.SeasonFactionBigWarActivity.Type then
      finish = self:GetSeasonFactionBigWarActivityStatus(flag, data)
    elseif data.type == EnumActivity.GoldTree.Type then
      finish = self:GetSeasonGoldTreeStatus(flag, data)
    elseif data.type == EnumActivity.SeasonCallbackActivity.Type then
      finish = self:GetSeasonCallbackActivityStatus(flag, data)
    elseif data.type == EnumActivity.SeasonFarmer.Type then
      finish = self:GetSeasonFarmerActivityStatus(flag, data)
    elseif data.type == EnumActivity.ActHeroLevelReplace.Type then
      finish = self:GetActHeroLevelReplaceStatus(flag, data)
    elseif data.type == EnumActivity.SeasonWarZoneOutpostFix.Type then
      finish = self:GetSeasonWarZoneOutpostFixStatus(flag, data)
    elseif data.type == EnumActivity.SeasonWarZoneOutpostAttack.Type then
      finish = self:GetSeasonWarZoneOutpostAttackStatus(flag, data)
    elseif data.type == EnumActivity.SeasonStrongholdRank.Type then
      finish = self:GetSeasonStrongholdRankStatus(flag, data)
    elseif data.type == EnumActivity.SeasonCrossDeclareWarActivity.Type then
      finish = self:GetSeasonCrossDeclareWarActivityStatus(flag, data)
    elseif data.type == EnumActivity.ActivityTetris.Type then
      finish = self:GetSeasonTetrisStatus()
    elseif data.type == EnumActivity.SeasonAllianceWarTime.Type then
      finish = self:GetAllianceWarTimeStatus()
    elseif data.type == EnumActivity.BiuBiu.Type then
      finish = self:GetBiuBiuStatus(flag, data)
    elseif data.type == EnumActivity.GGGo.Type then
      finish = self:GetGGGoStatus(flag, data)
    elseif data.type == EnumActivity.SeasonBountyShop.Type then
      finish = DataCenter.SeasonBountyShopManager:HasSoldOut()
    elseif data.type == EnumActivity.Season6CampDestroy.Type then
      finish = self:GetSeason6CampDestroyStatus(flag, data)
    elseif data.type == EnumActivity.LimitedTimeFeast.Type then
      finish = self:GetLimitedTimeFeastStatus(flag, data)
    elseif data.type == EnumActivity.SeasonCityAltar.Type then
      finish = not DataCenter.SeasonCityAltarManager:IsAnyAltarInContention()
    end
    if finish then
      return SeasonMainActivityRewardStatusType.Finish
    end
  end
  flag = SeasonMainActivityRewardSignType.Duration
  check = signType & flag == flag
  if check then
    if data.type == EnumActivity.SeasonFactionBigWarActivity.Type then
      doing = self:GetSeasonFactionBigWarActivityStatus(flag, data)
    elseif data.type == EnumActivity.TradeStation.Type then
      doing = self:GetTradeStationStatus(flag, data)
    elseif data.type == EnumActivity.SeasonAttackCityActivity.Type then
      doing = self:GetSeasonAttackCityActivityStatus(flag, data)
    elseif data.type == EnumActivity.BloodyNight.Type then
      doing = self:GetBloodyNightStatus(flag, data)
    elseif data.type == EnumActivity.SeasonFactionDeclareWarActivity.Type then
      doing = self:GetSeasonFactionDeclareWarActivityStatus(flag, data)
    elseif data.type == EnumActivity.SeasonFactionDeclareWarActivityMummy.Type then
      doing = self:GetSeasonFactionDeclareWarActivityStatus(flag, data)
    elseif data.type == EnumActivity.SeasonFactionSelectionActivity.Type then
      doing = self:GetSeasonFactionSelectionActivityStatus(flag, data)
    elseif data.type == EnumActivity.SeasonFactionSelectionActivityMummy.Type then
      doing = self:GetSeasonFactionSelectionActivityStatus(flag, data)
    elseif data.type == EnumActivity.SheepGame.Type then
      doing = self:GetSheepGameStatus(flag, data)
    elseif data.type == EnumActivity.CounterAttack.Type then
      doing = self:GetCounterAttackStatus(flag, data)
    elseif data.type == EnumActivity.SeasonCrossDeclareWarActivity.Type then
      doing = self:GetSeasonCrossDeclareWarActivityStatus(flag, data)
    elseif data.type == EnumActivity.SeasonServerBattleV8Activity.Type then
      doing = self:GetSeasonServerBattleV8ActivityStatus(flag, data)
    elseif data.type == EnumActivity.SeasonWarZoneOutpostFix.Type then
      doing = self:GetSeasonWarZoneOutpostFixStatus(flag, data)
    elseif data.type == EnumActivity.SeasonWarZoneOutpostAttack.Type then
      doing = self:GetSeasonWarZoneOutpostAttackStatus(flag, data)
    elseif data.type == EnumActivity.Season6CampDestroy.Type then
      doing = self:GetSeason6CampDestroyStatus(flag, data)
    elseif data.type == EnumActivity.SeasonStrongholdRank.Type then
      doing = self:GetSeasonStrongholdRankStatus(flag, data)
    elseif data.type == EnumActivity.SeasonCityAltar.Type then
      doing = DataCenter.SeasonCityAltarManager:IsAnyAltarInContention()
    end
    if doing then
      return SeasonMainActivityRewardStatusType.During
    end
  end
  return SeasonMainActivityRewardStatusType.Normal
end

function SeasonMainActivitySignUtils:GetSheepGameStatus(flag, data)
  if flag == SeasonMainActivityRewardSignType.Duration then
    return not DataCenter.LWSheepDataManager:IsDayPass()
  elseif flag == SeasonMainActivityRewardSignType.Task then
    return DataCenter.LWSheepDataManager:IsDayPass()
  end
end

function SeasonMainActivitySignUtils:GetHeroPromotionStatus(flag, activityId)
  local activityHeroData = SeasonRedPointUtils.GetConfigData(tostring(activityId))
  if activityHeroData == nil then
    return false
  end
  local heroConfigData = DataCenter.SeasonDataManager:GetHeroCanPromoteDataByIndex(activityHeroData.index)
  if not heroConfigData then
    return false
  end
  local newHeroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroConfigData.newId)
  return newHeroData ~= nil
end

function SeasonMainActivitySignUtils:GetSeasonPeriodicCardStatus(flag, data)
  if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    local playerSeasonInfo = DataCenter.SeasonDataManager.playerSeasonInfo
    if playerSeasonInfo and playerSeasonInfo:GetConfig() and playerSeasonInfo:GetConfig().week_card then
      return not SeasonRedPointUtils.GetWeekFreeGift(playerSeasonInfo:GetConfig().week_card)
    end
  else
    return not DataCenter.RedPointManager:HasCount({
      "Season",
      tostring(data.activityId),
      "SeasonWeekCardFreeGift"
    })
  end
  return false
end

function SeasonMainActivitySignUtils:GetSeasonAttackCityActivityStatus(signType, data)
  if signType == SeasonMainActivityRewardSignType.Duration then
    local DeclareWarDataList = DataCenter.AllianceDeclareWarManager:GetAllianceDeclareWarData()
    if DeclareWarDataList ~= nil then
      local allianceId = LuaEntry.Player:GetAllianceUid()
      for _, WarData in ipairs(DeclareWarDataList) do
        if WarData.aId == allianceId then
          return true
        end
      end
    end
  elseif signType == SeasonMainActivityRewardSignType.Task then
    if LuaEntry.Player:IsInAlliance() then
      local DeclareWarData = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
      if DeclareWarData and DeclareWarData.content then
        local click_count = UIUtil.GetTodayActiveCount("SeasonAttackCity" .. DeclareWarData.content, false)
        if click_count == 0 then
          return false
        end
      end
    end
    if SeasonUtil.IsInSeasonNineNationMode() then
      local isDeclareDay = DataCenter.UILWSeasonAllianceWarTimeManager:IsDeclareDay()
      if not isDeclareDay then
        return true
      end
    end
    local k6 = DataCenter.AllianceDeclareWarManager:GetConfigData("k6")
    local dailyDeclareNum = DataCenter.SeasonDataManager.dailyDeclareNum or 0
    if k6 <= dailyDeclareNum then
      return true
    end
  end
  return false
end

function SeasonMainActivitySignUtils:GetSeasonLastWarStatus(flag, data)
  if data then
    local tasks = DataCenter.ActivityListDataManager:GetExtraData(EVE_DECISIVE_BATTLE_TASK)
    if tasks then
      for _, task in pairs(tasks) do
        if task and task.state ~= TaskState.Received then
          return false
        end
      end
      return true
    end
  end
  return false
end

function SeasonMainActivitySignUtils:GetDarknessSuppliesStatus(flag, data)
  local shareData = DataCenter.SeasonSuppliesShareDataManager:GetActivityInfo(false)
  local rewardCount = shareData and shareData.rewardCount or 0
  local max = shareData and shareData.rewardMax or 0
  return rewardCount >= max
end

function SeasonMainActivitySignUtils:GetTradeStationStatus(signType, data)
  local battleTrade = DataCenter.SeasonTradeDataManager:GetTradeStationDataByState(AllianceCityShowTimeState.TradeBattle)
  if signType == SeasonMainActivityRewardSignType.Duration then
    if battleTrade then
      return true
    end
  elseif signType == SeasonMainActivityRewardSignType.Task then
    if battleTrade then
      return false
    end
    local trade = DataCenter.SeasonTradeDataManager:GetTodayBattleTradeStation()
    if not trade then
      return true
    end
  end
  return false
end

function SeasonMainActivitySignUtils:GetHunterStatus(signType, data)
  local homeId, skillState, _, masteryTemp, skillTemplate = DataCenter.SeasonHunterManager:GetMasterySkillState()
  if signType == SeasonMainActivityRewardSignType.Duration then
    return skillState == MasterySkillState.Normal and DataCenter.SeasonHunterManager:IsBattleBegin()
  elseif signType == SeasonMainActivityRewardSignType.Task then
    return skillState == MasterySkillState.CD
  end
  return false
end

function SeasonMainActivitySignUtils:GetSeasonGoldTreeStatus(signType, data)
  if signType == SeasonMainActivityRewardSignType.Task then
    return DataCenter.SeasonGoldTreeManager:CanPrayCardCount() <= 0
  end
  return false
end

function SeasonMainActivitySignUtils:GetSeasonCallbackActivityStatus(signType, data)
  if signType == SeasonMainActivityRewardSignType.Task then
    return DataCenter.SeasonCallbackManager:HasView()
  end
  return false
end

function SeasonMainActivitySignUtils:GetSeasonFarmerActivityStatus(signType, data)
  if signType == SeasonMainActivityRewardSignType.Task then
    return not DataCenter.SeasonFarmerManager:IsActive() and DataCenter.SeasonFarmerManager:HasView()
  end
  return false
end

function SeasonMainActivitySignUtils:GetSeasonFactionSelectionActivityStatus(signType, data)
  local groupingActInfo = DataCenter.SeasonFactionWarDataManager:GetGroupingActInfo()
  local campInfo = DataCenter.SeasonFactionWarDataManager:GetGroupingData()
  if groupingActInfo then
    if groupingActInfo.hasSubStep then
      if groupingActInfo.subStep == 0 then
        return signType == SeasonMainActivityRewardSignType.Duration
      else
        return signType == SeasonMainActivityRewardSignType.Task
      end
    else
      return signType == SeasonMainActivityRewardSignType.Duration
    end
  elseif campInfo then
    return signType == SeasonMainActivityRewardSignType.Task
  end
  return false
end

function SeasonMainActivitySignUtils:GetSeasonFactionDeclareWarActivityStatus(signType, data)
  local mgr = DataCenter.SeasonFactionWarDataManager
  local actInfo = mgr:GetDeclareWarActInfo()
  if actInfo then
    local currStep = actInfo.currStep
    if signType == SeasonMainActivityRewardSignType.Duration then
      return currStep == SeasonFactionDeclareWarStep.battle or currStep == SeasonFactionDeclareWarStep.battle_after or currStep == SeasonFactionDeclareWarStep.battle_before
    elseif signType == SeasonMainActivityRewardSignType.Task then
      return currStep == SeasonFactionDeclareWarStep.declare_before
    end
  end
  return false
end

function SeasonMainActivitySignUtils:GetSeasonFactionBigWarActivityStatus(signType, data)
  local mgr = DataCenter.SeasonFactionWarDataManager
  local actInfo = mgr:GetDeclareWarActInfo()
  if actInfo then
    local currStep = actInfo.currStep
    if signType == SeasonMainActivityRewardSignType.Duration then
      return currStep == SeasonFactionDeclareWarStep.battle or currStep == SeasonFactionDeclareWarStep.battle_after or currStep == SeasonFactionDeclareWarStep.battle_before
    elseif signType == SeasonMainActivityRewardSignType.Task then
      return currStep == SeasonFactionDeclareWarStep.declare_before
    end
  end
  return false
end

function SeasonMainActivitySignUtils:GetBloodyNightStatus(signType, data)
  if signType == SeasonMainActivityRewardSignType.Duration then
    return DataCenter.BloodyNightDataManager:IsBloodyNight()
  elseif signType == SeasonMainActivityRewardSignType.Task then
    return DataCenter.BloodyNightDataManager:IsTodayTaskClear()
  end
  return false
end

function SeasonMainActivitySignUtils:GetCounterAttackStatus(signType, data)
  if signType == SeasonMainActivityRewardSignType.Duration then
    return DataCenter.CounterAttackDataManager:GetStage() == CounterAttackStage.Attack and DataCenter.CounterAttackDataManager:GetState() == 1
  elseif signType == SeasonMainActivityRewardSignType.Task then
    local now = UITimeManager:GetInstance():GetServerTime()
    local weekIndex = UITimeManager:GetInstance():GetWeekdayIndex(now)
    return weekIndex ~= 2 and weekIndex ~= 5
  end
  return false
end

function SeasonMainActivitySignUtils:GetHighSpeedRailwayStatus(signType, data)
  if signType == SeasonMainActivityRewardSignType.Task then
    return DataCenter.HSRDataManager:GetGetOnCount() <= 0 and 0 >= DataCenter.HSRDataManager:GetRobCount()
  end
  return false
end

function SeasonMainActivitySignUtils:GetSeasonServerBattleV8ActivityStatus(signType)
  if signType == SeasonMainActivityRewardSignType.Task then
    local open_count = UIUtil.GetWeekActiveCount("OpenServerBattleV8Main", false)
    if 0 < open_count then
      return true
    end
  end
  return false
end

function SeasonMainActivitySignUtils:GetSeasonCrossDeclareWarActivityStatus(signType)
  local data = DataCenter.SeasonDataManager.CrossDeclareWarInfo
  if data == nil then
    return false
  end
  if signType == SeasonMainActivityRewardSignType.Duration then
    if data.isDeclareWarDay then
      if data.declareList then
        for _, v in ipairs(data.declareList) do
          if v and v.result == 0 then
            return true
          end
        end
      end
      if data.beDeclareList then
        for _, v in ipairs(data.beDeclareList) do
          if v and v.result == 0 then
            return true
          end
        end
      end
    end
  elseif signType == SeasonMainActivityRewardSignType.Task then
    return not data.isDeclareWarDay
  end
  return false
end

function SeasonMainActivitySignUtils:GetSeasonTetrisStatus()
  return DataCenter.SeasonTetrisManager:IsAllFinished()
end

function SeasonMainActivitySignUtils:GetAllianceWarTimeStatus()
  return DataCenter.UILWSeasonAllianceWarTimeManager:HasSetWarTime()
end

function SeasonMainActivitySignUtils:GetActHeroLevelReplaceStatus(signType, data)
  if signType == SeasonMainActivityRewardSignType.Task then
    return DataCenter.ItemData:GetItemCount(640017) == 0
  end
  return false
end

function SeasonMainActivitySignUtils:GetLimitedTimeFeastStatus(signType, data)
  if signType == SeasonMainActivityRewardSignType.Task then
    local cur, max = DataCenter.ActLimitedTimeFeastData:GetCurAndMax(tonumber(data.id))
    return 0 <= max and max <= cur
  end
  return false
end

function SeasonMainActivitySignUtils:GetSeasonStrongholdRankStatus(signType, data)
  local actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonStrongholdRank.Type)
  if actData ~= nil and signType == SeasonMainActivityRewardSignType.Task then
    local dailyOccupyNum = toInt(DataCenter.SeasonDataManager.dailyStrongholdOccupyNum)
    local dailyOccupyMaxNum = toInt(DataCenter.SeasonDataManager.dailyStrongholdOccupyMaxNum)
    if 0 < dailyOccupyMaxNum and dailyOccupyNum >= dailyOccupyMaxNum then
      return true
    end
  elseif actData ~= nil and signType == SeasonMainActivityRewardSignType.Duration then
    local serverId, cityId = SeasonUtil.GetStrongholdInBattle()
    if serverId == nil or cityId == nil then
      return false
    end
    return true
  end
  return false
end

function SeasonMainActivitySignUtils:GetSeasonWarZoneOutpostFixStatus(signType, data)
  local actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonWarZoneOutpostFix.Type)
  if actData ~= nil and signType == SeasonMainActivityRewardSignType.Task then
    local seasonType = SeasonUtil.GetSeasonType(false, true, ServerEnum.Source)
    if seasonType == SeasonMapType.NineNationRainforest then
      local dataList = DataCenter.SeasonOutpostManager:CalcPutData()
      if not dataList then
        goto lbl_190
      end
      local theOutpostPosList = DataCenter.SeasonOutpostManager.theOutpostPosList
      local mySourceServerId = LuaEntry.Player:GetSourceServerId()
      local isManager = DataCenter.OfficialApplyManager:IsManager(mySourceServerId)
      local now = UITimeManager:GetInstance():GetServerTime()
      local theCityData
      for i = 1, 4 do
        theCityData = dataList[i]
        if not (now < theCityData.put_start_time) then
          if now < theCityData.put_end_time then
            if isManager and theOutpostPosList and theOutpostPosList[theCityData.index] == nil then
              return false
            end
            break
        end
        elseif now < theCityData.finish_time then
          break
        end
      end
      if theCityData and theCityData.cityInfo ~= nil and theCityData.cityInfo.repairInfo ~= nil and theCityData.cityInfo.repairInfo.outpostInfo ~= nil then
        if theCityData.cityInfo.repairInfo.outpostInfo.state == 1 then
          return true
        end
        local repairInfo = theCityData.cityInfo.repairInfo
        local hasPoint = 0
        if repairInfo then
          local outpostInfo = repairInfo.outpostInfo or {}
          hasPoint = toInt(outpostInfo.repairScore)
        end
        local needPoint = toInt(actData.para)
        if 0 < needPoint and hasPoint >= needPoint then
          return true
        elseif repairInfo ~= nil then
          local canRepairCount = toInt(actData.para_4)
          local repairCount = toInt(repairInfo.repairCount)
          return canRepairCount <= repairCount
        end
      end
    elseif seasonType == SeasonMapType.NineNation then
      local FetchOutpostRepairInfo = require("Net.Msgs.Season5.Outpost.FetchOutpostRepairInfoMessage")
      local mySourceServerId = LuaEntry.Player:GetSourceServerId()
      local cityId, serverId = SeasonUtil.GetOutpostId(mySourceServerId)
      local cityInfo = FetchOutpostRepairInfo.GetRepairInfo(serverId, cityId, true, false)
      local hasPoint = 0
      if cityInfo then
        local outpostInfo = cityInfo.outpostInfo or {}
        hasPoint = toInt(outpostInfo.repairScore)
      end
      local needPoint = toInt(actData.para)
      if 0 < needPoint and hasPoint >= needPoint then
        return true
      elseif cityInfo ~= nil then
        local canRepairCount = toInt(actData.para_4)
        local repairCount = toInt(cityInfo.repairCount)
        return canRepairCount <= repairCount
      end
    end
  end
  ::lbl_190::
  return false
end

function SeasonMainActivitySignUtils:GetSeasonWarZoneOutpostAttackStatus(signType, data)
  local attackActData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonWarZoneOutpostAttack.Type)
  if attackActData ~= nil and signType == SeasonMainActivityRewardSignType.Duration then
    local FetchOutpostBattleInfoMessage = require("Net.Msgs.Season5.Outpost.FetchOutpostBattleInfoMessage")
    local battleInfo = FetchOutpostBattleInfoMessage.GetBattleInfo(true, false)
    if battleInfo ~= nil then
      local battle_stage_list = battleInfo.stage
      if battle_stage_list == nil then
        return false
      end
      local now = UITimeManager:GetInstance():GetServerTime()
      local max_battle_time = DataCenter.SeasonOutpostManager:TryGetNum("k1", 3600) * 1000
      for i, v in ipairs(battle_stage_list) do
        if v <= now and now < v + max_battle_time then
          return true
        end
      end
    end
  end
  return false
end

function SeasonMainActivitySignUtils:GetBiuBiuStatus(signType, data)
  if signType == SeasonMainActivityRewardSignType.Task then
    return not DataCenter.LWBiuBiuDataManager:GetBiuBiuRed(true)
  end
  return false
end

function SeasonMainActivitySignUtils:GetSeason6CampDestroyStatus(signType, data)
  local mgr = DataCenter.SeasonCampDestroyManager
  if not mgr or not mgr:IsActive() then
    return false
  end
  if DataCenter.SeasonCampDestroyManager:GetFirstSeenRedPoint() or DataCenter.SeasonRewardDataManager:IsCampAchievementRewardTabFuckRed() then
    return false
  end
  local declareDay = mgr:IsDeclareDay()
  if signType == SeasonMainActivityRewardSignType.Duration then
    if declareDay then
      local stage = mgr:GetCurrentBattleStage()
      return stage == SeasonCampDestroyStage.Fight
    else
      return false
    end
  elseif signType == SeasonMainActivityRewardSignType.Task then
    return not declareDay
  end
end

function SeasonMainActivitySignUtils:GetGGGoStatus(signType, data)
  if signType == SeasonMainActivityRewardSignType.Task then
    return not DataCenter.LWGGGoDataManager:GetGGGoRed(true)
  end
  return false
end

return SeasonMainActivitySignUtils
