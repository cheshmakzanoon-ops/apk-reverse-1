local ActivityListDataManager = BaseClass("ActivityListDataManager")
local Localization = CS.GameEntry.Localization
local AllianceCompeteInfo = require("DataCenter.ActivityListData.ActAllianceBattleInfo")
local ActLeadingQuestData = require("DataCenter.ActivityListData.ActLeadingQuestData")
local ActBarterShopData = require("DataCenter.ActivityListData.ActBarterShopData")
local LockhartActivityMain = require("UI.UIActivityCenterTable.Component.Lockhart.LockhartActivityMain")
local KillZombieActivityMain = require("UI.UIActivityCenterTable.Component.KillZombie.KillZombieActivityMain")
local AttackCityActivityMain = require("UI.UIActivityCenterTable.Component.AttackCity.AttackCityActivityMain")
local TaskActivity = require("UI.UIActivityCenterTable.Component.Task.TaskActivity")
local HeroTrial = require("UI.UIActivityCenterTable.Component.HeroTrial.UIHeroTrial")
local ActivitySeasonDesertTreasureData = require("DataCenter.ActivityListData.ActivitySeasonDesertTreasureData")
local ActivityAccuRechargeInfoData = require("DataCenter.ActivityListData.ActivityAccuRechargeInfoData")
local ActivityOptionalWeekCardInfoData = require("DataCenter.ActivityListData.ActivityOptionalWeekCardInfoData")
local DataCenter = _ENV.DataCenter

local function __init(self)
  self.activityList = {}
  self.nowActivityList = {}
  self.laterActivityList = {}
  self.overActivityList = {}
  self.sevenDayList = {}
  self.lastVisitActivityId = nil
  self.lastVisitActDic = {}
  self.sevenDayLastVisitDayTab = nil
  self.timer = {}
  
  function self.timer_action(temp)
    self:RefreshArmsTime(temp)
  end
  
  self.firstMinuteTips = {}
  self.tenMinuteTips = {}
  self.fifteenMinuteTips = {}
  self:StartPassDayTimer()
  self:StartPassWeekTimer()
  self:StartUnDelayPassDayTimer()
  self.actScoreList = {}
  self.activityExtraData = {}
  self.activitySaveMinEndTime = -1
  self.activityEndTimer = nil
  self.actEventInfoMap = {}
  self.activityCache = {}
  self.viewActIdHaveClickHashSet = {}
  self.itemActivityData = {}
  self.itemActivityNeedToHidData = {}
  self.seasonCfgData = nil
  self.btnIconPathDataList = nil
end

local function __delete(self)
  if self.passDayTimer then
    self.passDayTimer:Stop()
    self.passDayTimer = nil
  end
  if self.passWeekTimer then
    self.passWeekTimer:Stop()
    self.passWeekTimer = nil
  end
  if self.unDelayPassDayTimer then
    self.unDelayPassDayTimer:Stop()
    self.unDelayPassDayTimer = nil
  end
  self.activityList = nil
  self.nowActivityList = nil
  self.laterActivityList = nil
  self.overActivityList = nil
  self.sevenDayList = nil
  self.lastVisitActivityId = nil
  self.lastVisitActDic = nil
  self.sevenDayLastVisitDayTab = nil
  self:DeleteArmsTimer()
  self.firstMinuteTips = nil
  self.tenMinuteTips = nil
  self.fifteenMinuteTips = nil
  self.actScoreList = nil
  self.activityExtraData = nil
  self.activityCache = {}
  table.walk(self.countdown, function(k, v)
    if v ~= nil then
      v:Stop()
    end
  end)
  self.activitySaveMinEndTime = -1
  self:StopActivityEndTimer()
  self.actEventInfoMap = nil
  self.viewActIdHaveClickHashSet = nil
  self.itemActivityData = nil
  self.itemActivityNeedToHidData = nil
  self.seasonCfgData = nil
  self.btnIconPathDataList = nil
end

local function InitActivityListData(self, message)
  DataCenter.GetDuelScoreManager:ClearAllDuelInfo()
  self.activityList = {}
  if message.activity ~= nil then
    Logger.Log(" activityList count: ", table.length(message.activity))
    table.walk(message.activity, function(k, v)
      self.activityCache[k] = v
    end)
  end
  if message.dayAct ~= nil then
    local data = ActivitySevenDayInfo.New()
    data:ParseActivityData(message.dayAct)
    self.sevenDayList = data
  end
  if message.eliteRedPoint ~= nil then
    DataCenter.ActChampionBattleManager:RefreshRedPoint(message.eliteRedPoint)
  end
  if message.shownEliteAct ~= nil then
    DataCenter.ActChampionBattleManager:SetEntranceOpenState(message.shownEliteAct)
  end
  self.activityExtraData[KILL_LOCK_HART_BOSS] = message[KILL_LOCK_HART_BOSS] or 0
  self.activityExtraData[KILL_LOCK_HART_BOSS_LEADER] = message[KILL_LOCK_HART_BOSS_LEADER] or 0
  self.activityExtraData[DIG_DISPATCH_GUARANTEE_NUM] = message[DIG_DISPATCH_GUARANTEE_NUM] or 0
end

local function RequestActivityData(self)
  if next(self.activityCache) == nil then
    return
  end
  for k, v in pairs(self.activityCache) do
    self:AddOneActivity(k, v, true)
  end
  self.activityCache = {}
  self:UpdateDialogSkinData()
end

local function StopActivityEndTimer(self)
  if self.activityEndTimer ~= nil then
    self.activityEndTimer:Stop()
    self.activityEndTimer = nil
  end
end

function ActivityListDataManager:UpdateExtraData(k, v)
  if self.activityExtraData ~= nil then
    self.activityExtraData[k] = v
  end
end

function ActivityListDataManager:GetExtraData(k, v)
  if k == nil or self.activityExtraData == nil then
    return v
  end
  return self.activityExtraData[k] or v
end

local function SaveData()
end

local function AddOneActivity(self, k, v, skipSkin)
  local data = ActivityInfoData.New()
  data:ParseActivityData(v)
  if data.id ~= nil then
    if data.type == EnumActivity.AllianceCompete.Type then
      local tempData = AllianceCompeteInfo.New()
      tempData:parseServerData(v)
      self.activityList[tempData.id] = tempData
      SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
      SFSNetwork.SendMessage(MsgDefines.AllianceCompeteWeeklySummary)
    elseif data.type == EnumActivity.PersonalArms.Type then
      DataCenter.ActPersonalArmsInfo:SetActivityId(data.activityId)
      self.activityList[data.id] = data
      self:ActivityByArmsTime(data)
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
      end
    elseif data.type == EnumActivity.KingActivity.Type then
      self.activityList[data.id] = data
      SFSNetwork.SendMessage(MsgDefines.GetKingdomActivityInfo)
    elseif data.type == EnumActivity.AllyDrill.Type then
      self.activityList[data.id] = data
      DataCenter.AllyDrillDataManager:SendMsgAllianceBossActInfo()
    elseif data.type == EnumActivity.SandWormHunt.Type then
      self.activityList[data.id] = data
      DataCenter.SandWormHuntDataManager:FetchActivityData()
      DataCenter.SandWormHuntDataManager:FetchTaskData()
    elseif data.type == EnumActivity.JungleTrial.Type then
      self.activityList[data.id] = data
      DataCenter.JungleTrialDataManager:FetchActivityData()
    elseif data.type == EnumActivity.BloodyNight.Type then
      self.activityList[data.id] = data
      DataCenter.BloodyNightDataManager:InitActivityData()
    elseif data.type == EnumActivity.HighSpeedRailway.Type then
      self.activityList[data.id] = data
      DataCenter.HSRDataManager:InitActivityData(data)
    elseif data.type == EnumActivity.Puzzle.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.ActivityPuzzleDataManager:SendMessageGetInfo(tostring(data.id))
      end
    elseif data.type == EnumActivity.AllianceOrder.Type then
      self.activityList[data.id] = data
      DataCenter.ActAllianceOrderManager:SetActivityData(data)
      if not string.IsNullOrEmpty(LuaEntry.Player.allianceId) then
        DataCenter.ActAllianceOrderManager:SendMessageGetInfo()
      end
    elseif data.type == EnumActivity.IndividualOrder.Type then
      self.activityList[data.id] = data
      DataCenter.ActIndividualOrderManager:SetActivityData(data)
      if self:CheckIsSend(data) then
        DataCenter.ActIndividualOrderManager:SendMessageGetInfo()
      end
    elseif data.type == EnumActivity.EdenWar.Type then
      self.activityList[data.id] = data
    elseif data.type == EnumActivity.WorldBoss.Type then
      self.activityList[data.id] = data
      local activityIdNew = toInt(data.id)
      if data and data:GetValidType() ~= ActivityValidType.Over then
        local activityIdOld = DataCenter.ActBossDataManager.activityId
        if activityIdOld and activityIdOld ~= activityIdNew then
          self.activityList[tostring(activityIdOld)] = nil
        end
      end
      DataCenter.ActBossDataManager:InitActivityData(activityIdNew, data)
      EventManager:GetInstance():Broadcast(EventId.WorldBossInitActivityData)
      DataCenter.LWSeasonBossLoginDataManager:InitAchievementTaskDataByActivity(data)
    elseif data.type == EnumActivity.LeadingQuest.Type then
      local tempInfo = ActLeadingQuestData.New()
      tempInfo:ParseData(v)
      self.activityList[data.id] = tempInfo
    elseif data.type == EnumActivity.MineCave.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.GetMineCaveInfo)
      end
    elseif data.type == EnumActivity.BarterShop.Type then
      local tempInfo = ActBarterShopData.New()
      tempInfo:ParseData(v)
      self.activityList[data.id] = tempInfo
    elseif data.type == EnumActivity.RadarRally.Type then
      self.activityList[data.id] = data
    elseif data.type == EnumActivity.BarterShopNotice.Type then
      local tempInfo = ActBarterShopData.New()
      tempInfo:ParseData(v)
      self.activityList[data.id] = tempInfo
    elseif data.type == EnumActivity.Arena.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.ArenaManager:InitRed()
      end
    elseif data.type == EnumActivity.DigActivity.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.DigActivityManager:RequestDigInfo(tonumber(data.id))
      end
    elseif data.type == EnumActivity.ActivitySummary.Type then
      self.activityList[data.id] = data
      DataCenter.ThemeActivityManager:UpdateOneThemeActivity(data)
    elseif data.type == EnumActivity.JigsawPuzzle.Type then
      self.activityList[data.id] = data
    elseif data.type == EnumActivity.LuckyRoll.Type then
      DataCenter.ActLuckyRollInfo:SetActivityId(data.id)
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.GetLuckyRollInfo, toInt(data.id))
      end
      self.activityList[data.id] = data
    elseif data.type == EnumActivity.BattlePass.Type then
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.GetBattlePassInfo, toInt(data.id))
      end
      DataCenter.ActBattlePassData:SetActivityId(data.id)
      self.activityList[data.id] = data
    elseif data.type == EnumActivity.BattlePass_new.Type then
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.id))
      end
      DataCenter.ActBattlePassData:SetActivityId(data.id)
      self.activityList[data.id] = data
    elseif data.type == EnumActivity.Adventure.Type then
      DataCenter.AdventureManager:SetActivityData(data)
      self.activityList[data.id] = data
    elseif data.type == EnumActivity.GolloesCards.Type then
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.GetGolloesCardInfo, toInt(data.id))
      end
      DataCenter.ActGolloesCardData:SetActivityId(data.id)
      self.activityList[data.id] = data
    elseif data.type == EnumActivity.PveAct.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.PveActManager:SendGetinfoByActId(tonumber(data.id))
        DataCenter.PveActManager:SendGetRank(tonumber(data.id))
      end
    elseif data.type == EnumActivity.MonsterTower.Type then
      DataCenter.ActMonsterTowerData:SetActivityId(data.id)
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.GetChallengeActInfo, toInt(data.id))
      end
    elseif data.type == EnumActivity.ActSevenDay.Type then
      DataCenter.ActSevenDayData:SetActivityId(data.id)
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.GetSevenDayActInfo, toInt(data.id))
      end
    elseif data.type == EnumActivity.GiftBoxActivity.Type then
      DataCenter.ActGiftBoxData:SetActivityId(data.id)
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.GetActivityGiftBoxInfo, toInt(data.id))
      end
    elseif data.type == ActivityEnum.ActivityType.LuckyShop then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.LuckyShopManager:GetShopInfoData(toInt(data.id))
      end
    elseif data.type == EnumActivity.StrongestCommander.Type then
      DataCenter.StrongestCommanderDataManager:SetActivityId(data.activityId)
      self.activityList[data.id] = data
      self:ActivityByArmsTime(data)
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
      end
    elseif data.type == EnumActivity.DispatchTask.Type then
      local dispatchTaskList = self:GetActivityDataByType(EnumActivity.DispatchTask.Type)
      for _, v in ipairs(dispatchTaskList) do
        self.activityList[v.id] = nil
      end
      self.activityList[data.id] = data
    elseif data.type == EnumActivity.ActDragon.Type then
      self.activityList[data.id] = data
      EnumActivity.ActDragon.ActId = data.id
      EnumActivity.ActDragon.needMainCityLevel = data.needMainCityLevel or 15
      if self:CheckIsSend(data) then
        DataCenter.ActDragonManager:ReqActInfo(true)
      end
    elseif data.type == EnumActivity.ActWinterStorm.Type then
      self.activityList[data.id] = data
      EnumActivity.ActWinterStorm.ActId = data.id
      EnumActivity.ActWinterStorm.needMainCityLevel = data.needMainCityLevel or 15
      if self:CheckIsSend(data) then
        DataCenter.ActWinterStormManager:ReqActInfo()
      end
    elseif data.type == EnumActivity.LockhartActivity.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.LockhartUnlockLevelGet)
        EventManager:GetInstance():Broadcast(EventId.Al_LockHartActivityTip)
      end
    elseif data.type == EnumActivity.KillZombieActivity.Type then
      self.activityList[data.id] = data
      DataCenter.ActivityKillZombieManager:InitActivity(data.id)
    elseif data.type == EnumActivity.PersonalArmsNew.Type then
      self:HandleAddPersonalArmsNew(data)
    elseif data.type == EnumActivity.AccuRecharge.Type then
      local tempData = ActivityAccuRechargeInfoData.New()
      tempData:ParseActivityData(v)
      self.activityList[tempData.id] = tempData
    elseif data.type == EnumActivity.GrowFoundation.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
      end
    elseif data.type == EnumActivity.RebateActivity.Type then
      self.activityList[data.id] = data
      SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
      SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, data.shopId)
    elseif data.type == EnumActivity.TaskActivity.Type or data.type == EnumActivity.TaskActivity2.Type then
      self.activityList[data.id] = data
      SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
    elseif data.type == EnumActivity.HeroTrialActivity.Type then
      self.activityList[data.id] = data
      SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
    elseif data.type == EnumActivity.TreasureHuntActivity.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.DigActivityManager:RequestDigInfo(tonumber(data.id))
      end
    elseif data.type == EnumActivity.ScratchOffGame.Type then
      DataCenter.ScratchOffGameManager:SetActivityId(data.id)
      self.activityList[data.id] = data
    elseif data.type == EnumActivity.ContinuePay.Type then
      self.activityList[data.id] = data
      SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
    elseif data.type == EnumActivity.InfiniteGift.Type or data.type == EnumActivity.CitySkinGet.Type or data.type == EnumActivity.CitySkinExchange.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
      end
    elseif data.type == EnumActivity.ArenaNewbie.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
      end
    elseif data.type == EnumActivity.Cooking.Type then
      DataCenter.ActCookingData:SetActivityId(data.id)
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityMakeFoodInfo, toInt(data.id))
      end
    elseif data.type == EnumActivity.Banquet.Type then
      DataCenter.ActBanquetData:SetActivityId(data.id)
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyInfo, toInt(data.id))
      end
    elseif data.type == EnumActivity.BanquetAttackMonster.Type then
      DataCenter.ActBanquetV2Data:SetActivityId(data.id)
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyV2Info, toInt(data.id))
      end
    elseif data.type == EnumActivity.BargainShop.Type then
      DataCenter.ActBargainShopData:SetActivityId(data.id)
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.id))
        SFSNetwork.SendMessage(MsgDefines.BargainHelpHistory, tostring(data.id))
      end
    elseif data.type == EnumActivity.ActMonopoly.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
      end
    elseif data.type == EnumActivity.SunriseFoundation.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.SunriseInfo, tonumber(data.activityId))
      end
    elseif data.type == EnumActivity.ActGiftGiving.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ThanksgivingInfo, tonumber(data.activityId))
      end
    elseif data.type == EnumActivity.ActLottery.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.LottoInfo, tonumber(data.activityId))
      end
    elseif data.type == EnumActivity.ActTrends.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityTrendInfo, tonumber(data.activityId))
      end
    elseif data.type == EnumActivity.ChampionDuelMain.Type then
      self.activityList[data.id] = data
    elseif data.type == EnumActivity.ActBingo.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
      end
    elseif data.type == EnumActivity.ActSlotMachine.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
      end
    elseif data.type == EnumActivity.ActTask.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
      end
    elseif data.type == EnumActivity.ArenaNewbieV2.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
      end
    elseif data.type == EnumActivity.TitaniumBlueStore.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
      end
    elseif data.type == EnumActivity.OptionalWeekCard.Type then
      DataCenter.LWOptionalWeekCardManager:SetActivityId(data.id)
      local tempData = ActivityOptionalWeekCardInfoData.New()
      tempData:ParseActivityData(v)
      self.activityList[tempData.id] = tempData
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
      end
    elseif data.type == EnumActivity.Doomsday.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
        SFSNetwork.SendMessage(MsgDefines.ActivityDoomsdayQuestInfo)
      end
    elseif data.type == EnumActivity.SeasonCrossDeclareWarActivity.Type then
      self.activityList[data.id] = data
      SFSNetwork.SendMessage(MsgDefines.GetCrossDeclareWarInfo)
    elseif data.type == EnumActivity.SeasonServerBattleV8Activity.Type then
      self.activityList[data.id] = data
    elseif data.type == EnumActivity.MultipleParkour.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
      end
    elseif data.type == EnumActivity.SignIn.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
      end
    elseif data.type == EnumActivity.SeasonSynthesis.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.LWSeasonActivitySynthesisInfo)
      end
    elseif data.type == EnumActivity.SeasonCallbackActivity.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.SeasonCallbackManager:InitData(data)
      end
    elseif data.type == EnumActivity.SeasonFarmer.Type then
      if SeasonUtil.GetFarmerConfigId() > 0 then
        self.activityList[data.id] = data
        if self:CheckIsSend(data) then
          DataCenter.SeasonFarmerManager:InitData(data)
        end
      end
    elseif data.type == EnumActivity.TradeStation.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.SeasonTradeDataManager:InitData(data)
      end
    elseif data.type == EnumActivity.DiggingGame.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.DiggingDataManager:InitData(data)
      end
    elseif data.type == EnumActivity.OFF_SEASON_DIG_REWARD.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.OffSeasonDiggingDataManager:InitData(data)
      end
    elseif data.type == EnumActivity.SeasonGreen.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.SeasonGreenManager:InitData(data)
      end
    elseif data.type == EnumActivity.SeasonPhoto.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.SeasonPhotoManager:InitData(data)
      end
    elseif data.type == EnumActivity.SeasonHunter.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.SeasonHunterManager:InitData(data)
      end
    elseif data.type == EnumActivity.DarknessSupplies.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.SeasonSuppliesShareDataManager:InitData(data)
      end
    elseif data.type == EnumActivity.GoldTree.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.SeasonGoldTreeManager:InitData(data)
        DataCenter.SeasonGoldTreeThirdManager:InitData(data)
      end
    elseif data.type == EnumActivity.SeasonPreview.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.SeasonPreviewManager:InitData(data)
      end
      DataCenter.SeasonPreviewManager.activityId = data.id
      DataCenter.SeasonPreviewManager.activityType = data.type
    elseif data.type == EnumActivity.CounterAttack.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.CounterAttackDataManager:InitData(data.id, data.para_2)
      end
    elseif data.type == EnumActivity.DispatchTreasure.Type then
      self.activityList[data.id] = data
    elseif data.type == EnumActivity.LeadingQuestV2.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
      end
    elseif data.type == EnumActivity.ZombieRush.Type then
      self.activityList[data.id] = data
      DataCenter.LWZombieRushManager:SendMsgZombieRushActInfo()
    elseif data.type == EnumActivity.TreasureHuntNewActivity.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.ActivityTreasureHuntNewManager:RequestDigInfo(tonumber(data.id))
      end
    elseif data.type == EnumActivity.CommunityLink.Type then
      if DataCenter.ActCommunityLinkManager:CheckActOpen() then
        self.activityList[data.id] = data
        if self:CheckIsSend(data) then
          DataCenter.ActCommunityLinkManager:SetActId(data.id)
        end
      end
    elseif data.type == EnumActivity.Questionnaire.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.LWQuestionnaireManager:SendMsgInquiryList()
      end
    elseif data.type == EnumActivity.ActivityRebateNew.Type then
      self.activityList[data.id] = data
      SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
      SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, data.shopId)
    elseif data.type == EnumActivity.BlackMarket.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
      end
      DataCenter.BuildManager:RefreshBuildingStateByType(BuildingTypes.LW_BUILD_BLACKMARKET)
    elseif data.type == EnumActivity.LimitedTimeFeast.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
      end
    elseif data.type == EnumActivity.DecorationGacha.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
      end
    elseif data.type == EnumActivity.Ghostrecon.Type then
      local ghostReconList = self:GetActivityDataByType(EnumActivity.Ghostrecon.Type)
      for _, v in ipairs(ghostReconList) do
        self.activityList[v.id] = nil
      end
      self.activityList[data.id] = data
      SFSNetwork.SendMessage(MsgDefines.GhostreconGetTaskList)
      SFSNetwork.SendMessage(MsgDefines.GhostReconGetAllianceTaskList)
    elseif data.type == EnumActivity.SnowStormComing.Type then
      local now = UITimeManager:GetInstance():GetServerTime()
      if now < data.endTime then
        DataCenter.SeasonSnowStormDataManager:RequestCurActivityInfo()
      end
      self.activityList[data.id] = data
    elseif data.type == EnumActivity.BerserkBoss.Type then
      self.activityList[data.id] = data
      DataCenter.LWBerserkBossManager:RequestAllBerserkBossInfo()
    elseif data.type == EnumActivity.TorchRelay.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
      end
    elseif data.type == EnumActivity.LotteLink.Type then
      local isNeedShow = DataCenter.ActivityLotteLinkManager:CheckIsNeedShowLotteLink(data)
      if isNeedShow then
        self.activityList[data.id] = data
        EventManager:GetInstance():Broadcast(EventId.LottleActivityGenVisitorCheck)
      end
    elseif data.type == EnumActivity.SeasonCrossAttackCityActivity.Type then
      self.activityList[data.id] = data
      SFSNetwork.SendMessage(MsgDefines.SeasonCrossAttackCityInfo)
    elseif data.type == EnumActivity.SeasonNuclearPowerPlantActivity.Type then
      SFSNetwork.SendMessage(MsgDefines.ViewBehemothDailyTime)
      if toInt(data.para) == 1 then
        SFSNetwork.SendMessage(MsgDefines.ViewBehemothTaskList, data.id)
      end
      self.activityList[data.id] = data
    elseif data.type == EnumActivity.MonsterInvasion.Type then
      self.activityList[data.id] = data
      DataCenter.ActivityMonsterInvasionDataManager:SetActivityId(data.activityId)
      DataCenter.ActivityMonsterInvasionDataManager:ReqMonsterInvasionActInfoMsg(data.activityId, false)
      SFSNetwork.SendMessage(MsgDefines.MonsterShopInfo, data.activityId)
    elseif data.type == EnumActivity.FrontBreakSunday.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
      end
    elseif data.type == EnumActivity.ActSevenDayV2.Type then
      DataCenter.ActSevenDayV2Data:SetActivityId(data.id)
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.GetSevenDayV2ActInfo, toInt(data.id))
      end
    elseif data.type == EnumActivity.ActMeteorite.Type then
      self.activityList[data.id] = data
      EnumActivity.ActMeteorite.ActId = data.id
      EnumActivity.ActMeteorite.needMainCityLevel = data.needMainCityLevel or 10
      if self:CheckIsSend(data) then
        DataCenter.ActMeteoriteBattleManager:ReqGetActInfo()
      end
    elseif data.type == EnumActivity.ActEpidemic.Type then
      self.activityList[data.id] = data
      EnumActivity.ActEpidemic.ActId = data.id
      if self:CheckIsSend(data) then
        DataCenter.ActEpidemicZoneManager:RequestActivityInfo(true)
      end
    elseif data.type == EnumActivity.ActDsbDuel.Type then
      self.activityList[data.id] = data
      EnumActivity.ActDsbDuel.ActId = data.id
      EnumActivity.ActDsbDuel.needMainCityLevel = data.needMainCityLevel or 10
      if self:CheckIsSend(data) then
        BattlefieldDsbDuelUtils.ActInfo:SendActInfoMsg(true)
      end
    elseif data.type == EnumActivity.DesertTreasure.Type then
      local tempData = ActivitySeasonDesertTreasureData.New()
      tempData:ParseActivityData(v)
      self.activityList[tempData.id] = tempData
    elseif data.type == EnumActivity.ActHeroLevelAndStarReplace.Type then
      self.activityList[data.id] = data
      DataCenter.ActExchangeHeroDataManager:UpdateData(v)
    elseif data.type == EnumActivity.ActValentineReceiveGift.Type then
      self.activityList[data.id] = data
      SFSNetwork.SendMessage(MsgDefines.ValentineGetActivityInfo, toInt(data.id), 1)
    elseif data.type == EnumActivity.ActBountyHunter.Type then
      self.activityList[data.id] = data
      SFSNetwork.SendMessage(MsgDefines.BountyHunterGetInfo, toInt(data.id))
    elseif data.type == EnumActivity.RevivalPlan.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(data.activityId))
      end
    elseif data.type == EnumActivity.SheepGame.Type then
      self.activityList[data.id] = data
      DataCenter.LWSheepDataManager:UpdateData(v)
    elseif data.type == EnumActivity.BiuBiu.Type then
      self.activityList[data.id] = data
      DataCenter.LWBiuBiuDataManager:UpdateData(v)
    elseif data.type == EnumActivity.GGGo.Type then
      self.activityList[data.id] = data
      DataCenter.LWGGGoDataManager:UpdateData(v)
    elseif data.type == EnumActivity.CampScience.Type then
      self.activityList[data.id] = data
      DataCenter.CampScienceDataManager:InitActivity(v)
    elseif data.type == EnumActivity.VirusResearch.Type then
      self.activityList[data.id] = data
      DataCenter.LWSpreadResearchDataManager:UpdateData(v)
    elseif data.type == EnumActivity.BossLogin.Type then
      self.activityList[data.id] = data
      DataCenter.LWSeasonBossLoginDataManager:InitActivityData(data.id, data)
    elseif data.type == EnumActivity.DigTreasure.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.DigTreasureManager:InitData(data)
      end
    elseif data.type == EnumActivity.ActEasterEgg.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.EasterEggInfo, toInt(data.id), 1)
      end
    elseif data.type == EnumActivity.OffSeason1Recapture.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.OffSeason1RecaptureManager:InitData(data.id)
      end
    elseif data.type == EnumActivity.OffSeason1QueenOfBlood.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.OffSeason1QueenOfBloodManager:InitData(data)
      end
    elseif data.type == EnumActivity.CrazyRock.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.MusicGameActivityInfo, toInt(data.id))
      end
    elseif data.type == EnumActivity.ActivityTetris.Type then
      self.activityList[data.id] = data
      DataCenter.SeasonTetrisManager:SetActId(data.id)
      if self:CheckIsSend(data) then
        DataCenter.SeasonTetrisManager:SendGetInfo()
      end
    elseif data.type == EnumActivity.SurfingBattleAct.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.LWSurfingDataManager:SendGetAllParkourInfosMessage(nil, true)
        DataCenter.LWSurfingDataManager:SetActId(data.id)
      end
    elseif data.type == EnumActivity.S0AttackCityNew.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.AttackCityS0DataManager:GetCityAttackActivityInfoMsg()
      end
    elseif data.type == EnumActivity.S0AttackCityBattlePass.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.AttackCityS0DataManager:GetBattlePassTaskMsg(CityAttackS0NewBattlePassType.ALL)
      end
    elseif data.type == EnumActivity.S0AttackCityClue.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.AttackCityS0DataManager:SendCityClueMsg()
      end
    elseif data.type == EnumActivity.OFF_SEASON_Treasure_V2.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        DataCenter.DigTreasureBoxRewardManager:SendMainBoxRewardUIMessage()
        DataCenter.DigTreasureBoxRewardManager:SetActId(data.activityId)
        EventManager:GetInstance():Broadcast(EventId.TreasureBoxRewardActRefresh)
      end
    elseif data.type == EnumActivity.SeasonBountyShop.Type then
      self.activityList[data.id] = data
      DataCenter.SeasonBountyShopManager:SetActId(data.id)
      if self:CheckIsSend(data) then
        DataCenter.SeasonBountyShopManager:SendGetList()
      end
    elseif data.type == EnumActivity.SeasonSelectLocation.Type then
      self.activityList[data.id] = data
      DataCenter.SeasonSelectLocationManager:SetActId(data.id)
      if self:CheckIsSend(data) then
      end
    elseif data.type == EnumActivity.SeasonMoneyRank.Type then
      self.activityList[data.id] = data
      DataCenter.SeasonMoneyRankManager:SetActId(data.id)
      if self:CheckIsSend(data) then
      end
    elseif data.type == EnumActivity.SeasonAllianceWarTime.Type then
      self.activityList[data.id] = data
      DataCenter.UILWSeasonAllianceWarTimeManager:SetActId(data.id)
      if self:CheckIsSend(data) then
        DataCenter.UILWSeasonAllianceWarTimeManager:SendGetInfo()
      end
    elseif data.type == EnumActivity.Season6CampDestroy.Type then
      self.activityList[data.id] = data
      DataCenter.SeasonCampDestroyManager:SetActId(data.id)
      if self:CheckIsSend(data) then
        DataCenter.SeasonCampDestroyManager:SendGetInfo()
      end
    elseif data.type == EnumActivity.NineNationKingBattle.Type then
      self.activityList[data.id] = data
      DataCenter.SeasonNineKingManager:InitData(data)
      if self:CheckIsSend(data) then
      end
    elseif data.type == EnumActivity.GhostParkour.Type then
      self.activityList[data.id] = data
      DataCenter.LWGhostParkourDataManager:SetActivityId(data.id)
      if self:CheckIsSend(data) then
        DataCenter.LWGhostParkourDataManager:SendGetGhostParkourInfosMessage()
      end
    elseif data.type == EnumActivity.SurvivalVipGift.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.SurvivalVipGiftGetInfo, toInt(data.id))
      end
    elseif data.type == EnumActivity.ActLandlord.Type then
      self.activityList[data.id] = data
      EnumActivity.ActLandlord.ActId = data.id
      EnumActivity.ActLandlord.needMainCityLevel = data.needMainCityLevel or 0
      if self:CheckIsSend(data) then
        DataCenter.LandlordMgr:ReqActInfo(true)
      end
    elseif data.type == EnumActivity.Recycle.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.RecycleShopInfo, checknumber(data.id))
      end
    elseif data.type == EnumActivity.SeasonSelectCamp.Type then
      self.activityList[data.id] = data
      DataCenter.SeasonSelectCampManager:SetActId(data.id)
      if self:CheckIsSend(data) then
        DataCenter.SeasonSelectCampManager:SendGetInfo()
      end
    elseif data.type == EnumActivity.SeasonCityAltar.Type then
      self.activityList[data.id] = data
      DataCenter.SeasonCityAltarManager:SetActId(data.id)
      if self:CheckIsSend(data) then
      end
    elseif data.type == EnumActivity.ActValentineSendGift.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        local param = {
          activityId = tonumber(data.id)
        }
        SFSNetwork.SendMessage(MsgDefines.ValentineFollowList, param)
      end
    elseif data.type == EnumActivity.SeasonMilitary.Type then
      function data.GetEndTimeFunc()
        return DataCenter.SeasonMilitaryManager:GetMainItemEndShowTime()
      end
      
      self.activityList[data.id] = data
      DataCenter.SeasonMilitaryManager:SetActId(data.id)
      if self:CheckIsSend(data) then
        DataCenter.SeasonMilitaryManager:SendGetInfo()
      end
    elseif data.type == EnumActivity.SeasonMilitaryElite.Type then
      self.activityList[data.id] = data
      DataCenter.SeasonMilitaryEliteManager:SetActId(data.id)
      if self:CheckIsSend(data) then
      end
    elseif data.type == EnumActivity.SurvivorPack.Type then
      self.activityList[data.id] = data
      DataCenter.SurvivorPackManager:ParseActivityInfo(data)
    elseif data.type == EnumActivity.S0AllianceBoss.Type then
      self.activityList[data.id] = data
      DataCenter.S0AllianceBossDataManager:SetActivityData(data.id, data)
      if self:CheckIsSend(data) then
        DataCenter.S0AllianceBossDataManager:ReqActMainMessage()
      end
    elseif data.type == EnumActivity.FishingMaster.Type then
      self.activityList[data.id] = data
      if self:CheckIsSend(data) then
        SFSNetwork.SendMessage(MsgDefines.SeasonFishGetPlayerFishInfo)
      end
    else
      self.activityList[data.id] = data
    end
    EventManager:GetInstance():BroadcastWithParam(EventId.ActivityOneDataUpdate, data.type, data.activityId)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    if skipSkin ~= true and data.activityId ~= nil then
      self:UpdateDialogSkinData(tostring(data.activityId))
    end
    local endTime = data.endTime
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if endTime ~= nil and 0 < endTime and endTime > curTime and (0 > self.activitySaveMinEndTime or endTime < self.activitySaveMinEndTime) then
      self:StopActivityEndTimer()
      self.activitySaveMinEndTime = endTime
      local leftTime = (self.activitySaveMinEndTime - curTime) / 1000
      if 0 < leftTime then
        self.activityEndTimer = TimerManager:GetInstance():DelayInvokeUnscaled(function()
          self:StopActivityEndTimer()
          EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
          EventManager:GetInstance():Broadcast(EventId.ActivityTimeEnd)
          self:TryTriggerNextActivityEnd()
        end, leftTime)
      end
    end
  end
end

local function TryTriggerNextActivityEnd(self)
  local nextEndTime = -1
  for k, v in pairs(self.activityList) do
    local endTime = v.endTime
    if endTime ~= nil and 0 < endTime and endTime > self.activitySaveMinEndTime and (nextEndTime < 0 or nextEndTime > endTime) then
      nextEndTime = endTime
    end
  end
  if 0 < nextEndTime then
    self.activitySaveMinEndTime = nextEndTime
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < self.activitySaveMinEndTime then
      local leftTime = (self.activitySaveMinEndTime - curTime) / 1000
      self.activityEndTimer = TimerManager:GetInstance():DelayInvokeUnscaled(function()
        self:StopActivityEndTimer()
        EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
        self:TryTriggerNextActivityEnd()
      end, leftTime)
    end
  end
end

local function CheckIsSend(self, data)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local mainLv = DataCenter.BuildManager.MainLv
  local timeDevintion = 1000
  local timeUnlock = curTime >= data.startTime - timeDevintion and curTime <= data.endTime + timeDevintion
  if data.endTime == 0 and (data.type == EnumActivity.MineCave.Type or data.type == EnumActivity.Arena.Type or data.type == EnumActivity.TruckActivity.Type or data.type == EnumActivity.TrainActivity.Type or data.type == EnumActivity.SurvivalVipGift.Type) then
    timeUnlock = true
  end
  if timeUnlock and mainLv >= data.needMainCityLevel then
    return true
  end
  return false
end

local function SortActivityArr(self)
  self.nowActivityList = {}
  self.laterActivityList = {}
  self.overActivityList = {}
  local mainLv = DataCenter.BuildManager.MainLv
  table.walk(self.activityList, function(k, v)
    if v.activity_daily ~= 1 and v.needMainCityLevel <= mainLv and v.type ~= EnumActivity.AllianceCompete.Type and v.type ~= EnumActivity.ActivitySummary.Type then
      local validType = ActivityValidType.None
      if v.type == EnumActivity.EdenWar.Type then
        if v.needMainCityLevel <= mainLv then
          validType = ActivityValidType.Now
        end
      else
        validType = v:GetValidType()
      end
      if validType == ActivityValidType.Now then
        self.nowActivityList[v.id] = v
      elseif validType == ActivityValidType.Later then
        self.laterActivityList[v.id] = v
      elseif validType == ActivityValidType.Over then
        self.overActivityList[v.id] = v
      end
    end
    if v.type == EnumActivity.EdenWar.Type and v.needMainCityLevel <= mainLv then
      self.nowActivityList[v.id] = v
    end
  end)
end

local function GetNowActivityList(self, forSeason, offSeason)
  local actList = {}
  local MainLv = DataCenter.BuildManager.MainLv
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local haveActMigration = false
  local bNewMigrationEntrance = RaceEntranceUtil.IsNewMigration()
  for i, v in pairs(self.activityList) do
    if v.type == EnumActivity.PersonalArms.Type and curTime >= v.startTime and MainLv >= v.needMainCityLevel and (not (forSeason ~= nil or v.forSeason) or forSeason == v.forSeason) and (v.type ~= EnumActivity.ActMigration.Type or not bNewMigrationEntrance) then
      actList[v.id] = v
    end
  end
  if table.IsNullOrEmpty(self.nowActivityList) then
    DataCenter.ActivityListDataManager:SortActivityArr()
  end
  for i, v in pairs(self.nowActivityList) do
    if curTime >= v.startTime and MainLv >= v.needMainCityLevel and (not (forSeason ~= nil or v.forSeason) or forSeason == v.forSeason) and (v.type ~= EnumActivity.ActDragon.Type and v.type ~= EnumActivity.ActWinterStorm.Type or RaceEntranceUtil.IsOldEntranceOpen()) then
      if v.type == EnumActivity.ActMigration.Type then
        if bNewMigrationEntrance then
          goto lbl_104
        end
        haveActMigration = true
      end
      actList[v.id] = v
    end
    ::lbl_104::
  end
  if not haveActMigration and not bNewMigrationEntrance then
    local tmpList = self:GetActivityDataByType(EnumActivity.ActMigration.Type)
    local v = tmpList[1]
    local vType = v ~= nil and v:GetValidType() or ActivityValidType.Over
    local sTime = v ~= nil and v.startTime or 0
    local nLv = v ~= nil and v.needMainCityLevel or 0
    if vType ~= ActivityValidType.Over and 0 < sTime and curTime >= sTime and MainLv >= nLv then
      actList[v.id] = v
    end
  end
  if not offSeason then
    local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
    local data = DataCenter.SeasonTemplateManager:GetConfigData(seasonId)
    if data == nil then
      return actList
    end
    local idMap = {}
    for _, id in ipairs(data.truceEnterActivityList or {}) do
      idMap[tostring(id)] = true
    end
    for key, value in pairs(actList) do
      if idMap[value.id] and value.isShowCenter == 1 and (value.type == EnumActivity.LimitedTimeFeast.Type or value.type == EnumActivity.ActBingo.Type or value.type == EnumActivity.BlackMarket.Type or value.type == EnumActivity.ActTrends.Type) then
        actList[key] = nil
      end
    end
  end
  return actList
end

local function GetLaterActivityList(self)
  return self.laterActivityList
end

local function GetOverActivityList(self)
  return self.overActivityList
end

local function GetActivityDataById(self, id)
  local srtId = tostring(id)
  local data = self.activityList[srtId]
  return data
end

local function GetActivityDataByType(self, type)
  local tab = {}
  if type ~= nil and self.activityList then
    local numType = tonumber(type)
    for i, v in pairs(self.activityList) do
      if v.type == numType then
        table.insert(tab, v)
      end
    end
  end
  return tab
end

local function GetActivityList(self)
  return self.activityList
end

local function GetSevenDayList(self)
  return self.sevenDayList
end

local function GetActivityOpenLv(self)
  if next(self.sevenDayList) then
    return 1
  end
  if next(self.activityList) then
    local openlv = 10000
    table.walk(self.activityList, function(k, v)
      if v.needMainCityLevel < openlv then
        openlv = v.needMainCityLevel
      end
    end)
    return openlv
  end
  return false
end

local function RetEventData(self, message)
  if message ~= nil then
    local activityid = message.id or ""
    activityid = tostring(activityid)
    local actInfo = self:GetActivityDataById(activityid)
    if actInfo ~= nil then
      if actInfo.type == EnumActivity.StrongestCommander.Type then
        DataCenter.StrongestCommanderDataManager:ParseEventData(message)
      elseif actInfo.type == EnumActivity.InfiniteGift.Type then
        DataCenter.ActInfiniteGiftDataManager:ParseActDetailInfo(message)
      elseif actInfo.type == EnumActivity.GiftBoxActivity.Type then
        DataCenter.ActGiftBoxData:ParseActGiftBoxScore(message)
      elseif actInfo.type == EnumActivity.CitySkinGet.Type then
        DataCenter.ActCitySkinDataManager:ParseActCitySkinGetMessage(message)
      elseif actInfo.type == EnumActivity.CitySkinExchange.Type then
        DataCenter.ActCitySkinDataManager:ParseActCitySkinExchangeMessage(message)
      elseif actInfo.type == EnumActivity.ArenaNewbie.Type then
        DataCenter.LWNewbieArenaManager:OnGetArenaInfo(message)
      elseif actInfo.type == EnumActivity.BattlePass_new.Type then
        DataCenter.ActBattlePassData:ParseEventData(message)
      elseif actInfo.type == EnumActivity.BargainShop.Type then
        DataCenter.ActBargainShopData:ParseEventData(message)
      elseif actInfo.type == EnumActivity.HeroTrialActivity.Type then
        if message.cur_stage and message.stageArr then
          local curStateInfo
          for k, v in ipairs(message.stageArr) do
            if tonumber(v.id) == message.cur_stage then
              curStateInfo = v
            end
          end
          local count = table.count(message.stageArr)
          local lastOne = message.stageArr[count]
          if lastOne and message.cur_stage == tonumber(lastOne.id) and curStateInfo and curStateInfo.state == 2 then
            actInfo.forceOrderType = ActForceOrderType.ForceLast
          else
            actInfo.forceOrderType = ActForceOrderType.None
          end
        end
      elseif actInfo.type == EnumActivity.ArenaNewbieV2.Type then
        DataCenter.LWNewbieArenaV2Manager:OnGetArenaInfo(message)
      elseif actInfo.type == EnumActivity.TitaniumBlueStore.Type then
        DataCenter.LWTitaniumBlueStoreManager:ParseTitaniumBlueStoreMessage(message)
      elseif actInfo.type == EnumActivity.OptionalWeekCard.Type then
        DataCenter.LWOptionalWeekCardManager:ParseOptionalWeekCardMessage(message, actInfo)
      elseif actInfo.type == EnumActivity.Doomsday.Type then
        DataCenter.LWDoomsdayManager:OnGetEventInfo(message)
      elseif actInfo.type == EnumActivity.MultipleParkour.Type then
        DataCenter.MultipleParkourActivityManager:OnGetActivityInfo(message)
      elseif actInfo.type == EnumActivity.SignIn.Type then
        DataCenter.LWActSignInManager:OnGetEventInfo(message)
      elseif actInfo.type == EnumActivity.LeadingQuestV2.Type then
        DataCenter.LWLeadingQuestV2Manager:OnGetInfo(message)
      elseif actInfo.type == EnumActivity.ActivityRebateNew.Type then
        DataCenter.ActivityRebateNewManager:OnGetInfo(message)
      elseif actInfo.type == EnumActivity.BlackMarket.Type then
        DataCenter.ActBlackMarketDataManager:ParseActInfoMessage(message)
      elseif actInfo.type == EnumActivity.DecorationGacha.Type then
        DataCenter.ActivityDecorationGachaManager:OnReceiveActivityData(message)
      elseif actInfo.type == EnumActivity.TorchRelay.Type then
        DataCenter.ActivityTorchRelayManager:OnReceiveActivityData(message)
      elseif actInfo.type == EnumActivity.FrontBreakSunday.Type then
        DataCenter.ActFrontBreakSundayDataManager:RefreshActDetailData(message)
      elseif actInfo.type == EnumActivity.AccuRecharge.Type then
        DataCenter.CumulativeRechargeManager:UpdateRechargeStageInfo(message)
      elseif actInfo.type == EnumActivity.NineNationKingBattle.Type then
        DataCenter.SeasonNineKingManager:OnGetInfo(message)
      end
      if self.actEventInfoMap == nil then
        self.actEventInfoMap = {}
      end
      local actEventInfo = self.actEventInfoMap[activityid]
      if actEventInfo == nil then
        actEventInfo = ActivityEventInfo.New()
        actEventInfo:ParseData(message)
        self.actEventInfoMap[activityid] = actEventInfo
      else
        actEventInfo:ParseData(message)
      end
      EventManager:GetInstance():Broadcast(EventId.RefreshActivityDetailData, activityid)
    else
      actInfo = self:GetEventTypeActivityById(message.activityId)
      if actInfo ~= nil and message.type == EnumActivity.AllianceCompete.EventType then
        local tempData = self:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
        tempData:parseServerData(message)
        EventManager:GetInstance():Broadcast(EventId.RefreshDataAllianceArms)
        DataCenter.GetDuelScoreManager:SetScoreByType(GetDuelScoreType.Ally, tempData.eventInfo)
      end
    end
  end
end

local function RefreshActivityTime(self, message)
  table.walk(self.activityList, function(k, v)
    if tonumber(v.activityId == tonumber(message.activityId)) then
      if message.eventList ~= nil then
        table.walk(message.eventList, function(k1, v1)
          v.startTime = v1.st
          v.endTime = v1.et
          v.readyTime = v1.rt
        end)
      end
      self:ActivityByArmsTime(v)
    end
  end)
end

local function GetTheFirstRedDotActivityId(self, forSeason)
  local list = self:GetNowActivityList(forSeason == true)
  for id, actInfo in pairs(list) do
    if actInfo.activity_daily == 0 and not actInfo.hideInActivityPanel then
      local c, reward, tip = self:GetActivityRedDotCount(id)
      if 0 < reward then
        return actInfo.activityId
      end
    end
  end
  return nil
end

local function GetTotalRedDotCount(self, forSeason)
  local rewardCount = 0
  local tipCount = 0
  local list = self:GetNowActivityList(forSeason == true)
  for id, actInfo in pairs(list) do
    if actInfo.activity_daily == 0 and not actInfo.hideInActivityPanel then
      local c, reward, tip = self:GetActivityRedDotCount(id)
      rewardCount = rewardCount + (reward or 0)
      tipCount = tipCount + (tip or 0)
    end
  end
  local sevenDay = DataCenter.ActivityListDataManager:GetSevenDayList()
  if next(sevenDay) then
    sevenDay:CheckRedDot()
  end
  rewardCount = rewardCount + self:GetDayActRedNum()
  return rewardCount + tipCount, rewardCount, tipCount
end

local function GetTotalThemeActivityRedDotCount(self, forSeason)
  local count = 0
  local list = self:GetNowActivityList(forSeason == true)
  for id, actInfo in pairs(list) do
    if actInfo.activity_daily == 0 and actInfo.hideInActivityPanel and actInfo.is_package == ActivityEntranceType.ThemeActivity then
      count = count + self:GetActivityRedDotCount(id)
    end
  end
  return count
end

local function GetActivityRedDotCount(self, id)
  local rewardCount = 0
  local tipCount = 0
  local data = self:GetActivityDataById(id)
  if data ~= nil then
    local num, reward, tip = self:GetRewardNumByTypeAndId(data.type, data.id)
    if num ~= nil then
      rewardCount = rewardCount + (reward or 0)
      tipCount = tipCount + (tip or 0)
    end
  end
  if self:IsActivityNew(id) then
    tipCount = tipCount + 1
  end
  return rewardCount + tipCount, rewardCount, tipCount
end

local function CheckIfHasNew(self, forSeason)
  local list = DataCenter.ActivityListDataManager:GetNowActivityList(forSeason == true)
  for i, v in pairs(list) do
    if v.activity_daily == 0 and self:IsActivityNew(v.id) then
      return true
    end
  end
  return false
end

local function IsActivityNew(self, id)
  local data = self:GetActivityDataById(id)
  if data == nil then
    return false
  end
  if data.type == EnumActivity.AllianceOrder.Type or data.type == EnumActivity.IndividualOrder.Type or data.type == EnumActivity.PersonalArms.Type or data.type == EnumActivity.BattlePass.Type or data.type == EnumActivity.BattlePass_new.Type or data.type == EnumActivity.GolloesCards.Type or data.type == EnumActivity.BarterShop.Type or data.type == EnumActivity.JigsawPuzzle.Type or data.type == EnumActivity.ActSevenDay.Type or data.type == EnumActivity.MonsterTower.Type or data.type == EnumActivity.LuckyRoll.Type or data.type == EnumActivity.StrongestCommander.Type or data.type == EnumActivity.AccuRecharge.Type or data.type == EnumActivity.LuckyShop.Type or data.type == EnumActivity.AllyDrill.Type or data.type == EnumActivity.ActDragon.Type or data.type == EnumActivity.ContinuePay.Type or data.type == EnumActivity.SignIn.Type or data.type == EnumActivity.ZombieRush.Type or data.type == EnumActivity.ActSevenDayV2.Type or data.type == EnumActivity.SurfingBattleAct.Type or data.type == EnumActivity.S0AllianceBoss.Type then
    local lastEndTime = self:GetActivityVisitedEndTime(id)
    return lastEndTime < data.endTime
  elseif data.type == EnumActivity.BarterShop.Type then
    local isNew = data:CheckIfIsNew()
    return isNew
  elseif data.type == EnumActivity.LeadingQuest.Type then
    local hasOpened = CS.GameEntry.Setting:GetBool("OpenedLeadingQuestView_" .. LuaEntry.Player.uid, false)
    return not hasOpened
  elseif data.type == EnumActivity.LeadingQuestV2.Type then
    local hasOpened = CS.GameEntry.Setting:GetBool("OpenedLeadingQuestV2View_" .. LuaEntry.Player.uid, false)
    return not hasOpened
  elseif data.type == EnumActivity.LockhartActivity.Type then
    local hasOpened = CS.GameEntry.Setting:GetBool("OpenedLockhartActivity_" .. LuaEntry.Player.uid, false)
    return not hasOpened
  elseif data.type == EnumActivity.KillZombieActivity.Type then
    local hasOpened = CS.GameEntry.Setting:GetBool("OpenedKillZombieActivity_" .. LuaEntry.Player.uid, false)
    return not hasOpened
  elseif data.type == EnumActivity.AttackCityActivity.Type then
    local hasOpened = CS.GameEntry.Setting:GetBool("OpenedAttackCity_" .. LuaEntry.Player.uid, false)
    return not hasOpened
  elseif data.type == ActivityEnum.ActivityType.LuckyShop then
    local isNew = DataCenter.LuckyShopManager:NeedShowNew()
    return isNew
  elseif data.type == EnumActivity.WorldBoss.Type then
    return DataCenter.ActBossDataManager:CanShowNewLabel()
  elseif data.type == EnumActivity.RevivalPlan.Type then
    local hasOpened = CS.GameEntry.Setting:GetBool("OpenedRevivalPlanActivity_" .. LuaEntry.Player.uid, false)
    return not hasOpened
  elseif data.type == EnumActivity.CommunityLink.Type then
    local isNew = DataCenter.ActCommunityLinkManager:NeedShowNew()
    return isNew
  end
  return false
end

local function GetRewardNumByTypeAndId(self, type, id)
  local num = 0
  local rewardNum = 0
  local tipNum = 0
  if type == EnumActivity.PersonalArms.Type then
    local list = self:GetNowActivityList(false)
    for i, v in pairs(list) do
      if i == id then
        local eventInfo = DataCenter.ActPersonalArmsInfo:GetEventInfo(v.activityId)
        if eventInfo ~= nil then
          for k = 1, 3 do
            if eventInfo.curScore >= eventInfo.rewardScoreIndexArr[k] then
              local state = false
              for n = 1, #eventInfo.hasRewardList do
                if tonumber(eventInfo.hasRewardList[n]) == k then
                  state = true
                end
              end
              if not state then
                rewardNum = rewardNum + 1
              end
            end
          end
        end
      end
    end
  elseif type == EnumActivity.AllianceCompete.Type then
    local allianceCompete = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    if allianceCompete then
      rewardNum = allianceCompete:GetRewardCount()
      return rewardNum, rewardNum, 0
    end
  elseif type == EnumActivity.AllyDrill.Type then
    tipNum = DataCenter.AllyDrillDataManager:GetRedDotCount()
    return tipNum, 0, tipNum
  elseif type == EnumActivity.AllianceOrder.Type then
    tipNum = DataCenter.ActAllianceOrderManager:GetRedDotCount()
    return tipNum, 0, tipNum
  elseif type == EnumActivity.IndividualOrder.Type then
    tipNum = DataCenter.ActIndividualOrderManager:GetRedDotCount()
    return tipNum, 0, tipNum
  elseif type == EnumActivity.LeadingQuest.Type then
    local leadingQuestInfo = DataCenter.ActivityListDataManager:GetActivityDataById(id)
    rewardNum = leadingQuestInfo:GetRedCount()
    return rewardNum, rewardNum, 0
  elseif type == EnumActivity.LeadingQuestV2.Type then
    rewardNum = DataCenter.LWLeadingQuestV2Manager:GetRedCount()
    return rewardNum, rewardNum, 0
  elseif type == EnumActivity.RadarRally.Type then
    tipNum = 0 < DataCenter.RadarCenterDataManager:GetRadarRallyFinishedNum() and 1 or 0
    return tipNum, 0, tipNum
  elseif type == EnumActivity.BarterShop.Type then
    local barterData = DataCenter.ActivityListDataManager:GetActivityDataById(id)
    tipNum = barterData:GetRedCount()
    return tipNum, 0, tipNum
  elseif type == EnumActivity.Puzzle.Type then
    rewardNum = DataCenter.ActivityPuzzleDataManager:GetRedDotNum()
    return rewardNum, rewardNum, 0
  elseif type == EnumActivity.MineCave.Type then
    tipNum = DataCenter.MineCaveManager:GetRedCount()
    return tipNum, 0, tipNum
  elseif type == EnumActivity.Arena.Type then
    tipNum = DataCenter.ArenaManager:GetArenaRedCount()
    return tipNum, 0, tipNum
  elseif type == EnumActivity.DigActivity.Type then
    tipNum = DataCenter.DigActivityManager:GetDigActivityRed()
    return tipNum, 0, tipNum
  elseif type == EnumActivity.RallyBossAct.Type then
    if id == EnumActivity.RallyBossAct.ActId then
      local redCount = DataCenter.AllianceBaseDataManager:CheckIfShowAutoRallyRed()
      tipNum = redCount
      return tipNum, 0, tipNum
    end
  elseif type == EnumActivity.BattlePass.Type or type == EnumActivity.BattlePass_new.Type then
    rewardNum = DataCenter.ActBattlePassData:GetActRed(toInt(id))
    return rewardNum, rewardNum, 0
  elseif type == EnumActivity.LuckyRoll.Type then
    return DataCenter.ActLuckyRollInfo:GetLuckyRollRed(toInt(id))
  elseif type == EnumActivity.GolloesCards.Type then
    tipNum = DataCenter.ActGolloesCardData:GetActRed(toInt(id))
    return tipNum, 0, tipNum
  elseif type == EnumActivity.ActSevenDay.Type then
    rewardNum = DataCenter.ActSevenDayData:GetActRed(toInt(id))
    return rewardNum, rewardNum, 0
  elseif type == EnumActivity.MonsterTower.Type then
    tipNum = DataCenter.ActMonsterTowerData:GetActRed(toInt(id))
    return tipNum, 0, tipNum
  elseif type == EnumActivity.JigsawPuzzle.Type then
    tipNum = DataCenter.JigsawPuzzleManager:GetJigsawRedCount(toInt(id))
    return tipNum, 0, tipNum
  elseif type == EnumActivity.StrongestCommander.Type then
    rewardNum = DataCenter.StrongestCommanderDataManager:GetEventCanRewardCount()
    return rewardNum, rewardNum, 0
  elseif type == EnumActivity.LockhartActivity.Type then
    rewardNum = LockhartActivityMain.GetEventCanRewardCount()
    return rewardNum, rewardNum, 0
  elseif type == EnumActivity.KillZombieActivity.Type then
    return KillZombieActivityMain.GetEventCanRewardCount()
  elseif type == EnumActivity.AttackCityActivity.Type then
    tipNum = AttackCityActivityMain.GetEventCanRewardCount()
    return tipNum, 0, tipNum
  elseif type == EnumActivity.DispatchTask.Type then
    _, rewardNum, tipNum = DataCenter.ActDispatchTaskDataManager:GetSingleTaskRedCount()
    local explorerTreasureCount = DataCenter.ExplorerTreasureManager:GetRedPointCount()
    return rewardNum + tipNum + explorerTreasureCount, rewardNum, tipNum + explorerTreasureCount
  elseif type == EnumActivity.AccuRecharge.Type then
    rewardNum = DataCenter.CumulativeRechargeManager:GetActRedNum(toInt(id))
    if 1 < rewardNum then
      rewardNum = 1
    end
    return rewardNum, rewardNum, 0
  elseif type == EnumActivity.PersonalArmsNew.Type then
    rewardNum = DataCenter.ActivityPersonalArmsDataManager:GetActRedNum(toInt(id))
    return rewardNum, rewardNum, 0
  elseif type == EnumActivity.GrowFoundation.Type then
    local eventInfo = self:GetActEventInfo(id)
    if eventInfo then
      local quests = eventInfo:GetStageQuests(1)
      for i, v in pairs(quests) do
        local taskValue = DataCenter.TaskManager:FindTaskInfo(v)
        if taskValue and taskValue.state == TaskState.CanReceive then
          rewardNum = rewardNum + 1
        end
      end
    end
  elseif type == EnumActivity.WorldBoss.Type then
    return DataCenter.ActBossDataManager:GetActRedNum()
  elseif type == EnumActivity.TaskActivity.Type or type == EnumActivity.TaskActivity2.Type then
    rewardNum = TaskActivity.GetEventCanRewardCount(id)
    return rewardNum, rewardNum, 0
  elseif type == EnumActivity.GiftBoxActivity.Type then
    return DataCenter.ActGiftBoxData:GetActRed(toInt(id))
  elseif type == EnumActivity.Cooking.Type then
    return DataCenter.ActCookingData:GetActRed(toInt(id))
  elseif type == EnumActivity.Banquet.Type then
    return DataCenter.ActBanquetData:GetActRed(toInt(id))
  elseif type == EnumActivity.BanquetAttackMonster.Type then
    return DataCenter.ActBanquetV2Data:GetActRed(toInt(id))
  elseif type == EnumActivity.HeroTrialActivity.Type then
    rewardNum = HeroTrial.GetEventCanRewardCount(id)
    return rewardNum, rewardNum, 0
  elseif type == EnumActivity.LuckyShop.Type then
    tipNum = DataCenter.LuckyShopManager:GetRedPotCount()
    return tipNum, 0, tipNum
  elseif type == EnumActivity.ScratchOffGame.Type then
    tipNum = DataCenter.ScratchOffGameManager:GetRedPointCount(toInt(id))
    return tipNum, 0, tipNum
  elseif type == EnumActivity.ContinuePay.Type then
    rewardNum = DataCenter.ContinuePayActivityManager:GetRedPointCount(toInt(id))
    return rewardNum, rewardNum, 0
  elseif type == EnumActivity.CitySkinExchange.Type then
    tipNum = DataCenter.ActCitySkinDataManager:GetExchangeRedPoint(toInt(id))
    return tipNum, 0, tipNum
  elseif type == EnumActivity.ArenaNewbie.Type then
    return DataCenter.LWNewbieArenaManager:GetRedDotCount()
  elseif type == EnumActivity.MonsterInvasion.Type then
    tipNum = DataCenter.ActivityMonsterInvasionDataManager:GetActRedNum(toInt(id))
    return tipNum, 0, tipNum
  elseif type == EnumActivity.RebateActivity.Type then
    tipNum = self:GetRebateactivityRedNum(toInt(id))
    return tipNum, 0, tipNum
  elseif type == EnumActivity.ActMonopoly.Type then
    return DataCenter.ActMonopolyDataManager:GetRedNum(toInt(id))
  elseif type == EnumActivity.HeroMonthCard.Type then
    rewardNum = DataCenter.HeroMonthCardManager:GetActRedNum(toInt(id))
    return rewardNum, rewardNum, 0
  elseif type == EnumActivity.SunriseFoundation.Type then
    rewardNum = DataCenter.ActSunriseFoundationDataManager:GetRedNum(toInt(id))
    return rewardNum, rewardNum, 0
  elseif type == EnumActivity.ActGiftGiving.Type then
    return DataCenter.ActGiftGivingDataManager:GetRedNum(toInt(id))
  elseif type == EnumActivity.ActLottery.Type then
    tipNum = DataCenter.ActLotteryDataManager:GetRedNum(toInt(id))
    return tipNum, 0, tipNum
  elseif type == EnumActivity.ActTrends.Type then
    tipNum = DataCenter.ActTrendsDataManager:GetRedNum(toInt(id))
    return tipNum, 0, tipNum
  elseif type == EnumActivity.ActBingo.Type then
    rewardNum = DataCenter.ActBingoDataManager:GetRedNum(toInt(id))
    return rewardNum, rewardNum, 0
  elseif type == EnumActivity.ActSlotMachine.Type then
    return DataCenter.ActSlotMachineDataManager:GetRedNum(toInt(id))
  elseif type == EnumActivity.BargainShop.Type then
    rewardNum = DataCenter.ActBargainShopData:GetActRedNum(toInt(id))
    return rewardNum, rewardNum, 0
  elseif type == EnumActivity.ArenaNewbieV2.Type then
    return DataCenter.LWNewbieArenaV2Manager:GetRedDotCount()
  elseif type == EnumActivity.TitaniumBlueStore.Type then
    rewardNum = DataCenter.LWTitaniumBlueStoreManager:GetRedNum()
    return rewardNum, rewardNum, 0
  elseif type == EnumActivity.OptionalWeekCard.Type then
    rewardNum = DataCenter.LWOptionalWeekCardManager:GetRedNum(toInt(id))
    return rewardNum, rewardNum, 0
  elseif type == EnumActivity.Doomsday.Type then
    rewardNum = DataCenter.LWDoomsdayManager:GetRedDotCount()
    return rewardNum, rewardNum, 0
  elseif type == EnumActivity.MultipleParkour.Type then
    return DataCenter.MultipleParkourActivityManager:GetRedDotCount()
  elseif type == EnumActivity.SignIn.Type then
    rewardNum = DataCenter.LWActSignInManager:GetRedDotCount(toInt(id))
    return rewardNum, rewardNum, 0
  elseif type == EnumActivity.DispatchTreasure.Type then
    tipNum = DataCenter.ActDispatchTreasureManager:GetTabRedPoint() and 1 or 0
    return tipNum, 0, tipNum
  elseif type == EnumActivity.TreasureHuntNewActivity.Type then
    rewardNum = DataCenter.ActivityTreasureHuntNewManager:GetDigActivityRed(toInt(id))
    return rewardNum, rewardNum, 0
  elseif type == EnumActivity.CommunityLink.Type then
    tipNum = DataCenter.ActCommunityLinkManager:GetRedNum()
    return tipNum, 0, tipNum
  elseif type == EnumActivity.Questionnaire.Type then
    return DataCenter.LWQuestionnaireManager:GetRedDotCount()
  elseif type == EnumActivity.ActivityRebateNew.Type then
    tipNum = DataCenter.ActivityRebateNewManager:GetTotalRedCount(toInt(id))
    return tipNum, 0, tipNum
  elseif type == EnumActivity.BlackMarket.Type then
    tipNum = DataCenter.ActBlackMarketDataManager:GetRedPoint(id)
    return tipNum, 0, tipNum
  elseif type == EnumActivity.ActWinterStorm.Type then
    tipNum = DataCenter.ActWinterStormManager:GetTotalRedCount()
    return tipNum, 0, tipNum
  elseif type == EnumActivity.ChampionDuelMain.Type then
    return DataCenter.ChampionDuelManager:GetTotalRedCount()
  elseif type == EnumActivity.DecorationGacha.Type then
    return DataCenter.ActivityDecorationGachaManager:GetTotalRedCount(id)
  elseif type == EnumActivity.Ghostrecon.Type then
    tipNum = DataCenter.ActGhostreconManager:GetTotalRedCount()
    return tipNum, 0, tipNum
  elseif type == EnumActivity.TorchRelay.Type then
    return DataCenter.ActivityTorchRelayManager:GetTotalRedCount(id)
  elseif type == EnumActivity.ActMigration.Type then
    tipNum = 0 < DataCenter.ActMigrationManager:GetRedNum() and 1 or 0
    return tipNum, 0, tipNum
  elseif type == EnumActivity.LotteLink.Type then
    tipNum = DataCenter.ActivityLotteLinkManager:IsNeedShowRedPoint() == true and 1 or 0
    return tipNum, 0, tipNum
  elseif type == EnumActivity.FrontBreakSunday.Type then
    tipNum = DataCenter.ActFrontBreakSundayDataManager:GetRedDotCount(toInt(id))
    return tipNum, 0, tipNum
  elseif type == EnumActivity.ZombieRush.Type then
    tipNum = DataCenter.LWZombieRushManager:GetRedDotCount(toInt(id))
    return tipNum, 0, tipNum
  elseif type == EnumActivity.SeasonPhoto.Type then
    return DataCenter.SeasonPhotoManager:GetRedDotCount()
  elseif type == EnumActivity.ActSevenDayV2.Type then
    rewardNum = DataCenter.ActSevenDayV2Data:GetActRed(toInt(id))
    return rewardNum, rewardNum, 0
  elseif type == EnumActivity.ActValentineReceiveGift.Type then
    tipNum = DataCenter.ValentineDataManager:GetActRed(toInt(id))
    return tipNum, 0, tipNum
  elseif type == EnumActivity.ActBountyHunter.Type then
    return DataCenter.BountyHunterActDataManager:GetActRed(toInt(id))
  elseif type == EnumActivity.ActValentineSendGift.Type then
    tipNum = DataCenter.ValentineDataManager:GetSendGiftActRed(toInt(id))
    return tipNum, 0, tipNum
  elseif type == EnumActivity.RevivalPlan.Type then
    return DataCenter.RevivalPlanManager:GetRedCount(toInt(id))
  elseif type == EnumActivity.ActEasterEgg.Type then
    tipNum = DataCenter.ActEasterEggManager:GetRedCount(toInt(id))
    return tipNum, 0, tipNum
  elseif type == EnumActivity.CrazyRock.Type then
    tipNum = DataCenter.ActCrazyRockDataManager:GetRedCount(toInt(id))
    return tipNum, 0, tipNum
  elseif type == EnumActivity.OffSeason1Recapture.Type then
    tipNum = DataCenter.OffSeason1RecaptureManager:GetRedDotNum()
    return tipNum, 0, tipNum
  elseif type == EnumActivity.OffSeason1QueenOfBlood.Type then
    tipNum = DataCenter.OffSeason1QueenOfBloodManager:GetRedDotNum()
    return tipNum, 0, tipNum
  elseif type == EnumActivity.SurfingBattleAct.Type then
    tipNum = DataCenter.LWSurfingDataManager:GetRedCount(toInt(id))
    return tipNum, 0, tipNum
  elseif type == EnumActivity.S0AttackCityBattlePass.Type then
    tipNum = DataCenter.AttackCityS0DataManager:GetBattlePassRedPointNum()
    return tipNum, 0, tipNum
  elseif type == EnumActivity.S0AttackCityClue.Type then
    tipNum = DataCenter.AttackCityS0DataManager:GetCityClueRedPoint()
    return tipNum, 0, tipNum
  elseif type == EnumActivity.GhostParkour.Type then
    tipNum = DataCenter.LWGhostParkourDataManager:GetRedCount()
    return tipNum, 0, tipNum
  elseif type == EnumActivity.Recycle.Type then
    return DataCenter.ActRecycleManager:GetTotalRedCount(id)
  elseif type == EnumActivity.S0AllianceBoss.Type then
    tipNum = DataCenter.S0AllianceBossDataManager:GetRedCount()
    return tipNum, 0, tipNum
  end
  return num, rewardNum, tipNum
end

local function ActRewardHandle(self, message)
  DataCenter.RewardManager:ShowCommonReward(message)
  DataCenter.RewardManager:AddRewardsAndRes(message)
  DataCenter.ActivityController:SendScoreActivityData()
  DataCenter.ActivityController:SendGetAllActivityInfo()
end

local function RefreshSevenDayActData(self, message)
  if message ~= nil and message.dayActs ~= nil then
    local data = ActivitySevenDayInfo.New()
    data:ParseActivityData(message)
    self.sevenDayList = data
    EventManager:GetInstance():Broadcast(EventId.UpdateDayActInfo)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

local function UpdateDayActScore(self, message)
  if message.score ~= nil then
    self.sevenDayList:UpdateDayActScore(message)
  end
end

local function GetDayActRedNum(self)
  if next(self.sevenDayList) then
    return self.sevenDayList.taskRedNum
  end
  return 0
end

local function GetActivityVisitedEndTime(self, id)
  local str = Setting:GetString(LuaEntry.Player.uid .. "_" .. SettingKeys.ACTIVITY_VISITED_END_TIME .. "_" .. id, "")
  return not string.IsNullOrEmpty(str) and tonumber(str) or 0
end

local function SetActivityVisitedEndTime(self, id)
  local data = self:GetActivityDataById(id)
  local str = tostring(data.endTime)
  Setting:SetString(LuaEntry.Player.uid .. "_" .. SettingKeys.ACTIVITY_VISITED_END_TIME .. "_" .. id, str)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function DeleteArmsTimer(self, actId)
  if self.timer[actId] ~= nil then
    self.timer[actId]:Stop()
    self.timer[actId] = nil
  end
  if not actId then
    for i, v in pairs(self.timer) do
      v:Stop()
      v = nil
    end
    self.firstMinuteTips = nil
    self.tenMinuteTips = nil
    self.fifteenMinuteTips = nil
    return
  end
  self.firstMinuteTips[actId] = false
  self.tenMinuteTips[actId] = false
  self.fifteenMinuteTips[actId] = false
end

local function ActivityByArmsTime(self, data)
  self:DeleteArmsTimer(data.activityId)
  local mainLv = DataCenter.BuildManager.MainLv
  if mainLv < data.needMainCityLevel then
    return
  end
  local timeEnd = {}
  table.insert(timeEnd, LuaEntry.DataConfig:TryGetNum("Armament_End_notice", "k1"))
  table.insert(timeEnd, LuaEntry.DataConfig:TryGetNum("Armament_End_notice", "k2"))
  table.insert(timeEnd, LuaEntry.DataConfig:TryGetNum("Armament_End_notice", "k3"))
  if self.timer[data.activityId] == nil then
    self.timer[data.activityId] = TimerManager:GetInstance():GetTimer(1, self.timer_action, {data = data, time = timeEnd}, false, false, false)
  end
  self.timer[data.activityId]:Start()
end

local function RefreshArmsTime(self, param)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local diff = param.data.endTime - curTime
  if diff <= param.time[1] * 60 * 1000 and diff > (param.time[1] - 0.5) * 60 * 1000 then
    if self.firstMinuteTips[param.data.activityId] then
      return
    end
    UIUtil.ShowTips(Localization:GetString("372161", param.time[1]))
    self.firstMinuteTips[param.data.activityId] = true
  elseif diff <= param.time[2] * 60 * 1000 and diff > (param.time[2] - 0.5) * 60 * 1000 then
    if self.tenMinuteTips[param.data.activityId] then
      return
    end
    UIUtil.ShowTips(Localization:GetString("372161", param.time[2]))
    self.tenMinuteTips[param.data.activityId] = true
  elseif diff <= param.time[3] * 60 * 1000 and diff > (param.time[3] - 0.5) * 60 * 1000 then
    if self.fifteenMinuteTips[param.data.activityId] then
      return
    end
    UIUtil.ShowTips(Localization:GetString("372161", param.time[3]))
    self.fifteenMinuteTips[param.data.activityId] = true
  elseif diff < 0 then
    self:DeleteArmsTimer(param.data.activityId)
    UIUtil.ShowTipsId(372153)
    SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, param.data.activityId)
  end
end

local function UpdateArmsActScore(self, message)
  if CS.SceneManager:IsInCity() then
    return
  end
  local delay = 0
  for k, v in pairs(NoticeEquipDelays) do
    if UIManager:GetInstance():IsWindowOpen(k) then
      delay = v
      break
    end
  end
  local list = DataCenter.ActPersonalArmsInfo.list
  for i, v in pairs(list) do
    if next(v) and v.eventInfo and v.eventInfo.actId == message.actId then
      if tonumber(message.score) - tonumber(message.addScore) >= v.eventInfo.rewardScoreIndexArr[3] then
        return
      end
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UINoticeEquipTips) then
        self:SetActScore(message)
        break
      end
      if 0 < delay then
        TimerManager:GetInstance():DelayInvoke(function()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UINoticeEquipTips, {anim = false, playEffect = false}, message, i)
        end, 3)
        break
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UINoticeEquipTips, {anim = false, playEffect = false}, message, i)
      break
    end
  end
end

local function SetActScore(self, message)
  table.insert(self.actScoreList, message)
end

local function GetActScore(self, actId)
  local data
  if self.actScoreList then
    for i = 1, #self.actScoreList do
      if self.actScoreList[i].actId == actId then
        data = self.actScoreList[i]
      end
    end
  end
  return data
end

local function ClearActScore(self)
  self.actScoreList = {}
end

local function UpdateActBarterShopInfo(self, t)
  local activityId = t.activityId
  local id = tonumber(t.id)
  local num = t.num
  local actInfo = self:GetActivityDataById(activityId)
  if actInfo then
    actInfo:UpdateOneData(id, num)
  end
  EventManager:GetInstance():Broadcast(EventId.BarterShopExchangeSucc, id)
end

local function CheckIfAlCompeteActivityOpen(self)
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if not activityInfo then
    return false
  end
  return true
end

local function GetActBossRankRewardDataList(self)
end

local function GetActBossRankPersonRewardDataList(self)
end

local function CheckIfActivityOpen(self, tempType, tempId)
  local actInfo
  if tempId then
    tempId = tostring(tempId)
    actInfo = self:GetActivityDataById(tempId)
  elseif tempType then
    local actList = self:GetActivityDataByType(tempType)
    actInfo = 0 < #actList and actList[1] or nil
  end
  if actInfo then
    return actInfo:IsValid()
  end
end

local function GetOpenIdByType(self, tempType)
  if not tempType then
    return nil
  end
  local numType = tonumber(tempType)
  for i, v in pairs(self.activityList) do
    if v.type == numType and v:IsValid() then
      return v.id
    end
  end
  return nil
end

local function GetOneOpenActivityByType(self, tempType)
  if not tempType then
    return nil
  end
  local numType = tonumber(tempType)
  for i, v in pairs(self.activityList) do
    if v.type == numType and v:IsValid() then
      return v
    end
  end
  return nil
end

local function GetAllOpenIdsByType(self, tempType)
  local ret = {}
  local actList = self:GetActivityDataByType(tempType)
  for _, v in pairs(actList) do
    if v:IsValid() then
      table.insert(ret, v.id)
    end
  end
  return ret
end

local function GetOpenIdByTypeAndEnterType(self, tempType, festivalEntrance)
  festivalEntrance = festivalEntrance < 100 and 0 or festivalEntrance
  local actList = self:GetActivityDataByType(tempType)
  local actInfo = actList[1]
  if actInfo and actInfo:IsValid() and actInfo.festivalEntrance == festivalEntrance then
    return actInfo.id
  end
  return nil
end

local function StartPassDayTimer(self)
  if self.passDayTimer then
    self.passDayTimer:Stop()
  end
  local remainTimeS = UITimeManager:GetInstance():GetResSecondsTo24()
  local delayS = remainTimeS + 5 + math.random() * 10
  self.passDayTimer = TimerManager:GetInstance():DelayInvokeUnscaled(function()
    self:OnPassDayUpdateActivity()
    EventManager:GetInstance():Broadcast(EventId.OnPassDay)
    self:StartPassDayTimer()
  end, delayS)
end

local function StartPassWeekTimer(self)
  if self.passWeekTimer then
    self.passWeekTimer:Stop()
  end
  local remainTimeS = UITimeManager:GetInstance():GetResSeoncdsToNextMonday()
  local delayS = remainTimeS + 4
  self.passWeekTimer = TimerManager:GetInstance():DelayInvokeUnscaled(function()
    EventManager:GetInstance():Broadcast(EventId.OnPassWeek)
    self:StartPassWeekTimer()
  end, delayS)
end

local function StartUnDelayPassDayTimer(self)
  if self.unDelayPassDayTimer then
    self.unDelayPassDayTimer:Stop()
  end
  local remainTimeS = UITimeManager:GetInstance():GetResSecondsTo24()
  self.unDelayPassDayTimer = TimerManager:GetInstance():DelayInvokeUnscaled(function()
    EventManager:GetInstance():Broadcast(EventId.OnUnDelayPassDay)
    self:StartUnDelayPassDayTimer()
  end, remainTimeS)
end

local function OnPassDayUpdateActivity(self)
  if not table.IsNullOrEmpty(self.activityList) then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    for i, v in pairs(self.activityList) do
      if v then
        local id = v.id
        if v.type == EnumActivity.BlackMarket.Type then
          DataCenter.ActBlackMarketDataManager:OnActPassDay(v)
        end
        if curTime < v.endTime then
          if v.type == EnumActivity.StrongestCommander.Type then
            DataCenter.DispatchRequestManager:Append(function()
              SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(v.id))
            end)
          elseif v.type == EnumActivity.ContinuePay.Type then
            DataCenter.DispatchRequestManager:Append(function()
              SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(v.id))
            end)
          elseif v.type == EnumActivity.BattlePass.Type then
            DataCenter.DispatchRequestManager:Append(function()
              SFSNetwork.SendMessage(MsgDefines.GetBattlePassInfo, toInt(v.id))
            end)
          elseif v.type == EnumActivity.BattlePass_new.Type then
            DataCenter.DispatchRequestManager:Append(function()
              SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(v.id))
            end)
          elseif v.type == EnumActivity.BargainShop.Type then
            DataCenter.DispatchRequestManager:Append(function()
              SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(v.id))
            end)
          elseif v.type == EnumActivity.LuckyRoll.Type then
            EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
          elseif v.type == EnumActivity.ActSevenDay.Type then
            DataCenter.DispatchRequestManager:Append(function()
              SFSNetwork.SendMessage(MsgDefines.GetSevenDayActInfo, toInt(v.id))
            end)
          elseif v.type == EnumActivity.TitaniumBlueStore.Type then
            DataCenter.DispatchRequestManager:Append(function()
              SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(v.id))
            end)
          elseif v.type == EnumActivity.OptionalWeekCard.Type then
            DataCenter.DispatchRequestManager:Append(function()
              SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(v.id))
            end)
          elseif v.type == EnumActivity.SignIn.Type then
            DataCenter.DispatchRequestManager:Append(function()
              SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(v.id))
            end)
          elseif v.type == EnumActivity.LeadingQuestV2.Type then
            DataCenter.DispatchRequestManager:Append(function()
              SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(v.id))
            end)
          elseif v.type == EnumActivity.DecorationGacha.Type then
            DataCenter.DispatchRequestManager:Append(function()
              SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(v.id))
            end)
          elseif v.type == EnumActivity.TorchRelay.Type then
            DataCenter.DispatchRequestManager:Append(function()
              SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(v.id))
            end)
          elseif v.type == EnumActivity.AccuRecharge.Type then
            DataCenter.DispatchRequestManager:Append(function()
              DataCenter.CumulativeRechargeManager:SendGetRechargeInfo(tostring(v.id))
            end)
          elseif v.type == EnumActivity.RevivalPlan.Type then
            DataCenter.DispatchRequestManager:Append(function()
              SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(v.id))
            end)
          elseif v.type == EnumActivity.ActEasterEgg.Type then
            DataCenter.DispatchRequestManager:Append(function()
              SFSNetwork.SendMessage(MsgDefines.EasterEggInfo, toInt(v.id), 1)
            end)
          elseif v.type == EnumActivity.CrazyRock.Type then
            DataCenter.DispatchRequestManager:Append(function()
              SFSNetwork.SendMessage(MsgDefines.MusicGameActivityInfo, toInt(v.id))
            end)
          elseif v.type == EnumActivity.ActBountyHunter.Type then
            DataCenter.DispatchRequestManager:Append(function()
              SFSNetwork.SendMessage(MsgDefines.BountyHunterGetInfo, toInt(v.id))
            end)
          elseif v.type == EnumActivity.SurfingBattleAct.Type then
            DataCenter.DispatchRequestManager:Append(function()
              SFSNetwork.SendMessage(MsgDefines.GetParkourMainInfo)
            end)
          elseif v.type == EnumActivity.S0AttackCityNew.Type then
            DataCenter.DispatchRequestManager:Append(function()
              DataCenter.AttackCityS0DataManager:GetCityAttackActivityInfoMsg()
            end)
          elseif v.type == EnumActivity.S0AttackCityBattlePass.Type then
            DataCenter.DispatchRequestManager:Append(function()
              DataCenter.AttackCityS0DataManager:GetBattlePassTaskMsg(CityAttackS0NewBattlePassType.ALL)
            end)
          elseif v.type == EnumActivity.S0AttackCityClue.Type then
            DataCenter.DispatchRequestManager:Append(function()
              DataCenter.AttackCityS0DataManager:SendCityClueMsg()
            end)
          elseif v.type == EnumActivity.OFF_SEASON_Treasure_V2.Type then
            DataCenter.DispatchRequestManager:Append(function()
              DataCenter.DigTreasureBoxRewardManager:SendMainBoxRewardUIMessage()
              EventManager:GetInstance():Broadcast(EventId.TreasureBoxRewardActRefresh)
            end)
          elseif v.type == EnumActivity.GhostParkour.Type then
            DataCenter.DispatchRequestManager:Append(function()
              DataCenter.LWGhostParkourDataManager:SendGetGhostParkourInfosMessage()
            end)
          elseif v.type == EnumActivity.Recycle.Type then
            DataCenter.DispatchRequestManager:Append(function()
              SFSNetwork.SendMessage(MsgDefines.RecycleShopInfo, toInt(v.id))
            end)
          elseif v.type == EnumActivity.LimitedTimeFeast.Type then
            DataCenter.DispatchRequestManager:Append(function()
              SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(v.id))
            end)
          elseif v.type == EnumActivity.ActSlotMachine.Type then
            DataCenter.DispatchRequestManager:Append(function()
              SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(v.id))
            end)
          elseif v.type == EnumActivity.WorldBoss.Type then
            DataCenter.DispatchRequestManager:Append(function()
              SFSNetwork.SendMessage(MsgDefines.UserGetActBossMarch)
            end)
          elseif v.type == EnumActivity.S0AllianceBoss.Type then
            DataCenter.DispatchRequestManager:Append(function()
              DataCenter.S0AllianceBossDataManager:ReqActMainMessage()
            end)
          end
        end
      end
    end
  end
end

local function SetLastVisitedActivityId(self, id)
  local tempInfo = self:GetActivityDataById(tostring(id))
  if tempInfo == nil then
    tempInfo = 0
    self.lastVisitActDic[tempInfo] = id
  else
    if tempInfo.type == EnumActivity.ActCalendar.Type then
      return
    end
    self.lastVisitActDic[tempInfo.activity_daily] = id
  end
end

local function GetLastVisitedActivityId(self, activityDaily)
  return self.lastVisitActDic[activityDaily]
end

local function CheckIsShowGiftPackPoint(self)
  local activities = self:GetActivityDataByType(EnumActivity.AccuRecharge.Type)
  local isValid = false
  local actIds = {}
  local temps = {}
  if not table.IsNullOrEmpty(activities) then
    for _, v in pairs(activities) do
      if v and v:IsValid() then
        table.insert(temps, {
          order = v.order,
          actId = v.id
        })
      end
    end
  end
  if not table.IsNullOrEmpty(temps) then
    table.sort(temps, function(a, b)
      return a.order < b.order
    end)
    for _, v in ipairs(temps) do
      table.insert(actIds, v.actId)
    end
    isValid = true
  end
  return isValid, actIds
end

local function GetActivityShowData(self, actId)
  if not actId then
    return nil
  end
  if string.endswith(tostring(actId), "fake") then
    local originActId = string.match(tostring(actId), "(%d+)")
    local actInfo = self:GetActivityDataById(originActId)
    if not actInfo then
      return nil
    end
    for k, v in pairs(NonActivityType) do
      if v == actInfo.type then
        local actShowData = NonActivityContentHandler[v]
        if actShowData then
          local handlerData = {}
          handlerData.assetPath = actShowData.assetPath
          handlerData.cls = require(actShowData.cls)
          return handlerData
        end
      end
    end
  end
  local actInfo = self:GetActivityDataById(actId)
  if not actInfo then
    return nil
  end
  local handlerData, actShowData
  if SubTypeActivities[actInfo.type] then
    actShowData = SubTypeActivities[actInfo.type][actInfo.subViewType]
  else
    actShowData = ActivityContentHandler[actInfo.type]
  end
  if actShowData then
    handlerData = {}
    handlerData.assetPath = actShowData.assetPath
    handlerData.cls = require(actShowData.cls)
  else
    actShowData = SeasonUtil.GetSeasonActivityContentHandler(actInfo.type)
    if actShowData ~= nil then
      handlerData = {}
      handlerData.assetPath = actShowData.assetPath
      handlerData.cls = require(actShowData.clsPath)
    end
  end
  return handlerData
end

local function DebuggerGetActivityShowData(self, actId)
  if not actId then
    return nil
  end
  if string.endswith(tostring(actId), "fake") then
    local originActId = string.match(tostring(actId), "(%d+)")
    local actInfo = self:GetActivityDataById(originActId)
    if not actInfo then
      return nil
    end
    for k, v in pairs(NonActivityType) do
      if v == actInfo.type then
        local actShowData = NonActivityContentHandler[v]
        if actShowData then
          return actShowData.cls
        end
      end
    end
  end
  local actInfo = self:GetActivityDataById(actId)
  if not actInfo then
    return nil
  end
  local handlerData, actShowData
  if SubTypeActivities[actInfo.type] then
    actShowData = SubTypeActivities[actInfo.type][actInfo.subViewType]
  else
    actShowData = ActivityContentHandler[actInfo.type]
  end
  if actShowData then
    return actShowData.cls
  else
    actShowData = SeasonUtil.GetSeasonActivityContentHandler(actInfo.type)
    if actShowData ~= nil then
      return actShowData.clsPath
    end
  end
end

local function GetActEventInfo(self, actId)
  if not actId then
    return nil
  end
  local actInfo = self:GetActivityDataById(actId)
  if not actInfo then
    return nil
  end
  local actEventInfo = self.actEventInfoMap[tostring(actId)]
  if not actEventInfo then
    return nil
  end
  return actEventInfo
end

function ActivityListDataManager:GetEventTypeActivityById(activityid)
  if activityid == nil then
    return nil
  end
  for k, v in pairs(self.activityList) do
    if v ~= nil and v.activityId == activityid then
      return v
    end
  end
  return nil
end

function ActivityListDataManager:IsContainActivityGroup(groupId)
  if groupId == nil then
    return false
  end
  for k, v in pairs(self.activityList) do
    if v ~= nil and v.festivalEntrance == groupId then
      return true
    end
  end
  return false
end

function ActivityListDataManager:GetActivityDataByGroupId(groupId)
  local ret = {}
  if groupId == nil then
    return ret
  end
  for k, v in pairs(self.activityList) do
    if v ~= nil and v.festivalEntrance == groupId then
      table.insert(ret, v)
    end
  end
  return ret
end

function ActivityListDataManager:GetActivityRedCountByGroupId(groupId)
  local count = 0
  local rewardCount = 0
  local tipCount = 0
  local actList = DataCenter.ActivityListDataManager:GetActivityDataByGroupId(groupId)
  if actList then
    for k, v in ipairs(actList) do
      local redNum, rewardNum, tipNum = DataCenter.ActivityListDataManager:GetRewardNumByTypeAndId(v.type, v.id)
      if redNum == nil then
        redNum = 0
      end
      if rewardNum == nil then
        rewardNum = 0
      end
      if tipNum == nil then
        tipNum = 0
      end
      if 0 < redNum then
        count = count + tonumber(redNum)
      end
      if 0 < rewardNum then
        rewardCount = rewardCount + tonumber(rewardNum)
      end
      if 0 < tipNum then
        tipCount = tipCount + tonumber(tipNum)
      end
    end
  end
  return count, rewardCount, tipCount
end

function ActivityListDataManager:GetActivityRadarHeadIcon(isBigPic)
  local activityList = DataCenter.ActivityListDataManager:GetActivityList()
  for k, v in pairs(activityList) do
    if not string.IsNullOrEmpty(v.radar_pic_replace_small) then
      return isBigPic and v.radar_pic_replace_big or v.radar_pic_replace_small
    end
  end
end

function ActivityListDataManager:GetActivityShopActData(actId)
  actId = tostring(actId)
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
  if actInfo and actInfo:IsValid() then
    local actData
    if actInfo.type == EnumActivity.LuckyRoll.Type then
      actData = DataCenter.ActLuckyRollInfo:GetInfoByActId(tonumber(actId))
    elseif actInfo.type == EnumActivity.GiftBoxActivity.Type then
      actData = DataCenter.ActGiftBoxData:GetInfoByActId(tonumber(actId)).activityFreeRewardData
    elseif actInfo.type == EnumActivity.LuckyShop.Type then
      actData = DataCenter.LuckyShopManager:GetShopInfo().activityFreeRewardData
    elseif actInfo.type == EnumActivity.Cooking.Type then
      actData = DataCenter.ActCookingData.activityFreeRewardData
    elseif actInfo.type == EnumActivity.Banquet.Type then
      actData = DataCenter.ActBanquetData.activityFreeRewardData
    elseif actInfo.type == EnumActivity.BanquetAttackMonster.Type then
      actData = DataCenter.ActBanquetV2Data.activityFreeRewardData
    elseif actInfo.type == EnumActivity.ActMonopoly.Type then
      actData = DataCenter.ActMonopolyDataManager:GetActData(tonumber(actId)).activityFreeRewardData
    elseif actInfo.type == EnumActivity.ActSlotMachine.Type then
      actData = DataCenter.ActSlotMachineDataManager:GetActData(tonumber(actId)).activityFreeRewardData
    elseif actInfo.type == EnumActivity.BargainShop.Type then
      actData = DataCenter.ActBargainShopData:GetInfoByActId(tonumber(actId)).activityFreeRewardData
    elseif actInfo.type == EnumActivity.TitaniumBlueStore.Type then
      actData = DataCenter.LWTitaniumBlueStoreManager.activityFreeRewardData
    elseif actInfo.type == EnumActivity.ActBountyHunter.Type then
      actData = DataCenter.BountyHunterActDataManager:GetActData(tonumber(actId)).activityFreeRewardData
    end
    return actData
  end
  return nil
end

function ActivityListDataManager:GetActHasFreeDailyReward(actId)
  local actData = self:GetActivityShopActData(actId)
  if not actData or actData.lastReceiveFreeTime == nil then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if not UITimeManager:GetInstance():IsSameDayForServer(actData.lastReceiveFreeTime / 1000, curTime) then
    return true
  end
end

local function GetRebateactivityRedNum(self, activityId)
  local redNum = 0
  local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if activityData == nil then
    return redNum
  end
  local shopId = activityData.shopId
  local shopData = DataCenter.CommonShopManager:GetGoodsListByShopType(shopId)
  local goodsId = activityData.costGoodsId
  local curNum = DataCenter.ItemData:GetItemCount(goodsId)
  for _, v in pairs(shopData) do
    if curNum >= v.costNum then
      redNum = 1
      break
    end
  end
  return redNum
end

function ActivityListDataManager:GetActivityRadarDigModel()
  local activityList = self:GetActivityList()
  for k, v in pairs(activityList) do
    if not string.IsNullOrEmpty(v.radar_dig_replace_model) then
      return v.radar_dig_replace_model
    end
  end
end

function ActivityListDataManager:GetActivityRadarDigImage()
  local activityList = self:GetActivityList()
  for k, v in pairs(activityList) do
    if not string.IsNullOrEmpty(v.radar_dig_replace_image) then
      return v.radar_dig_replace_image
    end
  end
end

function ActivityListDataManager:GetActivityCenterGroupList(goId)
  local dailyType = 0
  if goId then
    local goActInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(goId))
    if goActInfo then
      dailyType = goActInfo.activity_daily
    end
  end
  local retGroups = {}
  DataCenter.ActivityListDataManager:SortActivityArr()
  local list = DataCenter.ActivityListDataManager:GetNowActivityList(false)
  if list ~= nil then
    local fakeDataList = self:CheckNonActivityView(true)
    table.walk(fakeDataList, function(k, v)
      list[v.id] = v
    end)
    local tempDic = {}
    for i, v in pairs(list) do
      if (not dailyType or dailyType == v.activity_daily) and v.tabGroup ~= nil and v.type ~= EnumActivity.KingActivity.Type and not v.hideInActivityPanel and (v.type ~= EnumActivity.ActDragon.Type and v.type ~= EnumActivity.ActWinterStorm.Type or RaceEntranceUtil.IsOldEntranceOpen()) then
        if not tempDic[v.tabGroup] then
          local newGroup = {}
          newGroup.tabGroup = v.tabGroup
          newGroup.tabGroupOrder = v.tabGroupOrder
          newGroup.activityList = {}
          tempDic[v.tabGroup] = newGroup
        end
        table.insert(tempDic[v.tabGroup].activityList, v)
      end
    end
    retGroups = table.values(tempDic)
    table.sort(retGroups, function(a, b)
      if a.tabGroupOrder ~= b.tabGroupOrder then
        return a.tabGroupOrder < b.tabGroupOrder
      else
        return false
      end
    end)
    for i, v in ipairs(retGroups) do
      table.sort(v.activityList, function(a, b)
        if a.forceOrderType ~= b.forceOrderType then
          return a.forceOrderType < b.forceOrderType
        end
        if a.order ~= b.order then
          return a.order < b.order
        else
          return false
        end
      end)
    end
  end
  return retGroups
end

function ActivityListDataManager:CheckNonActivityView(isShowInActCenter)
  local ret = {}
  local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.GiftBoxActivity.Type)
  if not table.IsNullOrEmpty(actList) then
    local giftBoxData = actList[1]
    if isShowInActCenter and giftBoxData.isShowCenter == 0 or not isShowInActCenter and giftBoxData.isShowCenter == 1 then
      return ret
    end
    local actId = giftBoxData.id
    local template = DataCenter.ActGiftBoxData:GetActTemplateByActId(tonumber(actId))
    if template.show_rank == 1 then
      local fakeActData = {}
      fakeActData.noneActType = NonActivityType.GiftBoxRank
      fakeActData.type = EnumActivity.FakeActivity.Type
      fakeActData.id = giftBoxData.id .. "fake"
      fakeActData.activityId = giftBoxData.id .. "fake"
      fakeActData.list_icon = giftBoxData.list_icon
      fakeActData.name = 390040
      fakeActData.order = giftBoxData.order + 1
      fakeActData.extraOrder = fakeActData.order
      fakeActData.tabGroup = giftBoxData.tabGroup
      fakeActData.tabGroupOrder = giftBoxData.tabGroupOrder
      fakeActData.activity_daily = giftBoxData.activity_daily
      table.insert(ret, fakeActData)
    end
  end
  return ret
end

function ActivityListDataManager:SetClickActIdRecord(actId)
  self.viewActIdHaveClickHashSet[tostring(actId)] = true
  EventManager:GetInstance():Broadcast(EventId.RefreshActivityEndMark)
end

function ActivityListDataManager:GetClickActIdRecord(actId)
  local isHaveClick = false
  if self.viewActIdHaveClickHashSet[tostring(actId)] then
    isHaveClick = true
  end
  return isHaveClick
end

function ActivityListDataManager:GetDispatchGroupList()
  local ret = {}
  local actTypeList = {
    EnumActivity.DispatchTask.Type,
    EnumActivity.DispatchTreasure.Type,
    EnumActivity.Ghostrecon.Type
  }
  if not LuaEntry.Player:AtHomeNow() and not DataCenter.ActDispatchTaskDataManager:IsOpenCrossSteal() then
    actTypeList = {
      EnumActivity.Ghostrecon.Type
    }
  end
  for index, value in ipairs(actTypeList) do
    local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(value)
    if actList and actList[1] then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local endTime = actList[1].endTime
      if endTime ~= nil and 0 < endTime and curTime < endTime then
        table.insert(ret, actList[1])
      end
    end
  end
  return ret
end

function ActivityListDataManager:GetGhostreconData()
  local data
  local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.Ghostrecon.Type)
  if actList and actList[1] then
    data = actList[1]
  end
  return data
end

function ActivityListDataManager:IsActivityOpen(type)
  local data = DataCenter.ActivityListDataManager:GetActivityDataByType(type)
  if data and data[1] then
    local now = UITimeManager:GetInstance():GetServerTime()
    if now < data[1].endTime then
      return true
    end
  end
  return false
end

function ActivityListDataManager:Description()
  local _supportedActivityDetail = {}
  _supportedActivityDetail[EnumActivity.PersonalArmsNew.Type] = function()
    return DataCenter.ActivityPersonalArmsDataManager:Description()
  end
  _supportedActivityDetail[EnumActivity.ActDragon.Type] = function()
    return DataCenter.ActDragonManager:Description()
  end
  _supportedActivityDetail[EnumActivity.SheepGame.Type] = function()
    return DataCenter.LWSheepDataManager:Description()
  end
  _supportedActivityDetail[EnumActivity.ActWinterStorm.Type] = function()
    return DataCenter.ActWinterStormManager:Description()
  end
  local activityDetail = {}
  local sb = StringBuilder.New()
  sb:AppendLine(string.format("\230\180\187\229\138\168\230\149\176\233\135\143:%s", self.activityList and table.count(self.activityList) or 0))
  sb:AppendLine()
  local time = UITimeManager:GetInstance()
  sb:AppendLine("---\229\159\186\231\161\128\228\191\161\230\129\175---")
  sb:AppendLine(string.format("\231\142\169\229\174\182id:%s", LuaEntry.Player:GetUid()))
  sb:AppendLine(string.format("\229\142\159\230\156\141id:%s", LuaEntry.Player:GetSourceServerId()))
  sb:AppendLine(string.format("\231\153\187\229\189\149\230\156\141id:%s", LuaEntry.Player:GetSelfServerId()))
  sb:AppendLine(string.format("\229\189\147\229\137\141\230\151\182\233\151\180:%s", time:TimeStampToTimeForServer(time:GetServerTime())))
  sb:AppendLine()
  local index = 0
  if table.count(self.activityList) > 0 then
    sb:AppendLine("---\230\159\165\231\156\139\230\180\187\229\138\168\228\191\161\230\129\175---")
    for k, v in pairs(self.activityList) do
      sb:Append(string.format("%s.", index))
      sb:Append(v:Description())
      sb:AppendFormat(",show:%s", self:CheckIsSend(v) and "\226\136\154" or "\195\151")
      sb:AppendLine()
      if _supportedActivityDetail[v.type] then
        table.insert(activityDetail, {
          index = index,
          type = v.type,
          name = Localization:GetString(v.activityName),
          description = _supportedActivityDetail[v.type]
        })
      end
      index = index + 1
    end
  end
  return {
    description = sb:ToString(),
    list = activityDetail
  }
end

function ActivityListDataManager:AddActivityByPushAtPassDay(activityId)
  local activityId = activityId
  if activityId then
    local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
    if activityInfo and activityInfo.type == EnumActivity.HeroMonthCard.Type then
      DataCenter.HeroMonthCardManager:GetDataFromServer()
    end
  end
end

function ActivityListDataManager:GetItemActivityData()
  if self.itemActivityData and next(self.itemActivityData) then
    return self.itemActivityData
  else
    local id = LuaEntry.DataConfig:TryGetStr("truce_season_time", "k1")
    local value = LuaEntry.DataConfig:TryGetStr("truce_season_time", "k2")
    local k1_items = {}
    for item in string.gmatch(id, "([^|]+)") do
      table.insert(k1_items, item)
    end
    local k2_items = {}
    for item in string.gmatch(value, "([^|]+)") do
      table.insert(k2_items, item)
    end
    self.itemActivityData = {}
    for i = 1, #k1_items do
      self.itemActivityData[k1_items[i]] = k2_items[i]
    end
    return self.itemActivityData
  end
end

function ActivityListDataManager:GetItemActivityNeedToHideData()
  if self.itemActivityNeedToHidData and next(self.itemActivityNeedToHidData) and self.seasonCfgData ~= nil then
    return self.itemActivityNeedToHidData, self.seasonCfgData
  else
    local datas = LuaEntry.DataConfig:TryGetStr("truce_season_time", "k3")
    for pair in string.gmatch(datas, "([^;]+)") do
      local key, value = pair:match("([^|]+)|([^|]+)")
      self.itemActivityNeedToHidData[tonumber(key)] = tonumber(value)
      local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
      self.seasonCfgData = DataCenter.SeasonTemplateManager:GetConfigData(seasonId)
    end
    return self.itemActivityNeedToHidData, self.seasonCfgData
  end
end

function ActivityListDataManager:GetTheActIsCanShow(activityId)
  local actList, cfgData = self:GetItemActivityNeedToHideData()
  if cfgData and cfgData.truceEnterStartTime then
    local days = tonumber(cfgData.truceEnterStartTime)
    if actList and actList[activityId] then
      local seasonDay = SeasonUtil.GetSeasonDay()
      if seasonDay > days + actList[activityId] then
        return true
      else
        return false
      end
    end
  end
  return true
end

function ActivityListDataManager:UpdateDialogSkinData(strActivityId)
  if type(Localization.UpdateSkinData) == "function" and LocalController:instance():hasTable(TableName.Dialog_Skin) then
    local skinCache = self.skinCache
    if skinCache == nil then
      skinCache = {}
      LocalController:instance():visitTable(TableName.Dialog_Skin, function(id, line)
        if line ~= nil then
          local theKey = tostring(line.activity_condition)
          if theKey ~= nil and theKey ~= "" and theKey ~= "0" and theKey ~= "nil" then
            if skinCache[theKey] == nil then
              skinCache[theKey] = {}
            end
            skinCache[theKey][line.dialog_1] = line.dialog_2
          end
        end
      end)
      self.skinCache = skinCache
    end
    if table.IsNullOrEmpty(skinCache) then
      return
    end
    local dict = {}
    if strActivityId == nil and self.activityList ~= nil then
      for _, v in pairs(self.activityList) do
        if v ~= nil and v.activityId ~= nil then
          local data = skinCache[v.activityId]
          if data ~= nil then
            for dialog_1, dialog_2 in pairs(data) do
              dict[dialog_1] = dialog_2
            end
          end
        end
      end
    else
      local data = skinCache[strActivityId]
      if data ~= nil then
        for dialog_1, dialog_2 in pairs(data) do
          dict[dialog_1] = dialog_2
        end
      end
    end
    if not table.IsNullOrEmpty(dict) then
      SeasonUtil.UpdateDialogSkin(dict, false)
    end
  end
end

local easterFlag = "2025easter#"
local loadPathPrefix = "Assets/Main/"
local easterModLoadPathPrefix = "Assets/Main/ActivityRes/2025EasterMod/"

function ActivityListDataManager:GetActivityModLoadPath(srcPath, cfgStr)
  if cfgStr == nil then
    Logger.LogError("GetActivityModLoadPath \228\188\160\229\133\165\233\133\141\231\189\174\232\183\175\229\190\132\228\184\186\231\169\186\239\188\129")
    return
  end
  if type(cfgStr) ~= "string" then
    Logger.LogError("GetActivityModLoadPath \228\188\160\229\133\165\233\133\141\231\189\174\232\183\175\229\190\132\228\184\141\230\152\175\229\173\151\231\172\166\228\184\178\231\177\187\229\158\139\239\188\129")
    return
  end
  if string.startswith(cfgStr, easterFlag) then
    local newPath = string.gsub(srcPath, loadPathPrefix, easterModLoadPathPrefix)
    local fileName = string.sub(cfgStr, #easterFlag + 1)
    return string.format(newPath, fileName)
  end
  return string.format(srcPath, cfgStr)
end

function ActivityListDataManager:GetActivityBtnIconPath()
  if self.btnIconPathDataList == nil then
    local keyStr = LuaEntry.DataConfig:TryGetStr("offseason_icon_config", "k1")
    self.btnIconPathDataList = {}
    for segment in string.gmatch(keyStr, "[^|]+") do
      local season, day, icon = string.match(segment, "([^;]+);([^;]+);(.+)")
      table.insert(self.btnIconPathDataList, {
        season = tonumber(season),
        day = tonumber(day),
        icon = icon
      })
    end
  end
  local nowSeason, nowDay = DataCenter.SeasonDataManager:GetNowSeasonAndSeasonDay()
  local iconName = ""
  local maxDay = -1
  for _, v in pairs(self.btnIconPathDataList) do
    if v.season == nowSeason and nowDay >= v.day and maxDay < v.day then
      iconName = v.icon
      maxDay = v.day
    end
  end
  return iconName
end

local function IsReadyForDownloadRes(self, activityId)
  return self:IsNeedCheckDownloadRes(activityId) and self:IsDownloadResComplete(activityId)
end

local function IsNeedCheckDownloadRes(self, activityId)
  local actInfo = self:GetActivityDataById(activityId)
  return actInfo ~= nil and actInfo:IsNeedCheckDownloadRes()
end

local function IsDownloadResComplete(self, activityId)
  local packConfigIdList = {}
  local actInfo = self:GetActivityDataById(activityId)
  if actInfo then
    packConfigIdList = actInfo:GetDownloadResPackConfigIdList()
  end
  if not table.IsNullOrEmpty(packConfigIdList) then
    for i, configId in pairs(packConfigIdList) do
      if not CS.DownloadResGroupCommonManager.Instance:IsDownload(configId) then
        return false
      end
    end
  end
  return true
end

function ActivityListDataManager:DelEndActivity(actList)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if actList then
    for i = #actList, 1, -1 do
      local act = actList[i]
      if act.festivalEntrance == CommonActivityGroupEnum.S0AttackCityNew and act.endTime and curTime > act.endTime then
        table.remove(actList, i)
      end
    end
  end
  return actList
end

function ActivityListDataManager:IsEndDay(actId)
  local data = self:GetActivityDataById(actId)
  if not data then
    return false
  end
  if not data.endTime then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if data.endTime - curTime > 0 and data.endTime - curTime <= 86400000 then
    return true
  end
  return false
end

function ActivityListDataManager:HandleAddPersonalArmsNew(newActData)
  if newActData == nil or newActData.type ~= EnumActivity.PersonalArmsNew.Type then
    return
  end
  local oldActEnd = false
  local acts = self:GetActivityDataByType(newActData.type)
  if not table.IsNullOrEmpty(acts) then
    for _, oldActData in pairs(acts) do
      if newActData.group_number == oldActData.group_number then
        if newActData.group_priority < oldActData.group_priority then
          return
        elseif newActData.group_priority > oldActData.group_priority then
          oldActEnd = true
          self.activityList[oldActData.id] = nil
        end
      end
    end
  end
  self.activityList[newActData.id] = newActData
  if self:CheckIsSend(newActData) then
    SFSNetwork.SendMessage(MsgDefines.ActivityHeroGetInfo, toInt(newActData.id))
  end
  if oldActEnd then
    EventManager:GetInstance():Broadcast(EventId.ActivityPersonalArmsReplaceActivity)
  end
end

function ActivityListDataManager:UpdateActivityInfo()
  if self.activityList == nil then
    return
  end
  for k, v in pairs(self.activityList) do
    if v then
      pcall(v.UpdateActivityInfo, v)
    end
  end
end

function ActivityListDataManager:GetCurActDayIndex(activityId)
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if activityInfo == nil then
    return
  end
  if not activityInfo then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local actTotalDays = (activityInfo.endTime - activityInfo.startTime) / (OneDayTime * 1000) + 1
  if curTime >= activityInfo.startTime and curTime < activityInfo.endTime then
    local value = (curTime - activityInfo.startTime) / 1000
    for i = 1, actTotalDays do
      if value <= i * OneDayTime then
        return i
      end
    end
  end
  return 1
end

ActivityListDataManager.__init = __init
ActivityListDataManager.__delete = __delete
ActivityListDataManager.InitActivityListData = InitActivityListData
ActivityListDataManager.RequestActivityData = RequestActivityData
ActivityListDataManager.CheckIsSend = CheckIsSend
ActivityListDataManager.SortActivityArr = SortActivityArr
ActivityListDataManager.GetNowActivityList = GetNowActivityList
ActivityListDataManager.GetLaterActivityList = GetLaterActivityList
ActivityListDataManager.GetOverActivityList = GetOverActivityList
ActivityListDataManager.GetActivityDataById = GetActivityDataById
ActivityListDataManager.RetEventData = RetEventData
ActivityListDataManager.GetRewardNumByTypeAndId = GetRewardNumByTypeAndId
ActivityListDataManager.GetActivityList = GetActivityList
ActivityListDataManager.GetActivityDataByType = GetActivityDataByType
ActivityListDataManager.GetActivityOpenLv = GetActivityOpenLv
ActivityListDataManager.ActRewardHandle = ActRewardHandle
ActivityListDataManager.RefreshActivityTime = RefreshActivityTime
ActivityListDataManager.GetSevenDayList = GetSevenDayList
ActivityListDataManager.RefreshSevenDayActData = RefreshSevenDayActData
ActivityListDataManager.UpdateDayActScore = UpdateDayActScore
ActivityListDataManager.GetDayActRedNum = GetDayActRedNum
ActivityListDataManager.GetTotalRedDotCount = GetTotalRedDotCount
ActivityListDataManager.GetTotalThemeActivityRedDotCount = GetTotalThemeActivityRedDotCount
ActivityListDataManager.GetActivityRedDotCount = GetActivityRedDotCount
ActivityListDataManager.IsActivityNew = IsActivityNew
ActivityListDataManager.GetActivityVisitedEndTime = GetActivityVisitedEndTime
ActivityListDataManager.SetActivityVisitedEndTime = SetActivityVisitedEndTime
ActivityListDataManager.AddOneActivity = AddOneActivity
ActivityListDataManager.DeleteArmsTimer = DeleteArmsTimer
ActivityListDataManager.ActivityByArmsTime = ActivityByArmsTime
ActivityListDataManager.RefreshArmsTime = RefreshArmsTime
ActivityListDataManager.UpdateArmsActScore = UpdateArmsActScore
ActivityListDataManager.SetActScore = SetActScore
ActivityListDataManager.GetActScore = GetActScore
ActivityListDataManager.ClearActScore = ClearActScore
ActivityListDataManager.UpdateActBarterShopInfo = UpdateActBarterShopInfo
ActivityListDataManager.CheckIfHasNew = CheckIfHasNew
ActivityListDataManager.CheckIfAlCompeteActivityOpen = CheckIfAlCompeteActivityOpen
ActivityListDataManager.GetActBossRankRewardDataList = GetActBossRankRewardDataList
ActivityListDataManager.CheckIfActivityOpen = CheckIfActivityOpen
ActivityListDataManager.GetOpenIdByType = GetOpenIdByType
ActivityListDataManager.GetOneOpenActivityByType = GetOneOpenActivityByType
ActivityListDataManager.GetAllOpenIdsByType = GetAllOpenIdsByType
ActivityListDataManager.GetOpenIdByTypeAndEnterType = GetOpenIdByTypeAndEnterType
ActivityListDataManager.GetActBossRankPersonRewardDataList = GetActBossRankPersonRewardDataList
ActivityListDataManager.StartPassDayTimer = StartPassDayTimer
ActivityListDataManager.OnPassDayUpdateActivity = OnPassDayUpdateActivity
ActivityListDataManager.SetLastVisitedActivityId = SetLastVisitedActivityId
ActivityListDataManager.GetLastVisitedActivityId = GetLastVisitedActivityId
ActivityListDataManager.CheckIsShowGiftPackPoint = CheckIsShowGiftPackPoint
ActivityListDataManager.StopActivityEndTimer = StopActivityEndTimer
ActivityListDataManager.TryTriggerNextActivityEnd = TryTriggerNextActivityEnd
ActivityListDataManager.GetActivityShowData = GetActivityShowData
ActivityListDataManager.GetActEventInfo = GetActEventInfo
ActivityListDataManager.StartPassWeekTimer = StartPassWeekTimer
ActivityListDataManager.GetRebateactivityRedNum = GetRebateactivityRedNum
ActivityListDataManager.StartUnDelayPassDayTimer = StartUnDelayPassDayTimer
ActivityListDataManager.GetTheFirstRedDotActivityId = GetTheFirstRedDotActivityId
ActivityListDataManager.IsNeedCheckDownloadRes = IsNeedCheckDownloadRes
ActivityListDataManager.IsDownloadResComplete = IsDownloadResComplete
ActivityListDataManager.IsReadyForDownloadRes = IsReadyForDownloadRes
ActivityListDataManager.DebuggerGetActivityShowData = DebuggerGetActivityShowData
return ActivityListDataManager
