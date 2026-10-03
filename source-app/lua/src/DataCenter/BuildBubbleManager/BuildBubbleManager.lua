local BuildBubbleManager = BaseClass("BuildBubbleManager")
local ResourceManager = CS.GameEntry.Resource
local BuildBubbleTip = require("UI.BuildBubbleTip.View.BuildBubbleTip")
local BuildResourceGetBubble = require("Scene.BuildResourceGetBubble.BuildResourceGetBubble")
local WorldTroopTransIcon = require("Scene.WorldTroopTransIcon.WorldTroopTransIcon")
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local Localization = CS.GameEntry.Localization
local TileBgScale2 = Vector3.New(1, 1, 1)
local TileBgScale1 = Vector3.New(0.7, 0.7, 0.7)
local TileBgScale3 = Vector3.New(0.75, 0.75, 0.75)
local TileBgScale4 = Vector3.New(1.2, 1.2, 1.2)
local HammerBgScale = Vector3.New(1.5, 1.5, 1.5)
local TrainScale = Vector3.New(1.8, 1.8, 1.8)
local ResourceIconScale = Vector3.New(1.25, 1.25, 1.25)
local AssistanceIconScale = Vector3.New(2.5, 2.5, 2.5)
local HeroStationSkillIconScale = Vector3.New(1.5, 1.5, 1.5)
local WormHoleSubIconScale = Vector3.New(1.5, 1.5, 1.5)
local BuildingLv0RuinsIconScale = Vector3.New(0.55, 0.55, 0.55)
local ResidentOrderIconScale = Vector3.New(0.8, 0.8, 0.8)
local HeroFreeScienceAndBuild = Vector3.New(1.5, 1.5, 1.5)
local SoldierBgScale = Vector3.New(1, 1, 1)
local SoldierIconScale = Vector3.New(1, 1, 1)
local AllianceHelpIconScale = Vector3.New(1, 1, 1)
local NewSoldierIconScale = Vector3.New(1.6, 1.6, 1.6)
local NewBeizengmenIconScale = Vector3.New(1.7, 1.7, 1.7)
local ActivityAlarmClockIconScale = Vector3.New(3, 3, 3)
local NoRefreshTime = 3
local GetResourceRefreshTime = 30
local Const = require("Scene.LWBattle.Const")

local function InitParam(self, param, buildId, buildTemplate, data, bubbleType, uuid)
  param.model = UIAssets.BuildStateIcon
  param.buildBubbleType = bubbleType
  param.pos = data.pointId
  param.tileX = buildTemplate.tileX
  param.tileY = buildTemplate.tileY
  param.callBack = self.OnClickCallBack
  param.bgScale = self:GetBgScale(param)
  param.iconScale = self:GetIconScale(param)
  param.buildId = buildId
  param.bUuid = data.uuid
  param.uuid = uuid
end

local function GetMarchStateIconNameBuildingBubbleByType(marchInfo)
  local strImg = "zyf_zhujiemian_suo"
  if marchInfo ~= nil then
    local marchTargetType = marchInfo:GetMarchTargetType()
    local marchType = marchInfo:GetMarchType()
    if marchType == NewMarchType.SCOUT or marchType == NewMarchType.TREAT_VIRUS or marchType == NewMarchType.LOTTO_RECEIVE or marchType == NewMarchType.ZONE_MOBILIZATION_DONATE or marchType == NewMarchType.MONSTER_CHALLENGE_DONATE then
      if MarchUtil.IsScoutMarch(marchTargetType) then
        strImg = "zyf_zhujiemian_suo"
      else
        strImg = "dl_zhujiemian_qianfan"
      end
    else
      local currentStatus = marchInfo:GetMarchStatus()
      if marchInfo.inBattle == true then
        strImg = "dl_zhujiemian_qianfan_gongji"
      elseif marchInfo:GetIsBroken() == true then
        strImg = "dl_zhujiemian_qianfan"
      elseif marchTargetType == MarchTargetType.BACK_HOME then
        strImg = "dl_zhujiemian_qianfan"
      elseif currentStatus == MarchStatus.DESTROY_WAIT then
        strImg = "dl_zhujiemian_qianfan_gongji"
      elseif currentStatus == MarchStatus.CHASING then
        strImg = "dl_zhujiemian_qianfan_gongji"
      elseif currentStatus == MarchStatus.MOVING then
        if marchTargetType == MarchTargetType.STATE or marchTargetType == MarchTargetType.ATTACK_MONSTER or marchTargetType == MarchTargetType.ATTACK_ARMY or marchTargetType == MarchTargetType.ATTACK_CITY or marchTargetType == MarchTargetType.ATTACK_WINTER_STORM_CITY or marchTargetType == MarchTargetType.ATTACK_EPIDEMIC_CITY or marchTargetType == MarchTargetType.RALLY_FOR_CITY or marchTargetType == MarchTargetType.RALLY_EPIDEMIC_CITY or marchTargetType == MarchTargetType.ATTACK_WINTER_STORM_CITY or marchTargetType == MarchTargetType.ATTACK_ALLIANCE_CITY or marchTargetType == MarchTargetType.RALLY_FOR_ALLIANCE_CITY or marchTargetType == MarchTargetType.RALLY_SERVER_THRONE_BUILDING or marchTargetType == MarchTargetType.RALLY_CENTER_THRONE or marchTargetType == MarchTargetType.RAINFOREST_THRONE_RALLY or marchTargetType == MarchTargetType.DIRECT_ATTACK_ACT_BOSS or marchTargetType == MarchTargetType.RALLY_FOR_BOSS then
          strImg = "dl_zhujiemian_qianfan_gongji"
        else
          strImg = "zyf_zhujiemian_xingjun"
        end
      elseif currentStatus == MarchStatus.WAIT_RALLY or currentStatus == MarchStatus.IN_TEAM then
        strImg = "zyf_zhujiemian_jijie"
      elseif currentStatus == MarchStatus.COLLECTING then
        strImg = "dl_zhujiemian_qianfan_wajue"
      elseif currentStatus == MarchStatus.TREASURE_DIGGING then
        strImg = "dl_zhujiemian_qianfan_wajue"
      elseif currentStatus == MarchStatus.BACK_HOME then
        strImg = "dl_zhujiemian_qianfan"
      elseif currentStatus == MarchStatus.ASSISTANCE then
        strImg = "dl_zhujiemian_shoucheng"
      elseif currentStatus == MarchStatus.CROSS_SERVER then
        strImg = "zyf_zhujiemian_suo"
      elseif currentStatus == MarchStatus.SAMPLING or currentStatus == MarchStatus.PICKING then
        strImg = "dl_zhujiemian_qianfan_wajue"
      else
        strImg = "zyf_zhujiemian_suo"
      end
    end
  end
  return strImg
end

local function __init(self)
  self.allBuildBubble = {}
  self.loadingBuildBubble = {}
  self.bubbleBuildTimer = {}
  self.showBuildBubbleFlag = {}
  self.pastureBubbleGroup = nil
  self.showBubbleNode = true
  self.bubbleNode = nil
  self.lodCache = 0
  self.isInCityCache = nil
  self.assistedBuild = {}
  self.state = BubbleState.Normal
  self.buildTypeBubbleType = {}
  self.needCheckBuildTypeList = {}
  self.realCheckUpdateList = {}
  self.checkLv0BuildDict = {}
  self.cacheModel = {}
  self.noRefreshTimer = {}
  
  function self.noRefreshTimerCallBack(uuid)
    self:NoRefreshTimerCallBack(uuid)
  end
  
  function self.get_resource_refresh_timer_callback()
    self:GetResourceRefreshCallBack()
  end
  
  function self.delayUpdateCallBack()
    self:DoCheckShowBubble()
  end
  
  self._delayUpdateData = {}
  self._delayUpdateTimer = nil
  self:AddListener()
end

local function __delete(self)
  self:ClearAll()
  self.cacheModel = nil
  self.allBuildBubble = nil
  self.loadingBuildBubble = {}
  self.bubbleBuildTimer = nil
  self.pastureBubbleGroup = nil
  self.showBubbleNode = nil
  self.bubbleNode = nil
  self.lodCache = nil
  self.isInCityCache = nil
  self.assistedBuild = nil
  self.state = nil
  self.buildTypeBubbleType = nil
  self.noRefreshTimer = nil
  self.noRefreshTimerCallBack = nil
  if self._delayUpdateTimer ~= nil then
    self._delayUpdateTimer:Stop()
    self._delayUpdateTimer = nil
  end
  self._delayUpdateData = nil
  self:RemoveListener()
  self:DeleteGetResourceRefreshTimer()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.HeroStationUpdate, self.OnHeroStationUpdateSignal)
  EventManager:GetInstance():AddListener(EventId.TrainingArmy, self.OnBuildTrainingStartSignal)
  EventManager:GetInstance():AddListener(EventId.TrainingArmyFinish, self.OnBuildTrainingFinishSignal)
  EventManager:GetInstance():AddListener(EventId.UnlockArmy, self.OnUnlockArmy)
  EventManager:GetInstance():AddListener(EventId.OnScienceQueueResearch, self.OnScienceQueueResearchSignal)
  EventManager:GetInstance():AddListener(EventId.OnScienceQueueFinish, self.OnScienceQueueFinishSignal)
  EventManager:GetInstance():AddListener(EventId.HospitalUpdate, self.OnHospitalUpdateSignal)
  EventManager:GetInstance():AddListener(EventId.HospitaiStart, self.HospitalStartSignal)
  EventManager:GetInstance():AddListener(EventId.HospitalFinish, self.HospitalFinishSignal)
  EventManager:GetInstance():AddListener(EventId.QUEUE_TIME_END, self.QueueTimeEndSignal)
  EventManager:GetInstance():AddListener(EventId.AllianceQueueHelpNew, self.QueueTimeEndSignal)
  EventManager:GetInstance():AddListener(EventId.AllianceBuildHelpNew, self.OnAllianceHelpCallBack)
  EventManager:GetInstance():AddListener(EventId.AllianceBuildFixHelpNew, self.OnAllianceFixHelpCallBack)
  EventManager:GetInstance():AddListener(EventId.RefreshResidentOrder, self.RefreshResidentOrderSignal)
  EventManager:GetInstance():AddListener(EventId.RefreshResourceItem, self.RefreshResourceItemSignal)
  EventManager:GetInstance():AddListener(EventId.RefreshEarthOrder, self.RefreshEarthOrderSignal)
  EventManager:GetInstance():AddListener(EventId.GetNewEarthOrder, self.RefreshEarthOrderSignal)
  EventManager:GetInstance():AddListener(EventId.EndEarthOrder, self.RefreshEarthOrderSignal)
  EventManager:GetInstance():AddListener(EventId.ViewEndEarthOrder, self.RefreshEarthOrderSignal)
  EventManager:GetInstance():AddListener(EventId.RefreshResourceItem, self.RefreshEarthOrderSignal)
  EventManager:GetInstance():AddListener(EventId.SoldResourceItem, self.RefreshEarthOrderSignal)
  EventManager:GetInstance():AddListener(EventId.ShowCapacitySecond, self.OnBuildGatherSecondProductSignal)
  EventManager:GetInstance():AddListener(EventId.CanGetProduct, self.OnFoodFactoryProductCreateSignal)
  EventManager:GetInstance():AddListener(EventId.GetAllProduct, self.OnFoodFactoryGatherProductSignal)
  EventManager:GetInstance():AddListener(EventId.GatherResourceItemFinish, self.GatherResourceItemFinishSignal)
  EventManager:GetInstance():AddListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
  EventManager:GetInstance():AddListener(EventId.AllianceMemberNeedHelp, self.UpdateAllianceSignal)
  EventManager:GetInstance():AddListener(EventId.GetFactoryData, self.GetFactoryDataSignal)
  EventManager:GetInstance():AddListener(EventId.GetAllDetectInfo, self.CheckDetectEventSignal)
  EventManager:GetInstance():AddListener(EventId.DetectInfoChange, self.CheckDetectEventSignal)
  EventManager:GetInstance():AddListener(EventId.SoldResourceItem, self.RefreshResourceItemSignal)
  EventManager:GetInstance():AddListener(EventId.CheckPubBubble, self.OnCheckPubBubble)
  EventManager:GetInstance():AddListener(EventId.UpdateOneCommonShop, self.OnCheckPubShopBubble)
  EventManager:GetInstance():AddListener(EventId.OnBuyCommonGoodsSucc, self.OnCheckPubShopBubble)
  EventManager:GetInstance():AddListener(EventId.Build_Fix_Time_End, self.BuildFixTimeEndSignal)
  EventManager:GetInstance():AddListener(EventId.RefreshItems, self.RefreshItemsSignal)
  EventManager:GetInstance():AddListener(EventId.AllianceWarNewStatusChanged, self.RefreshAllianceBattleSignal)
  EventManager:GetInstance():AddListener(EventId.AllianceQuitOK, self.RefreshAllianceBattleSignal)
  EventManager:GetInstance():AddListener(EventId.AllianceQuitOK, self.UpdateAllianceSignal)
  EventManager:GetInstance():AddListener(EventId.UpdateAllianceGiftNum, self.UpdateAllianceSignal)
  EventManager:GetInstance():AddListener(EventId.AllianceBaseDataUpdated, self.UpdateAllianceSignal)
  EventManager:GetInstance():AddListener(EventId.OnGetNewAlJoinReq, self.UpdateAllianceSignal)
  EventManager:GetInstance():AddListener(EventId.StorageShopBubbleStatusChange, self.UpdateKonbiniSignal)
  EventManager:GetInstance():AddListener(EventId.UpdateKonbini, self.UpdateKonbiniSignal)
  EventManager:GetInstance():AddListener(EventId.PlayerCareerSelect, self.UpdateKonbiniSignal)
  EventManager:GetInstance():AddListener(EventId.FormationInfoUpdate, self.CheckDetectEventSignal)
  EventManager:GetInstance():AddListener(EventId.RefreshGroceryStoreOrder, self.RefreshGroceryStoreOrderSignal)
  EventManager:GetInstance():AddListener(EventId.EndGroceryStoreOrder, self.RefreshGroceryStoreOrderSignal)
  EventManager:GetInstance():AddListener(EventId.RefreshResourceItem, self.RefreshGroceryStoreOrderSignal)
  EventManager:GetInstance():AddListener(EventId.SoldResourceItem, self.RefreshGroceryStoreOrderSignal)
  EventManager:GetInstance():AddListener(EventId.GolloesDataChange, self.RefreshGolloesCampBubbleSignal)
  EventManager:GetInstance():AddListener(EventId.TalentDataChange, self.RefreshGolloesCampBubbleSignal)
  EventManager:GetInstance():AddListener(EventId.MonthCardInfoUpdated, self.RefreshGolloesCampBubbleSignal)
  EventManager:GetInstance():AddListener(EventId.BuildResourcesSecond, self.FeedAnimalSignal)
  EventManager:GetInstance():AddListener(EventId.PasturePanelStateChange, self.PasturePanelSignal)
  EventManager:GetInstance():AddListener(EventId.RefreshRecommendShow, self.RefreshRecommendShowSignal)
  EventManager:GetInstance():AddListener(EventId.RefreshGuide, self.RefreshGuideSignal)
  EventManager:GetInstance():AddListener(EventId.UpdateMarchItem, self.UpdateMarchItemSignal)
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
  EventManager:GetInstance():AddListener(EventId.QueueHeroFreeTime, self.QueueHeroFreeTime)
  EventManager:GetInstance():AddListener(EventId.WorldTrendRedUpdate, self.RefreshWorldTrendSignal)
  EventManager:GetInstance():AddListener(EventId.AllianceMember, self.AllianceMemberSignal)
  EventManager:GetInstance():AddListener(EventId.RefreshAllianceCareer, self.RefreshAllianceCareerSignal)
  EventManager:GetInstance():AddListener(EventId.MainLvUp, self.MainLvUpSignal)
  EventManager:GetInstance():AddListener(EventId.NoRefresh, self.NoRefreshSignal)
  EventManager:GetInstance():AddListener(EventId.MarchItemUpdateSelf, self.UpdateMarchSignal)
  EventManager:GetInstance():AddListener(EventId.ResourceUpdated, self.ResourceUpdatedSignal)
  EventManager:GetInstance():AddListener(EventId.BatteryPowerResourceUpdated, self.OnBatteryPowerUpdated)
  EventManager:GetInstance():AddListener(EventId.ShowBuildDetail, self.BuildInViewSignal)
  EventManager:GetInstance():AddListener(EventId.HideBuildDetail, self.BuildOutViewSignal)
  EventManager:GetInstance():AddListener(EventId.DeclareWar, self.UpdateAllianceSignal)
  EventManager:GetInstance():AddListener(EventId.OnCommonShopRedChange, self.RefreshGolloesCampBubbleSignal)
  EventManager:GetInstance():AddListener(EventId.TalentDataChange, self.CheckTalentSignal)
  EventManager:GetInstance():AddListener(EventId.RefreshHeroBountyBubble, self.CheckHeroBountySignal)
  EventManager:GetInstance():AddListener(EventId.EnergyOrderRefresh, self.EnergyOrderRefreshSignal)
  EventManager:GetInstance():AddListener(EventId.ProductLineUpdate, self.ProductLineUpdateSignal)
  EventManager:GetInstance():AddListener(EventId.BuildingHeroDispatching, self.BuildingHeroDispatchingSignal)
  EventManager:GetInstance():AddListener(EventId.AcquireWorker, self.BuildingHeroDispatchingSignal)
  EventManager:GetInstance():AddListener(EventId.UpdateParkourStage, self.OnParkourUpdate)
  EventManager:GetInstance():AddListener(EventId.BuildLevelUp, self.OnBuildUpLevel)
  EventManager:GetInstance():AddListener(EventId.GF_item_refreshed, self.OnItemRefreshed)
  EventManager:GetInstance():AddListener(EventId.UpdateWeekCardFreeGiftData, self.RefreshWeekCardBubbleSignal)
  EventManager:GetInstance():AddListener(EventId.FreeWeeklyPackage, self.RefreshWeekCardBubbleSignal)
  EventManager:GetInstance():AddListener(EventId.LWSeasonWeekCardFreeRewardUpdate, self.RefreshWeekCardBubbleSignal)
  EventManager:GetInstance():AddListener(EventId.LWSeasonWeekCardDailyRewardUpdate, self.RefreshWeekCardBubbleSignal)
  EventManager:GetInstance():AddListener(EventId.LWSeasonWeekCardInfoUpdate, self.RefreshWeekCardBubbleSignal)
  EventManager:GetInstance():AddListener(EventId.GF_building_parkour_bubble_refresh, self.RefreshParkourBubble)
  EventManager:GetInstance():AddListener(EventId.UpdateFirstPayState, self.OnRefreshFirstPayState)
  EventManager:GetInstance():AddListener(EventId.OnWeekCardInfoChange, self.RefreshWeekCardBubbleSignal)
  EventManager:GetInstance():AddListener(EventId.OnPassDay, self.OnPassDaySignal)
  EventManager:GetInstance():AddListener(EventId.CommonEquipDataChanged, self.OnCommonEquipUpdateSignal)
  EventManager:GetInstance():AddListener(EventId.LuaEntryEffectRefreshStatus, self.RefreshCityState)
  EventManager:GetInstance():AddListener(EventId.HeroHonorLevelUpgrade, self.OnHeroHonorLevelUpgrade)
  EventManager:GetInstance():AddListener(EventId.HeroFragmentItemUpdate, self.OnHeroFragmentItemChange)
  EventManager:GetInstance():AddListener(EventId.PVPArenaInfoUpdate, self.OnPVPArenaInfoUpdate)
  EventManager:GetInstance():AddListener(EventId.WorldTrendEventDataUpdate, self.OnWorldTrendEventDataUpdate)
  EventManager:GetInstance():AddListener(EventId.TacticalWeaponBubbleRefresh, self.OnTacticalWeaponBubbleUpdateSignal)
  EventManager:GetInstance():AddListener(EventId.UpdateGiftPackageBuilding, self.OnRefreshGiftPackage)
  EventManager:GetInstance():AddListener(EventId.RefreshTrailTowerShowBubble, self.OnRefreshTrailTowerBubble)
  EventManager:GetInstance():AddListener(EventId.DecorateRedPoint, self.OnDecorateRedPointSignal)
  EventManager:GetInstance():AddListener(EventId.ReadNewComic, self.OnReadNewComicCallBack)
  EventManager:GetInstance():AddListener(EventId.TWSkillUnlockTimeUpdate, self.OnTWSkillChipUnlockCountDownSignal)
  EventManager:GetInstance():AddListener(EventId.LWMasteryChangeMsgGet, self.CheckMasterySignal)
  EventManager:GetInstance():AddListener(EventId.LWMasterySkillUp, self.CheckMasterySignal)
  EventManager:GetInstance():AddListener(EventId.MasteryUseSkill, self.CheckMasterySignal)
  EventManager:GetInstance():AddListener(EventId.TacticalCardBoxItemChange, self.CheckMasterySignal)
  EventManager:GetInstance():AddListener(EventId.NeedRefreshWorkerUpBubble, self.CheckWorkerUpSignal)
  EventManager:GetInstance():AddListener(EventId.GiftVoucherBubbleNeedRefresh, self.CheckGiftVoucherSignal)
  EventManager:GetInstance():AddListener(EventId.TWSkillChipRefreshBubble, self.OnTWSkillChipUpdate)
  EventManager:GetInstance():AddListener(EventId.LWSeasonWeekCardInfo, self.OnSeasonWeekCardDataUpdate)
  EventManager:GetInstance():AddListener(EventId.DecorationPlaySoundStart, self.OnDecorationPlaySoundStart)
  EventManager:GetInstance():AddListener(EventId.DecorationPlaySoundStop, self.OnDecorationPlaySoundStop)
  EventManager:GetInstance():AddListener(EventId.RebirthHospitalFinish, self.OnRefreshRebirthHospital)
  EventManager:GetInstance():AddListener(EventId.RebirthHospitalUpdate, self.OnRefreshRebirthHospital)
  EventManager:GetInstance():AddListener(EventId.RebirthHospitalStart, self.HospitalStartSignal)
  EventManager:GetInstance():AddListener(EventId.BlackMarketInfoUpdate, self.OnBlackMarketUpdate)
  EventManager:GetInstance():AddListener(EventId.BUILDING_FURNACE_DATA_UPDATE, self.OnPersonalFurnaceStateChange)
  EventManager:GetInstance():AddListener(EventId.MyBaseTemperatureChangeCrossZero, self.OnPersonalFurnaceStateChange)
  EventManager:GetInstance():AddListener(EventId.HeroLotteryBubbleUpdate, self.OnHeroLotteryBubbleUpdate)
  EventManager:GetInstance():AddListener(EventId.UpdateSeasonDeathSoldierInfo, self.UpdateSeasonDeathSoldierInfo)
  EventManager:GetInstance():AddListener(EventId.DominatorMainBuildingRedPointChanged, self.OnDominatorMainBuildingRedChanged)
  EventManager:GetInstance():AddListener(EventId.DominatorAppearanceUpdate, self.OnDominatorMainBuildingRedChanged)
  EventManager:GetInstance():AddListener(EventId.BuildDecoNumChange, self.OnDecorationNumChange)
  EventManager:GetInstance():AddListener(EventId.OnDecorationShopBubbleCheck, self.RefreshDecorationShopBubble)
  EventManager:GetInstance():AddListener(EventId.RefreshRaceEntrance, self.UpdateRaceEntranceBubble)
  EventManager:GetInstance():AddListener(EventId.GetNewUserInfoSucc, self.OnGetUserInfoSuccess)
  EventManager:GetInstance():AddListener(EventId.CHAT_HIGH_FIVE_RECEIVE, self.OnHighFiveReceive)
  EventManager:GetInstance():AddListener(EventId.T11SuccessChangeSoldierMode, self.RefreshSoldierBuildingBubble)
  EventManager:GetInstance():AddListener(EventId.T11ArriveMaxStage, self.RefreshSoldierBuildingBubble)
  EventManager:GetInstance():AddListener(EventId.GF_guide_done, self.OnGuideDone)
  EventManager:GetInstance():AddListener(EventId.MakingCoffeeUnlock, self.OnRefreshCoffeeBubble)
  EventManager:GetInstance():AddListener(EventId.MakingCoffeeUpdate, self.OnRefreshCoffeeBubble)
  EventManager:GetInstance():AddListener(EventId.GetCoffeeGoods, self.OnRefreshCoffeeBubble)
  EventManager:GetInstance():AddListener(EventId.T11IdleGameRefreshAlertTowerBubble, self.RefreshT11IdleGameBubble)
  EventManager:GetInstance():AddListener(EventId.RefreshMyFishList, self.OnRefreshFishBubble)
  EventManager:GetInstance():AddListener(EventId.MSG_ITME_STATUS_TIME_CHANGE, self.OnRefreshFishBubble)
  EventManager:GetInstance():AddListener(EventId.SeasonTower_RefreshBubble, self.RefreshSeasonTowerBubble)
  EventManager:GetInstance():AddListener(EventId.RefreshPopupActivityView, self.RefreshPopupActivityBubble)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.UnlockArmy, self.OnUnlockArmy)
  EventManager:GetInstance():RemoveListener(EventId.TalentDataChange, self.CheckTalentSignal)
  EventManager:GetInstance():RemoveListener(EventId.PlayerCareerSelect, self.UpdateKonbiniSignal)
  EventManager:GetInstance():RemoveListener(EventId.Build_Fix_Time_End, self.BuildFixTimeEndSignal)
  EventManager:GetInstance():RemoveListener(EventId.PasturePanelStateChange, self.PasturePanelSignal)
  EventManager:GetInstance():RemoveListener(EventId.FormationInfoUpdate, self.CheckDetectEventSignal)
  EventManager:GetInstance():RemoveListener(EventId.GetAllDetectInfo, self.CheckDetectEventSignal)
  EventManager:GetInstance():RemoveListener(EventId.DetectInfoChange, self.CheckDetectEventSignal)
  EventManager:GetInstance():RemoveListener(EventId.HeroStationUpdate, self.OnHeroStationUpdateSignal)
  EventManager:GetInstance():RemoveListener(EventId.TrainingArmy, self.OnBuildTrainingStartSignal)
  EventManager:GetInstance():RemoveListener(EventId.TrainingArmyFinish, self.OnBuildTrainingFinishSignal)
  EventManager:GetInstance():RemoveListener(EventId.OnScienceQueueResearch, self.OnScienceQueueResearchSignal)
  EventManager:GetInstance():RemoveListener(EventId.OnScienceQueueFinish, self.OnScienceQueueFinishSignal)
  EventManager:GetInstance():RemoveListener(EventId.HospitaiStart, self.HospitalStartSignal)
  EventManager:GetInstance():RemoveListener(EventId.HospitalFinish, self.HospitalFinishSignal)
  EventManager:GetInstance():RemoveListener(EventId.QUEUE_TIME_END, self.QueueTimeEndSignal)
  EventManager:GetInstance():RemoveListener(EventId.BuildResourcesSecond, self.FeedAnimalSignal)
  EventManager:GetInstance():RemoveListener(EventId.HospitalUpdate, self.OnHospitalUpdateSignal)
  EventManager:GetInstance():RemoveListener(EventId.AllianceQueueHelpNew, self.QueueTimeEndSignal)
  EventManager:GetInstance():RemoveListener(EventId.AllianceBuildFixHelpNew, self.OnAllianceFixHelpCallBack)
  EventManager:GetInstance():RemoveListener(EventId.AllianceBuildHelpNew, self.OnAllianceHelpCallBack)
  EventManager:GetInstance():RemoveListener(EventId.RefreshResidentOrder, self.RefreshResidentOrderSignal)
  EventManager:GetInstance():RemoveListener(EventId.RefreshResourceItem, self.RefreshResourceItemSignal)
  EventManager:GetInstance():RemoveListener(EventId.RefreshEarthOrder, self.RefreshEarthOrderSignal)
  EventManager:GetInstance():RemoveListener(EventId.GetNewEarthOrder, self.RefreshEarthOrderSignal)
  EventManager:GetInstance():RemoveListener(EventId.EndEarthOrder, self.RefreshEarthOrderSignal)
  EventManager:GetInstance():RemoveListener(EventId.ViewEndEarthOrder, self.RefreshEarthOrderSignal)
  EventManager:GetInstance():RemoveListener(EventId.RefreshResourceItem, self.RefreshEarthOrderSignal)
  EventManager:GetInstance():RemoveListener(EventId.SoldResourceItem, self.RefreshEarthOrderSignal)
  EventManager:GetInstance():RemoveListener(EventId.ShowCapacitySecond, self.OnBuildGatherSecondProductSignal)
  EventManager:GetInstance():RemoveListener(EventId.CanGetProduct, self.OnFoodFactoryProductCreateSignal)
  EventManager:GetInstance():RemoveListener(EventId.GetAllProduct, self.OnFoodFactoryGatherProductSignal)
  EventManager:GetInstance():RemoveListener(EventId.GatherResourceItemFinish, self.GatherResourceItemFinishSignal)
  EventManager:GetInstance():RemoveListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
  EventManager:GetInstance():RemoveListener(EventId.AllianceMemberNeedHelp, self.UpdateAllianceSignal)
  EventManager:GetInstance():RemoveListener(EventId.GetFactoryData, self.GetFactoryDataSignal)
  EventManager:GetInstance():RemoveListener(EventId.SoldResourceItem, self.RefreshResourceItemSignal)
  EventManager:GetInstance():RemoveListener(EventId.CheckPubBubble, self.OnCheckPubBubble)
  EventManager:GetInstance():RemoveListener(EventId.UpdateOneCommonShop, self.OnCheckPubShopBubble)
  EventManager:GetInstance():RemoveListener(EventId.OnBuyCommonGoodsSucc, self.OnCheckPubShopBubble)
  EventManager:GetInstance():RemoveListener(EventId.RefreshItems, self.RefreshItemsSignal)
  EventManager:GetInstance():RemoveListener(EventId.AllianceWarNewStatusChanged, self.RefreshAllianceBattleSignal)
  EventManager:GetInstance():RemoveListener(EventId.AllianceQuitOK, self.RefreshAllianceBattleSignal)
  EventManager:GetInstance():RemoveListener(EventId.AllianceQuitOK, self.UpdateAllianceSignal)
  EventManager:GetInstance():RemoveListener(EventId.UpdateAllianceGiftNum, self.UpdateAllianceSignal)
  EventManager:GetInstance():RemoveListener(EventId.AllianceBaseDataUpdated, self.UpdateAllianceSignal)
  EventManager:GetInstance():RemoveListener(EventId.OnGetNewAlJoinReq, self.UpdateAllianceSignal)
  EventManager:GetInstance():RemoveListener(EventId.RefreshGroceryStoreOrder, self.RefreshGroceryStoreOrderSignal)
  EventManager:GetInstance():RemoveListener(EventId.EndGroceryStoreOrder, self.RefreshGroceryStoreOrderSignal)
  EventManager:GetInstance():RemoveListener(EventId.RefreshResourceItem, self.RefreshGroceryStoreOrderSignal)
  EventManager:GetInstance():RemoveListener(EventId.SoldResourceItem, self.RefreshGroceryStoreOrderSignal)
  EventManager:GetInstance():RemoveListener(EventId.GolloesDataChange, self.RefreshGolloesCampBubbleSignal)
  EventManager:GetInstance():RemoveListener(EventId.TalentDataChange, self.RefreshGolloesCampBubbleSignal)
  EventManager:GetInstance():RemoveListener(EventId.MonthCardInfoUpdated, self.RefreshGolloesCampBubbleSignal)
  EventManager:GetInstance():RemoveListener(EventId.RefreshRecommendShow, self.RefreshRecommendShowSignal)
  EventManager:GetInstance():RemoveListener(EventId.RefreshGuide, self.RefreshGuideSignal)
  EventManager:GetInstance():RemoveListener(EventId.UpdateMarchItem, self.UpdateMarchItemSignal)
  EventManager:GetInstance():RemoveListener(EventId.StorageShopBubbleStatusChange, self.UpdateKonbiniSignal)
  EventManager:GetInstance():RemoveListener(EventId.UpdateKonbini, self.UpdateKonbiniSignal)
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
  EventManager:GetInstance():RemoveListener(EventId.QueueHeroFreeTime, self.QueueHeroFreeTime)
  EventManager:GetInstance():RemoveListener(EventId.WorldTrendRedUpdate, self.RefreshWorldTrendSignal)
  EventManager:GetInstance():RemoveListener(EventId.AllianceMember, self.AllianceMemberSignal)
  EventManager:GetInstance():RemoveListener(EventId.RefreshAllianceCareer, self.RefreshAllianceCareerSignal)
  EventManager:GetInstance():RemoveListener(EventId.MainLvUp, self.MainLvUpSignal)
  EventManager:GetInstance():RemoveListener(EventId.NoRefresh, self.NoRefreshSignal)
  EventManager:GetInstance():RemoveListener(EventId.MarchItemUpdateSelf, self.UpdateMarchSignal)
  EventManager:GetInstance():RemoveListener(EventId.ResourceUpdated, self.ResourceUpdatedSignal)
  EventManager:GetInstance():RemoveListener(EventId.BatteryPowerResourceUpdated, self.OnBatteryPowerUpdated)
  EventManager:GetInstance():RemoveListener(EventId.ShowBuildDetail, self.BuildInViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.HideBuildDetail, self.BuildOutViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.DeclareWar, self.UpdateAllianceSignal)
  EventManager:GetInstance():RemoveListener(EventId.OnCommonShopRedChange, self.RefreshGolloesCampBubbleSignal)
  EventManager:GetInstance():RemoveListener(EventId.RefreshHeroBountyBubble, self.CheckHeroBountySignal)
  EventManager:GetInstance():RemoveListener(EventId.EnergyOrderRefresh, self.EnergyOrderRefreshSignal)
  EventManager:GetInstance():RemoveListener(EventId.ProductLineUpdate, self.ProductLineUpdateSignal)
  EventManager:GetInstance():RemoveListener(EventId.BuildingHeroDispatching, self.BuildingHeroDispatchingSignal)
  EventManager:GetInstance():RemoveListener(EventId.AcquireWorker, self.BuildingHeroDispatchingSignal)
  EventManager:GetInstance():RemoveListener(EventId.UpdateParkourStage, self.OnParkourUpdate)
  EventManager:GetInstance():RemoveListener(EventId.BuildLevelUp, self.OnBuildUpLevel)
  EventManager:GetInstance():RemoveListener(EventId.GF_item_refreshed, self.OnItemRefreshed)
  EventManager:GetInstance():RemoveListener(EventId.UpdateWeekCardFreeGiftData, self.RefreshWeekCardBubbleSignal)
  EventManager:GetInstance():RemoveListener(EventId.FreeWeeklyPackage, self.RefreshWeekCardBubbleSignal)
  EventManager:GetInstance():RemoveListener(EventId.LWSeasonWeekCardFreeRewardUpdate, self.RefreshWeekCardBubbleSignal)
  EventManager:GetInstance():RemoveListener(EventId.LWSeasonWeekCardDailyRewardUpdate, self.RefreshWeekCardBubbleSignal)
  EventManager:GetInstance():RemoveListener(EventId.LWSeasonWeekCardInfoUpdate, self.RefreshWeekCardBubbleSignal)
  EventManager:GetInstance():RemoveListener(EventId.GF_building_parkour_bubble_refresh, self.RefreshParkourBubble)
  EventManager:GetInstance():RemoveListener(EventId.UpdateFirstPayState, self.OnRefreshFirstPayState)
  EventManager:GetInstance():RemoveListener(EventId.OnWeekCardInfoChange, self.RefreshWeekCardBubbleSignal)
  EventManager:GetInstance():RemoveListener(EventId.OnPassDay, self.OnPassDaySignal)
  EventManager:GetInstance():RemoveListener(EventId.CommonEquipDataChanged, self.OnCommonEquipUpdateSignal)
  EventManager:GetInstance():RemoveListener(EventId.LuaEntryEffectRefreshStatus, self.RefreshCityState)
  EventManager:GetInstance():RemoveListener(EventId.HeroHonorLevelUpgrade, self.OnHeroHonorLevelUpgrade)
  EventManager:GetInstance():RemoveListener(EventId.HeroFragmentItemUpdate, self.OnHeroFragmentItemChange)
  EventManager:GetInstance():RemoveListener(EventId.PVPArenaInfoUpdate, self.OnPVPArenaInfoUpdate)
  EventManager:GetInstance():RemoveListener(EventId.WorldTrendEventDataUpdate, self.OnWorldTrendEventDataUpdate)
  EventManager:GetInstance():RemoveListener(EventId.TacticalWeaponBubbleRefresh, self.OnTacticalWeaponBubbleUpdateSignal)
  EventManager:GetInstance():RemoveListener(EventId.UpdateGiftPackageBuilding, self.OnRefreshGiftPackage)
  EventManager:GetInstance():RemoveListener(EventId.RefreshTrailTowerShowBubble, self.OnRefreshTrailTowerBubble)
  EventManager:GetInstance():RemoveListener(EventId.DecorateRedPoint, self.OnDecorateRedPointSignal)
  EventManager:GetInstance():RemoveListener(EventId.ReadNewComic, self.OnReadNewComicCallBack)
  EventManager:GetInstance():RemoveListener(EventId.TWSkillUnlockTimeUpdate, self.OnTWSkillChipUnlockCountDownSignal)
  EventManager:GetInstance():RemoveListener(EventId.LWMasteryChangeMsgGet, self.CheckMasterySignal)
  EventManager:GetInstance():RemoveListener(EventId.LWMasterySkillUp, self.CheckMasterySignal)
  EventManager:GetInstance():RemoveListener(EventId.MasteryUseSkill, self.CheckMasterySignal)
  EventManager:GetInstance():RemoveListener(EventId.TacticalCardBoxItemChange, self.CheckMasterySignal)
  EventManager:GetInstance():RemoveListener(EventId.NeedRefreshWorkerUpBubble, self.CheckWorkerUpSignal)
  EventManager:GetInstance():RemoveListener(EventId.GiftVoucherBubbleNeedRefresh, self.CheckGiftVoucherSignal)
  EventManager:GetInstance():RemoveListener(EventId.TWSkillChipRefreshBubble, self.OnTWSkillChipUpdate)
  EventManager:GetInstance():RemoveListener(EventId.LWSeasonWeekCardInfo, self.OnSeasonWeekCardDataUpdate)
  EventManager:GetInstance():RemoveListener(EventId.DecorationPlaySoundStart, self.OnDecorationPlaySoundStart)
  EventManager:GetInstance():RemoveListener(EventId.DecorationPlaySoundStop, self.OnDecorationPlaySoundStop)
  EventManager:GetInstance():RemoveListener(EventId.RebirthHospitalFinish, self.OnRefreshRebirthHospital)
  EventManager:GetInstance():RemoveListener(EventId.RebirthHospitalUpdate, self.OnRefreshRebirthHospital)
  EventManager:GetInstance():RemoveListener(EventId.RebirthHospitalStart, self.HospitalStartSignal)
  EventManager:GetInstance():RemoveListener(EventId.BlackMarketInfoUpdate, self.OnBlackMarketUpdate)
  EventManager:GetInstance():RemoveListener(EventId.BUILDING_FURNACE_DATA_UPDATE, self.OnPersonalFurnaceStateChange)
  EventManager:GetInstance():RemoveListener(EventId.MyBaseTemperatureChangeCrossZero, self.OnPersonalFurnaceStateChange)
  EventManager:GetInstance():RemoveListener(EventId.HeroLotteryBubbleUpdate, self.OnHeroLotteryBubbleUpdate)
  EventManager:GetInstance():RemoveListener(EventId.UpdateSeasonDeathSoldierInfo, self.UpdateSeasonDeathSoldierInfo)
  EventManager:GetInstance():RemoveListener(EventId.DominatorMainBuildingRedPointChanged, self.OnDominatorMainBuildingRedChanged)
  EventManager:GetInstance():RemoveListener(EventId.DominatorAppearanceUpdate, self.OnDominatorMainBuildingRedChanged)
  EventManager:GetInstance():RemoveListener(EventId.BuildDecoNumChange, self.OnDecorationNumChange)
  EventManager:GetInstance():RemoveListener(EventId.OnDecorationShopBubbleCheck, self.RefreshDecorationShopBubble)
  EventManager:GetInstance():RemoveListener(EventId.RefreshRaceEntrance, self.UpdateRaceEntranceBubble)
  EventManager:GetInstance():RemoveListener(EventId.GetNewUserInfoSucc, self.OnGetUserInfoSuccess)
  EventManager:GetInstance():RemoveListener(EventId.CHAT_HIGH_FIVE_RECEIVE, self.OnHighFiveReceive)
  EventManager:GetInstance():RemoveListener(EventId.T11SuccessChangeSoldierMode, self.RefreshSoldierBuildingBubble)
  EventManager:GetInstance():RemoveListener(EventId.T11ArriveMaxStage, self.RefreshSoldierBuildingBubble)
  EventManager:GetInstance():RemoveListener(EventId.GF_guide_done, self.OnGuideDone)
  EventManager:GetInstance():RemoveListener(EventId.T11IdleGameRefreshAlertTowerBubble, self.RefreshT11IdleGameBubble)
  EventManager:GetInstance():RemoveListener(EventId.MakingCoffeeUnlock, self.OnRefreshCoffeeBubble)
  EventManager:GetInstance():RemoveListener(EventId.MakingCoffeeUpdate, self.OnRefreshCoffeeBubble)
  EventManager:GetInstance():RemoveListener(EventId.GetCoffeeGoods, self.OnRefreshCoffeeBubble)
  EventManager:GetInstance():RemoveListener(EventId.RefreshMyFishList, self.OnRefreshFishBubble)
  EventManager:GetInstance():RemoveListener(EventId.MSG_ITME_STATUS_TIME_CHANGE, self.OnRefreshFishBubble)
  EventManager:GetInstance():RemoveListener(EventId.SeasonTower_RefreshBubble, self.RefreshSeasonTowerBubble)
  EventManager:GetInstance():RemoveListener(EventId.RefreshPopupActivityView, self.RefreshPopupActivityBubble)
end

local function Startup()
end

local function GetBuildBubbleTypeListByBuildType(self, buildType, template, level, uuid)
  local list = {}
  if template ~= nil then
    if not string.IsNullOrEmpty(template.upgrade_notice) then
      self.needCheckBuildTypeList[buildType] = tonumber(template.upgrade_notice)
      local mainLv = DataCenter.BuildManager.MainLv
      if mainLv - level >= tonumber(template.upgrade_notice) then
        self.realCheckUpdateList[buildType] = 1
        table.insert(list, BuildBubbleType.BuildCanUpgrade)
      else
        self.realCheckUpdateList[buildType] = nil
      end
    else
      self.needCheckBuildTypeList[buildType] = nil
    end
    if template.put == BuildPutType.Lv0 and level <= 0 then
      self.checkLv0BuildDict[buildType] = 1
      table.insert(list, BuildBubbleType.BuildingLv0Ruins)
    else
      self.checkLv0BuildDict[buildType] = nil
    end
  end
  local seasonWeekCard = BuildingUtils.IsSeasonWeekCardCityBuilding(buildType)
  if not seasonWeekCard and self.buildTypeBubbleType[buildType] ~= nil then
    for _, v in ipairs(list) do
      if not table.hasvalue(self.buildTypeBubbleType[buildType], v) then
        table.insert(self.buildTypeBubbleType[buildType], v)
      end
    end
    return self.buildTypeBubbleType[buildType]
  end
  table.insert(list, BuildBubbleType.UpgradeAllianceHelp)
  table.insert(list, BuildBubbleType.HeroFreeScienceAddTime)
  table.insert(list, BuildBubbleType.HeroFreeBuildAddTime)
  table.insert(list, BuildBubbleType.BuildFixFinishEnd)
  table.insert(list, BuildBubbleType.FixBuildingAllianceHelp)
  if buildType == BuildingTypes.LW_BUILD_TREASURE_CHEST then
    table.insert(list, BuildBubbleType.MysteryTreasureChest)
  elseif buildType == BuildingTypes.FUN_BUILD_TRADING_CENTER then
    table.insert(list, BuildBubbleType.EarthOrder)
  elseif buildType == BuildingTypes.FUN_BUILD_GROCERY_STORE then
    table.insert(list, BuildBubbleType.GetResource)
    table.insert(list, BuildBubbleType.GroceryStore)
    table.insert(list, BuildBubbleType.CommonShopFree)
  elseif buildType == BuildingTypes.FUN_BUILD_SCIENE or buildType == BuildingTypes.LW_BUILE_SCIENCE_TWO or buildType == BuildingTypes.LW_BUILE_SCIENCE_THREE then
    table.insert(list, BuildBubbleType.ScienceFree)
    table.insert(list, BuildBubbleType.ScienceAllianceHelp)
    table.insert(list, BuildBubbleType.ScienceEnd)
    table.insert(list, BuildBubbleType.QueueWorking)
    if buildType == BuildingTypes.LW_BUILE_SCIENCE_TWO then
      table.insert(list, BuildBubbleType.BuyScienceBuildGift)
    end
  elseif buildType == BuildingTypes.FUN_BUILD_SCIENCE_PART then
    table.insert(list, BuildBubbleType.ScienceAllianceHelp)
    table.insert(list, BuildBubbleType.ScienceEnd)
    table.insert(list, BuildBubbleType.QueueWorking)
  elseif buildType == BuildingTypes.FUN_BUILD_BUSINESS_CENTER then
    table.insert(list, BuildBubbleType.ResidentOrder)
  elseif buildType == BuildingTypes.APS_BUILD_PASTURE_OSTRICH or buildType == BuildingTypes.APS_BUILD_PASTURE_CATTLE or buildType == BuildingTypes.APS_BUILD_PASTURE_SANDWORM then
    table.insert(list, BuildBubbleType.PastureProduct)
  elseif DataCenter.BuildManager:IsFactoryBuild(buildType) then
    table.insert(list, BuildBubbleType.GetFoodProduct)
  elseif buildType == BuildingTypes.FUN_BUILD_CAR_BARRACK then
    table.insert(list, BuildBubbleType.CarSoldierUnlock)
  elseif buildType == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK then
    table.insert(list, BuildBubbleType.FootSoldierUnlock)
  elseif buildType == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
    table.insert(list, BuildBubbleType.BowSoldierUnlock)
  elseif buildType == BuildingTypes.LW_BUILD_HOSPITL then
    table.insert(list, BuildBubbleType.HospitalFree)
    table.insert(list, BuildBubbleType.HospitalAllianceHelp)
    table.insert(list, BuildBubbleType.HospitalEnd)
    table.insert(list, BuildBubbleType.QueueWorking)
  elseif buildType == BuildingTypes.LW_BUILD_GATE then
    table.insert(list, BuildBubbleType.FireExtinguisher)
  elseif buildType == BuildingTypes.FUN_BUILD_STONE or buildType == BuildingTypes.FUN_BUILD_OIL or buildType == BuildingTypes.FUN_BUILD_WATER then
    table.insert(list, BuildBubbleType.GetResource)
  elseif buildType == BuildingTypes.FUN_BUILD_WIND_TURBINE then
    table.insert(list, BuildBubbleType.GetResource)
  elseif buildType == BuildingTypes.FUN_BUILD_SOLAR_POWER_STATION then
    table.insert(list, BuildBubbleType.GetResource)
  elseif buildType == BuildingTypes.FUN_BUILD_ELECTRICITY then
    table.insert(list, BuildBubbleType.GetResource)
  elseif buildType == BuildingTypes.FUND_BUILD_ALLIANCE_CENTER then
    table.insert(list, BuildBubbleType.NoAlliance)
    table.insert(list, BuildBubbleType.HighFive)
  elseif buildType == BuildingTypes.FUN_BUILD_CONDOMINIUM or buildType == BuildingTypes.FUN_BUILD_VILLA then
    table.insert(list, BuildBubbleType.GetResource)
  elseif buildType == BuildingTypes.APS_BUILD_FARM then
    table.insert(list, BuildBubbleType.EnergyOrder)
  elseif buildType == BuildingTypes.FUN_BUILD_RADAR_CENTER then
    local skyBattleIsOpen = DataCenter.LWSkyBattleChapterManager:IsOpen()
    local skyBattleGrowthIsOpen = DataCenter.LWSkyBattleGrowthChapterManager:IsOpen()
    if skyBattleIsOpen or skyBattleGrowthIsOpen then
      local buildData = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.FUN_BUILD_RADAR_CENTER)[1]
      if buildData and buildData.uuid == uuid then
        table.insert(list, BuildBubbleType.SkyBattleChapter)
      end
    end
  elseif buildType == BuildingTypes.FUN_BUILD_TEMP_WIND_POWER_PLANT then
    table.insert(list, BuildBubbleType.BuildZeroUp)
  elseif buildType == BuildingTypes.FUN_BUILD_SMITHY then
    table.insert(list, BuildBubbleType.AllianceBattle)
  elseif buildType == BuildingTypes.FUN_BUILD_KONBINI then
    table.insert(list, BuildBubbleType.StorageShopMoney)
    table.insert(list, BuildBubbleType.StorageShopFirstOpen)
    table.insert(list, BuildBubbleType.StorageShopGolloes)
    table.insert(list, BuildBubbleType.KonbiniFree)
  elseif buildType == BuildingTypes.APS_BUILD_PUB then
    table.insert(list, BuildBubbleType.PubFreeItem)
    table.insert(list, BuildBubbleType.HeroRecruitOther)
    table.insert(list, BuildBubbleType.HeroRecruit)
    table.insert(list, BuildBubbleType.GetResource)
  elseif buildType == BuildingTypes.FUN_BUILD_GREEN_CRYSTAL then
    table.insert(list, BuildBubbleType.GetResource)
  elseif buildType == BuildingTypes.FUN_BUILD_DRONE then
    table.insert(list, BuildBubbleType.WorldTrendStateRefresh)
  elseif buildType == BuildingTypes.FUN_BUILD_HERO_BOUNTY then
    table.insert(list, BuildBubbleType.HeroBountyFinish)
    table.insert(list, BuildBubbleType.HeroBountyFree)
  elseif buildType == BuildingTypes.APS_BUILD_WORMHOLE_MAIN then
    table.insert(list, BuildBubbleType.WormHoleSub)
    table.insert(list, BuildBubbleType.CrossWormHoleSub)
  elseif buildType == BuildingTypes.APS_BUILD_WORMHOLE_SUB then
    local configOpenState = LuaEntry.DataConfig:CheckSwitch("new_worm_hole")
    if configOpenState then
      table.insert(list, BuildBubbleType.WormHoleSubZero)
      table.insert(list, BuildBubbleType.WormHoleSub)
      for i = 1, #list do
        if list[i] == BuildBubbleType.BuildingLv0Ruins then
          table.remove(list, i)
        end
      end
    end
  elseif buildType == BuildingTypes.WORM_HOLE_CROSS then
    table.insert(list, BuildBubbleType.CrossWormHoleSub)
  elseif buildType == BuildingTypes.FUN_BUILD_HERO_BAR then
    table.insert(list, BuildBubbleType.GetResource)
  elseif buildType == BuildingTypes.FUN_BUILD_OUT_WOOD or buildType == BuildingTypes.FUN_BUILD_OUT_STONE then
    table.insert(list, BuildBubbleType.GetResource)
  elseif buildType == BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY then
    table.insert(list, BuildBubbleType.DetectEvent)
    table.insert(list, BuildBubbleType.DetectEventFinished)
  elseif buildType == BuildingTypes.LW_BUILD_MILITARY_CAMP then
    table.insert(list, BuildBubbleType.BuildingNoFunctioning)
    table.insert(list, BuildBubbleType.BuildingFunctioning)
    table.insert(list, BuildBubbleType.BuildingFunctioningFinish)
  elseif buildType == BuildingTypes.LW_BUILD_SMITH_SHOP then
    table.insert(list, BuildBubbleType.BuildingFunctioning)
    table.insert(list, BuildBubbleType.BuildingFunctioningFinish)
    table.insert(list, BuildBubbleType.SmithShopCanCraftNewEquip)
  elseif buildType == BuildingTypes.LW_BUILDING_TACTICAL_CHIP_FACTORY then
    table.insert(list, BuildBubbleType.TacticalChipFactoryNormal)
    table.insert(list, BuildBubbleType.BuildingFunctioning)
    table.insert(list, BuildBubbleType.BuildingFunctioningFinish)
  elseif buildType == BuildingTypes.LW_BUILD_BATTLE_HANGUP_REWARD then
    if 0 < level then
      table.insert(list, BuildBubbleType.BattleHangUpBattleJump)
      table.insert(list, BuildBubbleType.BattleHangUp)
      table.insert(list, BuildBubbleType.BattleHangUpFinish)
    end
  elseif buildType == BuildingTypes.LW_BUILD_PUB then
    table.insert(list, BuildBubbleType.CanFreeRecruitHero)
    table.insert(list, BuildBubbleType.RecruitHeroNew)
  elseif buildType == BuildingTypes.LW_BUILD_PARKINGLOT then
    table.insert(list, BuildBubbleType.ParkingLotState)
  elseif buildType == BuildingTypes.LW_BUILD_PARKINGLOT_TWO then
    table.insert(list, BuildBubbleType.ParkingLotState)
    table.insert(list, BuildBubbleType.ParkingLotUnlock)
  elseif buildType == BuildingTypes.LW_BUILD_PARKINGLOT_THREE then
    table.insert(list, BuildBubbleType.ParkingLotState)
    table.insert(list, BuildBubbleType.ParkingLotUnlock)
  elseif buildType == BuildingTypes.LW_BUILD_WORKER_HOUSE then
  elseif buildType == BuildingTypes.LW_BUILD_PARKINGLOT_FOUR then
    table.insert(list, BuildBubbleType.ParkingLotState)
    table.insert(list, BuildBubbleType.GolloesMonthCard)
  elseif buildType == BuildingTypes.LW_FIRST_PAY then
    table.insert(list, BuildBubbleType.FirstPayNotFixing)
    table.insert(list, BuildBubbleType.FirstPayFixing)
    table.insert(list, BuildBubbleType.FirstPayFixed)
    table.insert(list, BuildBubbleType.NewFirstPay)
  elseif buildType == BuildingTypes.LW_BUILD_RAILWAY_STATION then
    table.insert(list, BuildBubbleType.TrainFirstReward)
    table.insert(list, BuildBubbleType.TrainCanRob)
  elseif buildType == BuildingTypes.LW_BUILDING_SEASON5_RESEARCH then
    table.insert(list, BuildBubbleType.CoffeeCanUnlocked)
    table.insert(list, BuildBubbleType.MakingCoffee)
  elseif buildType == BuildingTypes.LW_BUILD_SEASON6_INSTITUTE then
    table.insert(list, BuildBubbleType.SeasonEatFish)
  elseif buildType == BuildingTypes.LW_BUILD_TRUCK_STATION_1 or buildType == BuildingTypes.LW_BUILD_TRUCK_STATION_2 or buildType == BuildingTypes.LW_BUILD_TRUCK_STATION_3 or buildType == BuildingTypes.LW_BUILD_TRUCK_STATION_4 then
    table.insert(list, BuildBubbleType.TruckReady)
    table.insert(list, BuildBubbleType.TruckReward)
    table.insert(list, BuildBubbleType.TruckTravelling)
  elseif buildType == BuildingTypes.LW_BUILD_SHOP then
    table.insert(list, BuildBubbleType.GolloesGift)
    table.insert(list, BuildBubbleType.DecorationShop)
    table.insert(list, BuildBubbleType.GiftVoucher)
  elseif buildType == BuildingTypes.LW_BUILD_COUNT_BATTLE then
    local buildData = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_COUNT_BATTLE)[1]
    if buildData and buildData.productBase and 0 < buildData.productBase then
      table.insert(list, BuildBubbleType.CountBattleSoldiers)
    else
      table.insert(list, BuildBubbleType.CountBattleEntrance)
    end
  elseif buildType == BuildingTypes.LW_CIVILIZATION_SPARK then
    local canUpgrade = DataCenter.LWCivilizationSparkManager:CheckCanUpgrade()
    if canUpgrade then
      table.insert(list, BuildBubbleType.CivilizationSparkLvUp)
    else
      local buildData = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_CIVILIZATION_SPARK)[1]
      local yardLevel = DataCenter.BuildManager:GetMaxBuildingLevel(BuildingTypes.LW_BUILD_ARMY_YARD)
      if buildData and buildData.productBase and 0 < buildData.productBase and 1 <= yardLevel then
        table.insert(list, BuildBubbleType.CivilizationSparkSoldiers)
      else
        table.insert(list, BuildBubbleType.CivilizationSparkEntrance)
      end
    end
  elseif buildType == BuildingTypes.LW_BUILD_ALERTTOWER then
    local bubbleType = DataCenter.LWSeasonTowerManager:GetAlertTowerBubbleType()
    if bubbleType == AlertTowerBubbleType.T11IdleGame then
      table.insert(list, BuildBubbleType.T11IdleGame)
    elseif bubbleType == AlertTowerBubbleType.SeasonTower then
      table.insert(list, BuildBubbleType.SeasonTower)
    elseif bubbleType == AlertTowerBubbleType.AlertTowerEntrance then
      table.insert(list, BuildBubbleType.AlertTowerEntrance)
    end
  elseif buildType == BuildingTypes.LW_BUILD_PVP_ARENA then
    local bubbleType = DataCenter.NewPeakArenaManager:GetBuildBuildingTypeWithChampionDuel()
    if bubbleType ~= ArenaBubbleType.None then
      if bubbleType == ArenaBubbleType.New then
        table.insert(list, BuildBubbleType.PVPArenaNew)
      elseif bubbleType == ArenaBubbleType.ChampionDuel then
        table.insert(list, BuildBubbleType.ChampionDuel)
      else
        table.insert(list, BuildBubbleType.PVPArena)
      end
    else
      table.insert(list, BuildBubbleType.PVPArena)
    end
  elseif buildType == BuildingTypes.LW_BUILD_PYRAMID then
    table.insert(list, BuildBubbleType.PyramidGift)
  elseif buildType == BuildingTypes.LW_BUILD_TANKCENTER or buildType == BuildingTypes.LW_BUILD_ARTILLERYCENTER or buildType == BuildingTypes.LW_BUILD_AIRCRAFTCENTER then
    table.insert(list, BuildBubbleType.HeroHonroLevelUpgrade)
  elseif buildType == BuildingTypes.LW_BUILD_TACTICAL_CENTER then
    table.insert(list, BuildBubbleType.SquadEquipChange)
    table.insert(list, BuildBubbleType.TacticalWepaonUpgrade)
    table.insert(list, BuildBubbleType.TacticalWeaponBasic)
    table.insert(list, BuildBubbleType.TWSkillChipUnlockCountDown)
    table.insert(list, BuildBubbleType.TWSkillChipCanUnlock)
    table.insert(list, BuildBubbleType.TWSkillChip)
  elseif buildType == BuildingTypes.LW_DECORATION_EXHIBITION then
    table.insert(list, BuildBubbleType.DecoratorExhibition)
  elseif buildType == BuildingTypes.SEASON_CAREER_BUILD then
    table.insert(list, BuildBubbleType.LWMastery)
  elseif buildType == BuildingTypes.LW_BUILD_TALENT_HALL then
    table.insert(list, BuildBubbleType.LWWorkerUp)
  elseif buildType == BuildingTypes.LW_BUILDING_REBIRTH_HOSPITAL then
    table.insert(list, BuildBubbleType.RebirthHospitalFree)
    table.insert(list, BuildBubbleType.RebirthHospitalAllianceHelp)
    table.insert(list, BuildBubbleType.RebirthHospitalEnd)
    table.insert(list, BuildBubbleType.QueueWorking)
  elseif buildType == BuildingTypes.LW_BUILD_BLACKMARKET then
    table.insert(list, BuildBubbleType.BlackMarket)
  elseif buildType == BuildingTypes.LW_BUILD_ACTIVITY_ALARM_CLOCK then
    table.insert(list, BuildBubbleType.ActivityAlarmClock)
  elseif buildType == BuildingTypes.LW_BUILD_DOMINATOR_MAIN then
    table.insert(list, BuildBubbleType.DominatorMainEntrance)
  elseif buildType == BuildingTypes.LW_MO_FIE_HERO then
    table.insert(list, BuildBubbleType.MoFieHeroBubble)
  elseif buildType == BuildingTypes.LW_BUILD_RACE_ENTRANCE then
    table.insert(list, BuildBubbleType.RaceEntrance)
  elseif buildType == BuildingTypes.LW_T11_Research then
    table.insert(list, BuildBubbleType.T11Research)
  elseif buildType == BuildingTypes.LW_BUILDING_SEASON5_SHOP then
  end
  table.insert(list, BuildBubbleType.HeroStationAvailable)
  table.insert(list, BuildBubbleType.HeroStationSkill)
  if DataCenter.ProductLineManager:IsProductLineBuild(buildType) then
    table.insert(list, BuildBubbleType.ProductLineNormal)
    table.insert(list, BuildBubbleType.ProductLineFull)
  end
  local buildTemlate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(template.id, 1)
  if 0 < tonumber(buildTemlate.hero_slots) then
    table.insert(list, BuildBubbleType.BuildingReplaceWorker)
  end
  local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(template.id, level)
  if buildLevelTemplate and buildLevelTemplate.build_hammer_need_opstage then
    local opstageDone = DataCenter.LWOpeningStageManager:IsStageDone(buildLevelTemplate.build_hammer_need_opstage)
    local otherBuildingsDone = true
    for _, needBuildingId in ipairs(buildLevelTemplate.build_hammer_need_otherbuildings) do
      local needLv = needBuildingId % 1000
      local itemId = math.floor(needBuildingId / 1000) * 1000
      otherBuildingsDone = otherBuildingsDone and DataCenter.BuildManager:HasBuildByIdAndLevel(itemId, needLv)
      if not otherBuildingsDone then
        break
      end
    end
    if opstageDone and otherBuildingsDone then
      table.insert(list, BuildBubbleType.BuildHammer)
    end
  end
  local upgrade_items = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.Building), template.id + level, "item")
  if not string.IsNullOrEmpty(upgrade_items) then
    table.insert(list, BuildBubbleType.UpgradeItem)
  end
  if buildType == BuildingTypes.FUN_BUILD_MAIN then
    table.insert(list, BuildBubbleType.SaveGirl)
    table.insert(list, BuildBubbleType.BuildingMainDetail)
    table.insert(list, BuildBubbleType.BuildingMainPopupActivity)
  end
  if buildType == BuildingTypes.LW_BUILD_WORLDTREND then
    table.insert(list, BuildBubbleType.WorldTrend)
  end
  if buildType == BuildingTypes.LW_GIFT_PACKAGE then
    table.insert(list, BuildBubbleType.GiftPackage)
  end
  if buildType == BuildingTypes.LW_BUILD_TREASURE_CHEST_1 or buildType == BuildingTypes.LW_BUILD_TREASURE_CHEST_2 or buildType == BuildingTypes.LW_BUILD_TREASURE_CHEST_3 or buildType == BuildingTypes.LW_BUILD_TREASURE_CHEST_4 then
    table.insert(list, BuildBubbleType.TreasureChest)
  end
  if buildType == BuildingTypes.LW_BUILD_SKY_BATTLE_1 or buildType == BuildingTypes.LW_BUILD_SKY_BATTLE_2 or buildType == BuildingTypes.LW_BUILD_SKY_BATTLE_3 or buildType == BuildingTypes.LW_BUILD_SKY_BATTLE_4 then
    table.insert(list, BuildBubbleType.SkyBattle)
  end
  local season_group = toInt(template.season_group)
  if level == 0 and buildLevelTemplate ~= nil and 1 <= season_group and BuildingUtils.IsSeasonInCityBuilding(buildType) and not SeasonUtil.IsMummyYardBuilding(buildType) then
    local chan_show_fix = true
    local need_task = tostring(buildLevelTemplate.quest_condition)
    if string.IsNullOrEmpty(need_task) then
      chan_show_fix = true
    else
      local taskInfo = DataCenter.TaskManager:FindTaskInfo(need_task)
      if taskInfo == nil then
        chan_show_fix = false
        local buildDataList = DataCenter.BuildManager:GetBuildingDatasByBuildingId(buildType)
        if buildDataList ~= nil then
          for k, buildData in ipairs(buildDataList) do
            if buildData ~= nil and buildData.completeTask ~= nil and buildData.state ~= BuildingStateType.Upgrading then
              local task_id_vec = string.split_ss_array(buildData.completeTask or "", ",")
              for _, taskId in ipairs(task_id_vec) do
                if need_task == taskId then
                  chan_show_fix = true
                  break
                end
              end
            end
          end
        end
      else
        chan_show_fix = taskInfo.state == TaskState.Received
      end
    end
    if chan_show_fix and buildLevelTemplate.preBuilds then
      local limit_level = LuaEntry.DataConfig:TryGetNum("season_building_repair_bubble", "k1", 1) or 1
      for k, v in ipairs(buildLevelTemplate.preBuilds) do
        local need_level = math.max(1, v.level - limit_level)
        if not DataCenter.BuildManager:IsExistBuildByTypeLv(v.buildId, need_level) then
          chan_show_fix = false
          break
        end
      end
    end
    if chan_show_fix then
      local buildDataList = DataCenter.BuildManager:GetBuildingDatasByBuildingId(buildType)
      if buildDataList ~= nil then
        for k, buildData in ipairs(buildDataList) do
          if buildData ~= nil and buildData.state == BuildingStateType.Upgrading then
            chan_show_fix = false
            break
          end
        end
      end
    end
    if chan_show_fix then
      table.insert(list, BuildBubbleType.SeasonBuildingLv0Ruins)
    end
  end
  if BuildingUtils.IsSeasonWeekCardCityBuilding(buildType) then
    local flag = true
    local actWeek = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonPeriodicCard.Type)
    if actWeek ~= nil and actWeek.endTime ~= nil then
      local now = UITimeManager:GetInstance():GetServerTime()
      if now < actWeek.endTime then
        local cardId = toInt(actWeek.para)
        local cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(cardId)
        if cardData and cardData:IsBought() then
          flag = false
        end
      else
        flag = false
      end
    end
    if flag then
      list = {}
      table.insert(list, BuildBubbleType.SeasonWeekCard)
    end
  end
  if buildType == BuildingTypes.LW_BUILD_DISPATCH_TASK and DataCenter.ActDispatchTaskDataManager:CheckUnlock() then
    if level == 0 then
      table.insert(list, BuildBubbleType.BuildHammer)
    else
      table.insert(list, BuildBubbleType.DispatchTask)
    end
  end
  if template ~= nil and checknumber(template.tab_type) == UIBuildListTabType.Decorate then
    table.insert(list, BuildBubbleType.DecorationPlaySound)
  end
  if buildType == BuildingTypes.LW_BUILD_HERO_COUNTDOWN then
    table.insert(list, BuildBubbleType.BuildHeroCountdownReady)
  end
  if buildType == BuildingTypes.LW_BUILDING_SEASON2_PERSONAL_FURNACE then
    table.insert(list, BuildBubbleType.PersonalFurnaceTip)
  end
  local mainLv = DataCenter.BuildManager.MainLv
  if SeasonUtil.IsMummyYardBuilding(buildType) and 1 < mainLv then
    table.insert(list, BuildBubbleType.BuildMummyYard)
  end
  if buildType == BuildingTypes.LW_BUILD_SEASON_BIG_PHOTO and 1 < mainLv then
    if DataCenter.SeasonPhotoManager:IsActive() then
      table.insert(list, BuildBubbleType.BuildSeasonBigPhoto)
    elseif SeasonUtil.IsInSeasonPrepareMode(true) then
      table.insert(list, BuildBubbleType.BuildSeasonWorld)
    end
  end
  if buildType == BuildingTypes.LW_BUILD_SEASON4_LIGHTHOUSE and 0 < level then
    table.insert(list, BuildBubbleType.BuildSeasonLightHouse)
  end
  if 0 <= level and (buildType == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1 or buildType == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION2 or buildType == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION3 or buildType == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION4) then
    table.insert(list, BuildBubbleType.BuildSeasonPowerStation)
  end
  if buildType == BuildingTypes.LW_BUILD_DIG_GAME then
    table.insert(list, BuildBubbleType.DigGame)
  end
  if buildType == BuildingTypes.LW_BUILD_SUPPLIES_SEARCH_1 or buildType == BuildingTypes.LW_BUILD_SUPPLIES_SEARCH_2 or buildType == BuildingTypes.LW_BUILD_SUPPLIES_SEARCH_3 then
    table.insert(list, BuildBubbleType.SuppliesSearch)
  end
  table.sort(list, self.CompareBuildType)
  local dontCache = buildType == BuildingTypes.LW_BUILD_PUB and level < 2
  dontCache = dontCache or buildType == BuildingTypes.LW_BUILD_BATTLE_HANGUP_REWARD and level < 1
  dontCache = dontCache or buildType == BuildingTypes.LW_BUILD_COUNT_BATTLE
  dontCache = dontCache or buildType == BuildingTypes.LW_BUILD_ALERTTOWER
  dontCache = dontCache or buildType == BuildingTypes.LW_BUILD_PVP_ARENA
  dontCache = dontCache or buildType == BuildingTypes.LW_BUILD_PARKINGLOT
  dontCache = dontCache or buildType == BuildingTypes.LW_BUILD_PARKINGLOT_TWO
  dontCache = dontCache or buildType == BuildingTypes.LW_BUILD_PARKINGLOT_THREE
  dontCache = dontCache or buildType == BuildingTypes.LW_BUILD_PARKINGLOT_FOUR
  dontCache = dontCache or buildType == BuildingTypes.LW_GIFT_PACKAGE
  dontCache = dontCache or buildType == BuildingTypes.LW_BUILDING_SEASON_FARMLAND_CTIY_4
  dontCache = dontCache or buildType == BuildingTypes.LW_BUILDING_SEASON2_FARMLAND_CTIY_5
  dontCache = dontCache or buildType == BuildingTypes.LW_BUILDING_SEASON5_CTIY_5
  dontCache = dontCache or buildType == BuildingTypes.LW_BUILDING_BLESSING_FOUNTAIN_5
  dontCache = dontCache or buildType == BuildingTypes.LW_BUILD_SEASON4_WEEK_CARD or seasonWeekCard
  dontCache = dontCache or buildType == BuildingTypes.FUN_BUILD_RADAR_CENTER
  dontCache = dontCache or buildType == BuildingTypes.LW_CIVILIZATION_SPARK
  dontCache = dontCache or level == 0
  if not dontCache then
    self.buildTypeBubbleType[buildType] = list
  end
  return list
end

local function GetBuildNeedShowBuildBubble(self, uuid)
  if self.showBuildBubbleFlag[uuid] ~= nil or CS.SceneManager.World == nil or SceneUtils.GetIsInWorld() then
    return
  end
  local data = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if data ~= nil and DataCenter.GuideManager:IsStartCanShowBuild() then
    local buildState = data.state
    local buildId = toInt(data.itemId)
    local buildLevel = toInt(data.level)
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    if buildState ~= BuildingStateType.FoldUp and data.destroyStartTime <= 0 then
      local list = self:GetBuildBubbleTypeListByBuildType(data.itemId, buildTemplate, data.level, uuid)
      if list ~= nil and buildTemplate ~= nil then
        local isContinue = true
        local param = {}
        param.modelHeight = CS.SceneManager.World:GetBuildingHeight(data.pointId)
        for k, v in ipairs(list) do
          if isContinue then
            if v == BuildBubbleType.ParkourBattle then
              local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
              if not DataCenter.GainWorkerManager:GetIsHavePveWorker() and buildData.level >= 2 then
                local curStage = DataCenter.ParkourManager.curStageId
                local passStage = DataCenter.ParkourManager.passStageId
                if data.level > 0 and curStage > passStage then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Beizengmen)
                  isContinue = false
                end
              end
            elseif v == BuildBubbleType.TreasureChest then
              InitParam(self, param, buildId, buildTemplate, data, v, uuid)
              param.iconName = "Assets/Main/Sprites/UI/UIBuildBtns/zxl_zhujiemian_liwu.png"
              param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
              isContinue = false
              param.bgScale = SoldierBgScale
              param.iconScale = Vector3.New(1.5, 1.5, 1.5)
              param.dontShake = false
              param.treasureChestId = 0
              param.extendInfo = string.format("%d", data.itemId)
              local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(data.itemId, data.level)
              if template and not string.IsNullOrEmpty(template.para1) then
                param.treasureChestId = tonumber(template.para1) or 0
              end
            elseif v == BuildBubbleType.SkyBattle then
              InitParam(self, param, buildId, buildTemplate, data, v, uuid)
              param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.SkyBattle)
              param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
              isContinue = false
              param.bgScale = SoldierBgScale
              param.iconScale = Vector3.New(1, 1, 1)
              param.dontShake = false
              param.levelId = 0
              local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(data.itemId, data.level)
              if template and not string.IsNullOrEmpty(template.para1) then
                param.levelId = tonumber(template.para1) or 0
              end
            elseif v == BuildBubbleType.SkyBattleChapter then
              InitParam(self, param, buildId, buildTemplate, data, v, uuid)
              param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.SkyBattle)
              param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
              isContinue = false
              param.bgScale = SoldierBgScale
              param.iconScale = Vector3.New(1, 1, 1)
              param.dontShake = false
            elseif v == BuildBubbleType.FireExtinguisher then
              local canRebuild = DataCenter.CityRebuildDataManager:CheckCanPopRebuildUI()
              local isOn = LuaEntry.Effect:CheckCityFarmState()
              local canShowAllianceHelp = LuaEntry.Player:IsInAlliance() and 0 < data.updateTime and (data.isHelped == AllianceHelpState.No or data.isHelped == AllianceHelpState.RuinsHelped) and data.level > 0
              if isOn and not canShowAllianceHelp and not canRebuild then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.model = UIAssets.BuildStateIcon
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.FireExtinguisher)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                isContinue = false
              end
            elseif v == BuildBubbleType.TruckReady then
              local state = DataCenter.LWMyStationDataManager:GetTruckStationState(uuid)
              if state == TruckStationState.Ready then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_chenjimaoyi_zhujiemian_kacheicon.png"
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                isContinue = false
                param.bgScale = SoldierBgScale
                param.iconScale = Vector3.New(2, 2, 2)
                param.dontShake = false
              end
            elseif v == BuildBubbleType.TruckTravelling then
              local state, duration = DataCenter.LWMyStationDataManager:GetTruckStationState(uuid)
              if state == TruckStationState.Travelling then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = "Assets/Main/Sprites/UI/LWCommon/Sprite/guaji_cfm_tubiao_2.png"
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                param.model = UIAssets.BuildStateIcon6
                isContinue = false
                param.uuid = uuid
                param.bgScale = SoldierBgScale
                param.iconScale = Vector3.New(2.5, 2.5, 2.5)
                param.dontShake = true
                self:AddOneBubbleTimer(data.uuid, duration, v)
              end
            elseif v == BuildBubbleType.TruckReward then
              local state = DataCenter.LWMyStationDataManager:GetTruckStationState(uuid)
              if state == TruckStationState.Reward then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = "Assets/Main/Sprites/UI/LWCommon/Sprite/guaji_cfm_tubiao_3.png"
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                isContinue = false
                param.bgScale = SoldierBgScale
                param.iconScale = Vector3.New(2, 2, 2)
                param.dontShake = false
              end
            elseif v == BuildBubbleType.TrainFirstReward then
              local state = DataCenter.LWMyStationDataManager:GetRailwayStationState()
              if state == RailwayStationState.FirstReward then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = "Assets/Main/Sprites/UI/LWCommon/Sprite/guaji_cfm_tubiao_3.png"
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                isContinue = false
                param.bgScale = SoldierBgScale
                param.iconScale = Vector3.New(2, 2, 2)
                param.dontShake = false
              end
            elseif v == BuildBubbleType.TrainCanRob then
              local state = DataCenter.LWMyStationDataManager:GetRailwayStationState()
              if state == RailwayStationState.CanRob or state == RailwayStationState.CannotRob then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_chenjimaoyi_zhujiemian_kacheicon.png"
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                isContinue = false
                param.bgScale = SoldierBgScale
                param.iconScale = Vector3.New(2, 2, 2)
                param.dontShake = false
              end
            elseif v == BuildBubbleType.CoffeeCanUnlocked then
              if DataCenter.MakingCoffeeManager:HasUnlockableCoffee() and data.level > 0 then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = "Assets/Main/SeasonRes/S5/Sprites/MakingCoffee/zxl_zhujiemian_qipao_kafei.png"
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                param.model = UIAssets.BuildStateIcon8
                isContinue = false
                param.bgScale = SoldierBgScale
                param.iconScale = Vector3.New(0.8, 0.8, 0.8)
                param.dontShake = false
              end
            elseif v == BuildBubbleType.MakingCoffee then
              local state = DataCenter.MakingCoffeeManager:GetCoffeeState()
              local canShow = false
              if data.level > 0 then
                if state == CoffeeState.FULL then
                  canShow = true
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                  param.txtNum = DataCenter.MakingCoffeeManager:GetCurCount()
                elseif state == CoffeeState.AVAILABLE and not DataCenter.MakingCoffeeManager:HasCoffeeStatus() then
                  canShow = true
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                  param.txtNum = DataCenter.MakingCoffeeManager:GetCurCount()
                end
              end
              if canShow then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = "Assets/Main/SeasonRes/S5/Sprites/MakingCoffee/zxl_zhujiemian_qipao_kafei.png"
                param.model = UIAssets.BuildStateIcon8
                isContinue = false
                param.bgScale = SoldierBgScale
                param.iconScale = Vector3.New(0.8, 0.8, 0.8)
                param.dontShake = false
              end
            elseif v == BuildBubbleType.SeasonEatFish then
              if DataCenter.FishingDataManager:CanShowEatFishBubble() and data.level > 0 then
                local suggest = DataCenter.FishingDataManager:SuggestEat()
                param.bgName = string.format(LoadPath.UIBuildBubble, suggest and BuildBubbleIconName.Bubble_Bg2 or BuildBubbleIconName.Bubble_Bg1)
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = "Assets/Main/SeasonRes/S6/Sprites/Fishing/ljq_zhujiemian_qipao_yu.png"
                param.model = UIAssets.BuildStateIcon8
                isContinue = false
                param.bgScale = SoldierBgScale
                param.iconScale = Vector3.New(1, 1, 1)
                param.dontShake = not suggest
              end
            elseif v == BuildBubbleType.BuildCanUpgrade then
              if data.level > 0 and DataCenter.BuildManager:ShowBuildCanUpgradeBubble(uuid) then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BuildUpgrade)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BuildUpgrade)
                isContinue = false
              end
            elseif v == BuildBubbleType.PyramidGift then
              if data.level > 0 then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.PyramidGiftBubble)
                isContinue = false
              end
            elseif v == BuildBubbleType.FootSoldierFree then
              local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.FootSoldier)
              if data.level > 0 and buildState == BuildingStateType.Normal and queue ~= nil and queue:GetQueueState() == NewQueueState.Free then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = nil
                param.bgName = nil
                isContinue = false
                param.itemId = queue.itemId
              end
            elseif v == BuildBubbleType.StorageShopFirstOpen then
              if data.level > 0 and DataCenter.StorageShopManager:CheckIfIsFirstOpen() then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.StorageShopFirstOpen)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                isContinue = false
              end
            elseif v == BuildBubbleType.StorageShopMoney then
              if data.level > 0 and DataCenter.StorageShopManager:CheckIfHasUnclaimedMoney() then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.StorageShopMoney)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                isContinue = false
              end
            elseif v == BuildBubbleType.StorageShopGolloes then
              if data.level > 0 and DataCenter.StorageShopManager:CheckIfHasGolloesBuy() then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.StorageShopGolloes)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                isContinue = false
              end
            elseif v == BuildBubbleType.CarSoldierFree then
              local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.CarSoldier)
              if data.level > 0 and buildState == BuildingStateType.Normal and queue ~= nil and queue:GetQueueState() == NewQueueState.Free then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = nil
                param.bgName = nil
                isContinue = false
                param.uuid = queue.uuid
                param.itemId = queue.itemId
              end
            elseif v == BuildBubbleType.CarSoldierUnlock then
              local armyToUnlock = DataCenter.ArmyManager:GetArmyUnlock(BuildingTypes.FUN_BUILD_CAR_BARRACK)
              if data.level > 0 and not string.IsNullOrEmpty(armyToUnlock) then
                local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyToUnlock)
                if template ~= nil then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.model = UIAssets.BuildStateIcon5
                  param.bgName = string.format(LoadPath.SoldierIcons, template.icon)
                  isContinue = false
                end
              end
            elseif v == BuildBubbleType.FootSoldierUnlock then
              local armyToUnlock = DataCenter.ArmyManager:GetArmyUnlock(BuildingTypes.FUN_BUILD_INFANTRY_BARRACK)
              if data.level > 0 and not string.IsNullOrEmpty(armyToUnlock) then
                local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyToUnlock)
                if template ~= nil then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.model = UIAssets.BuildStateIcon5
                  param.bgName = string.format(LoadPath.SoldierIcons, template.icon)
                  isContinue = false
                end
              end
            elseif v == BuildBubbleType.BowSoldierUnlock then
              local armyToUnlock = DataCenter.ArmyManager:GetArmyUnlock(BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK)
              if data.level > 0 and not string.IsNullOrEmpty(armyToUnlock) then
                local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyToUnlock)
                if template ~= nil then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.model = UIAssets.BuildStateIcon5
                  param.bgName = string.format(LoadPath.SoldierIcons, template.icon)
                  isContinue = false
                end
              end
            elseif v == BuildBubbleType.BowSoldierFree then
              local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.BowSoldier)
              if data.level > 0 and buildState == BuildingStateType.Normal and queue ~= nil and queue:GetQueueState() == NewQueueState.Free then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = nil
                param.bgName = nil
                isContinue = false
                param.uuid = queue.uuid
                param.itemId = queue.itemId
              end
            elseif v == BuildBubbleType.HospitalFree then
              local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
              if data.level > 0 and queue ~= nil and queue:GetQueueState() == NewQueueState.Free and DataCenter.HospitalManager:IsHaveInjuredSolider() then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Hospital_soldier)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                isContinue = false
                param.uuid = queue.uuid
                param.buid = data.uuid
                param.itemId = queue.itemId
              end
            elseif v == BuildBubbleType.HospitalEnd then
              local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
              if data.level > 0 and queue ~= nil and (queue:GetQueueState() == NewQueueState.Finish or DataCenter.CityRebuildDataManager:GetCureState()) then
                param.model = UIAssets.BuildStateIcon
                local template = DataCenter.HospitalManager:GetMaxSoldierInTreating()
                if template ~= nil then
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                  if T11Util.IsSuperSoldier(template.lv) then
                    param.iconName = T11Util.GetSoldierBubblePath()
                  else
                    param.iconName = string.format(LoadPath.UIMainBubble, template.bubble_icon)
                  end
                else
                  SFSNetwork.SendMessage(MsgDefines.QueueFinish, {
                    uuid = queue.uuid
                  })
                end
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                isContinue = false
                param.uuid = queue.uuid
                param.itemId = queue.itemId
                param.bgScale = self:GetBgScale(param)
                param.iconScale = NewSoldierIconScale
              end
            elseif v == BuildBubbleType.ScienceFree then
              local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(uuid)
              if data.level > 0 and queue ~= nil and queue:GetQueueState() == NewQueueState.Free then
                param.model = UIAssets.BuildStateIcon
                local name = BuildBubbleIconName.ScienceFree
                if data.itemId == BuildingTypes.LW_BUILE_SCIENCE_TWO then
                  name = BuildBubbleIconName.ScienceFreeTwo
                elseif data.itemId == BuildingTypes.LW_BUILE_SCIENCE_THREE then
                  name = BuildBubbleIconName.ScienceThree
                end
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, name)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                isContinue = false
                param.uuid = queue.uuid
                param.itemId = queue.itemId
              end
            elseif v == BuildBubbleType.ScienceEnd then
              local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(uuid)
              if data.level > 0 and queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
                param.model = UIAssets.BuildStateIcon
                local id = tonumber(queue.itemId)
                local level = 1
                local science = DataCenter.ScienceDataManager:GetScienceById(id)
                if science ~= nil then
                  level = science.level + 1
                end
                local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(id, level)
                if template ~= nil then
                  param.iconName = string.format(LoadPath.UILWScience, template.icon)
                  param.exp = template.exp
                end
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                isContinue = false
                param.uuid = queue.uuid
                param.itemId = queue.itemId
              end
            elseif v == BuildBubbleType.HeroBountyFinish then
              if data.level > 0 and DataCenter.HeroBountyDataManager:GetIsShowBubble() and DataCenter.HeroBountyDataManager:GetIsTaskFinish() then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.HeroBounty)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgSelect)
                isContinue = false
              end
            elseif v == BuildBubbleType.HeroBountyFree then
              if data.level > 0 and DataCenter.HeroBountyDataManager:GetIsShowBubble() and DataCenter.HeroBountyDataManager:GetIsTaskFinish() == false then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.HeroBounty)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                isContinue = false
              end
            elseif v == BuildBubbleType.HeroFreeScienceAddTime then
              local isUseHero = DataCenter.QueueDataManager:GetCanUseHeroFreeTime(uuid)
              if isUseHero and isUseHero[2] then
                local queue = DataCenter.QueueDataManager:GetQueueByUuid(isUseHero[4])
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                if isUseHero[5] then
                  param.robotId = isUseHero[5]
                  param.iconName = string.format(LoadPath.ItemPath, "Speedup_robot_" .. isUseHero[5])
                else
                  param.iconName = string.format(LoadPath.ItemPath, "Speedup_daben")
                end
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgSelect)
                isContinue = false
                param.itemId = queue.itemId
                param.queueUuid = isUseHero[4]
                param.freeTimeType = isUseHero[3]
              end
            elseif v == BuildBubbleType.HeroFreeBuildAddTime then
              local isUseHero = DataCenter.BuildQueueManager:GetCanUseHeroFreeTime(uuid)
              if isUseHero and isUseHero[2] then
                local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                if isUseHero[5] then
                  param.robotId = isUseHero[5]
                  param.iconName = string.format(LoadPath.ItemPath, "Speedup_robot_" .. isUseHero[5])
                else
                  param.iconName = string.format(LoadPath.ItemPath, "Speedup_daben")
                end
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgSelect)
                isContinue = false
                param.itemId = buildData.itemId
                param.queueUuid = isUseHero[4]
                param.freeTimeType = isUseHero[3]
              end
            elseif v == BuildBubbleType.UpgradeAllianceHelp then
              if LuaEntry.Player:IsInAlliance() and 0 < data.updateTime and (data.isHelped == AllianceHelpState.No or data.isHelped == AllianceHelpState.RuinsHelped) and data.level > 0 and data:IsUpgradeFinish() == false then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.model = UIAssets.BuildStateIcon
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.UpgradeAllianceHelp)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                isContinue = false
              end
            elseif v == BuildBubbleType.ScienceAllianceHelp then
              local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(uuid)
              if data.level > 0 and LuaEntry.Player:IsInAlliance() and queue ~= nil and queue:GetQueueState() == NewQueueState.Work and queue.isHelped == 0 then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.model = UIAssets.BuildStateIcon
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.ScienceAllianceHelp)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                isContinue = false
                param.uuid = queue.uuid
                param.itemId = queue.itemId
              end
            elseif v == BuildBubbleType.HospitalAllianceHelp then
              local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
              local maxCount = LuaEntry.DataConfig:TryGetNum("medical_assist_daily_limit", "k1")
              local sameDay = false
              if queue and 0 < queue.lastHelpTime then
                local curTime = UITimeManager:GetInstance():GetServerTime()
                sameDay = UITimeManager:GetInstance():IsSameDayForServer(queue.lastHelpTime // 1000, curTime // 1000)
              end
              if data.level > 0 and LuaEntry.Player:IsInAlliance() and queue ~= nil and queue:GetQueueState() == NewQueueState.Work and queue.isHelped == 0 and (maxCount > queue.helpNum or not sameDay) then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.model = UIAssets.BuildStateIcon
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.HospitalAllianceHelp)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                isContinue = false
                param.uuid = queue.uuid
                param.itemId = queue.itemId
              end
            elseif v == BuildBubbleType.PastureProduct then
              local queueList = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(uuid)
              local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIPasture)
              local windowFlag = false
              if window ~= nil and window.View ~= nil and window.View.activeSelf == true and uuid == window.View.buildUuid then
                windowFlag = true
              end
              if DataCenter.RecommendShowManager:IsShowByType(RecommendShowType.FeedOstrich) or DataCenter.GuideManager:InGuide() then
                windowFlag = true
              end
              if windowFlag == false and data.level > 0 and buildState == BuildingStateType.Normal and queueList ~= nil then
                for k1, v1 in pairs(queueList) do
                  if isContinue and v1:GetParaState() == QueueProductState.PASTURE_MATURE and v1:GetQueueState() == NewQueueState.Finish then
                    local functionTemplate = DataCenter.FarmingDataManager:GetFramingTemplate(v1.itemId)
                    if functionTemplate ~= nil then
                      local itemId = ""
                      local count = 0
                      table.walk(functionTemplate.second_get_goods, function(m, n)
                        itemId = m
                        count = n
                      end)
                      local resourceItemData = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemId)
                      if resourceItemData ~= nil then
                        InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                        param.iconName = resourceItemData:GetIconPath()
                        param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.AnimalBgYellow)
                        isContinue = false
                        param.itemId = v1.itemId
                      end
                    end
                  end
                end
                if windowFlag == false and isContinue == true then
                  for _, v1 in pairs(queueList) do
                    if v1:GetParaState() == QueueProductState.DEFAULT and v1:GetQueueState() == NewQueueState.Finish or v1:GetParaState() == QueueProductState.PASTURE_MATURE and v1:GetQueueState() == NewQueueState.Free or v1:GetParaState() == QueueProductState.DEFAULT and v1:GetQueueState() == NewQueueState.Work then
                      local functionTemplate = DataCenter.FarmingDataManager:GetFramingTemplate(v1.itemId)
                      if functionTemplate ~= nil then
                        local itemId = ""
                        table.walk(functionTemplate.second_need_goods, function(m, n)
                          itemId = m
                        end)
                        local resourceItemData = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemId)
                        if resourceItemData ~= nil then
                          InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                          param.iconName = resourceItemData:GetIconPath()
                          param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.AnimalBg)
                          isContinue = false
                          param.needToFeed = true
                          param.itemId = v1.itemId
                        end
                      end
                    end
                  end
                end
              end
            elseif v == BuildBubbleType.GetFoodProduct then
              local factoryData = DataCenter.FactoryDataManager:GetFactoryDataByBUuid(uuid)
              if data.level > 0 and factoryData ~= nil then
                local itemId, productId = factoryData:CheckCanGetProduct()
                if itemId > -1 and not string.IsNullOrEmpty(productId) then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  isContinue = false
                  local pic = string.format(LoadPath.CommonNewPath, "Common_duihao2")
                  local factoryTemplate = DataCenter.FactoryDataManager:GetFactoryTemplate(productId)
                  if factoryTemplate then
                    pic = factoryTemplate:GetProductShowIcon()
                  end
                  param.iconName = pic
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.AnimalBgYellow)
                  param.itemId = itemId
                  param.factoryId = productId
                end
              end
            elseif v == BuildBubbleType.ResidentOrder then
              local state = DataCenter.ResidentOrderDataManager:GetBusinessBubbleState()
              local sendLeftTime = DataCenter.ResidentOrderDataManager:GetOrderSendLeftTime()
              local reachLimit = DataCenter.ResidentOrderDataManager:IsReachMax()
              if data.level > 0 and buildState == BuildingStateType.Normal and state == BusinessBubbleState.Yes and sendLeftTime <= 0 and reachLimit == false then
                isContinue = false
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.state = state
                if state == BusinessBubbleState.NoSubmit then
                  param.model = UIAssets.BuildStateIcon
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Business)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                else
                  param.model = UIAssets.BuildStateIcon3
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Mars)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgCircle)
                end
                param.bgScale = Vector3.New(0.8, 0.8, 0.8)
                param.iconScale = self:GetIconScale(param)
                param.buildId = buildId
              end
            elseif v == BuildBubbleType.GolloesGift then
              if data.level > 0 then
                local showBubble = DataCenter.MonthCardNewManager:ShowSubscriptionBubble()
                if showBubble then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.SubscriptionReward)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                  isContinue = false
                end
              end
            elseif v == BuildBubbleType.DecorationShop then
              if data.level > 0 then
                local showBubble = DataCenter.CommonShopManager:IfHaveNewItemInDecorationShop()
                if showBubble then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = string.format(LoadPath.ItemPath, BuildBubbleIconName.DecorationShopBuildBubbleIcon)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                  isContinue = false
                end
              end
            elseif v == BuildBubbleType.GiftVoucher then
              if data.level > 0 then
                local showBubble = DataCenter.GiftVoucherShopBuildBubbleDataManager:GetIsShowBubble()
                if showBubble then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = string.format(LoadPath.ItemPath, BuildBubbleIconName.GiftVoucherBubbleIcon)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                  isContinue = false
                end
              end
            elseif v == BuildBubbleType.GolloesMonthCard then
              local isOpen = DataCenter.MonthCardNewManager:CheckIfMonthCardActive()
              if not isOpen and 0 < DataCenter.BuildManager.MainLv then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.ItemPath, BuildBubbleIconName.MonthCardBuy)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                isContinue = false
              end
            elseif v == BuildBubbleType.ParkingLotState then
              local formationIndex = DataCenter.ArmyFormationDataManager:GetFormationIndexByBuildingType(data.itemId)
              local Player = LuaEntry.Player
              local armyInfo = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByIndex(formationIndex)
              local march
              if armyInfo then
                march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(Player.uid, armyInfo.uuid, Player.allianceId)
              end
              if 0 < formationIndex and 4 <= DataCenter.BuildManager.MainLv and data.level > 0 and march ~= nil then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                local iconName = GetMarchStateIconNameBuildingBubbleByType(march)
                param.iconName = string.format(LoadPath.UIBuildBubble, iconName)
                param.bgName = string.format(LoadPath.UIBuildBubble, iconName)
                param.model = UIAssets.BuildStateIcon10
                param.endTime = march.endTime
                isContinue = false
                param.dontShake = true
              end
            elseif v == BuildBubbleType.ParkingLotUnlock then
              if data.level == 0 and data.uuid ~= nil then
                local cfg = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, 0)
                if cfg ~= nil then
                  local preBuild = cfg:GetPreBuild()
                  if preBuild ~= nil then
                    for tk, tv in ipairs(preBuild) do
                      if DataCenter.BuildManager:IsExistBuildByTypeLv(tv.buildId, tv.level) then
                        InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                        param.iconName = string.format(LoadPath.CommonNewPath, "big_hammer")
                        param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgSelect2)
                        isContinue = false
                        param.buildUuid = data.uuid
                        break
                      end
                    end
                  end
                end
              end
            elseif v == BuildBubbleType.GroceryStore then
              if data.level > 0 and buildState == BuildingStateType.Normal and DataCenter.GroceryStoreOrderDataManager:HasCanSubmitOrder() then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.CommonNewPath, "Common_duihao2")
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgSelect2)
                isContinue = false
              end
            elseif v == BuildBubbleType.CommonShopFree then
              if data.level > 0 and buildState == BuildingStateType.Normal and 0 < DataCenter.CommonShopManager:GetRedCount() then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.AllianceGift)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                isContinue = false
              end
            elseif v == BuildBubbleType.MysteryTreasureChest then
              isContinue = false
              param.buildBubbleType = v
              param.pos = data.pointId
              param.tileX = buildTemplate.tileX
              param.tileY = buildTemplate.tileY
              param.callBack = self.OnClickCallBack
              param.uuid = uuid
              param.bgScale = TileBgScale4
              param.iconScale = Vector3.New(2, 2, 2)
              param.buildId = buildId
              param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
              local template = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(tonumber(data.specialStageId))
              if template.stage_icons and 0 < #template.stage_icons then
                local index = 1
                if data.specialStagePassedIds and 0 < #data.specialStagePassedIds then
                  index = #data.specialStagePassedIds + 1
                end
                if index <= #template.stage_icons then
                  param.iconName = string.format(LoadPath.UIBuildBubble, template.stage_icons[index])
                end
              else
                param.iconName = string.format(LoadPath.UIBuildBubble, template.icon)
              end
              param.model = UIAssets.MysteryTreasureBubble
              param.modelHeight = 3
            elseif v == BuildBubbleType.DigGame then
              param.iconName = string.format(LoadPath.UIDigTreasureSpritePath, "FX_S3_xiusaiqi_jidongduiwabao_chuizi_icon")
              param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
              param.model = UIAssets.BuildStateIcon
              isContinue = false
              param.buildBubbleType = v
              param.pos = data.pointId
              param.tileX = buildTemplate.tileX
              param.tileY = buildTemplate.tileY
              param.callBack = self.OnClickCallBack
              param.uuid = uuid
              param.bgScale = SoldierBgScale
              param.iconScale = TrainScale
              param.buildId = buildId
            elseif v == BuildBubbleType.EarthOrder then
              if LuaEntry.Effect:GetGameEffect(EffectDefine.EARTH_ORDER_UNLOCK) == 1 and data.level > 0 then
                local info = DataCenter.EarthOrderDataManager:GetOneEarthOrder()
                local recall = DataCenter.EarthOrderDataManager:checkIsRecall()
                local hasComplete = DataCenter.EarthOrderDataManager:HasCanSubmitOrder()
                local leftTime = 1
                if info ~= nil then
                  leftTime = info.expTime - UITimeManager:GetInstance():GetServerTime()
                end
                if BuildingUtils.IsRocketPlayingArrive(data.pointId) == false then
                  if leftTime <= 0 and info ~= nil then
                    if info.orderItemArr ~= nil then
                      InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                      param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.NoGetResource)
                      param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                      isContinue = false
                      param.expTime = info.expTime
                    end
                  elseif recall == true then
                    InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                    param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.EarthOrderRecall)
                    param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                    isContinue = false
                    param.modelHeight = 1
                  elseif hasComplete == true and info ~= nil then
                    InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                    param.iconName = string.format(LoadPath.CommonNewPath, "Common_duihao2")
                    param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgSelect2)
                    isContinue = false
                  end
                end
              end
            elseif v == BuildBubbleType.SuppliesSearch then
              param.iconName = string.format(LoadPath.UIBuildBubble, "zxl_zhujiemian_qipao_sousuo")
              param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
              param.model = UIAssets.BuildStateIcon
              isContinue = false
              param.buildBubbleType = v
              param.pos = data.pointId
              param.tileX = buildTemplate.tileX
              param.tileY = buildTemplate.tileY
              param.callBack = self.OnClickCallBack
              param.uuid = uuid
              param.bgScale = SoldierBgScale
              param.iconScale = SoldierBgScale
              param.buildId = buildId
            elseif v == BuildBubbleType.ExtendDome then
              local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_DOME)
              if buildData ~= nil then
                local level = buildData.level
                local buildId = buildData.itemId
                local domeTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
                if domeTemplate ~= nil and level < domeTemplate.max_level then
                  local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
                  if buildLevelTemplate ~= nil then
                    local showIcon = true
                    if not buildLevelTemplate:IsPreBuildConditionValid() then
                      showIcon = false
                    end
                    local ret = DataCenter.BuildManager:CheckBuildUpgradeResAndItem(buildData.uuid)
                    if not ret.enough then
                      showIcon = false
                    end
                    if showIcon then
                      InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                      param.iconName = nil
                      isContinue = false
                    end
                  end
                end
              end
            elseif v == BuildBubbleType.GetResource then
              if data.level > 0 and not DataCenter.BuildGetItemAfterShowTalkManager:IsDelayShowGetResourceBubble(uuid) then
                local showTime = DataCenter.BuildManager:GetShowBubbleTime(uuid)
                local now = UITimeManager:GetInstance():GetServerTime()
                if 0 < showTime then
                  if showTime >= now then
                    self:AddOneBubbleTimer(data.uuid, (showTime - now) / 1000, v)
                  else
                    param.model = UIAssets.BuildResourceGetBubble
                    isContinue = false
                    param.buildBubbleType = v
                    param.pos = data.pointId
                    param.tileX = buildTemplate.tileX
                    param.tileY = buildTemplate.tileY
                    param.callBack = self.OnClickCallBack
                    param.uuid = data.uuid
                    param.resourceType = DataCenter.BuildManager:GetOutResourceTypeByBuildId(buildTemplate.id)
                    param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                    param.maxColorValue = buildTemplate:GetOutResourceMaxColorPercent()
                    param.unavailableTime = data.unavailableTime
                    param.produceEndTime = data.produceEndTime
                    param.lastCollectTime = data.lastCollectTime
                    local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(data.itemId, data.level)
                    if levelTemplate ~= nil then
                      param.collectSpeed = levelTemplate:GetCollectSpeed() / 1000
                      param.collectMax = levelTemplate:GetCollectMax()
                      if param.resourceType == ResourceType.ResourceItem then
                        local resourceItemId = levelTemplate:GetOutResourceItemId()
                        param.itemId = resourceItemId
                        if resourceItemId ~= nil then
                          local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(resourceItemId)
                          if template ~= nil then
                            param.iconName = template:GetIconPath()
                          end
                        end
                      else
                        param.iconName = DataCenter.ResourceManager:GetResourceIconByType(param.resourceType)
                      end
                    end
                    param.buildId = buildTemplate.id
                    param.bgScale = self:GetBgScale(param)
                    param.iconScale = self:GetIconScale(param)
                    if 0 < param.unavailableTime and now > param.unavailableTime then
                      now = param.unavailableTime
                    end
                    if 0 < param.produceEndTime and now > param.produceEndTime then
                      now = param.produceEndTime
                    end
                    local curValue = (now - param.lastCollectTime) * param.collectSpeed / param.collectMax
                    if curValue >= param.maxColorValue then
                      param.state = BuildGetResourceState.Full
                      param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgSelect)
                      self:RemoveOneBubbleTimer(data.uuid, v)
                    elseif 1 <= curValue then
                      param.state = BuildGetResourceState.Add
                      param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                      self:RemoveOneBubbleTimer(data.uuid, v)
                    end
                  end
                end
              end
            elseif v == BuildBubbleType.NoGetResource then
              if data.level > 0 and BuildingUtils.IsBuildResourceEmpty(data.itemId, data.pointId) then
                param.model = UIAssets.BuildStateIcon
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.NoGetResource)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                isContinue = false
                param.buildBubbleType = v
                param.pos = data.pointId
                param.tileX = buildTemplate.tileX
                param.tileY = buildTemplate.tileY
                param.callBack = self.OnClickCallBack
                param.uuid = data.uuid
                param.resourceType = DataCenter.BuildManager:GetOutResourceTypeByBuildId(buildTemplate.id)
                local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(data.itemId, data.level)
                if levelTemplate ~= nil and param.resourceType == ResourceType.ResourceItem then
                  local resourceItemId = levelTemplate:GetOutResourceItemId()
                  param.itemId = resourceItemId
                end
                param.bgScale = self:GetBgScale(param)
                param.iconScale = self:GetIconScale(param)
                param.buildId = buildId
              end
            elseif v == BuildBubbleType.NeedTransport then
              if data.level > 0 and 0 >= data.unavailableTime then
                local now = UITimeManager:GetInstance():GetServerTime()
                local produceEndTime = data.produceEndTime
                if now >= produceEndTime then
                  self:RemoveOneBubbleTimer(data.uuid, v)
                  param.model = UIAssets.BuildStateIcon
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.NoGetResource)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                  isContinue = false
                  param.buildBubbleType = v
                  param.pos = data.pointId
                  param.tileX = buildTemplate.tileX
                  param.tileY = buildTemplate.tileY
                  param.callBack = self.OnClickCallBack
                  param.uuid = data.uuid
                  param.bgScale = self:GetBgScale(param)
                  param.iconScale = self:GetIconScale(param)
                  param.buildId = buildId
                else
                  self:AddOneBubbleTimer(data.uuid, (produceEndTime - now) / 1000, v)
                end
              end
            elseif LuaEntry.Player:IsInAlliance() and (v == BuildBubbleType.AllianceTask or v == BuildBubbleType.AllianceHelp or v == BuildBubbleType.AllianceGift) then
              if v == BuildBubbleType.AllianceTask then
                local redCount = DataCenter.DailyTaskManager:GetRedNum()
                if 0 < redCount then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.AllianceTask)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                  isContinue = false
                end
              elseif v == BuildBubbleType.AllianceHelp then
                local otherList = DataCenter.AllianceHelpDataManager:GetOtherHelpList()
                if data.level > 0 and LuaEntry.Player:IsInAlliance() and 0 < DataCenter.AllianceHelpDataManager:GetHelpNum() then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.AllianceHelpOthers)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                  isContinue = false
                end
              elseif v == BuildBubbleType.AllianceGift then
                local count = DataCenter.AllianceGiftDataManager:GetGiftNum()
                if 0 < count then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.AllianceGift)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                  isContinue = false
                end
              end
            elseif v == BuildBubbleType.HeroAdvance then
              if data.level > 0 and HeroAdvanceController:GetInstance():CanShowAdvanceBubble() then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, v == BuildBubbleType.HeroAdvance and BuildBubbleIconName.HeroAdvance or BuildBubbleIconName.HeroRecruit)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                isContinue = false
              end
            elseif v == BuildBubbleType.HeroRecruit then
              if data.level > 0 and DataCenter.LotteryDataManager:CanShowTipBubble(true) then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, v == BuildBubbleType.HeroAdvance and BuildBubbleIconName.HeroAdvance or BuildBubbleIconName.HeroRecruit)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                isContinue = false
              end
            elseif v == BuildBubbleType.HeroRecruitOther then
              if data.level > 0 and DataCenter.LotteryDataManager:CanShowTipBubble(false) then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, v == BuildBubbleType.HeroAdvance and BuildBubbleIconName.HeroAdvance or BuildBubbleIconName.HeroRecruit)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                isContinue = false
              end
            elseif v == BuildBubbleType.PubFreeItem then
              local isFree = DataCenter.CommonShopManager:CheckHeroResetIsFree()
              if isFree then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.GolloesGift)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                isContinue = false
              end
            elseif v == BuildBubbleType.DetectEvent then
              local uuids = DataCenter.RadarCenterDataManager:GetDetectEventInfoUuids()
              if data.level > 0 and not DataCenter.GainWorkerManager:GetIsHavePveWorker() and DataCenter.GainWorkerManager:GetIsShowAllBubble() then
                local isFirstJoinAl = LuaEntry.Player:IsFirstJoinAlliance()
                local mainWorldPos = LuaEntry.Player:GetMainWorldPos()
                if isFirstJoinAl or not isFirstJoinAl and mainWorldPos <= 0 or data.level > 0 and uuids ~= nil and 0 < table.count(uuids) and DataCenter.RadarCenterDataManager:CheckGuideOpenBuildBubble() then
                  local count = DataCenter.RadarCenterDataManager:GetFinishedDetectEventNum()
                  if count == 0 then
                    InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                    isContinue = false
                    param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                    param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.DetectEvent)
                    param.modelHeight = 3
                  end
                end
              end
            elseif v == BuildBubbleType.DetectEventFinished then
              local uuids = DataCenter.RadarCenterDataManager:GetDetectEventInfoUuids()
              if not DataCenter.GainWorkerManager:GetIsHavePveWorker() and DataCenter.GainWorkerManager:GetIsShowAllBubble() and data.level > 0 and uuids ~= nil and 0 < table.count(uuids) and DataCenter.RadarCenterDataManager:CheckGuideOpenBuildBubble() then
                local count = DataCenter.RadarCenterDataManager:GetFinishedDetectEventNum()
                if 0 < count then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  isContinue = false
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.RoundBgYellow)
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.DetectEventComplete)
                  param.modelHeight = 3
                end
              end
            elseif v == BuildBubbleType.LWMastery then
              local masteryData = DataCenter.MasteryManager:GetData()
              if masteryData then
                local cardFunctionOpen = TacticalCardUtil.IsFunctionOpen()
                local isExistCanEquipCard = false
                local hasScoreReward = false
                if cardFunctionOpen then
                  isExistCanEquipCard = TacticalCardUtil.IsExistAnySlotShowRedDot()
                  hasScoreReward = TacticalCardUtil.HasScoreRewardRedDot()
                end
                if hasScoreReward then
                  param.model = UIAssets.BuildStateIcon
                  isContinue = false
                  param.buildBubbleType = v
                  param.pos = data.pointId
                  param.tileX = buildTemplate.tileX
                  param.tileY = buildTemplate.tileY
                  param.callBack = self.OnClickCallBack
                  param.uuid = uuid
                  param.bgScale = self:GetBgScale(param)
                  param.iconScale = self:GetIconScale(param)
                  param.buildId = buildId
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.TacticalCardBubble)
                  param.modelHeight = 3
                  param.openTCCardCachaPanel = true
                elseif isExistCanEquipCard then
                  param.model = UIAssets.BuildStateIcon
                  isContinue = false
                  param.buildBubbleType = v
                  param.pos = data.pointId
                  param.tileX = buildTemplate.tileX
                  param.tileY = buildTemplate.tileY
                  param.callBack = self.OnClickCallBack
                  param.uuid = uuid
                  param.bgScale = self:GetBgScale(param)
                  param.iconScale = self:GetIconScale(param)
                  param.buildId = buildId
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.TacticalCardBubble)
                  param.modelHeight = 3
                  param.openTCCardPanel = true
                elseif 0 < masteryData:GetCurPlanIdlePoint() or DataCenter.MasteryManager:CheckCanUpgradeByGoods() then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  isContinue = false
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgSelect)
                  if 0 < masteryData.home_id then
                    param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.MasteryClassBubbleIcon[masteryData.home_id])
                  else
                    param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.MasteryClassBubbleIcon[MasteryHome.Gather])
                  end
                  param.modelHeight = 3
                  param.openMasteryMain = true
                elseif cardFunctionOpen and TacticalCardUtil.IsExistCardCachaRed() then
                  param.model = UIAssets.BuildStateIcon
                  isContinue = false
                  param.buildBubbleType = v
                  param.pos = data.pointId
                  param.tileX = buildTemplate.tileX
                  param.tileY = buildTemplate.tileY
                  param.callBack = self.OnClickCallBack
                  param.uuid = uuid
                  param.bgScale = self:GetBgScale(param)
                  param.iconScale = self:GetIconScale(param)
                  param.buildId = buildId
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.TacticalCardBubble)
                  param.modelHeight = 3
                  param.openTCCardCachaPanel = true
                elseif DataCenter.MasteryManager:HaveSkillCanUse() then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  isContinue = false
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.MasterySkill)
                  param.modelHeight = 3
                  param.useMasterySkill = true
                elseif masteryData ~= nil and masteryData.home_id == MasteryHome.None then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  isContinue = false
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.MasteryClassBubbleIcon[MasteryHome.Gather])
                  param.modelHeight = 3
                  param.openMasteryMain = true
                end
              end
            elseif v == BuildBubbleType.LWWorkerUp then
              local survivorPackMgr = DataCenter.SurvivorPackManager
              if survivorPackMgr and survivorPackMgr.GetTalentHallFreeBubbleIconPath ~= nil then
                local iconPath, iconScale = survivorPackMgr:GetTalentHallFreeBubbleIconPath()
                if not string.IsNullOrEmpty(iconPath) then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  isContinue = false
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                  param.iconName = iconPath
                  if iconScale ~= nil and tonumber(iconScale) ~= nil then
                    param.iconScale = Vector3.New(tonumber(iconScale), tonumber(iconScale), tonumber(iconScale))
                  end
                  param.modelHeight = 3
                  param.jumpType = 4
                end
              end
              if isContinue then
                local isShow = DataCenter.WorkerUpBuildBubbleDataManager:GetIsShowBubble()
                if isShow then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  isContinue = false
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                  param.iconName = string.format(LoadPath.ItemPath, BuildBubbleIconName.LWWorkerUp)
                  param.modelHeight = 3
                end
              end
              if isContinue and survivorPackMgr and survivorPackMgr.GetTalentHallPayBubbleIconPath ~= nil then
                local iconPath, iconScale = survivorPackMgr:GetTalentHallPayBubbleIconPath()
                if not string.IsNullOrEmpty(iconPath) then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  isContinue = false
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                  param.iconName = iconPath
                  if iconScale ~= nil and tonumber(iconScale) ~= nil then
                    param.iconScale = Vector3.New(tonumber(iconScale), tonumber(iconScale), tonumber(iconScale))
                  end
                  param.modelHeight = 3
                  param.jumpType = 4
                end
              end
            elseif v == BuildBubbleType.GetItem then
              if data.level > 0 then
                local showTime = DataCenter.BuildManager:GetShowItemBubbleTime(data.uuid)
                local now = UITimeManager:GetInstance():GetServerTime()
                if 0 < showTime then
                  if showTime >= now then
                    self:AddOneBubbleTimer(data.uuid, (showTime - now) / 1000, v)
                  else
                    self:RemoveOneBubbleTimer(data.uuid, v)
                    InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                    param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.GetItem)
                    param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                    isContinue = false
                    param.buildId = buildTemplate.id
                  end
                end
              end
            elseif v == BuildBubbleType.AllianceBattle then
              if DataCenter.AllianceWarDataManager:CheckIfHasNewWar() then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.AllianceBattle)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                isContinue = false
                param.buildId = buildTemplate.id
              end
            elseif v == BuildBubbleType.NoAlliance then
              if not LuaEntry.Player:IsInAlliance() and data.level >= 1 then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.NoAlliance)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                isContinue = false
                param.buildId = buildTemplate.id
              end
            elseif v == BuildBubbleType.HighFive then
              local state = false
              local player = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(LuaEntry.Player.uid, true)
              if player and 0 < player.joinAllianceThumbsUpCount - player.highFiveCount then
                state = true
              end
              if LuaEntry.Player:IsInAlliance() and state and data.level >= 1 then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.HighFive)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                isContinue = false
                param.buildId = buildTemplate.id
              end
            elseif v == BuildBubbleType.AllianceApply then
              if 0 < DataCenter.AllianceMemberDataManager:GetAllianceApplyRedCount() then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.AllianceApply)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                isContinue = false
                param.buildId = buildTemplate.id
              end
            elseif v == BuildBubbleType.BuildZeroUp then
              if CS.SceneManager:IsInCity() and data.level == 0 and data.state == BuildingStateType.Normal then
                local needItem = buildTemplate:GetNeedItem()
                if needItem ~= nil and needItem[1] ~= nil then
                  local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(needItem[1].itemId)
                  if itemTemplate ~= nil then
                    param.iconName = string.format(LoadPath.ItemPath, itemTemplate.icon)
                  end
                  local item = DataCenter.ItemData:GetItemById(needItem[1].itemId)
                  if item ~= nil and item.count >= needItem[1].num then
                    InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                    param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgSelect)
                    isContinue = false
                    param.buildId = buildTemplate.id
                  end
                end
              end
            elseif v == BuildBubbleType.Assistance then
              if self.assistedBuild[data.uuid] == true then
                isContinue = false
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.CommonNewPath, "Common_icon_march_assistance")
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                param.buildId = buildTemplate.id
              end
            elseif v == BuildBubbleType.HeroStationSkill then
              if DataCenter.HeroStationManager:Enabled() then
                local stationId = DataCenter.HeroStationManager:GetStationIdByBuildId(buildTemplate.id)
                if stationId ~= nil then
                  local skillId = DataCenter.HeroStationManager:GetStationFirstUsableSkillId(stationId)
                  if skillId ~= nil then
                    local icon = DataCenter.HeroStationManager:GetStationSkillBubbleIcon(skillId)
                    isContinue = false
                    InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                    param.iconName = icon
                    param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                    param.buildId = buildTemplate.id
                  end
                end
              end
            elseif v == BuildBubbleType.HeroStationAvailable then
              if data.level > 0 and DataCenter.HeroStationManager:Enabled() then
                local stationId = DataCenter.HeroStationManager:GetStationIdByBuildId(buildTemplate.id)
                if stationId ~= nil and DataCenter.HeroStationManager:HasAvailableHero(stationId) and DataCenter.HeroStationManager:HasAvailableSlot(stationId) then
                  isContinue = false
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.HeroStationAvailable)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                  param.buildId = buildTemplate.id
                end
              end
            elseif v == BuildBubbleType.KonbiniFree then
              if data.level > 0 then
                local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, data.level)
                local freeCount = toInt(tonumber(template.para2) + LuaEntry.Effect:GetGameEffect(EffectDefine.KONBINI_EXTRA_FREE_COUNT))
                local freeBuyCount = LuaEntry.Player:GetKonbiniFreeBuyCountToday()
                if freeCount > freeBuyCount then
                  isContinue = false
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.KonbiniFree)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                  param.buildId = buildTemplate.id
                end
              end
            elseif v == BuildBubbleType.WorldTrendStateRefresh then
              if DataCenter.WorldTrendManager:CheckOpen() and 4 <= DataCenter.BuildManager.MainLv then
                local redNum = DataCenter.WorldTrendManager:GetBuildIsBubble()
                if redNum then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  isContinue = false
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.WorldTrendStateRefresh)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgSelect)
                end
              end
            elseif v == BuildBubbleType.WormHoleSub then
              local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
              for _, march in pairs(selfMarch) do
                if march:GetMarchStatus() == MarchStatus.IN_WORM_HOLE or march:GetMarchTargetType() == MarchTargetType.GO_WORM_HOLE then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.model = UIAssets.BuildStateIcon4
                  param.iconName = string.format(LoadPath.UIBuildBubble, "UIworld_icon_trans")
                  param.bgName = string.format(LoadPath.UIBuildBubble, "UIworld_garbage_iconbg01")
                  isContinue = false
                  param.buildId = buildTemplate.id
                  param.startTime = march.startTime
                  param.endTime = march.endTime
                  break
                end
              end
            elseif v == BuildBubbleType.CrossWormHoleSub then
              local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
              for _, march in pairs(selfMarch) do
                if march:GetMarchStatus() == MarchStatus.CROSS_SERVER or march:GetMarchTargetType() == MarchTargetType.CROSS_SERVER_WORM then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.model = UIAssets.BuildStateIcon4
                  param.iconName = string.format(LoadPath.UIBuildBubble, "UIworld_icon_trans")
                  param.bgName = string.format(LoadPath.UIBuildBubble, "UIworld_garbage_iconbg01")
                  isContinue = false
                  param.buildId = buildTemplate.id
                  param.startTime = march.startTime
                  param.endTime = march.endTime
                  break
                end
              end
            elseif v == BuildBubbleType.WormHoleSubZero then
              local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.APS_BUILD_WORMHOLE_SUB)
              if 0 < #buildList and buildList[1].level == 0 and buildList[1].state ~= BuildingStateType.Upgrading then
                local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
                for _, march in pairs(selfMarch) do
                  if march:GetMarchTargetType() == MarchTargetType.BUILD_WORM_HOLE then
                    return nil
                  end
                end
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBtns, "uibuild_btn_xiujian")
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                isContinue = false
                param.buildId = buildTemplate.id
              end
            elseif v == BuildBubbleType.AllianceCareer then
              if DataCenter.AllianceCareerManager:IsCanSetCareer() and 0 < DataCenter.AllianceCareerManager:GetRedNum() then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.AllianceCareer)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                isContinue = false
              end
            elseif v == BuildBubbleType.InactivePlayer then
              if 0 < DataCenter.AllianceMemberDataManager:CheckIfNeedInactiveMemberBubble() then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.InactivePlayer)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                isContinue = false
              end
            elseif v == BuildBubbleType.AllianceCityDeclareWar then
              local isShow = DataCenter.AllianceDeclareWarManager:CheckIsShowBubble()
              if isShow then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.AllianceCityDeclareWar)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                isContinue = false
              end
            elseif v == BuildBubbleType.BuildingLv0Ruins then
              if data.level == 0 and buildState == BuildingStateType.Normal then
                local ret = DataCenter.BuildManager:CheckBuildUpgradeResAndItem(uuid)
                if ret.enough then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.model = UIAssets.BuildStateIcon2
                  isContinue = false
                  param.iconName = nil
                end
              end
            elseif v == BuildBubbleType.BuildHammer then
              if buildState == BuildingStateType.Normal and (buildId == BuildingTypes.FUN_BUILD_MAIN or 1 < DataCenter.BuildManager.MainLv or buildId ~= BuildingTypes.LW_BUILD_HOSPITL and buildId ~= BuildingTypes.LW_BUILD_WORKER_HOUSE and buildId ~= BuildingTypes.LW_BUILD_STEEL_MILL and buildId ~= BuildingTypes.LW_BUILD_ARMY_YARD and buildId ~= BuildingTypes.LW_BUILD_PARKINGLOT and buildId ~= BuildingTypes.LW_BUILD_BAKERY) then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BuildHammer)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgSelect)
                isContinue = false
              end
            elseif v == BuildBubbleType.BuildUpgradeReward then
              local isShow = DataCenter.BuildManager:CheckBuildIsReward(uuid)
              if isShow then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BuildUpgradeReward)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                isContinue = false
              end
            elseif v == BuildBubbleType.Talent then
              local show = DataCenter.TalentDataManager:HasTalentToChoose() and DataCenter.TalentDataManager:IsSystemOpen()
              if show then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Talent)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                isContinue = false
              end
            elseif v == BuildBubbleType.BuildingReplaceWorker then
              if data:IsMainBuilding() then
                local isNeedShowTaylorBubble = WorkerUtil.IsExistDispatchableTaylorWorker()
              end
              if not isNeedShowTaylorBubble then
                local isRedDot = data:CheckBuildingWorkerRedDot()
                if isRedDot and data.level > 0 then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = string.format(LoadPath.ItemPath, BuildBubbleIconName.ReplaceWorker)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                  isContinue = false
                end
              end
            elseif v == BuildBubbleType.EnergyOrder then
              if data.level > 0 then
                local show = DataCenter.EnergyOrderManager:GetShowBubbleByBuildUuid(uuid)
                if 0 < show then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.EnergyOrder)
                  param.bgName = string.format(LoadPath.UIBuildBubble, show == 1 and BuildBubbleIconName.BgUnSelect or BuildBubbleIconName.BgSelect)
                  isContinue = false
                end
              end
            elseif v == BuildBubbleType.OpenSeasonBountyShop then
            elseif v == BuildBubbleType.ProductLineNoHero then
              local state = DataCenter.ProductLineManager:GetState(uuid)
              if data.level > 0 and not data:IsUpgrading() and state == ProductLineState.NoHero then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = DataCenter.ProductLineManager:GetBubbleIcon(uuid)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                isContinue = false
              end
            elseif v == BuildBubbleType.ProductLineNormal then
              local state = DataCenter.ProductLineManager:GetState(uuid)
              local buildTemlate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(data.itemId, data.level)
              local now = UITimeManager:GetInstance():GetServerTime()
              local delayTime = buildTemlate.para2
              local curTime = 9999
              if data.productStartTime then
                curTime = (now - data.productStartTime) / 1000
              end
              local num = DataCenter.ProductLineManager:GetBuildProduceNum(uuid)
              if string.IsNullOrEmpty(delayTime) or curTime > tonumber(delayTime) or data.prodExtend > num * tonumber(delayTime) * 1000 / buildTemlate.produce_time then
                if data.level > 0 and state == ProductLineState.Normal and 0 < DataCenter.BuildManager.MainLv then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = DataCenter.ProductLineManager:GetBubbleIcon(uuid)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                  param.iconCircle = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1_1)
                  param.model = UIAssets.BuildStateIcon8
                  param.iconScale = DataCenter.ProductLineManager:GetBubbleScale(uuid)
                  isContinue = false
                  param.dontShake = true
                end
              else
                self:AddOneBubbleTimer(data.uuid, delayTime - curTime + 0.5, v)
              end
            elseif v == BuildBubbleType.ProductLineFull then
              local state = DataCenter.ProductLineManager:GetState(uuid)
              if data.level > 0 and state == ProductLineState.Full and 0 < DataCenter.BuildManager.MainLv then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = DataCenter.ProductLineManager:GetBubbleIcon(uuid)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                param.model = UIAssets.BuildStateIcon8
                param.iconScale = DataCenter.ProductLineManager:GetBubbleScale(uuid)
                isContinue = false
              end
            elseif v == BuildBubbleType.BuildingFunctioningFinish then
              local isTraining = BuildingUtils.IsBuildingFunctioning(data)
              local isFinishTraining = BuildingUtils.IsBuildingFinishFunctioning(data)
              if data.level > 0 and isTraining and isFinishTraining then
                local icon = ""
                local iconScale = SoldierIconScale
                if data.itemId == BuildingTypes.LW_BUILD_MILITARY_CAMP then
                  local soldierId = DataCenter.SoldierDataManager:GetSoldierIdByLevel(data.prodStatus)
                  local soldierTempalte = DataCenter.SoldierDataManager:GetTemplate(soldierId)
                  if T11Util.IsSuperSoldier(soldierTempalte.lv) then
                    icon = T11Util.GetSoldierBubblePath()
                  else
                    icon = string.format(LoadPath.UIMainBubble, soldierTempalte.bubble_icon)
                  end
                  iconScale = NewSoldierIconScale
                elseif data.itemId == BuildingTypes.LW_BUILD_SMITH_SHOP then
                  local equipId = data.prodStatus
                  icon = string.format(LoadPath.ItemPath, DataCenter.EquipTemplateManager:GetEquipIconById(equipId))
                  iconScale = SoldierIconScale
                elseif data.itemId == BuildingTypes.LW_BUILDING_TACTICAL_CHIP_FACTORY then
                  icon = string.format(LoadPath.ItemPath, BuildBubbleIconName.TacticalChipFactoryBubble)
                  iconScale = SoldierIconScale
                end
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = icon
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                param.model = UIAssets.BuildStateIcon6
                isContinue = false
                param.bgScale = SoldierBgScale
                param.iconScale = iconScale
              end
            elseif v == BuildBubbleType.BuildingNoWorker then
              local heroCount = data:GetAssignedHeroCount()
              if data.level > 0 and heroCount < 1 then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = DataCenter.ProductLineManager:GetBubbleIcon(uuid)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                isContinue = false
                param.bgScale = SoldierBgScale
                param.iconScale = SoldierIconScale
              end
            elseif v == BuildBubbleType.SmithShopCanCraftNewEquip then
              if data.level > 0 then
                local isCrafting = BuildingUtils.IsBuildingFunctioning(data)
                if not isCrafting then
                  local isFinishCrafting = BuildingUtils.IsBuildingFinishFunctioning(data)
                  if not isFinishCrafting then
                    local maxPowerEquip = DataCenter.EquipTemplateManager:GetCanCraftMaxPowerEquip(data.level)
                    local icon = ""
                    if maxPowerEquip == nil then
                      maxPowerEquip = DataCenter.EquipTemplateManager:GetTemplateBySlotTypeAndQualityAndHeroType(1, 0, 2)
                    end
                    if maxPowerEquip ~= nil then
                      icon = maxPowerEquip.icon
                    end
                    InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                    param.iconName = string.format(LoadPath.ItemPath, icon)
                    param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                    isContinue = false
                    param.bgScale = SoldierBgScale
                    param.iconScale = SoldierIconScale
                  end
                end
              end
            elseif v == BuildBubbleType.TacticalChipFactoryNormal then
              if data.level > 0 then
                local isCrafting = BuildingUtils.IsBuildingFunctioning(data)
                if not isCrafting then
                  local isFinishCrafting = BuildingUtils.IsBuildingFinishFunctioning(data)
                  if not isFinishCrafting then
                    InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                    param.iconName = string.format(LoadPath.ItemPath, BuildBubbleIconName.TacticalChipFactoryBubble)
                    param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                    isContinue = false
                    param.bgScale = SoldierBgScale
                    param.iconScale = SoldierIconScale
                  end
                end
              end
            elseif v == BuildBubbleType.BuildingNoFunctioning then
              local isTraining = data.productStartTime ~= nil
              if data.level > 0 and not isTraining then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.TrainArmy)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                isContinue = false
                param.bgScale = SoldierBgScale
                param.iconScale = SoldierIconScale
              end
            elseif v == BuildBubbleType.BuildingFunctioning then
              local isTraining = BuildingUtils.IsBuildingFunctioning(data)
              local isFinishTraining = BuildingUtils.IsBuildingFinishFunctioning(data)
              if data.level > 0 and isTraining and not isFinishTraining then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = "Assets/Main/Sprites/UI/LWCommon/Sprite/guaji_cfm_tubiao_2.png"
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                param.model = UIAssets.BuildStateIcon6
                isContinue = false
                param.bgScale = SoldierBgScale
                param.iconScale = Vector3.New(2.5, 2.5, 2.5)
              end
            elseif v == BuildBubbleType.BattleHangUpBattleJump then
              if DataCenter.StageManager.lastIdleRewardTimeStamp and not DataCenter.CityRebuildDataManager:CheckCanPopRebuildUI() then
                local curTime = UITimeManager:GetInstance():GetServerTime()
                local timeDelta = curTime - DataCenter.StageManager.lastIdleRewardTimeStamp
                local minTime = LuaEntry.DataConfig:TryGetNum("stage_idle_reward", "k3") * 60 * 1000
                if timeDelta < minTime then
                  local iconName = "dl_zhujiemian_qianfan_gongji"
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = string.format(LoadPath.UIBuildBubble, iconName)
                  param.bgName = string.format(LoadPath.UIBuildBubble, iconName)
                  param.model = UIAssets.BuildStateIcon10
                  param.endTime = 0
                  isContinue = false
                  param.bgScale = SoldierBgScale
                  param.iconScale = SoldierBgScale
                  param.dontShake = true
                end
              end
            elseif v == BuildBubbleType.BattleHangUp then
              if DataCenter.StageManager.lastIdleRewardTimeStamp and not DataCenter.CityRebuildDataManager:CheckCanPopRebuildUI() then
                local curTime = UITimeManager:GetInstance():GetServerTime()
                local timeDelta = curTime - DataCenter.StageManager.lastIdleRewardTimeStamp
                local minTime = LuaEntry.DataConfig:TryGetNum("stage_idle_reward", "k3") * 60 * 1000
                if timeDelta >= minTime and timeDelta < DataCenter.StageManager.hangUpMaxTime then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = "Assets/Main/Sprites/UI/LWCommon/Sprite/guaji_cfm_tubiao_3.png"
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                  param.model = UIAssets.BuildStateIcon6
                  isContinue = false
                  param.bgScale = SoldierBgScale
                  param.iconScale = Vector3.New(2, 2, 2)
                  param.dontShake = true
                end
              end
            elseif v == BuildBubbleType.BattleHangUpFinish and not DataCenter.CityRebuildDataManager:CheckCanPopRebuildUI() then
              if DataCenter.StageManager.lastIdleRewardTimeStamp then
                local curTime = UITimeManager:GetInstance():GetServerTime()
                local timeDelta = curTime - DataCenter.StageManager.lastIdleRewardTimeStamp
                if timeDelta >= DataCenter.StageManager.hangUpMaxTime then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = "Assets/Main/Sprites/UI/LWCommon/Sprite/guaji_cfm_tubiao_2.png"
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                  param.model = UIAssets.BuildStateIcon6
                  isContinue = false
                  param.bgScale = SoldierBgScale
                  param.iconScale = Vector3.New(2.5, 2.5, 2.5)
                end
              end
            elseif v == BuildBubbleType.RecruitHeroNew then
              if data.level >= 1 and DataCenter.LotteryDataManager:ShowBuildBubbleNew() then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = "Assets/Main/Sprites/UI/UILWNewsCenter/zyf_xinwen_new_icon"
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                isContinue = false
                param.bgScale = self:GetBgScale(param)
                param.iconScale = Vector3(3, 3, 1)
              end
            elseif v == BuildBubbleType.CanFreeRecruitHero then
              if data.level >= 1 then
                local lotteryData = DataCenter.LotteryDataManager:GetFreeRecruitLotteryData()
                if lotteryData ~= nil then
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.HeroFree)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                  isContinue = false
                  param.bgScale = SoldierBgScale
                  param.iconScale = SoldierIconScale
                else
                  local lotteryId = DataCenter.LotteryDataManager:GetClosestFreeRecruitLottery()
                  if lotteryId ~= nil then
                    local lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(lotteryId)
                    local now = UITimeManager:GetInstance():GetServerSeconds()
                    self:AddOneBubbleTimer(data.uuid, lotteryData.dailyFreeNextFreshTime - now + 1, v)
                  end
                  local count = DataCenter.ItemData:GetItemCount("230006")
                  if count and count >= 10 then
                    InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                    param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.HeroFree)
                    param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                    isContinue = false
                    param.bgScale = SoldierBgScale
                    param.iconScale = SoldierIconScale
                    param.dontShake = true
                  end
                end
              end
            elseif v == BuildBubbleType.UpgradeItem then
              if data.state ~= BuildingStateType.Upgrading or not data:IsUpgrading() then
                local upgrade_items = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.Building), data.itemId + data.level, "item")
                local entries = string.split(upgrade_items, "|")
                if entries ~= nil then
                  local entry = entries[1]
                  local itemId = tonumber(string.split(entry, ";")[1])
                  local needNum = tonumber(string.split(entry, ";")[2])
                  local item = DataCenter.ItemData:GetItemByItemId(itemId)
                  local num = item ~= nil and item.count or 0
                  param.itemId = itemId
                  param.needNum = needNum
                  if needNum <= num then
                    param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                  else
                    param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg5)
                    param.txtNum = num .. "/" .. needNum
                  end
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, itemId)
                  param.model = UIAssets.BuildBubbleUpgradeItem
                  isContinue = false
                  param.bgScale = Vector3(1, 1, 1)
                  param.iconScale = Vector3(1.5, 1.5, 1)
                  param.buildId = buildId
                  param.buildUuid = data.uuid
                end
              end
            elseif v == BuildBubbleType.FirstPayNotFixing then
              local isNewFirstPay = DataCenter.FirstPayManager:IsNewFirstPay()
              if not isNewFirstPay then
                local firstPayState = DataCenter.FirstPayManager:GetState()
                if firstPayState == FirstPayState.Unrepaired then
                  isContinue = false
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.FirstPay)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                  param.iconScale = Vector3.New(1, 1, 1)
                  param.bgScale = self:GetBgScale(param)
                end
              end
            elseif v == BuildBubbleType.FirstPayFixing then
              local isNewFirstPay = DataCenter.FirstPayManager:IsNewFirstPay()
              if not isNewFirstPay then
                local firstPayState = DataCenter.FirstPayManager:GetState()
                local fixEndTime = DataCenter.FirstPayManager:GetFixEndTime()
                local curTime = UITimeManager:GetInstance():GetServerTime()
                if firstPayState == FirstPayState.Repairing and fixEndTime > curTime then
                  isContinue = false
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.FirstPay)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                  param.model = UIAssets.FirstPayFixing
                  param.iconScale = Vector3.New(1, 1, 1)
                  param.bgScale = self:GetBgScale(param)
                  local fixEndTimeSec = fixEndTime / 1000
                  local curTimeSec = curTime / 1000
                  self:AddOneBubbleTimer(data.uuid, fixEndTimeSec - curTimeSec + 1, v)
                end
              end
            elseif v == BuildBubbleType.FirstPayFixed then
              local isNewFirstPay = DataCenter.FirstPayManager:IsNewFirstPay()
              if not isNewFirstPay then
                local firstPayState = DataCenter.FirstPayManager:GetState()
                local fixEndTime = DataCenter.FirstPayManager:GetFixEndTime()
                local curTime = UITimeManager:GetInstance():GetServerTime()
                if firstPayState == FirstPayState.Repairing and fixEndTime <= curTime then
                  isContinue = false
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.FirstPay)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                  param.iconScale = Vector3.New(1, 1, 1)
                end
              end
            elseif v == BuildBubbleType.MoFieHeroBubble then
              isContinue = false
              param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
              param.model = UIAssets.MoFieBuildIconBubble
              param.iconScale = Vector3.New(1, 1, 1)
              param.buildBubbleType = v
              param.pos = data.pointId
              param.tileX = buildTemplate.tileX
              param.tileY = buildTemplate.tileY
              param.callBack = self.OnClickCallBack
              param.uuid = uuid
              param.bgScale = self:GetBgScale(param)
              param.buildId = buildId
            elseif v == BuildBubbleType.NewFirstPay then
              local isNewFirstPay = DataCenter.FirstPayManager:IsNewFirstPay()
              if isNewFirstPay then
                local firstPayPack = DataCenter.FirstPayManager:GetFirstPayPack()
                if firstPayPack ~= nil then
                  isContinue = false
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.FirstPay)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                  param.iconScale = Vector3.New(1, 1, 1)
                end
              end
            elseif v == BuildBubbleType.CountBattleEntrance then
              local showCountBattleBubble = DataCenter.LWTrailTowerManager:CheckBubbleShowByTargetType(TrailTowerTabType.Common)
              local showTrailTowerBubble = DataCenter.LWTrailTowerManager:CheckBubbleShowByTargetType(TrailTowerTabType.TrailTower)
              local showStageFeatureChapterBubble = DataCenter.LWTrailTowerManager:CheckBubbleShowByTargetType(TrailTowerTabType.StageFeatureChapter)
              local showEasyStageFeatureChapterBubble = DataCenter.LWTrailTowerManager:CheckBubbleShowByTargetType(TrailTowerTabType.EasyStageFeatureChapter)
              local showStageFeatureIntegrateBubble = DataCenter.LWTrailTowerManager:CheckBubbleShowByTargetType(TrailTowerTabType.IntegratedStageFeatureChapter)
              if data.level > 0 and (showCountBattleBubble or showTrailTowerBubble or showStageFeatureChapterBubble or showEasyStageFeatureChapterBubble or showStageFeatureIntegrateBubble) then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                isContinue = false
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                local showIcon = BuildBubbleIconName.Beizengmen
                if DataCenter.LWTrailTowerManager:ShowAlertTowerEntrance() then
                  param.bgScale = TileBgScale4
                  param.iconScale = NewBeizengmenIconScale
                  showIcon = BuildBubbleIconName.NewBeizengmen
                end
                if showTrailTowerBubble then
                  showIcon = BuildBubbleIconName.TrailTowerBubble
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgSelect)
                  param.iconScale = self:GetIconScale(param)
                end
                param.iconName = string.format(LoadPath.UIBuildBubble, showIcon)
              end
            elseif v == BuildBubbleType.CivilizationSparkEntrance then
              InitParam(self, param, buildId, buildTemplate, data, v, uuid)
              isContinue = false
              param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
              local showIcon = BuildBubbleIconName.NewBeizengmen
              param.iconScale = NewBeizengmenIconScale
              param.iconName = string.format(LoadPath.UIBuildBubble, showIcon)
            elseif v == BuildBubbleType.CivilizationSparkLvUp then
              InitParam(self, param, buildId, buildTemplate, data, v, uuid)
              isContinue = false
              param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
              param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.ActivityAlarmClockBubbleIcon)
            elseif v == BuildBubbleType.AlertTowerEntrance then
              local showTrailTowerBubble = DataCenter.LWTrailTowerManager:ShowAlertTowerEntrance() and DataCenter.LWTrailTowerManager:GetTrailTowerShowBubbleData() and not DataCenter.T11IdleGameManager:IsT11IdleGameFunctionOn()
              if data.level > 0 and showTrailTowerBubble then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                isContinue = false
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgSelect)
                local showIcon = BuildBubbleIconName.TrailTowerBubble
                param.iconName = string.format(LoadPath.UIBuildBubble, showIcon)
              end
            elseif v == BuildBubbleType.CountBattleSoldiers then
              if data.level > 0 and data.productBase and 0 < data.productBase then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                isContinue = false
                if DataCenter.LWTrailTowerManager:ShowAlertTowerEntrance() then
                  param.bgScale = TileBgScale4
                end
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgSelect)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.TrainArmy)
              end
            elseif v == BuildBubbleType.CivilizationSparkSoldiers then
              if data.productBase and 0 < data.productBase then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                isContinue = false
                param.bgScale = TileBgScale4
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgSelect)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.TrainArmy)
              end
            elseif v == BuildBubbleType.SquadEquipChange then
              local canShow = DataCenter.TacticalWeaponManager:IsEquipFunctionUnlock()
              if data.level > 0 and canShow then
                local betterEquips = DataCenter.CommonEquipDataManager:IsHasBetterCommonEquip(CommonEquipType.SquadEquip, BuildingTypes.LW_BUILD_TACTICAL_CENTER)
                local showBubble = not table.IsNullOrEmpty(betterEquips)
                showBubble = showBubble or DataCenter.CommonEquipDataManager:IsCommonEquipCanUpgradeByOwner(CommonEquipType.SquadEquip, BuildingTypes.LW_BUILD_TACTICAL_CENTER)
                if showBubble then
                  isContinue = false
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.SquadEquip)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                  param.iconScale = Vector3.New(1, 1, 1)
                end
              end
            elseif v == BuildBubbleType.BuyScienceBuildGift then
              if data.level == 0 then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = "Assets/Main/Sprites/UI/UIBuildBubble/od_zhuchengqipao2nd.png"
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                isContinue = false
                param.bgScale = SoldierBgScale
                param.iconScale = Vector3.New(1, 1, 1)
                param.dontShake = false
              end
            elseif v == BuildBubbleType.PVPArena then
              if data.level > 0 then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.model = UIAssets.PVPArenaBubble
                isContinue = false
                param.iconScale = Vector3(1.2, 1.2, 1)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.PVPArena)
              end
            elseif v == BuildBubbleType.PVPArenaNew then
              if data.level > 0 then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.model = UIAssets.PVPArenaBubbleNew
                isContinue = false
                param.iconScale = Vector3(1.2, 1.2, 1)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                param.iconName = "Assets/Main/Sprites/UI/UILWNewsCenter/zyf_xinwen_new_icon"
              end
            elseif v == BuildBubbleType.ChampionDuel then
              if data.level > 0 then
                param.model = UIAssets.PVPArenaChampionDuelBubble
                isContinue = false
                param.buildBubbleType = v
                param.pos = data.pointId
                param.tileX = buildTemplate.tileX
                param.tileY = buildTemplate.tileY
                param.callBack = self.OnClickCallBack
                param.uuid = uuid
                param.buildId = buildId
                param.bgScale = self:GetBgScale(param)
                param.iconScale = Vector3(1, 1, 1)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                param.iconName = "Assets/Main/Sprites/UI/UIBuildBubble/lyt_zhujiemian_qipao_guanjunduijue"
              end
            elseif v == BuildBubbleType.QueueWorking then
              local queueData = DataCenter.BuildManager:GetBuildQueueByUuid(uuid)
              local iconScale = Vector3.New(1, 1, 1)
              if data.level > 0 and queueData and queueData:GetQueueState() == NewQueueState.Work then
                local iconName = "Assets/Main/Sprites/UI/LWCommon/Sprite/guaji_cfm_tubiao_2.png"
                if queueData.type == NewQueueType.Science then
                  local id = tonumber(queueData.itemId)
                  local level = 1
                  local science = DataCenter.ScienceDataManager:GetScienceById(id)
                  if science ~= nil then
                    level = science.level + 1
                  end
                  local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(id, level)
                  if template ~= nil then
                    iconName = string.format(LoadPath.UILWScience, template.icon)
                  end
                elseif queueData.type == NewQueueType.Hospital or queueData.type == NewQueueType.RebirthHospital then
                  iconScale = Vector3.New(2.5, 2.5, 2.5)
                end
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = iconName
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                param.model = UIAssets.BuildStateIcon6
                isContinue = false
                param.bgScale = SoldierBgScale
                param.iconScale = iconScale
                param.buildId = buildId
                param.queueData = queueData
              end
            elseif v == BuildBubbleType.WorldTrend then
              if data.level > 0 then
                param.iconName = "Assets/Main/Sprites/UI/UIBuildBubble/lrb_zhujiemian_qipao_tianxiadashi.png"
                local isEnd = DataCenter.LWWorldTrendDataManager:GetIsEndEvent()
                local isNotFirstClick = true
                if not isEnd then
                  local key = DataCenter.LWWorldTrendDataManager:GetCurEventDataKey()
                  if key then
                    isNotFirstClick = CommonUtil.PlayerPrefsGetBool(key, false)
                  end
                end
                local isAnyUnArchive = DataCenter.ComicManager:IsAnyUnArchiveComic()
                if isAnyUnArchive then
                  isNotFirstClick = false
                end
                local bubbleBg = isNotFirstClick and BuildBubbleIconName.Bubble_Bg1 or BuildBubbleIconName.Bubble_Bg2
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.bgName = string.format(LoadPath.UIBuildBubble, bubbleBg)
                param.model = UIAssets.BuildStateIcon6
                isContinue = false
                param.bgScale = SoldierBgScale
                param.iconScale = Vector3.New(1, 1, 1)
                param.buildId = buildId
              end
            elseif v == BuildBubbleType.HeroHonroLevelUpgrade then
              if not (data.level < LuaEntry.DataConfig:TryGetNum("honor_wall_unlock", "k1", 1)) then
                local heroType = BuildingTypeHero[data.itemId]
                local canUpgradeHero, heroUuid = HeroRedPointManager:HasHeroCanUpgradeHonorLevel(heroType)
                local heroData
                if canUpgradeHero then
                  heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
                end
                if heroData then
                  isContinue = false
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = HeroUtils.GetHeroIconPath(heroData.modelId, HeroIconType.small_icon, heroData:GetSkinId())
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                  param.iconScale = Vector3.New(1, 1, 1)
                  param.heroUuid = heroUuid
                  param.heroType = heroType
                end
              end
            elseif v == BuildBubbleType.SaveGirl then
              if DataCenter.LWSaveGirlManager:IsShowBubble() then
                param.iconName = "Assets/Main/Sprites/UI/UIBuildBtns/lrb_zhujiemian_chaidan.png"
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                param.model = UIAssets.BuildStateIcon_Savegirl
                isContinue = false
                param.buildBubbleType = v
                param.pos = data.pointId
                param.tileX = buildTemplate.tileX
                param.tileY = buildTemplate.tileY
                param.callBack = self.OnClickCallBack
                param.uuid = uuid
                param.bgScale = HammerBgScale
                param.iconScale = Vector3.New(1.2, 1.2, 1.2)
                param.buildId = buildId
              end
            elseif v == BuildBubbleType.TacticalWepaonUpgrade then
              if data.level > 0 then
                local showBubble = DataCenter.TacticalWeaponManager:ShowRedPoint()
                if showBubble then
                  isContinue = false
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.TacticalWeaponUpgrade)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                  param.iconScale = Vector3.New(1, 1, 1)
                end
              end
            elseif v == BuildBubbleType.TacticalWeaponBasic then
              if data.level > 0 then
                isContinue = false
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.TacticalWeaponUpgrade)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                param.iconScale = Vector3.New(1, 1, 1)
              end
            elseif v == BuildBubbleType.GiftPackage then
              local packId = buildTemplate.para1
              local packValid = GiftPackageData.checkPackIsValid(packId, true)
              if packValid then
                isContinue = false
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = buildTemplate.para2
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                param.iconScale = Vector3.New(1, 1, 1)
                param.buildBubbleType = v
                param.pos = data.pointId
                param.tileX = buildTemplate.tileX
                param.tileY = buildTemplate.tileY
                param.callBack = self.OnClickCallBack
                param.uuid = uuid
                param.bgScale = self:GetBgScale(param)
                param.buildId = buildId
              end
            elseif v == BuildBubbleType.TWSkillChipUnlockCountDown then
              local functionUnlocked = DataCenter.TWSkillChipManager:IsFunctionUnlock()
              if data.level > 0 and not functionUnlocked then
                local previewTime = DataCenter.TWSkillChipManager:GetChipPreviewTime()
                local unlockTime = DataCenter.TWSkillChipManager:GetChipOpenTime()
                local curTime = UITimeManager:GetInstance():GetServerSeconds()
                if previewTime <= curTime and unlockTime > curTime then
                  isContinue = false
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.TacticalWeaponUpgrade)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                  param.model = UIAssets.BuildStateIcon6
                  param.iconScale = Vector3.New(1, 1, 1)
                end
              end
            elseif v == BuildBubbleType.TWSkillChipCanUnlock then
              local functionUnlocked = DataCenter.TWSkillChipManager:IsFunctionUnlock()
              if data.level > 0 and not functionUnlocked then
                local previewTime = DataCenter.TWSkillChipManager:GetChipPreviewTime()
                local unlockTime = DataCenter.TWSkillChipManager:GetChipOpenTime()
                local curTime = UITimeManager:GetInstance():GetServerSeconds()
                if unlockTime < curTime then
                  isContinue = false
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.TacticalWeaponUpgrade)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                  param.iconScale = Vector3.New(1, 1, 1)
                end
              end
            elseif v == BuildBubbleType.DecoratorExhibition then
              if data.level > 0 and DataCenter.BuildManager:IsDecoratorHasRedDot() then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = "Assets/Main/Sprites/UI/UIBuildBtns/zyf_zhujiemian_qipao_tujian.png"
                local bubbleBg = BuildBubbleIconName.Bubble_Bg2
                param.bgName = string.format(LoadPath.UIBuildBubble, bubbleBg)
                param.model = UIAssets.BuildStateIcon6
                isContinue = false
                param.bgScale = SoldierBgScale
                param.iconScale = Vector3.New(1, 1, 1)
                param.buildId = buildId
              end
            elseif v == BuildBubbleType.TWSkillChip then
              local functionUnlocked = DataCenter.TWSkillChipManager:IsFunctionUnlock()
              if data.level > 0 and functionUnlocked and TacticalWeaponUtils.ChipBubbleShowRedPoint() then
                isContinue = false
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.TacticalWeaponUpgrade)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                param.iconScale = Vector3.New(1, 1, 1)
              end
            elseif v == BuildBubbleType.DispatchTask then
              local iconName = BuildBubbleIconName.DispatchTask
              local bg = BuildBubbleIconName.BgUnSelect
              InitParam(self, param, buildId, buildTemplate, data, v, uuid)
              param.iconScale = Vector3.New(1.8, 1.8, 1.8)
              local normalCount, rewardableCount = DataCenter.ActDispatchTaskDataManager:GetSingleTaskNormalCount()
              if 0 < rewardableCount then
                iconName = BuildBubbleIconName.GetItem
                bg = BuildBubbleIconName.BgSelect
                param.iconScale = Vector3.New(1.2, 1.2, 1.2)
              end
              param.iconName = string.format(LoadPath.UIBuildBubble, iconName)
              param.bgName = string.format(LoadPath.UIBuildBubble, bg)
              isContinue = false
              param.bgScale = TileBgScale2
              param.buildId = buildId
              if 0 < normalCount or 0 < rewardableCount then
                param.dontShake = false
              else
                param.dontShake = true
              end
            elseif v == BuildBubbleType.SeasonBuildingLv0Ruins then
              if data ~= nil and data.level == 0 then
                isContinue = false
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.buildBubbleType = BuildBubbleType.SeasonBuildingLv0Ruins
                param.iconName = "Assets/Main/Sprites/ItemIcons/cfm_zhujiemian_qipao_xiufu2.png"
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                param.iconScale = Vector3.New(1.6, 1.6, 1.6)
                param.dontShake = true
                param.txtNum = ""
              end
            elseif v == BuildBubbleType.SeasonWeekCard then
              local weekConfig = SeasonUtil.GetSeasonWeekCardConfig()
              if weekConfig == nil or string.IsNullOrEmpty(weekConfig.bubble_tips) then
                return nil
              end
              InitParam(self, param, buildId, buildTemplate, data, v, uuid)
              param.iconName = weekConfig.bubble_tips
              param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
              param.iconCircle = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1_1)
              param.model = UIAssets.BuildStateIcon8
              param.iconScale = Vector3.New(1.2, 1.2, 1.2)
              isContinue = false
              param.dontShake = true
            elseif v == BuildBubbleType.DecorationPlaySound then
              if DataCenter.DecorationBGMManager:IsPlayingBGMByBuildId(buildId) then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.model = UIAssets.DecorationPlaySoundBubble
                isContinue = false
                param.dontShake = true
              end
            elseif v == BuildBubbleType.RebirthHospitalFree then
              local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.RebirthHospital)
              if data.level > 0 and queue ~= nil and queue:GetQueueState() == NewQueueState.Free and DataCenter.RebirthHospitalManager:IsShowBuildingBubbleFree() then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.RebirthHospitalFree)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                isContinue = false
                param.uuid = queue.uuid
                param.buid = data.uuid
                param.itemId = queue.itemId
              end
            elseif v == BuildBubbleType.RebirthHospitalEnd then
              local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.RebirthHospital)
              if data.level > 0 and queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
                local template = DataCenter.RebirthHospitalManager:GetMaxLevelSoldierDataInRebirth()
                if template ~= nil then
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                  if T11Util.IsSuperSoldier(template.lv) then
                    param.iconName = T11Util.GetSoldierBubblePath()
                  else
                    param.iconName = string.format(LoadPath.UIMainBubble, template.bubble_icon)
                  end
                else
                  SFSNetwork.SendMessage(MsgDefines.QueueFinish, {
                    uuid = queue.uuid
                  })
                end
                isContinue = false
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.uuid = queue.uuid
                param.itemId = queue.itemId
                param.iconScale = NewSoldierIconScale
              end
            elseif v == BuildBubbleType.RebirthHospitalAllianceHelp then
              local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.RebirthHospital)
              if data.level > 0 and LuaEntry.Player:IsInAlliance() and queue ~= nil and queue:GetQueueState() == NewQueueState.Work and queue.isHelped == 0 then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.HospitalAllianceHelp)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                isContinue = false
                param.uuid = queue.uuid
                param.itemId = queue.itemId
              end
            elseif v == BuildBubbleType.BuildHeroCountdownReady then
              local curTime = math.floor(UITimeManager:GetInstance():GetServerTime())
              if data.fixCityHeroEndTime and curTime >= data.fixCityHeroEndTime then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.model = UIAssets.HeroEventFinishBubble
                isContinue = false
                param.bgScale = HammerBgScale
                param.iconScale = Vector3.New(1.2, 1.2, 1.2)
                param.buildId = buildId
                param.dontShake = false
              end
            elseif v == BuildBubbleType.BlackMarket then
              local canShow = 0 < DataCenter.ActBlackMarketDataManager:GetOpenActRemainRefreshCount()
              if canShow then
                isContinue = false
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BlackMarket)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                param.iconScale = Vector3.New(1, 1, 1)
              end
            elseif v == BuildBubbleType.PersonalFurnaceTip then
              if data.state == BuildingStateType.Normal then
                local furnaceState = DataCenter.BuildManager:GetFurnaceStateAndTemp()
                local temp = DataCenter.TemperatureManager:GetMyBaseTemperature()
                if furnaceState ~= HeatSourceState.Overload and temp < 0 then
                  isContinue = false
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.PersonalFurnaceTip)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                  param.iconScale = Vector3.New(1, 1, 1)
                end
              end
            elseif v == BuildBubbleType.ActivityAlarmClock then
              local todayShow = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.ActivityAlarmClockBubble)
              if todayShow then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.ActivityAlarmClockBubbleIcon)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                isContinue = false
              end
            elseif v == BuildBubbleType.BuildSeasonBigPhoto then
              InitParam(self, param, buildId, buildTemplate, data, v, uuid)
              isContinue = false
              param.iconName = string.format(LoadPath.UIBuildBubble, "ljq_zhujiemian_qipao_saijidahezhao.png")
              param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
              param.iconScale = Vector3.New(1, 1, 1)
              self:RemoveOneBubbleTimer(data.uuid, v)
              local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.SeasonPhoto.Type)
              if actList ~= nil and 0 < #actList then
                local now = UITimeManager:GetInstance():GetServerTime()
                local timerClose = actList[1].endTime - now
                if 0 < timerClose then
                  self:AddOneBubbleTimer(data.uuid, timerClose / 1000, v)
                end
              end
            elseif v == BuildBubbleType.BuildSeasonWorld then
              InitParam(self, param, buildId, buildTemplate, data, v, uuid)
              isContinue = false
              param.iconName = string.format(LoadPath.UIBuildBubble, "ljq_zhujiemian_qipao_diqiu.png")
              param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
              param.iconScale = Vector3.New(1, 1, 1)
              self:RemoveOneBubbleTimer(data.uuid, v)
              local now = UITimeManager:GetInstance():GetServerTime()
              local checkBubbleDelay = ((DataCenter.SeasonDataManager.nextSeasonStartTime or now + 1) - now) / 1000
              if 0 < checkBubbleDelay then
                self:AddOneBubbleTimer(data.uuid, checkBubbleDelay, v)
              end
            elseif v == BuildBubbleType.BuildSeasonLightHouse then
              local mgrPower = DataCenter.SeasonPowerWorkerManager
              isContinue = false
              InitParam(self, param, buildId, buildTemplate, data, v, uuid)
              param.model = "Assets/Main/SeasonRes/S4/Prefabs/UI/Component/BuildStateIcon.prefab"
              param.iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/UIBuildBubble/ljq_saijis4_daditu_qipaoa_03.png"
              param.bgName = ""
              param.iconScale = Vector3.New(3, 3, 3)
              param.dontShake = true
              param.txtNum = ""
              local lightHouseStatus = mgrPower.lightHouseStatus
              if lightHouseStatus == nil or lightHouseStatus.active ~= true then
                param.iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/UIBuildBubble/ljq_saijis4_daditu_qipaoa_01.png"
              else
                local powerNow, powerMax = mgrPower:GetBatteryPowerResourceInfo()
                local brightnessLevel = toInt(lightHouseStatus.brightnessLevel)
                if brightnessLevel == 0 then
                  if powerNow == powerMax then
                    param.iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/UIBuildBubble/ljq_saijis4_daditu_qipaoa_08.png"
                  elseif powerNow == 0 then
                    param.iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/UIBuildBubble/ljq_saijis4_daditu_qipaoa_02.png"
                  else
                    param.iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/UIBuildBubble/ljq_saijis4_daditu_qipaoa_03.png"
                  end
                elseif powerNow == powerMax then
                  param.txtNum = ""
                  param.iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/UIBuildBubble/ljq_saijis4_daditu_qipaoa_09.png"
                elseif brightnessLevel == 1 then
                  param.txtNum = "L1"
                  param.iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/UIBuildBubble/ljq_saijis4_daditu_qipaoa_04.png"
                elseif brightnessLevel == 2 then
                  param.txtNum = "L2"
                  param.iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/UIBuildBubble/ljq_saijis4_daditu_qipaoa_05.png"
                elseif brightnessLevel == 3 then
                  param.txtNum = "L3"
                  param.iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/UIBuildBubble/ljq_saijis4_daditu_qipaoa_06.png"
                elseif brightnessLevel == 4 then
                  param.txtNum = "L4"
                  param.iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/UIBuildBubble/ljq_saijis4_daditu_qipaoa_07.png"
                end
              end
              mgrPower:RegisterPowerStation(buildId, uuid)
            elseif v == BuildBubbleType.BuildSeasonPowerStation then
              local mgrPower = DataCenter.SeasonPowerWorkerManager
              local taskInfo = DataCenter.TaskManager:FindTaskInfo(buildTemplate.finish_quest)
              if taskInfo == nil then
                local dataList = mgrPower:GetPowerBuildInfo()
                taskInfo = dataList ~= nil and dataList[buildId] ~= nil and dataList[buildId].taskInfo or nil
              end
              mgrPower:RegisterPowerStation(buildId, uuid)
              if taskInfo ~= nil and taskInfo.state ~= TaskState.Received then
                isContinue = false
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                if taskInfo.state == TaskState.NoComplete then
                  param.iconName = "Assets/Main/Sprites/HeroIconsSmall/zyf_zombie_new16.png"
                else
                  param.iconName = "Assets/Main/Sprites/HeroIconsSmall/zyf_zombie_new16.png"
                end
                param.txtNum = ""
                param.model = UIAssets.BuildStateIcon8
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                param.iconCircle = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg3)
                param.iconScale = Vector3.New(1, 1, 1)
                param.dontShake = taskInfo.state ~= TaskState.CanReceive
                param.taskInfo = taskInfo
              elseif data.level > 0 then
                local formation = mgrPower:GetFormationByBuild(buildId)
                local worker = mgrPower:GetPowerWorkerByBuild(buildId)
                if (worker ~= nil or formation ~= nil) and not mgrPower:IsLightHouseActive() then
                  isContinue = false
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.buildBubbleType = BuildBubbleType.BuildSeasonLightHouse
                  param.model = "Assets/Main/SeasonRes/S4/Prefabs/UI/Component/BuildStateIcon.prefab"
                  param.bgName = ""
                  param.iconScale = Vector3.New(2.5, 2.5, 2.5)
                  param.dontShake = true
                  param.txtNum = ""
                  param.iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/UIBuildBubble/ljq_saijis4_daditu_qipaoa_01.png"
                  param.hasWorkerButNoActive = true
                else
                  return nil
                end
              elseif mgrPower:IsLightHouseActive() then
                local showGuidePop = buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1
                if buildId > BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1 then
                  local worker = mgrPower:GetPowerWorkerByBuild(buildId - 1000)
                  local formation = mgrPower:GetFormationByBuild(buildId - 1000)
                  if formation ~= nil or worker ~= nil then
                    showGuidePop = true
                  end
                end
                if showGuidePop then
                  isContinue = false
                  InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                  param.buildBubbleType = BuildBubbleType.BuildSeasonLightHouse
                  param.model = "Assets/Main/SeasonRes/S4/Prefabs/UI/Component/BuildStateIcon.prefab"
                  param.bgName = ""
                  param.iconScale = Vector3.New(2.5, 2.5, 2.5)
                  param.dontShake = true
                  param.txtNum = ""
                  param.iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/UIBuildBubble/ljq_saijis4_daditu_qipaoa_01.png"
                  param.gotoFixBuildUI = true
                else
                  return nil
                end
              else
                return nil
              end
            elseif v == BuildBubbleType.BuildMummyYard then
              if not SeasonUtil.IsInSeason(true) then
                return nil
              end
              InitParam(self, param, buildId, buildTemplate, data, v, uuid)
              local state = -1
              if data.level == 0 then
                state = 0
                param.iconScale = Vector3.New(1.2, 1.2, 1.2)
                param.dontShake = false
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.GetMummyBubble)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                local cfg = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, 1)
                local effectCondition = cfg.effectCondition
                if effectCondition and effectCondition.effectId then
                  local effectId = effectCondition.effectId
                  local effectValue = LuaEntry.Effect:GetGameEffect(effectId)
                  if effectValue == nil or effectValue == 0 then
                    local effectValue1 = DataCenter.LWSeasonTrendsManager:GetEffectValue(effectCondition.effectId)
                    if effectValue1 == nil or effectValue1 == 0 then
                      state = 1
                      param.dontShake = true
                      param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.GetMummyBubble)
                      param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                      param.iconScale = Vector3.New(1.2, 1.2, 1.2)
                    end
                  end
                end
              end
              if state == -1 then
                local count, maxArmy = DataCenter.SeasonMummyDataManager:GetArmyCount()
                if 0 < count and maxArmy then
                  state = 2
                  param.txtNum = count
                  param.dontShake = false
                  param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.GetMummyBubble)
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                  param.iconScale = Vector3.New(1, 1, 1)
                end
              end
              if state == -1 then
                state = 3
                param.dontShake = true
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.GetMummyBubble)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                param.iconScale = Vector3.New(1.18, 1.18, 1.18)
              end
              param.buildMummyBubbleState = state
              param.model = UIAssets.BuildStateIcon8
              isContinue = false
            elseif v == BuildBubbleType.DominatorMainEntrance then
              if 0 < DataCenter.DominatorManager:GetMainBuildingBubbleRedCount() and data.level > 0 then
                local bubbleIcon = DataCenter.DominatorManager:GetMainBuildingBubbleIconPath()
                isContinue = false
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = bubbleIcon
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                param.iconScale = Vector3.New(1.7, 1.7, 1.7)
              end
            elseif v == BuildBubbleType.T11Research then
              local t11Research = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_T11_Research)
              if t11Research and t11Research.level > 0 then
                isContinue = false
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.T11ResearchBuildBubbleIcon)
                local isShowRedDot = T11Util.IsShowRedDot4T11Building()
                if DataCenter.T11DataManager:GetCurT11UnlockState() == T11UnlockState.T11Unlockable and not T11Util.IfHasUnLockCamp() then
                  isShowRedDot = false
                end
                local iconBG = isShowRedDot and BuildBubbleIconName.Bubble_Bg2 or BuildBubbleIconName.BgUnSelect
                param.bgName = string.format(LoadPath.UIBuildBubble, iconBG)
                param.dontShake = not isShowRedDot
                param.iconScale = Vector3.New(2.5, 2.5, 2.5)
                param.model = UIAssets.BuildStateIcon6
                if T11Util.IsInResearchingState() then
                  local curBreakQueueData = T11Util.GetCurBreakQueueInfo()
                  if curBreakQueueData then
                    param.queueData = curBreakQueueData
                    param.dontShake = false
                    local unlockSkillData = T11Util.GetNextStageSkillData()
                    if unlockSkillData and not string.IsNullOrEmpty(unlockSkillData.icon) then
                      param.iconName = unlockSkillData.icon
                      param.iconScale = Vector3(1, 1, 1)
                    end
                  end
                end
              end
            elseif v == BuildBubbleType.RaceEntrance then
              local actType, bBig, _, endSec = RaceEntranceUtil.CheckCanShowTip(true)
              param.iconName = RaceEntranceUtil.GetBubbleIcon(actType, bBig)
              if 0 <= actType then
                param.actType = actType
                param.endTime = endSec
                if actType == 0 then
                  param.model = UIAssets.PVPArenaBubbleNew
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                  param.iconScale = Vector3(3, 3, 1)
                elseif bBig then
                  param.model = UIAssets.RaceEntranceBigBubble
                  param.bgName = "Assets/Main/Sprites/UI/UIRaceEntrance/mjc_zhujiemian_qipao_sshd.png"
                  if param.actType == EnumActivity.ActDsbDuel.Type then
                    param.bgName = "Assets/Main/Sprites/UI/UIRaceEntrance/lrb_zhujiemian_qipao_smdll.png"
                  end
                else
                  param.bgName = ""
                  param.model = UIAssets.RaceEntranceBubble
                  param.iconScale = Vector3(2.5, 2.5, 1)
                end
              else
                param.model = UIAssets.PVPArenaBubbleNew
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                param.iconScale = Vector3(0.9, 0.9, 1)
              end
              param.buildBubbleType = v
              param.pos = data.pointId
              isContinue = false
              param.tileX = buildTemplate.tileX
              param.tileY = buildTemplate.tileY
              param.callBack = self.OnClickCallBack
              param.uuid = uuid
              param.buildId = buildId
            elseif v == BuildBubbleType.T11IdleGame then
              if DataCenter.T11IdleGameManager:IsShowAlertTowerBubble() then
                isContinue = false
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = "Assets/Main/Sprites/UI/T11IdleGame/T11IdleGameGuide/wxy_t11guaji_qipao_icon"
                if DataCenter.T11IdleGameManager:IsAlertTowerBubbleShowRed() then
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                else
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                end
                param.iconScale = Vector3.New(1.7, 1.7, 1.7)
                param.modelHeight = 7
              end
            elseif v == BuildBubbleType.BuildingMainDetail then
              if WorkerUtil.IsExistDispatchableTaylorWorker() then
                isContinue = false
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.ItemPath, "wxy_xingcunzhe_paiqian_qipao")
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                param.iconScale = Vector3.New(1.7, 1.7, 1.7)
                param.modelHeight = 7
              end
            elseif v == BuildBubbleType.SeasonTower then
              if DataCenter.LWSeasonTowerManager:IsShowEntrance() then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                isContinue = false
                if DataCenter.LWSeasonTowerManager:IsAlertTowerBubbleShowRed() then
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                else
                  param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                end
                param.iconName = SeasonTowerConfig.EntranceIcon
                param.modelHeight = 7
              end
            elseif v == BuildBubbleType.BuildingMainPopupActivity then
              local activityList = DataCenter.LWPopupManager:GetPopupActivityList()
              if activityList and 0 < #activityList then
                isContinue = false
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, "lrb_hdgg_zhujiemian_qipao")
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg2)
                param.modelHeight = 7
                param.iconLocalPos = Vector3.New(0, 0, -0.11)
              end
            end
          end
        end
        if not isContinue then
          return param
        end
      end
    elseif buildState ~= BuildingStateType.FoldUp and data.destroyStartTime > 0 then
      local list = self:GetBuildBubbleTypeListByBuildType(data.itemId, buildTemplate, data.level, uuid)
      if list ~= nil and buildTemplate ~= nil then
        local isContinue = true
        local param = {}
        param.modelHeight = CS.SceneManager.World:GetBuildingHeight(data.pointId)
        for k, v in ipairs(list) do
          if isContinue then
            if v == BuildBubbleType.BuildFixFinishEnd then
              local now = UITimeManager:GetInstance():GetServerTime()
              if 0 < data.destroyEndTime and now >= data.destroyEndTime and data.state ~= BuildingStateType.FoldUp then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BuildFixFinishEnd)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgSelect)
                isContinue = false
                param.buildId = buildTemplate.id
              end
            elseif v == BuildBubbleType.FixBuildingAllianceHelp then
              local now = UITimeManager:GetInstance():GetServerTime()
              if LuaEntry.Player:IsInAlliance() and now < data.destroyEndTime and (data.isHelped == AllianceHelpState.No or data.isHelped == AllianceHelpState.UpgradeHelped) and data.level > 0 and data:IsUpgradeFinish() == false then
                InitParam(self, param, buildId, buildTemplate, data, v, uuid)
                param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.UpgradeAllianceHelp)
                param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
                isContinue = false
              end
            end
          end
        end
        if not isContinue then
          return param
        end
      end
    end
    if buildTemplate ~= nil then
      local taskInfo = DataCenter.TaskManager:FindTaskInfo(buildTemplate.quest_condition)
      if taskInfo == nil or taskInfo.state == TaskState.Received then
        local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, buildLevel)
        taskInfo = DataCenter.TaskManager:FindTaskInfo(buildLevelTemplate.quest_condition)
      end
      if taskInfo ~= nil and taskInfo.state ~= TaskState.Received then
        local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(taskInfo.id)
        if questTemplate == nil then
          return nil
        end
        local param = {}
        param.modelHeight = CS.SceneManager.World:GetBuildingHeight(data.pointId)
        InitParam(self, param, buildId, buildTemplate, data, BuildBubbleType.BuildNormalTaskBubble, uuid)
        param.iconName = questTemplate:GetIconPath()
        param.txtNum = ""
        param.model = UIAssets.BuildStateIcon8
        param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1)
        param.iconScale = Vector3.New(0.8, 0.8, 0.8)
        param.dontShake = taskInfo.state ~= TaskState.CanReceive
        param.taskInfo = taskInfo
        param.buildId = buildId
        param.buildLevel = buildLevel
        param.callBack = self.OnClickCallBack
        return param
      end
    end
  end
  return nil
end

local function DeleteOneBuildBubble(self, bUuid)
  if self.loadingBuildBubble[bUuid] ~= nil then
    if self.loadingBuildBubble[bUuid].request ~= nil then
      self.loadingBuildBubble[bUuid].request:Destroy()
    end
    self.loadingBuildBubble[bUuid] = nil
  end
  if self.allBuildBubble[bUuid] ~= nil then
    self:DeleteBuildBubbleChild(bUuid)
    self.allBuildBubble[bUuid]:ToFree()
    self.allBuildBubble[bUuid].gameObject:SetActive(false)
    local param = self.allBuildBubble[bUuid].param
    if self.cacheModel[param.buildBubbleType] == nil then
      self.cacheModel[param.buildBubbleType] = {}
    end
    table.insert(self.cacheModel[param.buildBubbleType], self.allBuildBubble[bUuid])
    self.allBuildBubble[bUuid] = nil
    self:DeleteGetResourceRefreshTimer()
  end
end

local function DeleteBuildBubbleChild(self, bUuid)
  if self.allBuildBubble[bUuid].list ~= nil then
    for i = 1, table.length(self.allBuildBubble[bUuid].list) do
      self.allBuildBubble[bUuid].list[i].request:Destroy()
      self.allBuildBubble[bUuid].list[i] = nil
    end
  end
  if self.allBuildBubble[bUuid].foodShouquFx ~= nil then
    self.allBuildBubble[bUuid].foodShouquFx:Destroy()
    self.allBuildBubble[bUuid].foodShouquFx = nil
  end
end

local function ShowOneBuildBubble(self, bUuid, param)
  if self.cacheModel[param.buildBubbleType] ~= nil then
    local buildBubbleTip = table.remove(self.cacheModel[param.buildBubbleType])
    if buildBubbleTip ~= nil and buildBubbleTip.param ~= nil and param ~= nil and buildBubbleTip.param.model ~= param.model then
      buildBubbleTip:OnDestroy()
      buildBubbleTip.request:Destroy()
      buildBubbleTip = nil
    end
    if buildBubbleTip ~= nil then
      buildBubbleTip.gameObject:SetActive(true)
      self.allBuildBubble[bUuid] = buildBubbleTip
      buildBubbleTip.transform:Set_localScale(0, ResetScale.y, ResetScale.z)
      self.allBuildBubble[bUuid]:ReInit(param)
      self:AddGetResourceRefreshTimer()
      return
    end
  end
  if self.loadingBuildBubble[bUuid] == nil or self.loadingBuildBubble[bUuid].model ~= param.model then
    if self.loadingBuildBubble[bUuid] ~= nil and self.loadingBuildBubble[bUuid].request ~= nil then
      self.loadingBuildBubble[bUuid].request:Destroy()
    end
    self.loadingBuildBubble[bUuid] = param
    local request = ResourceManager:InstantiateAsync(param.model)
    param.request = request
    request:completed("+", function()
      local buildParam = self.loadingBuildBubble[bUuid]
      self.loadingBuildBubble[bUuid] = nil
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(self:GetParentNode(param.buildBubbleType))
      request.gameObject.transform:Set_localScale(0, ResetScale.y, ResetScale.z)
      request.gameObject.name = "BuildBubble" .. bUuid
      local buildBubbleTip
      if buildParam.model == UIAssets.BuildResourceGetBubble then
        buildBubbleTip = BuildResourceGetBubble.New()
      else
        buildBubbleTip = BuildBubbleTip.New()
      end
      buildBubbleTip:OnCreate(request)
      self.allBuildBubble[bUuid] = buildBubbleTip
      self.allBuildBubble[bUuid]:ReInit(buildParam)
      self:AddGetResourceRefreshTimer()
      if buildParam ~= nil and buildParam.uuid ~= nil and SeasonUtil.IsMummyYardBuilding(buildParam.buildId) then
        BuildBubbleManager.ShowBuildMummyYardAnim(buildParam.uuid)
      end
      if buildParam.buildId == BuildingTypes.LW_BUILD_GATE then
        EventManager:GetInstance():Broadcast(EventId.GF_gate_building_bubble_create, buildParam)
      end
    end)
  else
    param.request = self.loadingBuildBubble[bUuid].request
    self.loadingBuildBubble[bUuid] = param
  end
end

local function UpdateBuildBubblePosition(self, data)
  if data:ContainsKey("bUuid") then
    local bUuid = data:GetLong("bUuid")
    if self.allBuildBubble[bUuid] ~= nil then
      self.allBuildBubble[bUuid]:UpdatePosition(data:GetInt("pos"))
    end
  end
end

local function CompareBuildType(buildBubbleType1, buildBubbleType2)
  local type1 = BuildBubbleTypeOrder[buildBubbleType1] or IntMaxValue
  local type2 = BuildBubbleTypeOrder[buildBubbleType2] or IntMaxValue
  return type1 < type2
end

local function OnHeroStationUpdateSignal()
  local stationIdList = DataCenter.HeroStationManager:GetStationIdList()
  if stationIdList == nil then
    return
  end
  for _, stationId in pairs(stationIdList) do
    local bUuid = DataCenter.HeroStationManager:GetBuildUuidByStationId(stationId)
    if bUuid ~= nil then
      DataCenter.BuildBubbleManager:CheckShowBubble(bUuid)
    end
  end
end

local function OnBuildTrainingStartSignal(data)
  local bUuid = 0
  if data:ContainsKey("bUuid") then
    bUuid = data:GetLong("bUuid")
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(bUuid)
end

local function OnBuildUpLevel(info)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(info.uuid)
  if buildData.itemId == BuildingTypes.FUN_BUILD_MAIN then
    if buildData.level >= 2 then
      local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY)
      if buildData then
        DataCenter.BuildBubbleManager:CheckShowBubble(buildData.uuid)
      end
    end
  elseif buildData.itemId == BuildingTypes.LW_BUILD_PUB then
    DataCenter.BuildBubbleManager:CheckShowBubble(buildData.uuid)
  elseif buildData.itemId == BuildingTypes.LW_BUILD_BATTLE_HANGUP_REWARD then
    DataCenter.BuildBubbleManager:CheckShowBubble(buildData.uuid)
  elseif buildData.itemId == BuildingTypes.LW_BUILD_FLAG then
    for uuid, buildData in pairs(DataCenter.BuildManager.allBuilding) do
      DataCenter.BuildBubbleManager:CheckShowBubble(uuid)
    end
  elseif buildData.itemId == BuildingTypes.LW_BUILD_ARMY_YARD then
  elseif buildData.itemId == BuildingTypes.LW_BUILD_PARKINGLOT then
  elseif buildData.itemId == BuildingTypes.LW_BUILD_MILITARY_CAMP then
  end
end

local function OnItemRefreshed(itemInfo)
  local buildings = DataCenter.BuildManager.buildIdBuilding[BuildingTypes.LW_BUILD_PUB]
  if buildings ~= nil and #buildings == 1 then
    DataCenter.BuildBubbleManager:CheckShowBubble(buildings[1].uuid)
  end
end

local function RefreshParkourBubble(itemId)
  if itemId == BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY then
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY)
    if buildData then
      DataCenter.BuildBubbleManager:CheckShowBubble(buildData.uuid)
    end
  end
end

local function OnUnlockArmy(buildId)
  local buildData = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
  if buildData ~= nil and table.count(buildData) > 0 then
    DataCenter.BuildBubbleManager:CheckShowBubble(buildData[1].uuid)
  end
end

local function OnScienceQueueResearchSignal(data)
  local bUuid = 0
  if data:ContainsKey("bUuid") then
    bUuid = data:GetLong("bUuid")
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(bUuid)
end

local function HospitalStartSignal(data)
  if data:ContainsKey("aboutBuilds") then
    local builds = data:GetSFSArray("aboutBuilds")
    if builds ~= nil then
      for i = 1, builds:Size() do
        local v = builds:GetSFSObject(i)
        if v ~= nil and v:ContainsKey("bUuid") then
          local bUuid = v:GetLong("bUuid")
          DataCenter.BuildBubbleManager:CheckShowBubble(bUuid)
        end
      end
    end
  end
end

local function BuildInViewSignal(data)
  local bUuid = tonumber(data)
  local param = DataCenter.BuildBubbleManager:GetBuildNeedShowBuildBubble(bUuid)
  if param == nil then
    DataCenter.BuildBubbleManager:DeleteOneBuildBubble(bUuid)
  elseif DataCenter.BuildBubbleManager.allBuildBubble[bUuid] ~= nil and param.model == DataCenter.BuildBubbleManager.allBuildBubble[bUuid].param.model then
    DataCenter.BuildBubbleManager.allBuildBubble[bUuid]:ReInit(param)
  else
    DataCenter.BuildBubbleManager:DeleteOneBuildBubble(bUuid)
    DataCenter.BuildBubbleManager:ShowOneBuildBubble(bUuid, param)
  end
end

local function BuildOutViewSignal(data)
  DataCenter.BuildBubbleManager:DeleteOneBuildBubble(tonumber(data))
end

local function QueueTimeEndSignal(data)
  DataCenter.BuildBubbleManager:RefreshBubbleByQueueType(data)
end

local function OnAllianceHelpCallBack(data)
  DataCenter.BuildBubbleManager:CheckShowBubble(tonumber(data))
end

local function OnAllianceFixHelpCallBack(data)
  DataCenter.BuildBubbleManager:CheckShowBubble(tonumber(data))
end

local function OnClickCallBack(param)
  DataCenter.LWSoundManager:PlaySound(80077, false)
  local guideParam = {}
  guideParam.buildBubbleType = param.buildBubbleType
  DataCenter.GuideManager:SetCompleteNeedParam(guideParam)
  DataCenter.GuideManager:CheckGuideComplete()
  if param.buildBubbleType == BuildBubbleType.ParkourBattle then
    local quest = DataCenter.GuideManager.questTemplate
    if quest ~= nil and (quest.para1 == 103 or quest.para1 == 104 or quest.para1 == 105 or quest.para1 == 106) then
      GoToUtil.GoLWParkourBattle(quest.para1)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMap, {anim = false}, nil)
    end
  elseif param.buildBubbleType == BuildBubbleType.BuildNormalTaskBubble then
    local theTaskInfo = param.taskInfo
    if theTaskInfo ~= nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, param.uuid)
    end
  elseif param.buildBubbleType == BuildBubbleType.TruckReady then
    RailwayUtil.OpenUITruckDeparture(param.uuid)
  elseif param.buildBubbleType == BuildBubbleType.TruckReward then
    local trainData = DataCenter.LWMyStationDataManager:GetMyTrainByBuildUuid(param.uuid)
    RailwayUtil.ApplyArriveReward(trainData)
  elseif param.buildBubbleType == BuildBubbleType.TruckTravelling then
    RailwayUtil.OpenUITrainList(TrainTab.Mine, param.uuid)
  elseif param.buildBubbleType == BuildBubbleType.TreasureChest then
    if param.treasureChestId and param.treasureChestId > 0 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITreasureChest, {anim = false}, param.treasureChestId, param.extendInfo)
    end
  elseif param.buildBubbleType == BuildBubbleType.SkyBattle then
    if param.levelId and 0 < param.levelId then
      local battleParam = {}
      battleParam.type = PVEType.SkyBattle
      battleParam.enterType = PVEEnterType.CityBuilding
      battleParam.levelId = param.levelId
      DataCenter.LWBattleManager:Enter(battleParam)
    end
  elseif param.buildBubbleType == BuildBubbleType.SkyBattleChapter then
    local skyBattleIsOpen = DataCenter.LWSkyBattleChapterManager:IsOpen()
    local skyBattleGrowthIsOpen = DataCenter.LWSkyBattleGrowthChapterManager:IsOpen()
    if skyBattleIsOpen or skyBattleGrowthIsOpen then
      local growthMode = false
      if skyBattleGrowthIsOpen then
        growthMode = true
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWStageSkyBattleChapter, {anim = true}, {growMode = growthMode})
    else
      UIUtil.ShowTipsId(Localization:GetString("undo_system_toast_failed_desc003"))
    end
    PostEventLog.Track(PostEventLog.Defines.BattleSkyBattleBubbleClick)
  elseif param.buildBubbleType == BuildBubbleType.TrainFirstReward then
    DataCenter.LWMyStationDataManager:TryCollectFirstReward()
  elseif param.buildBubbleType == BuildBubbleType.TrainCanRob then
    RailwayUtil.OpenUITrainList(TrainTab.Enemy)
  elseif param.buildBubbleType == BuildBubbleType.FireExtinguisher then
    if CoppaUtil.IsCoppaLimit() then
      return
    end
    if DataCenter.BuildHelpStopFireManager:IsOpen() then
      local str = string.format(Localization:GetString("outfire_tips_01", LuaEntry.DataConfig:TryGetNum("city_wall", "k9")))
      local costParam = {
        right = {
          iconPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_gold.png",
          text = "100"
        },
        left = {
          iconPath = nil,
          text = Localization:GetString("151084")
        }
      }
      UIUtil.ShowSecondMessage(Localization:GetString("801330"), str, 2, Localization:GetString("outfire_btn_02"), Localization:GetString("outfire_btn_01"), function()
        if LuaEntry.Player:IsInAlliance() == false then
          UIUtil.OnJoinAllianceBtnClick()
        else
          local pos = SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
          local t = {}
          t.roomId = ChatInterface.getAllianceRoomId()
          t.post = PostType.HELP_STOP_FIRE
          t.oname = LuaEntry.Player:GetFullName()
          t.sid = LuaEntry.Player:GetSelfServerId()
          t.worldId = 0
          t.x = pos.x
          t.y = pos.y
          SFSNetwork.SendMessage(MsgDefines.RequestHelpStopCityFire, t)
          PostEventLog.Track(PostEventLog.Defines.SendHelpStopFire, {})
          DataCenter.AllianceBaseDataManager:OpenAllinceChatRoom()
        end
      end, nil, function()
        SFSNetwork.SendMessage(MsgDefines.StopCityFire)
      end, nil, nil, nil, true, nil, nil, false, costParam)
    else
      local str = string.format(Localization:GetString("801143", LuaEntry.DataConfig:TryGetNum("city_wall", "k9")))
      UIUtil.ShowSecondMessage(Localization:GetString("801330"), str, 2, "", "", function()
        SFSNetwork.SendMessage(MsgDefines.StopCityFire)
      end, nil, nil, nil, nil, nil, nil, nil, nil, false)
    end
  elseif param.buildBubbleType == BuildBubbleType.FootSoldierFree then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITrain, BuildingTypes.FUN_BUILD_INFANTRY_BARRACK)
  elseif param.buildBubbleType == BuildBubbleType.CarSoldierFree then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITrain, BuildingTypes.FUN_BUILD_CAR_BARRACK)
  elseif param.buildBubbleType == BuildBubbleType.BowSoldierFree then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITrain, BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK)
  elseif param.buildBubbleType == BuildBubbleType.HospitalFree then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIHospital, param.buid)
  elseif param.buildBubbleType == BuildBubbleType.HospitalEnd then
    DataCenter.HospitalManager:CheckSendFinish(param.bUuid)
  elseif param.buildBubbleType == BuildBubbleType.StorageShopMoney then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIStorageShopMain, nil, 1)
  elseif param.buildBubbleType == BuildBubbleType.StorageShopGolloes then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIStorageShopMain, nil, 1)
  elseif param.buildBubbleType == BuildBubbleType.ScienceFree then
    GoToUtil.GotoScience(nil, nil, param.bUuid)
  elseif param.buildBubbleType == BuildBubbleType.ScienceEnd then
    DataCenter.ScienceManager:CheckResearchFinishByBuildUuid(param.bUuid)
    local v3 = SceneUtils.TileIndexToWorld(param.pos)
    v3.x = v3.x - 1
    v3.y = v3.y
    v3.z = v3.z + param.modelHeight - 1
    local pos = CS.SceneManager.World:WorldToScreenPoint(v3)
    DataCenter.PlayerLevelManager:FlyExp(ExpSource.Science, pos, param.exp)
  elseif param.buildBubbleType == BuildBubbleType.AllianceHelp then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Alliance)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    DataCenter.AllianceHelpDataManager:SetHelpNum(0)
    local v3 = SceneUtils.TileIndexToWorld(param.pos)
    v3.x = v3.x - 1
    v3.y = v3.y
    v3.z = v3.z + param.modelHeight - 1
    local pos = CS.SceneManager.World:WorldToScreenPoint(v3)
    SFSNetwork.SendMessage(MsgDefines.AlHelpAll, math.floor(curTime), pos)
  elseif param.buildBubbleType == BuildBubbleType.AllianceTask then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceMainTable)
  elseif param.buildBubbleType == BuildBubbleType.AllianceGift then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceGift, {anim = true})
  elseif param.buildBubbleType == BuildBubbleType.CommonShopFree then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop)
  elseif param.buildBubbleType == BuildBubbleType.UpgradeAllianceHelp then
    SFSNetwork.SendMessage(MsgDefines.AllianceCallHelp, param.uuid, AllianceHelpType.Building, NewQueueType.Default, "")
  elseif param.buildBubbleType == BuildBubbleType.FixBuildingAllianceHelp then
    SFSNetwork.SendMessage(MsgDefines.AllianceCallHelp, param.uuid, AllianceHelpType.FIX_BUILDING, NewQueueType.Default, "")
  elseif param.buildBubbleType == BuildBubbleType.ScienceAllianceHelp then
    SFSNetwork.SendMessage(MsgDefines.AllianceCallHelp, param.uuid, AllianceHelpType.Queue, NewQueueType.Science, param.itemId)
  elseif param.buildBubbleType == BuildBubbleType.HospitalAllianceHelp then
    SFSNetwork.SendMessage(MsgDefines.AllianceCallHelp, param.uuid, AllianceHelpType.Queue, NewQueueType.Hospital, param.itemId)
  elseif param.buildBubbleType == BuildBubbleType.ResidentOrder then
    UIUtil.CheckAndOpenBusinessCenter()
  elseif param.buildBubbleType == BuildBubbleType.MakingCoffee then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWMakingCoffeeView, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif param.buildBubbleType == BuildBubbleType.SeasonEatFish then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFishEat, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif param.buildBubbleType == BuildBubbleType.CoffeeCanUnlocked then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWMakingCoffeeView, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif param.buildBubbleType == BuildBubbleType.HeroBountyFinish or param.buildBubbleType == BuildBubbleType.HeroBountyFree then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroBountyMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif param.buildBubbleType == BuildBubbleType.EarthOrder then
    local recall = DataCenter.EarthOrderDataManager:checkIsRecall()
    if recall == true then
      DataCenter.EarthOrderDataManager:SendGetEarthOrder()
    elseif LuaEntry.Effect:GetGameEffect(EffectDefine.EARTH_ORDER_UNLOCK) == 1 then
      if BuildingUtils.IsRocketPlayingArrive(param.pos) == true then
        UIUtil.ShowTipsId(GameDialogDefine.PLEASE_WAIT_ROCKET_STOP)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIEarthOrder, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        }, param.uuid)
      end
    end
  elseif param.buildBubbleType == BuildBubbleType.GroceryStore then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGroceryStore)
  elseif param.buildBubbleType == BuildBubbleType.ExtendDome then
    local pos = SceneUtils.TileIndexToWorld(param.pos)
    CS.SceneManager.World:AutoFocus(pos + Vector3.New(-1, 0, -1), CS.LookAtFocusState.Dome, 1, function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDomeUpdate, param.uuid)
    end)
  elseif param.buildBubbleType == BuildBubbleType.PastureProduct then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(param.uuid)
    if buildData ~= nil and DataCenter.RecommendShowManager:IsCanClickBuild(buildData.itemId, buildData) then
      local pos = SceneUtils.TileIndexToWorld(param.pos)
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPasture)
      local onComplete
      
      function onComplete()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIPasture, {
          anim = true,
          playEffect = false,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide
        }, param.uuid)
      end
      
      CS.SceneManager.World:AutoFocus(pos, CS.LookAtFocusState.FarmPlant, LookAtFocusTime, false, true, onComplete)
    end
  elseif param.buildBubbleType == BuildBubbleType.GetFoodProduct then
    local factoryTemplate = DataCenter.FactoryDataManager:GetFactoryTemplate(param.factoryId)
    local num = factoryTemplate:GetProductResourceItemNum()
    if 0 < num and DataCenter.ResourceItemDataManager:CheckIsStorageFull(num) then
      if DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ResourceItemFull, tostring(BuildingTypes.FUN_BUILD_COLD_STORAGE)) then
        DataCenter.GuideManager:SetGuideEndCallBack(function()
          GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
        end)
      else
        GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
      end
    else
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Product3)
      SFSNetwork.SendMessage(MsgDefines.GatherProduct, param.uuid, {0})
      local products = factoryTemplate.productList
      table.walk(products, function(_, v)
        local rewardType = DataCenter.FactoryDataManager:FactoryProductTypeToRewardType(v.type, v.itemId)
        local pos = CS.SceneManager.World:WorldToScreenPoint(DataCenter.BuildBubbleManager:GetBubblePosition(param.uuid))
        local pic = DataCenter.FactoryDataManager:GetProductShowIcon(v)
        local str = tostring(param.uuid) .. ";" .. tostring(v.itemId)
        UIUtil.DoFly(tonumber(rewardType), v.num, pic, pos, Vector3.New(0, 0, 0), nil, nil, nil, true)
        EventManager:GetInstance():Broadcast(EventId.ShowCapacity, str)
      end)
    end
  elseif param.buildBubbleType == BuildBubbleType.GetResource then
    DataCenter.BuildManager:ShowGetNewResourceEffect(param)
  elseif param.buildBubbleType == BuildBubbleType.NoGetResource then
    local tempBuild = DataCenter.BuildManager:GetBuildingDataByUuid(param.uuid)
    if tempBuild ~= nil then
      if tempBuild.state == BuildingStateType.Normal and DataCenter.BuildManager:IsHaveResource(param.uuid) then
        local worldPos = SceneUtils.TileIndexToWorld(tempBuild.pointId)
        local pos = CS.SceneManager.World:WorldToScreenPoint(worldPos)
        DataCenter.FlyResourceEffectManager:ShowGetResourceEffect(pos, param.resourceType, FlyMoneyCount)
        DataCenter.DecResourceEffectManager:DecOneItemEffect(worldPos + FlyGetResourceDelta, DataCenter.ResourceManager:GetResourceIconByType(param.resourceType), DataCenter.BuildManager:GetOutResourceNum(param.uuid), param.uuid)
      end
      SFSNetwork.SendMessage(MsgDefines.UserResSynNew, {
        resourceType = param.resourceType
      })
    end
    SFSNetwork.SendMessage(MsgDefines.FreeBuildingFoldUpNew, {
      buildUuid = param.uuid
    })
  elseif param.buildBubbleType == BuildBubbleType.NeedTransport then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITransportRes, param.uuid)
  elseif param.buildBubbleType == BuildBubbleType.HeroAdvance then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroAdvance, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif param.buildBubbleType == BuildBubbleType.HeroRecruit then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroQualityRecruit, true)
  elseif param.buildBubbleType == BuildBubbleType.HeroRecruitOther then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroQualityRecruit, true)
  elseif param.buildBubbleType == BuildBubbleType.MoFieHeroBubble then
    local lotteryId = DataCenter.LotteryDataManager:GetBuildBubbleGotoLotteryId()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit, {anim = true}, false, false, lotteryId)
  elseif param.buildBubbleType == BuildBubbleType.PubFreeItem then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroResetShop, true)
  elseif param.buildBubbleType == BuildBubbleType.GetItem then
    DataCenter.BuildGetItemAfterShowTalkManager:AddOneWillShowTalkUuid(param.uuid)
    SFSNetwork.SendMessage(MsgDefines.ReceiveBuildingGrowValReward, {
      uuid = param.uuid
    })
  elseif param.buildBubbleType == BuildBubbleType.MysteryTreasureChest then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(param.uuid)
    if buildData ~= nil then
      local temp = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(tonumber(buildData.specialStageId))
      if #temp.winType == 1 then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIMysteryTreasureChest, param.uuid)
      end
    end
  elseif param.buildBubbleType == BuildBubbleType.DigGame then
    DataCenter.BuildingDigTreasureManager:OpenGameWindowByBuildingUuid(param.uuid)
  elseif param.buildBubbleType == BuildBubbleType.SuppliesSearch then
    DataCenter.SuppliesSearchManager:OpenSuppliesSearchWindow(SuppliesSearchType.Monopoly, param.uuid)
  elseif param.buildBubbleType == BuildBubbleType.DetectEvent then
    UIUtil.OpenDetectEventView()
  elseif param.buildBubbleType == BuildBubbleType.DetectEventFinished then
    if not UIUtil.CheckDetectCanCrossServer() and CrossServerUtil:NeedIntercept(500019) then
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif param.buildBubbleType == BuildBubbleType.LWMastery then
    local isMasteryOpen = DataCenter.MasteryManager:Enabled()
    if isMasteryOpen then
      if param.openMasteryMain then
        UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMastery, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        })
      elseif param.useMasterySkill then
        UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasterySkillUse, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        })
      elseif param.openTCCardPanel then
        TacticalCardUtil.OpenTacticalCardMain()
      elseif param.openTCCardCachaPanel then
        TacticalCardUtil.OpenCardBox()
      end
    end
  elseif param.buildBubbleType == BuildBubbleType.LWWorkerUp then
    local jumpData = {}
    if param.jumpType ~= nil then
      jumpData.jumpType = param.jumpType
    end
    if param.jumpParam ~= nil then
      jumpData.jumpParam = param.jumpParam
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorkerOverviewList, {anim = true}, jumpData)
  elseif param.buildBubbleType == BuildBubbleType.BuildFixFinishEnd then
    DataCenter.BuildManager:CheckSendFixBuildFinish(param.uuid)
  elseif param.buildBubbleType == BuildBubbleType.GolloesGift then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISubscriptionListPanel, {anim = true})
    DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.ShowSubscriptionBubble, false)
    DataCenter.BuildBubbleManager:CheckShowBubble(param.uuid)
  elseif param.buildBubbleType == BuildBubbleType.DecorationShop then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true}, CommonShopType.DecorationShop)
  elseif param.buildBubbleType == BuildBubbleType.GiftVoucher then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true}, CommonShopType.GiftVoucher)
  elseif param.buildBubbleType == BuildBubbleType.GolloesMonthCard then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.MonthCard)
  elseif param.buildBubbleType == BuildBubbleType.ParkingLotState then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(param.uuid)
    local formationIndex = DataCenter.ArmyFormationDataManager:GetFormationIndexByBuildingType(buildData.itemId)
    local Player = LuaEntry.Player
    local armyInfo = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByIndex(formationIndex)
    local march
    if armyInfo then
      march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(Player.uid, armyInfo.uuid, Player.allianceId)
    end
    if formationIndex > 0 then
      if buildData.level == 0 then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, param.buildUuid)
      elseif march ~= nil then
        local marchInfo = march
        TimerManager:GetInstance():DelayInvoke(function()
          GoToUtil.GotoMarchCurPos(marchInfo, nil, function()
            CS.SceneManager.World:TrackMarch(marchInfo.uuid)
            WorldMarchTileUIManager:GetInstance():ShowTroop(marchInfo.uuid)
          end)
        end, 0.1)
      end
    end
  elseif param.buildBubbleType == BuildBubbleType.AllianceBattle then
    DataCenter.AllianceWarDataManager:OpenALWarMain()
  elseif param.buildBubbleType == BuildBubbleType.NoAlliance then
    if LuaEntry.Player:IsFirstJoinAlliance() == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
      return
    end
    local params = {guide = false}
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
  elseif param.buildBubbleType == BuildBubbleType.HighFive then
    DataCenter.PlayerInfoDataManager:RequestHighFiveInfo()
  elseif param.buildBubbleType == BuildBubbleType.AllianceApply then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceMainTable, {anim = true}, nil, 3)
  elseif param.buildBubbleType == BuildBubbleType.BuildZeroUp then
    if DataCenter.BuildManager:IsCanUpgradeZeroBuild(param.uuid) then
      if param.buildId == BuildingTypes.FUN_BUILD_MAIN then
        DataCenter.BuildZeroUpgradeEffectManager:ShowCancelEffect()
      else
        local paramUpgrade = {}
        paramUpgrade.uuid = param.uuid
        SFSNetwork.SendMessage(MsgDefines.BuildCityBuilding, paramUpgrade)
      end
    else
      UIUtil.ShowTipsId(GameDialogDefine.NO_ITEM)
    end
  elseif param.buildBubbleType == BuildBubbleType.Assistance then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, param.uuid, LuaEntry.Player.uid, param.pos, AssistanceType.MainCity)
  elseif param.buildBubbleType == BuildBubbleType.HeroStationSkill then
    local stationId = DataCenter.HeroStationManager:GetStationIdByBuildId(param.buildId)
    DataCenter.HeroStationManager:UseStationSkill(stationId)
  elseif param.buildBubbleType == BuildBubbleType.HeroStationAvailable then
    UIUtil.OpenHeroStationByBuildUuid(param.uuid)
  elseif param.buildBubbleType == BuildBubbleType.StorageShopFirstOpen then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIStorageShopMain, nil, 1)
  elseif param.buildBubbleType == BuildBubbleType.KonbiniFree then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIKonbini, param.uuid)
  elseif param.buildBubbleType == BuildBubbleType.HeroFreeScienceAddTime then
    SFSNetwork.SendMessage(MsgDefines.QueueCcdMNew, {
      qUUID = param.queueUuid,
      itemIDs = "",
      isGold = IsGold.NoUseGold
    })
    local heroData = DataCenter.HeroDataManager:GetFreeAddTimeHero(EffectDefine.RESEARCH_TIME_REDUCE)
    local freeTime = Mathf.Ceil(LuaEntry.Effect:GetGameEffect(EffectDefine.RESEARCH_TIME_REDUCE) / 60)
    local time = freeTime .. Localization:GetString("100165")
    if heroData then
      local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroData.heroId)
      local name = Localization:GetString(heroConfig.name)
      local str = Localization:GetString("110201", name, time, Localization:GetString("100025"))
      TimerManager:GetInstance():DelayInvoke(function()
        UIUtil.ShowTips(str, nil, nil, heroData)
      end, 1)
    else
      local name = Localization:GetString(GetTableData(TableName.Robot, param.robotId, "name"))
      local str = Localization:GetString("110201", name, time, Localization:GetString("100025"))
      TimerManager:GetInstance():DelayInvoke(function()
        UIUtil.ShowTips(str, nil, nil)
      end, 1)
    end
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Speed_Button2)
  elseif param.buildBubbleType == BuildBubbleType.HeroFreeBuildAddTime then
    SFSNetwork.SendMessage(MsgDefines.BuildCcdMNew, {
      bUUID = param.uuid,
      itemIDs = "",
      isFixRuins = false
    })
    local heroData = DataCenter.HeroDataManager:GetFreeAddTimeHero(EffectDefine.BUILD_TIME_REDUCE)
    local freeTime = Mathf.Ceil(LuaEntry.Effect:GetGameEffect(EffectDefine.BUILD_TIME_REDUCE) / 60)
    local time = freeTime .. Localization:GetString("100165")
    if heroData then
      local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroData.heroId)
      local name = Localization:GetString(heroConfig.name)
      local str = Localization:GetString("110201", name, time, Localization:GetString("310148"))
      TimerManager:GetInstance():DelayInvoke(function()
        UIUtil.ShowTips(str, nil, nil, heroData)
      end, 1)
    else
      local name = Localization:GetString(GetTableData(TableName.Robot, param.robotId, "name"))
      local str = Localization:GetString("110201", name, time, Localization:GetString("310148"))
      TimerManager:GetInstance():DelayInvoke(function()
      end, 1)
      UIUtil.ShowTips(str, nil, nil)
    end
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Speed_Button2)
  elseif param.buildBubbleType == BuildBubbleType.WorldTrendStateRefresh then
    DataCenter.WorldTrendManager:RequestWorldTrendServerData()
  elseif param.buildBubbleType == BuildBubbleType.AllianceCareer then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceMainTable)
  elseif param.buildBubbleType == BuildBubbleType.InactivePlayer then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceMainTable, {anim = true}, nil, 2)
    DataCenter.BuildBubbleManager:UpdateAllianceSignal()
  elseif param.buildBubbleType == BuildBubbleType.AllianceCityDeclareWar then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCity)
    DataCenter.BuildBubbleManager:UpdateAllianceSignal()
  elseif param.buildBubbleType == BuildBubbleType.WormHoleSub or param.buildBubbleType == BuildBubbleType.CrossWormHoleSub then
  elseif param.buildBubbleType == BuildBubbleType.WormHoleSubZero then
    MarchUtil.OnClickStartMarch(MarchTargetType.BUILD_WORM_HOLE, param.pos, param.uuid)
  elseif param.buildBubbleType == BuildBubbleType.BuildingLv0Ruins then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, param.uuid)
  elseif param.buildBubbleType == BuildBubbleType.BuildCanUpgrade then
    WorldArrowManager:GetInstance():RemoveEffect()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, param.uuid)
  elseif param.buildBubbleType == BuildBubbleType.BuildUpgradeReward then
    DataCenter.BuildManager:ClickBubbleUpgradeReward(param.uuid)
  elseif param.buildBubbleType == BuildBubbleType.Talent then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITalentChoose, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif param.buildBubbleType == BuildBubbleType.FootSoldierUnlock then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITrain, BuildingTypes.FUN_BUILD_INFANTRY_BARRACK)
  elseif param.buildBubbleType == BuildBubbleType.CarSoldierUnlock then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITrain, BuildingTypes.FUN_BUILD_CAR_BARRACK)
  elseif param.buildBubbleType == BuildBubbleType.BowSoldierUnlock then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITrain, BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK)
  elseif param.buildBubbleType == BuildBubbleType.EnergyOrder then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIEnergyOrder, param.uuid)
  elseif param.buildBubbleType == BuildBubbleType.BuildingReplaceWorker then
    DataCenter.ProductLineManager:OnNoHeroBubbleClick(param.uuid)
  elseif param.buildBubbleType == BuildBubbleType.OpenSeasonBountyShop then
    SeasonUtil.OpenSeasonActivityByType(EnumActivity.SeasonBountyShop.Type)
  elseif param.buildBubbleType == BuildBubbleType.ProductLineNormal or param.buildBubbleType == BuildBubbleType.ProductLineFull then
    DataCenter.ProductLineManager:OnCollectClick(param.uuid)
    DataCenter.LWSoundManager:PlayBubbleEffect(param.buildId)
    if SeasonUtil.IsInSeasonNineNationMode(true) and param.buildId >= BuildingTypes.LW_BUILDING_SEASON5_CTIY_1 and param.buildId <= BuildingTypes.LW_BUILDING_SEASON5_CTIY_5 then
      DataCenter.LWSoundManager:PlaySound(5100009, false)
    end
  elseif param.buildBubbleType == BuildBubbleType.BuildingNoWorker or param.buildBubbleType == BuildBubbleType.BuildingNoFunctioning or param.buildBubbleType == BuildBubbleType.BuildingFunctioning then
    if param.buildBubbleType == BuildBubbleType.BuildingNoWorker then
      DataCenter.ProductLineManager:OnNoHeroBubbleClick(param.uuid)
      return
    end
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(param.uuid)
    if buildData then
      if buildData.itemId == BuildingTypes.LW_BUILD_MILITARY_CAMP then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMilitaryCampPanel, {anim = true}, param.uuid)
      elseif buildData.itemId == BuildingTypes.LW_BUILD_SMITH_SHOP then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIEquipMainPanel, {anim = false}, param.uuid)
      elseif buildData.itemId == BuildingTypes.LW_BUILDING_TACTICAL_CHIP_FACTORY then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalChipFactory, {anim = false}, param.uuid)
      end
    end
  elseif param.buildBubbleType == BuildBubbleType.SmithShopCanCraftNewEquip then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIEquipMainPanel, {anim = false}, param.uuid)
  elseif param.buildBubbleType == BuildBubbleType.TacticalChipFactoryNormal then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalChipFactory, {anim = false}, param.uuid)
  elseif param.buildBubbleType == BuildBubbleType.BuildingFunctioningFinish then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(param.uuid)
    if buildData ~= nil then
      BuildingUtils.CollectSoldier(buildData)
    end
  elseif param.buildBubbleType == BuildBubbleType.BattleHangUpBattleJump then
    UIUtil.StageJump()
  elseif param.buildBubbleType == BuildBubbleType.BattleHangUp or param.buildBubbleType == BuildBubbleType.BattleHangUpFinish then
    SFSNetwork.SendMessage(MsgDefines.HangUpRewardMessage, 0)
  elseif param.buildBubbleType == BuildBubbleType.CanFreeRecruitHero then
    local freeRecruitLottery = DataCenter.LotteryDataManager:GetFreeRecruitLotteryData()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit, {anim = true}, false, false, freeRecruitLottery)
  elseif param.buildBubbleType == BuildBubbleType.RecruitHeroNew then
    local lotteryId = DataCenter.LotteryDataManager:GetBuildBubbleGotoLotteryId()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit, {anim = true}, false, false, lotteryId)
  elseif param.buildBubbleType == BuildBubbleType.UpgradeItem then
    if param.txtNum ~= nil then
      LWResourceLackUtil:GotoGoodsItemLack(param.itemId, param.needNum)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, param.buildUuid)
    end
  elseif param.buildBubbleType == BuildBubbleType.FirstPayNotFixing or param.buildBubbleType == BuildBubbleType.FirstPayFixing or param.buildBubbleType == BuildBubbleType.FirstPayFixed or param.buildBubbleType == BuildBubbleType.NewFirstPay then
    EventManager:GetInstance():Broadcast(EventId.ShowFirstPayUI)
    local todayShow = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.FirstPayShowHero)
    if todayShow then
      DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.FirstPayShowHero, false)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroExhibitPanel, {anim = false}, 50009, {50009}, nil, true)
      PostEventLog.Track(PostEventLog.Defines.PlayFirstPayTimeline, {
        param1 = tostring(DataCenter.MonopolyManager.player.curId)
      })
    end
  elseif param.buildBubbleType == BuildBubbleType.ParkingLotUnlock then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, param.buildUuid)
  elseif param.buildBubbleType == BuildBubbleType.BuildHammer then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(param.uuid)
    local param = {}
    param.uuid = tostring(buildData.uuid)
    param.gold = BuildUpgradeUseGoldType.No
    param.upLevel = 1
    param.clientParam = ""
    param.truckId = 0
    param.pathTime = 0
    param.robotUuid = 0
    SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpNew, param)
    EventManager:GetInstance():Broadcast(EventId.GF_building_hammer_bubble_click, buildData)
  elseif param.buildBubbleType == BuildBubbleType.CountBattleEntrance then
    DataCenter.LWTrailTowerManager:OpenTrailTowerMainPanelWithScene(param.trailTowerTabType)
  elseif param.buildBubbleType == BuildBubbleType.CivilizationSparkEntrance then
    DataCenter.LWTrailTowerManager:OpenTrailTowerMainPanelWithScene(param.trailTowerTabType)
  elseif param.buildBubbleType == BuildBubbleType.CivilizationSparkLvUp then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUICivilizationSparkUpgrade, {anim = true})
  elseif param.buildBubbleType == BuildBubbleType.AlertTowerEntrance and DataCenter.LWTrailTowerManager:ShowAlertTowerEntrance() then
    DataCenter.LWTrailTowerManager:OpenTrailTowerMainPanel(param.trailTowerTabType)
  elseif param.buildBubbleType == BuildBubbleType.CountBattleSoldiers then
    SFSNetwork.SendMessage(MsgDefines.LWClaimStageSoldier)
  elseif param.buildBubbleType == BuildBubbleType.CivilizationSparkSoldiers then
    SFSNetwork.SendMessage(MsgDefines.LWClaimSparkSoldier)
  elseif param.buildBubbleType == BuildBubbleType.SquadEquipChange then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeapon, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, TacticalWeaponPageType.Equip)
  elseif param.buildBubbleType == BuildBubbleType.PVPArena then
    local peakArenastate = DataCenter.LWPVPArenaManager.state
    local arena3V3State = DataCenter.LW3V3ArenaManager.state
    local newbieArenaV2State = DataCenter.LWNewbieArenaV2Manager:GetState()
    local newPeakArenaState = DataCenter.NewPeakArenaManager.state
    local newGaleArenaState = DataCenter.NewGaleArenaManager.state
    if peakArenastate == PVPArenaState.Invalide and arena3V3State == PVPArenaState.Invalide and newbieArenaV2State == ActivityArenaState.None and newPeakArenaState == NewPeakArenaState.Invalide and newGaleArenaState == NewPeakArenaState.Invalide then
      local newbieArenaState = DataCenter.LWNewbieArenaManager:GetState()
      if newbieArenaState ~= ActivityArenaState.None then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        }, DataCenter.LWNewbieArenaManager:GetArenaInfoId())
      else
        UIUtil.ShowTipsId(801141)
      end
    else
      DataCenter.NewPeakArenaManager:OnClickBubble()
      DataCenter.LWPVPArenaManager.ShowPVPArenaMain()
    end
  elseif param.buildBubbleType == BuildBubbleType.PVPArenaNew then
    local peakArenastate = DataCenter.LWPVPArenaManager.state
    local arena3V3State = DataCenter.LW3V3ArenaManager.state
    local newbieArenaState = DataCenter.LWNewbieArenaV2Manager:GetState()
    local newPeakArenaState = DataCenter.NewPeakArenaManager.state
    local newGaleArenaState = DataCenter.NewGaleArenaManager.state
    if peakArenastate == PVPArenaState.Invalide and arena3V3State == PVPArenaState.Invalide and newbieArenaState == ActivityArenaState.None and newPeakArenaState == NewPeakArenaState.Invalide and newGaleArenaState == NewPeakArenaState.Invalide then
      UIUtil.ShowTipsId(801141)
    else
      DataCenter.NewPeakArenaManager:OnClickBubble()
      DataCenter.LWPVPArenaManager.ShowPVPArenaMain()
      local bUuid = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_PVP_ARENA)[1].uuid
      DataCenter.BuildBubbleManager:CheckShowBubble(bUuid)
    end
  elseif param.buildBubbleType == BuildBubbleType.ChampionDuel then
    if not LuaEntry.Player:IsLoginSourceServer() then
      UIUtil.ShowTipsId("entrance_config_tips001")
      return
    end
    DataCenter.NewPeakArenaManager:GoToChampionDuelMain()
  elseif param.buildBubbleType == BuildBubbleType.PyramidGift then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerLevelPackage, {anim = true}, 1720000, {1720000})
  elseif param.buildBubbleType == BuildBubbleType.QueueWorking then
    if param.buildId == BuildingTypes.FUN_BUILD_SCIENE or param.buildId == BuildingTypes.FUN_BUILD_SCIENCE_PART or param.buildId == BuildingTypes.LW_BUILE_SCIENCE_TWO or param.buildId == BuildingTypes.LW_BUILE_SCIENCE_THREE then
      local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(param.uuid)
      if queue ~= nil then
        local state = queue:GetQueueState()
        if state == NewQueueState.Work then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, ItemSpdMenu.ItemSpdMenu_Science, queue.uuid)
        end
      end
    elseif param.buildId == BuildingTypes.LW_BUILD_HOSPITL then
      local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
      if queue ~= nil then
        local state = queue:GetQueueState()
        if state == NewQueueState.Work then
          UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIHospital)
        end
      end
    elseif param.buildId == BuildingTypes.LW_BUILDING_REBIRTH_HOSPITAL then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIRebirthHospital, param.uuid)
    end
  elseif param.buildBubbleType == BuildBubbleType.HeroHonroLevelUpgrade then
    if param.heroUuid then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHeroHOF, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, param.heroType, param.heroUuid)
    end
  elseif param.buildBubbleType == BuildBubbleType.BuyScienceBuildGift then
    DataCenter.ScienceManager:OpenScienceGiftView()
  elseif param.buildBubbleType == BuildBubbleType.WorldTrend then
    local key = DataCenter.LWWorldTrendDataManager:GetCurEventDataKey()
    if key then
      local isFrist = CommonUtil.PlayerPrefsGetBool(key, false)
      if not isFrist then
        CommonUtil.PlayerPrefsSetBool(key, true)
        DataCenter.BuildBubbleManager:OnWorldTrendEventDataUpdate()
      end
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIWorldTrend)
  elseif param.buildBubbleType == BuildBubbleType.DecoratorExhibition then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWDecorationBook)
  elseif param.buildBubbleType == BuildBubbleType.SaveGirl then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSaveGirl)
  elseif param.buildBubbleType == BuildBubbleType.TacticalWepaonUpgrade then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeapon, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif param.buildBubbleType == BuildBubbleType.TacticalWeaponBasic then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeapon, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif param.buildBubbleType == BuildBubbleType.GiftPackage then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(param.uuid)
    if buildData then
      local buildId = buildData.itemId
      local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
      if buildTemplate then
        local packId = buildTemplate.para1
        local packValid = GiftPackageData.checkPackIsValid(packId)
        if packValid then
          local result, rechargeType, rechargeId = GiftPackageData.CheckIfIsPopupPackage(packId)
          if result then
            GiftPackageData.TryShowPopupPackage(pack, rechargeType, rechargeId)
          else
            local res, entryType, rechId = GiftPackageData.CheckPackageEntryType(packId)
            if res and entryType == RechargeEntryType.DailySale then
              GoToUtil.GotoOpenView(UIWindowNames.LWBuyDiamond, {
                anim = false,
                UIMainAnim = UIMainAnimType.AllHide
              }, nil, rechId, nil)
            end
          end
        end
      end
    end
  elseif param.buildBubbleType == BuildBubbleType.TWSkillChipUnlockCountDown or param.buildBubbleType == BuildBubbleType.TWSkillChipCanUnlock then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeapon, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, TacticalWeaponPageType.Basic, true)
  elseif param.buildBubbleType == BuildBubbleType.TWSkillChip then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeapon, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, TacticalWeaponPageType.SkillChip)
  elseif param.buildBubbleType == BuildBubbleType.DispatchTask then
    DataCenter.ActDispatchTaskDataManager:OnBuildBubbleClick()
  elseif param.buildBubbleType == BuildBubbleType.SeasonBuildingLv0Ruins then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, param.uuid)
  elseif param.buildBubbleType == BuildBubbleType.SeasonWeekCard then
    GoToUtil.GotoSeasonWeekCardView()
  elseif param.buildBubbleType == BuildBubbleType.DecorationPlaySound then
    if param.buildId ~= nil then
      DataCenter.DecorationBGMManager:StopBGMByBuildId(param.buildId)
    end
  elseif param.buildBubbleType == BuildBubbleType.RebirthHospitalFree then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIRebirthHospital, param.buid)
  elseif param.buildBubbleType == BuildBubbleType.RebirthHospitalEnd then
    DataCenter.RebirthHospitalManager:CheckRebirthQueueFinish(param.bUuid)
  elseif param.buildBubbleType == BuildBubbleType.RebirthHospitalAllianceHelp then
    SFSNetwork.SendMessage(MsgDefines.AllianceCallHelp, param.uuid, AllianceHelpType.Queue, NewQueueType.RebirthHospital, param.itemId)
  elseif param.buildBubbleType == BuildBubbleType.BuildHeroCountdownReady then
    DataCenter.BuildHeroCountdownManager:TryFixHero(param.uuid)
  elseif param.buildBubbleType == BuildBubbleType.BlackMarket then
    local actId = DataCenter.ActivityListDataManager:GetOpenIdByType(EnumActivity.BlackMarket.Type)
    if actId and tonumber(actId) > 0 then
      GoToUtil.GoActWindow({actId})
    else
      UIUtil.ShowTipsId("458272")
    end
    return
  elseif param.buildBubbleType == BuildBubbleType.PersonalFurnaceTip then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildingPersonalFurnace, param.uuid)
  elseif param.buildBubbleType == BuildBubbleType.BuildSeasonLightHouse then
    if param.gotoFixBuildUI then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, param.uuid)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPowerHouse, {anim = true}, 1)
    end
  elseif param.buildBubbleType == BuildBubbleType.BuildSeasonPowerStation then
    if param.gotoFixBuildUI then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, param.uuid)
    elseif param.hasWorkerButNoActive then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPowerHouse, {anim = true}, 1)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, param.uuid)
    end
  elseif param.buildBubbleType == BuildBubbleType.BuildSeasonBigPhoto then
    UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonPhotoList, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif param.buildBubbleType == BuildBubbleType.BuildSeasonWorld then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWSeasonWorld, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif param.buildBubbleType == BuildBubbleType.BuildMummyYard then
    if param.buildMummyBubbleState == 1 then
      SeasonUtil.ShowSeasonUI(UIWindowNames.UILWMummyMain, {anim = true})
    elseif param.buildMummyBubbleState == 2 then
      local soldierLimit = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_MUMMY_MAX_STOCK)
      local mummyCount = DataCenter.SoldierDataManager:GetInsideSoldiersTotalNum(SoldierType.Mummy)
      if soldierLimit <= mummyCount then
        UIUtil.ShowTipsId("season_s3_Mummy_tips016")
        return
      end
      SFSNetwork.SendMessage(MsgDefines.FetchSeasonMummySoldier)
      BuildBubbleManager.ShowBuildMummyYardAnim(param.uuid)
    elseif param.buildMummyBubbleState == 3 then
      SeasonUtil.ShowSeasonUI(UIWindowNames.UILWMummyMain, {anim = true})
    else
      SeasonUtil.ShowSeasonUI(UIWindowNames.UILWMummyMain, {anim = true})
    end
  elseif param.buildBubbleType == BuildBubbleType.ActivityAlarmClock then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActivityAlarmClock, {anim = true})
  elseif param.buildBubbleType == BuildBubbleType.DominatorMainEntrance then
    DataCenter.DominatorManager:OnMainBuildingEntranceClick()
  elseif param.buildBubbleType == BuildBubbleType.RaceEntrance then
    RaceEntranceUtil.GotoOpenView(param.actType)
  elseif param.buildBubbleType == BuildBubbleType.T11Research then
    UIManager:GetInstance():OpenWindow(UIWindowNames.T11MainView)
  elseif param.buildBubbleType == BuildBubbleType.T11IdleGame then
    DataCenter.T11IdleGameManager:OnAlertTowerBubbleClick()
  elseif param.buildBubbleType == BuildBubbleType.BuildingMainDetail then
    UIUtil.OpenLWUIBuildDetailsView(tostring(param.pos))
    PostEventLog.Track(PostEventLog.Defines.c_open_build_main_detail_way, {
      i_para1 = 1,
      i_para2 = 1,
      i_para3 = DataCenter.BuildManager.MainLv,
      i_para4 = DataCenter.MonopolyManager.player.curId
    })
  elseif param.buildBubbleType == BuildBubbleType.SeasonTower then
    DataCenter.LWSeasonTowerManager:OnAlertTowerBubbleClick()
  elseif param.buildBubbleType == BuildBubbleType.BuildingMainPopupActivity then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIPopupActivityDataPanel)
  end
  local bubbleName = DataCenter.BuildBubbleManager:GetBubbleNameByBubbleType(param.buildBubbleType)
  if bubbleName ~= nil and param.buildId ~= nil then
    DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ClickBubble, param.buildId .. ";" .. bubbleName)
  end
end

function BuildBubbleManager.ShowBuildMummyYardAnim(uuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if buildData == nil or not SeasonUtil.IsMummyYardBuilding(buildData.itemId) then
    return
  end
  if buildData ~= nil and buildData.pointId ~= nil then
    local world = CS.SceneManager.World
    if IsNotNull(world) then
      local cityObj = world:GetBuildingByPoint(buildData.pointId)
      if IsNotNull(cityObj) and IsNotNull(cityObj.gameObject) then
        local go = cityObj.gameObject
        local eff_s3_a_build_anim_02_path = "ModelGo/Normal/Rect_Child/A_build_Munaiyijiaochang(Spawn)/jiaochang_dimian_pian/Eff_s3_A_build_Munaiyijiaochang_02"
        local eff_s3_a_build_anim_01_path = "ModelGo/Normal/Rect_Child/A_build_Munaiyijiaochang(Spawn)/jiaochang_ta_pian/Eff_s3_A_build_Munaiyijiaochang_01"
        local anim1 = go.transform:Find(eff_s3_a_build_anim_01_path)
        local anim2 = go.transform:Find(eff_s3_a_build_anim_02_path)
        if IsNotNull(anim1) and IsNotNull(anim2) and not anim1.gameObject.activeSelf and not anim2.gameObject.activeSelf then
          anim1.gameObject:SetActive(true)
          anim2.gameObject:SetActive(true)
          TimerManager:GetInstance():DelayInvoke(function()
            if GameObjectIsValid(go) then
              if IsNotNull(anim1) then
                anim1.gameObject:SetActive(false)
              end
              if IsNotNull(anim2) then
                anim2.gameObject:SetActive(false)
              end
            end
          end, 5)
        end
      end
    end
  end
end

local function CheckIfHasAllianceBuild(self, needJump)
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUND_BUILD_ALLIANCE_CENTER)
  if not buildData then
    UIUtil.ShowTipsId(390805)
    if needJump then
      GoToUtil.GotoBuildListByBuildId(BuildingTypes.FUND_BUILD_ALLIANCE_CENTER)
    end
    return false
  end
  return true
end

local function OnBuildTrainingFinishSignal(data)
  DataCenter.BuildBubbleManager:RefreshBubbleByQueueType(data)
end

local function OnScienceQueueFinishSignal()
  DataCenter.BuildBubbleManager:RefreshBubbleByQueueType(NewQueueType.Science)
end

local function RefreshBubbleByQueueType(self, queueType)
  if queueType == NewQueueType.Science then
    local listA = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_SCIENCE_PART)
    if listA ~= nil then
      for a, b in pairs(listA) do
        DataCenter.BuildBubbleManager:CheckShowBubble(b.uuid)
      end
    end
    local data = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILE_SCIENCE_TWO)
    if data then
      DataCenter.BuildBubbleManager:CheckShowBubble(data.uuid)
    end
    local data4Three = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILE_SCIENCE_THREE)
    if data4Three then
      DataCenter.BuildBubbleManager:CheckShowBubble(data4Three.uuid)
    end
  end
  local buildId = DataCenter.BuildManager:GetBuildIdByNewQueue(tonumber(queueType))
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
  if list ~= nil then
    for k, v in pairs(list) do
      DataCenter.BuildBubbleManager:CheckShowBubble(v.uuid)
    end
  end
end

local function HospitalFinishSignal()
  DataCenter.BuildBubbleManager:RefreshBubbleByQueueType(NewQueueType.Hospital)
end

local function OnRefreshRebirthHospital()
  DataCenter.BuildBubbleManager:RefreshBubbleByQueueType(NewQueueType.RebirthHospital)
end

local function OnDominatorMainBuildingRedChanged()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.DominatorMainEntrance)
end

local function OnT11IdleGameBubbleChanged()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.T11IdleGame)
end

local function OnHeroLotteryBubbleUpdate()
  local pubData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_PUB)
  if pubData == nil then
    return
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(tonumber(pubData.uuid))
end

local function UpdateSeasonDeathSoldierInfo()
  local bUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(SeasonUtil.GetMummyYardBuildingId())
  if buildData ~= nil then
    bUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(bUuid)
end

local function OnHospitalUpdateSignal()
  DataCenter.BuildBubbleManager:RefreshBubbleByQueueType(NewQueueType.Hospital)
end

local function OnBuildGatherSecondProductSignal(data)
  local strArr = string.split(data, ";")
  if 1 < #strArr then
    local bUuid = tonumber(strArr[1])
    DataCenter.BuildBubbleManager:CheckShowBubble(bUuid)
  end
end

local function FeedAnimalSignal(data)
  local queue = DataCenter.QueueDataManager:GetQueueByUuid(data)
  if queue ~= nil then
    local bUuid = tonumber(queue.funcUuid)
    DataCenter.BuildBubbleManager:CheckShowBubble(bUuid)
  end
end

local function PasturePanelSignal(data)
  local bUuid = tonumber(data)
  DataCenter.BuildBubbleManager:CheckShowBubble(bUuid)
end

local function OnBuildSecondProductCreateSignal(data)
  DataCenter.BuildBubbleManager:CheckShowBubble(tonumber(data))
end

local function OnFoodFactoryProductCreateSignal(data)
  DataCenter.BuildBubbleManager:CheckShowBubble(tonumber(data))
end

local function OnFoodFactoryGatherProductSignal(data)
  local bUuid = tonumber(data)
  DataCenter.BuildBubbleManager:DeleteOneBuildBubble(bUuid)
end

local function RefreshResidentOrderSignal()
  local bUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_BUSINESS_CENTER)
  if buildData ~= nil then
    bUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(bUuid)
end

local function RefreshResourceItemSignal()
  local bUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_BUSINESS_CENTER)
  if buildData ~= nil then
    bUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(bUuid)
  DataCenter.BuildBubbleManager:CheckShowBuildUpgrade()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.EnergyOrder)
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.ProductLineFull)
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.ProductLineNoHero)
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.ProductLineLack)
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.ProductLineNormal)
  DataCenter.BuildBubbleManager:RefreshT11BuildingBubbleSignal()
end

local function RefreshT11BuildingBubbleSignal()
  local buildUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_T11_Research)
  if buildData then
    buildUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(buildUuid)
end

local function RefreshT11IdleGameBubble()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.T11IdleGame)
end

local function RefreshSeasonTowerBubble()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.SeasonTower)
end

local function RefreshSoldierBuildingBubble()
  local buildUuid = 0
  local list = DataCenter.BuildManager:GetFunbuildListByItemID(BuildingTypes.LW_BUILD_MILITARY_CAMP)
  for _, v in pairs(list) do
    if v then
      buildUuid = v.uuid
    end
    DataCenter.BuildBubbleManager:CheckShowBubble(buildUuid)
  end
  local hospitalList = DataCenter.BuildManager:GetFunbuildListByItemID(BuildingTypes.LW_BUILD_HOSPITL)
  for _, v in pairs(hospitalList) do
    if v then
      buildUuid = v.uuid
    end
    DataCenter.BuildBubbleManager:CheckShowBubble(buildUuid)
  end
  local rebirthHospitalUuid = 0
  local rebirthHospitalData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILDING_REBIRTH_HOSPITAL)
  if rebirthHospitalData then
    rebirthHospitalUuid = rebirthHospitalData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(rebirthHospitalUuid)
end

local function RefreshAllianceBattleSignal()
  local buildUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_SMITHY)
  if buildData then
    buildUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(buildUuid)
end

local function RefreshGolloesCampBubbleSignal()
  local buildUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_PARKINGLOT_FOUR)
  if buildData then
    buildUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(buildUuid)
  buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_SHOP)
  if buildData then
    buildUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(buildUuid)
end

local function RefreshWeekCardBubbleSignal()
  local buildUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_SHOP)
  if buildData then
    buildUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(buildUuid)
  DataCenter.BuildBubbleManager.DoSeasonWeekCardBubbleRefresh()
end

local function RefreshDecorationShopBubble()
  local buildUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_SHOP)
  if buildData then
    buildUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(buildUuid)
end

local function OnPassDaySignal()
  local buildUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_SHOP)
  if buildData then
    buildUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(buildUuid)
  local activityAlarmClockBuildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_ACTIVITY_ALARM_CLOCK)
  if activityAlarmClockBuildData then
    DataCenter.BuildBubbleManager:CheckShowBubble(activityAlarmClockBuildData.uuid)
  end
end

local function OnCommonEquipUpdateSignal()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.SquadEquipChange)
end

local function OnHeroHonorLevelUpgrade()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.HeroHonroLevelUpgrade)
end

local function OnHeroFragmentItemChange()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.HeroHonroLevelUpgrade)
end

local function OnTacticalWeaponBubbleUpdateSignal()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.TacticalWepaonUpgrade)
end

local function OnTWSkillChipUnlockCountDownSignal()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.TWSkillChipUnlockCountDown)
end

local function RefreshGolloesMcBubbleSignal()
  local buildUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_GROCERY_STORE)
  if buildData then
    buildUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(buildUuid)
end

local function UpdateAllianceSignal(data)
  local buildUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUND_BUILD_ALLIANCE_CENTER)
  if buildData then
    buildUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(buildUuid)
end

local function UpdateKonbiniSignal(data)
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_KONBINI)
  if buildData then
    DataCenter.BuildBubbleManager:CheckShowBubble(buildData.uuid)
  end
end

local function UpdateRaceEntranceBubble(data)
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_RACE_ENTRANCE)
  if buildData then
    DataCenter.BuildBubbleManager:CheckShowBubble(buildData.uuid)
  end
end

local function CheckBuildUpgradeReward(buildId)
  local buildUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
  if buildData then
    buildUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(buildUuid)
end

local function RefreshEarthOrderSignal()
  local bUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_TRADING_CENTER)
  if buildData ~= nil then
    bUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(bUuid)
end

local function RefreshGroceryStoreOrderSignal()
  local bUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_GROCERY_STORE)
  if buildData ~= nil then
    bUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(bUuid)
end

local function GatherResourceItemFinishSignal()
  for k, v in pairs(DataCenter.BuildBubbleManager.allBuildBubble) do
    if v.param.buildBubbleType == BuildBubbleType.PastureProduct then
      DataCenter.BuildBubbleManager:CheckShowBubble(v.param.uuid)
    end
  end
end

local function RefreshWorldTrendSignal()
  local bUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_DRONE)
  if buildData ~= nil then
    bUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(bUuid)
end

local function UpdateMarchSignal()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.ParkingLotState)
  local buildUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.APS_BUILD_WORMHOLE_SUB)
  if buildData then
    buildUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(buildUuid)
  buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.APS_BUILD_WORMHOLE_MAIN)
  if buildData and buildUuid ~= buildData.uuid then
    DataCenter.BuildBubbleManager:CheckShowBubble(buildData.uuid)
  end
end

function BuildBubbleManager.OnBatteryPowerUpdated()
  local buildUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_SEASON4_LIGHTHOUSE)
  if buildData then
    buildUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(buildUuid)
  DataCenter.BuildBubbleManager:CheckShowBuildUpgrade()
end

local function ResourceUpdatedSignal()
  local buildUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_HERO_MONUMENT)
  if buildData then
    buildUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(buildUuid)
  DataCenter.BuildBubbleManager:CheckShowBuildUpgrade()
  DataCenter.BuildBubbleManager:RefreshT11BuildingBubbleSignal()
end

local function CheckShowBuildUpgrade(self)
  if self.realCheckUpdateList ~= nil then
    for k, v in pairs(self.realCheckUpdateList) do
      local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(k)
      for a, b in pairs(buildList) do
        DataCenter.BuildBubbleManager:CheckShowBubble(b.uuid)
      end
    end
  end
  if self.checkLv0BuildDict ~= nil then
    for k, v in pairs(self.checkLv0BuildDict) do
      local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(k)
      for a, b in pairs(buildList) do
        DataCenter.BuildBubbleManager:CheckShowBubble(b.uuid)
      end
    end
  end
end

local function GetBubblePosition(self, bUuid)
  local temp = self.allBuildBubble[bUuid]
  if temp ~= nil then
    return temp:GetBubblePosition()
  end
  return ResetPosition
end

local function AddOneBubbleTimer(self, uuid, time, buildBubbleType)
  self:RemoveOneBubbleTimer(uuid, buildBubbleType)
  local param = {}
  param.buildBubbleType = buildBubbleType
  param.uuid = uuid
  param.timer = TimerManager:GetInstance():GetTimer(time, self.BubbleTimerCallBack, param, true, false, false)
  if self.bubbleBuildTimer[uuid] == nil then
    self.bubbleBuildTimer[uuid] = {}
  end
  self.bubbleBuildTimer[uuid][buildBubbleType] = param
  param.timer:Start()
end

local function RemoveOneBubbleTimer(self, uuid, buildBubbleType)
  if self.bubbleBuildTimer[uuid] ~= nil and self.bubbleBuildTimer[uuid][buildBubbleType] ~= nil then
    self.bubbleBuildTimer[uuid][buildBubbleType].timer:Stop()
    self.bubbleBuildTimer[uuid][buildBubbleType] = nil
  end
end

local function BubbleTimerCallBack(param)
  DataCenter.BuildBubbleManager:RemoveOneBubbleTimer(param.uuid, param.buildBubbleType)
  DataCenter.BuildBubbleManager:CheckShowBubble(param.uuid)
end

local function CheckShowBubble(self, bUuid)
  if self.noRefreshTimer[bUuid] == nil then
    if DataCenter.BuildManager:IsBuildInView(bUuid) then
      self._delayUpdateData[bUuid] = true
      if self._delayUpdateTimer == nil then
        self._delayUpdateTimer = TimerManager:GetInstance():DelayInvoke(self.delayUpdateCallBack, 0.1)
        self._delayUpdateTimer:Start()
      end
      return
    else
      self:DeleteOneBuildBubble(bUuid)
    end
  end
end

local function DoCheckShowBubble(self)
  for bUuid, _ in pairs(self._delayUpdateData) do
    if self.noRefreshTimer[bUuid] == nil then
      if DataCenter.BuildManager:IsBuildInView(bUuid) then
        local param = self:GetBuildNeedShowBuildBubble(bUuid)
        if param == nil then
          self:DeleteOneBuildBubble(bUuid)
        elseif self.allBuildBubble[bUuid] ~= nil and param.model == self.allBuildBubble[bUuid].param.model then
          self.allBuildBubble[bUuid]:ReInit(param)
        else
          self:DeleteOneBuildBubble(bUuid)
          self:ShowOneBuildBubble(bUuid, param)
        end
      else
        self:DeleteOneBuildBubble(bUuid)
      end
    end
  end
  self._delayUpdateTimer = nil
  self._delayUpdateData = {}
end

local function DestroyAllTimer(self)
  for _, v in pairs(self.bubbleBuildTimer) do
    if v ~= nil then
      for _, v1 in pairs(v) do
        v1.timer:Stop()
      end
    end
  end
  self.bubbleBuildTimer = {}
end

local function UpdateBuildDataSignal(bUuid)
  if bUuid ~= nil then
    DataCenter.BuildBubbleManager:CheckShowBubble(tonumber(bUuid))
  end
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(tonumber(bUuid))
  if buildData then
    DataCenter.BuildBubbleManager:RefreshCheckUpgradeList(buildData)
  end
  DataCenter.BuildBubbleManager:CheckShowBuildUpgrade()
end

local function RefreshCheckUpgradeList(self, buildData)
  if buildData ~= nil then
    local mainLv = DataCenter.BuildManager.MainLv
    if buildData.itemId == BuildingTypes.FUN_BUILD_MAIN then
      if self.needCheckBuildTypeList ~= nil then
        self.realCheckUpdateList = {}
        for k, v in pairs(self.needCheckBuildTypeList) do
          local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(k)
          local isHave = false
          for _, b in pairs(buildList) do
            if isHave == false and v <= mainLv - b.level then
              isHave = true
            end
          end
          if isHave then
            self.realCheckUpdateList[k] = 1
          end
        end
      end
    elseif self.realCheckUpdateList[buildData.itemId] ~= nil then
      local limitLv = self.needCheckBuildTypeList[buildData.itemId]
      if limitLv ~= nil then
        local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildData.itemId)
        local isHave = false
        for _, b in pairs(buildList) do
          if isHave == false and limitLv <= mainLv - b.level then
            isHave = true
          end
        end
        if isHave == false then
          self.realCheckUpdateList[buildData.itemId] = nil
        end
      else
        self.needCheckBuildTypeList[buildData.itemId] = nil
      end
    end
    if self.checkLv0BuildDict ~= nil and self.checkLv0BuildDict[buildData.itemId] ~= nil then
      local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildData.itemId)
      local isHave = false
      for _, b in pairs(buildList) do
        if b.level <= 0 then
          isHave = true
        end
      end
      if isHave == false then
        self.checkLv0BuildDict[buildData.itemId] = nil
      end
    end
  end
end

local function BuildTimeEndSignal(bUuid)
  if bUuid ~= nil then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(tonumber(bUuid))
    if buildData ~= nil and buildData.destroyStartTime <= 0 then
      DataCenter.BuildBubbleManager:DeleteOneBuildBubble(tonumber(bUuid))
    end
  end
end

local function BuildFixTimeEndSignal(bUuid)
  if bUuid ~= nil then
    DataCenter.BuildBubbleManager:CheckShowBubble(tonumber(bUuid))
  end
end

local function OnCheckPubBubble(self)
  local pubData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_PUB)
  if pubData == nil then
    return
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(tonumber(pubData.uuid))
end

local function OnCheckPubShopBubble(self)
  local pubData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.APS_BUILD_PUB)
  if pubData == nil then
    return
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(tonumber(pubData.uuid))
end

local function GetBgScale(self, param)
  if param.buildBubbleType == BuildBubbleType.CarSoldierUnlock or param.buildBubbleType == BuildBubbleType.FootSoldierUnlock or param.buildBubbleType == BuildBubbleType.BowSoldierUnlock then
    return TrainScale
  elseif param.buildBubbleType == BuildBubbleType.PastureProduct or param.buildBubbleType == BuildBubbleType.GetFoodProduct then
    return TileBgScale3
  elseif param.buildBubbleType == BuildBubbleType.BuildHammer or param.buildBubbleType == BuildBubbleType.FireExtinguisher or param.buildBubbleType == BuildBubbleType.BuildMummyYard or param.buildBubbleType == BuildBubbleType.BuildingMainPopupActivity then
    return HammerBgScale
  end
  if param.tileX == BuildTilesSize.One or param.tileY == BuildTilesSize.One then
    return TileBgScale1
  else
    return TileBgScale2
  end
  return TileBgScale2
end

local function GetIconScale(self, param)
  if param.buildBubbleType == BuildBubbleType.Assistance then
    return AssistanceIconScale
  end
  if param.buildBubbleType == BuildBubbleType.GetResource then
    return ResourceIconScale
  end
  if param.buildBubbleType == BuildBubbleType.PastureProduct then
    return ResourceIconScale
  end
  if param.buildBubbleType == BuildBubbleType.GetFoodProduct then
    return ResourceIconScale
  end
  if param.buildBubbleType == BuildBubbleType.HeroStationSkill or param.buildBubbleType == BuildBubbleType.CanUseHeroEffectSkill then
    return HeroStationSkillIconScale
  end
  if param.buildBubbleType == BuildBubbleType.BuildingLv0Ruins then
    return BuildingLv0RuinsIconScale
  end
  if param.buildBubbleType == BuildBubbleType.ResidentOrder then
    return ResidentOrderIconScale
  end
  if param.buildBubbleType == BuildBubbleType.HeroFreeScienceAddTime or param.buildBubbleType == BuildBubbleType.HeroFreeBuildAddTime or param.buildBubbleType == BuildBubbleType.DecorationShop or param.buildBubbleType == BuildBubbleType.GiftVoucher then
    return HeroFreeScienceAndBuild
  end
  if param.buildBubbleType == BuildBubbleType.UpgradeAllianceHelp or param.buildBubbleType == BuildBubbleType.ScienceAllianceHelp or param.buildBubbleType == BuildBubbleType.HospitalAllianceHelp or param.buildBubbleType == BuildBubbleType.FixBuildingAllianceHelp then
    return AllianceHelpIconScale
  end
  if param.buildBubbleType == BuildBubbleType.ScienceEnd then
    return ResidentOrderIconScale
  end
  if param.buildBubbleType == BuildBubbleType.ActivityAlarmClock then
    return ActivityAlarmClockIconScale
  end
  if param.buildBubbleType == BuildBubbleType.CivilizationSparkLvUp then
    return ActivityAlarmClockIconScale
  end
  return ResetScale
end

local function GetFactoryDataSignal()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.GetFoodProduct)
end

local function CheckDetectEventSignal()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.DetectEvent)
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.DetectEventFinished)
end

local function CheckTalentSignal()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.Talent)
end

local function CheckMasterySignal()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.LWMastery)
end

local function CheckWorkerUpSignal()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.LWWorkerUp)
end

local function CheckGiftVoucherSignal()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.GiftVoucher)
end

local function CheckHeroBountySignal()
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_HERO_BOUNTY)
  for k1, v1 in pairs(list) do
    DataCenter.BuildBubbleManager:CheckShowBubble(v1.uuid)
  end
end

local function EnergyOrderRefreshSignal()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.EnergyOrder)
end

local function ProductLineUpdateSignal()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.ProductLineFull)
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.ProductLineNoHero)
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.ProductLineLack)
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.ProductLineNormal)
end

local function BuildingHeroDispatchingSignal()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.ProductLineFull)
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.ProductLineNoHero)
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.ProductLineLack)
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.ProductLineNormal)
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.BuildingNoWorker)
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.BuildingNoFunctioning)
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.BuildingFunctioning)
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.MilitaryCampTrainingFinished)
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.BuildingReplaceWorker)
end

local function GetBuildListByBubbleType(self, type)
  local result = {}
  if type == BuildBubbleType.GetFoodProduct then
    result = FactoryBuild
  elseif type == BuildBubbleType.DetectEvent or type == BuildBubbleType.DetectEventFinished then
    table.insert(result, BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY)
  elseif type == BuildBubbleType.LWMastery then
    table.insert(result, BuildingTypes.SEASON_CAREER_BUILD)
  elseif type == BuildBubbleType.LWWorkerUp then
    table.insert(result, BuildingTypes.LW_BUILD_TALENT_HALL)
  elseif type == BuildBubbleType.BuildZeroUp then
    table.insert(result, BuildingTypes.FUN_BUILD_MAIN)
    table.insert(result, BuildingTypes.FUN_BUILD_TEMP_WIND_POWER_PLANT)
  elseif type == BuildBubbleType.PastureProduct then
    table.insert(result, BuildingTypes.APS_BUILD_PASTURE_OSTRICH)
    table.insert(result, BuildingTypes.APS_BUILD_PASTURE_CATTLE)
    table.insert(result, BuildingTypes.APS_BUILD_PASTURE_SANDWORM)
  elseif type == BuildBubbleType.AllianceCareer then
    table.insert(result, BuildingTypes.FUND_BUILD_ALLIANCE_CENTER)
  elseif type == BuildBubbleType.Talent then
    table.insert(result, BuildingTypes.FUN_BUILD_MAIN)
  elseif type == BuildBubbleType.EnergyOrder then
    table.insert(result, BuildingTypes.APS_BUILD_FARM)
  elseif type == BuildBubbleType.ProductLineFull or type == BuildBubbleType.ProductLineLack or type == BuildBubbleType.ProductLineNoHero then
    local dict = DataCenter.ProductLineManager:GetAllBuildIds()
    for buildId, _ in pairs(dict) do
      table.insert(result, buildId)
    end
  elseif type == BuildBubbleType.SmithShopCanCraftNewEquip then
    table.insert(result, BuildingTypes.LW_BUILD_SMITH_SHOP)
  elseif type == BuildBubbleType.TacticalChipFactoryNormal then
    table.insert(result, BuildingTypes.LW_BUILDING_TACTICAL_CHIP_FACTORY)
  elseif type == BuildBubbleType.BattleHangUp then
    table.insert(result, BuildingTypes.LW_BUILD_BATTLE_HANGUP_REWARD)
  elseif type == BuildBubbleType.CanFreeRecruitHero then
    table.insert(result, BuildingTypes.LW_BUILD_PUB)
  elseif type == BuildBubbleType.BuildingReplaceWorker then
    for i, data in pairs(DataCenter.BuildManager:GetAllBuildData()) do
      local buildTemlate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(data.itemId, data.level)
      if tonumber(buildTemlate.hero_slots) > 0 and data.level > 0 then
        table.insert(result, data.itemId)
      end
    end
  elseif type == BuildBubbleType.GolloesMonthCard then
    table.insert(result, BuildingTypes.LW_BUILD_PARKINGLOT_FOUR)
  elseif type == BuildBubbleType.ParkingLotState then
    table.insert(result, BuildingTypes.LW_BUILD_PARKINGLOT)
    table.insert(result, BuildingTypes.LW_BUILD_PARKINGLOT_TWO)
    table.insert(result, BuildingTypes.LW_BUILD_PARKINGLOT_THREE)
    table.insert(result, BuildingTypes.LW_BUILD_PARKINGLOT_FOUR)
  elseif type == BuildBubbleType.GolloesGift or type == BuildBubbleType.GiftVoucher or type == BuildBubbleType.DecorationShop then
    table.insert(result, BuildingTypes.LW_BUILD_SHOP)
  elseif type == BuildBubbleType.ParkingLotUnlock then
    table.insert(result, BuildingTypes.LW_BUILD_PARKINGLOT)
    table.insert(result, BuildingTypes.LW_BUILD_PARKINGLOT_TWO)
    table.insert(result, BuildingTypes.LW_BUILD_PARKINGLOT_THREE)
  elseif type == BuildBubbleType.SquadEquipChange then
    table.insert(result, BuildingTypes.LW_BUILD_TACTICAL_CENTER)
  elseif type == BuildBubbleType.HeroHonroLevelUpgrade then
    table.insert(result, BuildingTypes.LW_BUILD_TANKCENTER)
    table.insert(result, BuildingTypes.LW_BUILD_ARTILLERYCENTER)
    table.insert(result, BuildingTypes.LW_BUILD_AIRCRAFTCENTER)
  elseif type == BuildBubbleType.TacticalWepaonUpgrade or type == BuildBubbleType.TacticalWeaponBasic or type == BuildBubbleType.TWSkillChipUnlockCountDown or type == BuildBubbleType.TWSkillChipCanUnlock or type == BuildBubbleType.TWSkillChip then
    table.insert(result, BuildingTypes.LW_BUILD_TACTICAL_CENTER)
  elseif type == BuildBubbleType.BlackMarket then
    table.insert(result, BuildingTypes.LW_BUILD_BLACKMARKET)
  elseif type == BuildBubbleType.DominatorMainEntrance then
    table.insert(result, BuildingTypes.LW_BUILD_DOMINATOR_MAIN)
  elseif type == BuildBubbleType.DecoratorExhibition then
    table.insert(result, BuildingTypes.LW_DECORATION_EXHIBITION)
  elseif type == BuildBubbleType.T11Research then
    table.insert(result, BuildingTypes.LW_T11_Research)
  elseif type == BuildBubbleType.T11IdleGame or type == BuildBubbleType.SeasonTower then
    table.insert(result, BuildingTypes.LW_BUILD_ALERTTOWER)
  elseif type == BuildBubbleType.BuildingMainDetail or type == BuildBubbleType.BuildingMainPopupActivity then
    table.insert(result, BuildingTypes.FUN_BUILD_MAIN)
  end
  return result
end

local function CheckShowByBubbleType(self, type)
  local buildList = self:GetBuildListByBubbleType(type)
  if not self.checkShowBubbleAction then
    function self.checkShowBubbleAction(data)
      if not data then
        return
      end
      DataCenter.BuildBubbleManager:CheckShowBubble(data.uuid)
    end
  end
  for k, v in ipairs(buildList) do
    DataCenter.BuildManager:DoActionForAllBuildingExceptState(v, BuildingStateType.FoldUp, self.checkShowBubbleAction)
  end
end

local function GetBubbleObjByBubbleTypeAndBuildId(self, bubbleType, buildId, isIgnore)
  for k, v in pairs(self.allBuildBubble) do
    if v.param.buildBubbleType == bubbleType and v.param.buildId == buildId then
      return self:GetBubbleObjByBuildUuid(k, isIgnore)
    end
  end
end

local function GetBubbleObjByBuildUuid(self, uuid, isIgnore)
  if self.allBuildBubble[uuid] ~= nil then
    return self.allBuildBubble[uuid]:GetBubbleObj(isIgnore)
  end
end

local function RefreshItemsSignal()
  if CS.SceneManager:IsInCity() then
    DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.BuildZeroUp)
    DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.BuildingMainDetail)
  end
  DataCenter.BuildBubbleManager:CheckShowBuildUpgrade()
  DataCenter.BuildBubbleManager:RefreshT11BuildingBubbleSignal()
  DataCenter.BuildBubbleManager:RefreshCivilizationSparkBubbleSignal()
end

local function RefreshRecommendShowSignal(showType)
  if showType ~= nil and tonumber(showType) == RecommendShowType.FeedOstrich then
    DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.PastureProduct)
  end
end

local function RefreshBubbleShow(self, bubbleType)
  if not self.allBuildBubble then
    return
  end
  for k, v in pairs(self.allBuildBubble) do
    if v.param.buildBubbleType == bubbleType then
      DataCenter.BuildBubbleManager:CheckShowBubble(v.param.uuid)
    end
  end
end

local function SetShowBuildBubble(self, bUuid, value)
  if value == false then
    self.showBuildBubbleFlag[bUuid] = true
    self.BuildOutViewSignal(bUuid)
  elseif self.showBuildBubbleFlag[bUuid] ~= nil then
    self.showBuildBubbleFlag[bUuid] = nil
    self.BuildInViewSignal(bUuid)
  end
end

local function ShowPastureBubble(self, buildUuid)
  if self.allBuildBubble[buildUuid] ~= nil then
    self.allBuildBubble[buildUuid]:Show()
    return true
  end
  return false
end

local function HidePastureBubble(self, buildUuid)
  if self.allBuildBubble[buildUuid] ~= nil then
    self.allBuildBubble[buildUuid]:Hide()
    return true
  end
  return false
end

local function HidePastureBubbleWithShow(self, buildUuid)
  if self.allBuildBubble[buildUuid] ~= nil then
    return self.allBuildBubble[buildUuid]:HideWithoutShowAndReturnResult()
  end
  return false
end

local function RefreshGuideSignal(self)
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.PastureProduct)
end

local function UpdateMarchItemSignal()
  DataCenter.BuildBubbleManager:RefreshAssistanceBubble()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.ParkingLotState)
end

local function RefreshAssistanceBubble(self)
  local bUuidList = {}
  for bUuid, _ in pairs(self.assistedBuild) do
    table.insert(bUuidList, bUuid)
  end
  self.assistedBuild = {}
  local marchInfos = DataCenter.WorldMarchDataManager:GetMarchesTargetForMineLite()
  for _, marchInfo in pairs(marchInfos) do
    if marchInfo:GetMarchStatus() == MarchStatus.ASSISTANCE then
      local bUuid = marchInfo.targetUuid
      self.assistedBuild[bUuid] = true
      table.insert(bUuidList, bUuid)
    end
  end
  for _, bUuid in ipairs(bUuidList) do
    self:CheckShowBubble(bUuid)
  end
end

local function QueueHeroFreeTime(param)
  if DataCenter.BuildManager:IsBuildInView(param.uuid) then
    if param.type == 1 then
      DataCenter.BuildQueueManager:SetCanUseHeroFreeTime(param.uuid)
    elseif param.type == 2 then
      DataCenter.QueueDataManager:SetCanUseHeroFreeTime(param.uuid)
    end
    DataCenter.BuildBubbleManager:CheckShowBubble(param.uuid)
  end
end

local function ChangeCameraLodSignal(lod)
  DataCenter.BuildBubbleManager:UpdateLod(lod)
end

local function UpdateLod(self, lod)
  self.lodCache = lod
  self:RefreshBubbleNode()
end

local function ShowBubbleNode(self)
  self.showBubbleNode = true
  self:RefreshBubbleNode()
end

local function HideBubbleNode(self)
  self.showBubbleNode = false
  self:RefreshBubbleNode()
end

local function RefreshBubbleNode(self)
  if not CS.SceneManager:IsInCity() then
    return
  end
  local node = self:GetBubbleNode()
  local active = self.showBubbleNode and self.lodCache and self.lodCache <= 1
  if not IsNull(node) then
    node:SetActive(active)
  end
  if active then
    for _, bubble in pairs(self.allBuildBubble) do
      bubble:Show()
    end
  end
end

local function GetBubbleNode(self)
  local isInCity = CS.SceneManager:IsInCity()
  if (self.bubbleNode == nil or self.isInCityCache ~= isInCity) and IsNotNull(CS.SceneManager.World) then
    local nodeTrans = CS.SceneManager.World.BuildBubbleNode
    if IsNotNull(nodeTrans) then
      self.bubbleNode = nodeTrans.gameObject
    else
      self.bubbleNode = nil
    end
    self.isInCityCache = isInCity
  end
  return self.bubbleNode
end

local function EnterBuildRoad(self)
  self.state = BubbleState.Road
  self:HideBubbleNode()
end

local function ExitBuildRoad(self)
  self.state = BubbleState.Normal
  self:ShowBubbleNode()
end

local function GetBubbleNameByBubbleType(self, bubbleType)
  for k, v in pairs(BuildBubbleType) do
    if v == bubbleType then
      return k
    end
  end
end

local function GetParentNode(self, buildBubbleType)
  return self:GetBubbleNode().transform
end

local function ClearAll(self)
  self:DestroyAllTimer()
  for k, v in pairs(self.allBuildBubble) do
    self:DeleteBuildBubbleChild(k)
    self.allBuildBubble[k]:OnDestroy()
    self.allBuildBubble[k].request:Destroy()
  end
  for k, v in pairs(self.cacheModel) do
    for k1, v1 in pairs(v) do
      v1:OnDestroy()
      v1.request:Destroy()
    end
  end
  self.cacheModel = {}
  self.allBuildBubble = {}
  for k, v in pairs(self.loadingBuildBubble) do
    if v.request ~= nil then
      v.request:Destroy()
    end
  end
  self.loadingBuildBubble = {}
  self.bubbleNode = nil
  self:ClearAllNoRefresh()
end

local function AllianceMemberSignal()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.AllianceCareer)
end

local function RefreshAllianceCareerSignal()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.AllianceCareer)
end

local function MainLvUpSignal()
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_PARKINGLOT)
  if buildData then
    DataCenter.BuildBubbleManager:CheckShowBubble(buildData.uuid)
  end
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_PARKINGLOT_TWO)
  if buildData then
    DataCenter.BuildBubbleManager:CheckShowBubble(buildData.uuid)
  end
  buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_PARKINGLOT_THREE)
  if buildData then
    DataCenter.BuildBubbleManager:CheckShowBubble(buildData.uuid)
  end
  buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_PARKINGLOT_FOUR)
  if buildData then
    DataCenter.BuildBubbleManager:CheckShowBubble(buildData.uuid)
  end
  DataCenter.BuildBubbleManager:RefreshGolloesCampBubbleSignal()
  buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_SHOP)
  if buildData then
    DataCenter.BuildBubbleManager:CheckShowBubble(buildData.uuid)
  end
  buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_COUNT_BATTLE)
  if buildData then
    DataCenter.BuildBubbleManager:CheckShowBubble(buildData.uuid)
  end
end

local function NoRefreshSignal(uuid)
  DataCenter.BuildBubbleManager:SetNoRefresh(uuid)
end

local function SetNoRefresh(self, uuid)
  self:ClearOneNoRefresh(uuid)
  if self.noRefreshTimer[uuid] == nil then
    self.noRefreshTimer[uuid] = TimerManager:GetInstance():GetTimer(NoRefreshTime, self.noRefreshTimerCallBack, uuid, true, false, false)
    self.noRefreshTimer[uuid]:Start()
  end
end

local function ClearOneNoRefresh(self, uuid)
  if self.noRefreshTimer[uuid] ~= nil then
    self.noRefreshTimer[uuid]:Stop()
    self.noRefreshTimer[uuid] = nil
  end
end

local function NoRefreshTimerCallBack(self, uuid)
  if self.noRefreshTimer[uuid] ~= nil then
    self:ClearOneNoRefresh(uuid)
    self:CheckShowBubble(uuid)
  end
end

local function ClearAllNoRefresh(self)
  if self.noRefreshTimer ~= nil then
    for k, v in pairs(self.noRefreshTimer) do
      v:Stop()
    end
    self.noRefreshTimer = {}
  end
end

function BuildBubbleManager:AddGetResourceRefreshTimer()
  if self.getResourceRefreshTimer == nil and self:GetBubbleCountByBubbleType(BuildBubbleType.GetResource) > 0 then
    self.getResourceRefreshTimer = TimerManager:GetInstance():GetTimer(GetResourceRefreshTime, self.get_resource_refresh_timer_callback, self, false, false, false)
    self.getResourceRefreshTimer:Start()
  end
end

function BuildBubbleManager:OnWorldTrendEventDataUpdate()
  local bUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_WORLDTREND)
  if buildData ~= nil then
    bUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(bUuid)
end

function BuildBubbleManager:DeleteGetResourceRefreshTimer()
  if self.getResourceRefreshTimer ~= nil and self:GetBubbleCountByBubbleType(BuildBubbleType.GetResource) == 0 then
    self.getResourceRefreshTimer:Stop()
    self.getResourceRefreshTimer = nil
  end
end

function BuildBubbleManager:GetResourceRefreshCallBack()
  for k, v in pairs(self.allBuildBubble) do
    if v.param.buildBubbleType == BuildBubbleType.GetResource then
      v:Refresh()
    end
  end
end

function BuildBubbleManager:GetBubbleCountByBubbleType(bubbleType)
  local result = 0
  if self.allBuildBubble ~= nil then
    for k, v in pairs(self.allBuildBubble) do
      if v.param.buildBubbleType == bubbleType then
        result = result + 1
      end
    end
  end
  return result
end

function BuildBubbleManager:OnParkourUpdate()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.ParkourBattle)
end

function BuildBubbleManager:OnRefreshFirstPayState()
  local bUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_FIRST_PAY)
  if buildData ~= nil then
    bUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(bUuid)
end

function BuildBubbleManager:OnPVPArenaInfoUpdate()
  local bUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_PVP_ARENA)
  if buildData ~= nil then
    bUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(bUuid)
end

function BuildBubbleManager:RefreshCityState()
  local bUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_GATE)
  if buildData ~= nil then
    bUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(bUuid)
end

function BuildBubbleManager:OnRefreshGiftPackage()
  local buildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_GIFT_PACKAGE)
  for _, v in ipairs(buildDataList) do
    DataCenter.BuildBubbleManager:CheckShowBubble(v.uuid)
  end
end

function BuildBubbleManager:OnRefreshTrailTowerBubble()
  local buildDataList
  if DataCenter.LWTrailTowerManager:ShowAlertTowerEntrance() then
    buildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_ALERTTOWER)
  else
    buildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_COUNT_BATTLE)
  end
  for _, v in ipairs(buildDataList) do
    DataCenter.BuildBubbleManager:CheckShowBubble(v.uuid)
  end
end

function BuildBubbleManager:OnDecorateRedPointSignal()
  local buildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_DECORATION_EXHIBITION)
  for _, v in ipairs(buildDataList) do
    DataCenter.BuildBubbleManager:CheckShowBubble(v.uuid)
  end
end

function BuildBubbleManager:OnReadNewComicCallBack()
  local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(BuildingTypes.LW_BUILD_WORLDTREND, false)
  local uuid = buildData and buildData.uuid or 0
  DataCenter.BuildBubbleManager:CheckShowBubble(uuid)
end

function BuildBubbleManager:OnTWSkillChipUpdate()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.TWSkillChip)
end

function BuildBubbleManager:OnRefreshDispatchTaskBubble()
  local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(BuildingTypes.LW_BUILD_DISPATCH_TASK, false)
  local uuid = buildData and buildData.uuid or 0
  DataCenter.BuildBubbleManager:CheckShowBubble(uuid)
end

function BuildBubbleManager:OnSeasonWeekCardDataUpdate()
  local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(BuildingTypes.LW_BUILDING_SEASON_FARMLAND_CTIY_4, false)
  if buildData then
    local uuid = buildData.uuid
    DataCenter.BuildBubbleManager:CheckShowBubble(uuid)
  end
  buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(BuildingTypes.LW_BUILDING_SEASON5_CTIY_5, false)
  if buildData then
    local uuid = buildData.uuid
    DataCenter.BuildBubbleManager:CheckShowBubble(uuid)
  end
  buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(BuildingTypes.LW_BUILDING_SEASON2_FARMLAND_CTIY_5, false)
  if buildData then
    local uuid = buildData.uuid
    DataCenter.BuildBubbleManager:CheckShowBubble(uuid)
  end
  buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(BuildingTypes.LW_BUILDING_BLESSING_FOUNTAIN_5, false)
  if buildData then
    local uuid = buildData.uuid
    DataCenter.BuildBubbleManager:CheckShowBubble(uuid)
  end
  buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(BuildingTypes.LW_BUILD_SEASON4_WEEK_CARD, false)
  if buildData then
    local uuid = buildData.uuid
    DataCenter.BuildBubbleManager:CheckShowBubble(uuid)
  end
end

local function OnDecorationPlaySoundStart(buildId)
  local buildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
  for _, v in ipairs(buildDataList) do
    DataCenter.BuildBubbleManager:CheckShowBubble(v.uuid)
  end
end

local function OnDecorationPlaySoundStop(buildId)
  local buildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
  for _, v in ipairs(buildDataList) do
    DataCenter.BuildBubbleManager:CheckShowBubble(v.uuid)
  end
end

local function OnBlackMarketUpdate()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.BlackMarket)
end

local function OnPersonalFurnaceStateChange()
  local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(BuildingTypes.LW_BUILDING_SEASON2_PERSONAL_FURNACE, false)
  if buildData then
    local uuid = buildData.uuid
    DataCenter.BuildBubbleManager:CheckShowBubble(uuid)
  end
end

local function OnDecorationNumChange()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.DecoratorExhibition)
end

function BuildBubbleManager.OnGetUserInfoSuccess(uid)
  if uid ~= LuaEntry.Player.uid then
    return
  end
  local buildings = DataCenter.BuildManager.buildIdBuilding[BuildingTypes.FUND_BUILD_ALLIANCE_CENTER]
  if buildings ~= nil and #buildings == 1 then
    DataCenter.BuildBubbleManager:CheckShowBubble(buildings[1].uuid)
  end
end

function BuildBubbleManager.OnHighFiveReceive(data)
  if data.uid ~= LuaEntry.Player.uid then
    return
  end
  local buildings = DataCenter.BuildManager.buildIdBuilding[BuildingTypes.FUND_BUILD_ALLIANCE_CENTER]
  if buildings ~= nil and #buildings == 1 then
    DataCenter.BuildBubbleManager:CheckShowBubble(buildings[1].uuid)
  end
end

function BuildBubbleManager.OnRefreshCoffeeBubble()
  local buildUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILDING_SEASON5_RESEARCH)
  if buildData then
    buildUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(buildUuid)
end

function BuildBubbleManager:OnRefreshFishBubble()
  local buildUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_SEASON6_INSTITUTE)
  if buildData then
    buildUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(buildUuid)
end

function BuildBubbleManager.DoSeasonWeekCardBubbleRefresh()
  local dict = BuildingUtils.GetSeasonWeekCardCityBuildingMap()
  if dict then
    for buildId, _ in pairs(dict) do
      local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
      if buildData ~= nil and buildData.uuid ~= nil then
        DataCenter.BuildBubbleManager:CheckShowBubble(buildData.uuid)
      end
    end
  end
end

local function OnGuideDone(guideId)
  if DataCenter.T11IdleGameManager:IsT11GuideId(guideId) then
    DataCenter.BuildBubbleManager:OnT11IdleGameBubbleChanged()
  end
end

function BuildBubbleManager:RefreshCivilizationSparkBubbleSignal()
  local buildUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_CIVILIZATION_SPARK)
  if buildData then
    buildUuid = buildData.uuid
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(buildUuid)
end

local function RefreshPopupActivityBubble()
  DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.BuildingMainPopupActivity)
end

BuildBubbleManager.__init = __init
BuildBubbleManager.__delete = __delete
BuildBubbleManager.Startup = Startup
BuildBubbleManager.AddListener = AddListener
BuildBubbleManager.RemoveListener = RemoveListener
BuildBubbleManager.CompareBuildType = CompareBuildType
BuildBubbleManager.OnHeroStationUpdateSignal = OnHeroStationUpdateSignal
BuildBubbleManager.OnBuildTrainingStartSignal = OnBuildTrainingStartSignal
BuildBubbleManager.OnScienceQueueResearchSignal = OnScienceQueueResearchSignal
BuildBubbleManager.HospitalStartSignal = HospitalStartSignal
BuildBubbleManager.BuildInViewSignal = BuildInViewSignal
BuildBubbleManager.BuildOutViewSignal = BuildOutViewSignal
BuildBubbleManager.QueueTimeEndSignal = QueueTimeEndSignal
BuildBubbleManager.GetBuildBubbleTypeListByBuildType = GetBuildBubbleTypeListByBuildType
BuildBubbleManager.GetBuildNeedShowBuildBubble = GetBuildNeedShowBuildBubble
BuildBubbleManager.DeleteOneBuildBubble = DeleteOneBuildBubble
BuildBubbleManager.ShowOneBuildBubble = ShowOneBuildBubble
BuildBubbleManager.UpdateBuildBubblePosition = UpdateBuildBubblePosition
BuildBubbleManager.OnClickCallBack = OnClickCallBack
BuildBubbleManager.OnBuildTrainingFinishSignal = OnBuildTrainingFinishSignal
BuildBubbleManager.OnScienceQueueFinishSignal = OnScienceQueueFinishSignal
BuildBubbleManager.RefreshBubbleByQueueType = RefreshBubbleByQueueType
BuildBubbleManager.HospitalFinishSignal = HospitalFinishSignal
BuildBubbleManager.OnHospitalUpdateSignal = OnHospitalUpdateSignal
BuildBubbleManager.OnAllianceHelpCallBack = OnAllianceHelpCallBack
BuildBubbleManager.RefreshResidentOrderSignal = RefreshResidentOrderSignal
BuildBubbleManager.RefreshResourceItemSignal = RefreshResourceItemSignal
BuildBubbleManager.RefreshEarthOrderSignal = RefreshEarthOrderSignal
BuildBubbleManager.OnBuildGatherSecondProductSignal = OnBuildGatherSecondProductSignal
BuildBubbleManager.OnBuildSecondProductCreateSignal = OnBuildSecondProductCreateSignal
BuildBubbleManager.OnFoodFactoryProductCreateSignal = OnFoodFactoryProductCreateSignal
BuildBubbleManager.OnFoodFactoryGatherProductSignal = OnFoodFactoryGatherProductSignal
BuildBubbleManager.GatherResourceItemFinishSignal = GatherResourceItemFinishSignal
BuildBubbleManager.GetBubblePosition = GetBubblePosition
BuildBubbleManager.CheckShowBubble = CheckShowBubble
BuildBubbleManager.DoCheckShowBubble = DoCheckShowBubble
BuildBubbleManager.AddOneBubbleTimer = AddOneBubbleTimer
BuildBubbleManager.RemoveOneBubbleTimer = RemoveOneBubbleTimer
BuildBubbleManager.BubbleTimerCallBack = BubbleTimerCallBack
BuildBubbleManager.DestroyAllTimer = DestroyAllTimer
BuildBubbleManager.UpdateBuildDataSignal = UpdateBuildDataSignal
BuildBubbleManager.GetBgScale = GetBgScale
BuildBubbleManager.GetIconScale = GetIconScale
BuildBubbleManager.DeleteBuildBubbleChild = DeleteBuildBubbleChild
BuildBubbleManager.GetFactoryDataSignal = GetFactoryDataSignal
BuildBubbleManager.GetBuildListByBubbleType = GetBuildListByBubbleType
BuildBubbleManager.CheckShowByBubbleType = CheckShowByBubbleType
BuildBubbleManager.CheckDetectEventSignal = CheckDetectEventSignal
BuildBubbleManager.CheckMasterySignal = CheckMasterySignal
BuildBubbleManager.CheckWorkerUpSignal = CheckWorkerUpSignal
BuildBubbleManager.CheckGiftVoucherSignal = CheckGiftVoucherSignal
BuildBubbleManager.CheckIfHasAllianceBuild = CheckIfHasAllianceBuild
BuildBubbleManager.OnCheckPubBubble = OnCheckPubBubble
BuildBubbleManager.OnCheckPubShopBubble = OnCheckPubShopBubble
BuildBubbleManager.BuildTimeEndSignal = BuildTimeEndSignal
BuildBubbleManager.GetBubbleObjByBubbleTypeAndBuildId = GetBubbleObjByBubbleTypeAndBuildId
BuildBubbleManager.GetBubbleObjByBuildUuid = GetBubbleObjByBuildUuid
BuildBubbleManager.RefreshItemsSignal = RefreshItemsSignal
BuildBubbleManager.RefreshAllianceBattleSignal = RefreshAllianceBattleSignal
BuildBubbleManager.UpdateAllianceSignal = UpdateAllianceSignal
BuildBubbleManager.RefreshGroceryStoreOrderSignal = RefreshGroceryStoreOrderSignal
BuildBubbleManager.RefreshGolloesCampBubbleSignal = RefreshGolloesCampBubbleSignal
BuildBubbleManager.RefreshWeekCardBubbleSignal = RefreshWeekCardBubbleSignal
BuildBubbleManager.OnPassDaySignal = OnPassDaySignal
BuildBubbleManager.FeedAnimalSignal = FeedAnimalSignal
BuildBubbleManager.PasturePanelSignal = PasturePanelSignal
BuildBubbleManager.RefreshRecommendShowSignal = RefreshRecommendShowSignal
BuildBubbleManager.RefreshBubbleShow = RefreshBubbleShow
BuildBubbleManager.SetShowBuildBubble = SetShowBuildBubble
BuildBubbleManager.ShowPastureBubble = ShowPastureBubble
BuildBubbleManager.HidePastureBubble = HidePastureBubble
BuildBubbleManager.RefreshGuideSignal = RefreshGuideSignal
BuildBubbleManager.UpdateMarchItemSignal = UpdateMarchItemSignal
BuildBubbleManager.ChangeCameraLodSignal = ChangeCameraLodSignal
BuildBubbleManager.UpdateLod = UpdateLod
BuildBubbleManager.ShowBubbleNode = ShowBubbleNode
BuildBubbleManager.HideBubbleNode = HideBubbleNode
BuildBubbleManager.RefreshBubbleNode = RefreshBubbleNode
BuildBubbleManager.GetBubbleNode = GetBubbleNode
BuildBubbleManager.RefreshAssistanceBubble = RefreshAssistanceBubble
BuildBubbleManager.EnterBuildRoad = EnterBuildRoad
BuildBubbleManager.ExitBuildRoad = ExitBuildRoad
BuildBubbleManager.UpdateKonbiniSignal = UpdateKonbiniSignal
BuildBubbleManager.GetBubbleNameByBubbleType = GetBubbleNameByBubbleType
BuildBubbleManager.GetParentNode = GetParentNode
BuildBubbleManager.BuildFixTimeEndSignal = BuildFixTimeEndSignal
BuildBubbleManager.OnAllianceFixHelpCallBack = OnAllianceFixHelpCallBack
BuildBubbleManager.ClearAll = ClearAll
BuildBubbleManager.QueueHeroFreeTime = QueueHeroFreeTime
BuildBubbleManager.RefreshWorldTrendSignal = RefreshWorldTrendSignal
BuildBubbleManager.UpdateMarchSignal = UpdateMarchSignal
BuildBubbleManager.ResourceUpdatedSignal = ResourceUpdatedSignal
BuildBubbleManager.RefreshGolloesMcBubbleSignal = RefreshGolloesMcBubbleSignal
BuildBubbleManager.AllianceMemberSignal = AllianceMemberSignal
BuildBubbleManager.RefreshAllianceCareerSignal = RefreshAllianceCareerSignal
BuildBubbleManager.MainLvUpSignal = MainLvUpSignal
BuildBubbleManager.NoRefreshSignal = NoRefreshSignal
BuildBubbleManager.SetNoRefresh = SetNoRefresh
BuildBubbleManager.ClearOneNoRefresh = ClearOneNoRefresh
BuildBubbleManager.NoRefreshTimerCallBack = NoRefreshTimerCallBack
BuildBubbleManager.ClearAllNoRefresh = ClearAllNoRefresh
BuildBubbleManager.CheckShowBuildUpgrade = CheckShowBuildUpgrade
BuildBubbleManager.CheckBuildUpgradeReward = CheckBuildUpgradeReward
BuildBubbleManager.CheckTalentSignal = CheckTalentSignal
BuildBubbleManager.CheckHeroBountySignal = CheckHeroBountySignal
BuildBubbleManager.EnergyOrderRefreshSignal = EnergyOrderRefreshSignal
BuildBubbleManager.ProductLineUpdateSignal = ProductLineUpdateSignal
BuildBubbleManager.BuildingHeroDispatchingSignal = BuildingHeroDispatchingSignal
BuildBubbleManager.OnUnlockArmy = OnUnlockArmy
BuildBubbleManager.RefreshCheckUpgradeList = RefreshCheckUpgradeList
BuildBubbleManager.OnBuildUpLevel = OnBuildUpLevel
BuildBubbleManager.RefreshParkourBubble = RefreshParkourBubble
BuildBubbleManager.OnItemRefreshed = OnItemRefreshed
BuildBubbleManager.OnCommonEquipUpdateSignal = OnCommonEquipUpdateSignal
BuildBubbleManager.OnHeroHonorLevelUpgrade = OnHeroHonorLevelUpgrade
BuildBubbleManager.OnHeroFragmentItemChange = OnHeroFragmentItemChange
BuildBubbleManager.OnTacticalWeaponBubbleUpdateSignal = OnTacticalWeaponBubbleUpdateSignal
BuildBubbleManager.OnTWSkillChipUnlockCountDownSignal = OnTWSkillChipUnlockCountDownSignal
BuildBubbleManager.OnDecorationPlaySoundStop = OnDecorationPlaySoundStop
BuildBubbleManager.OnDecorationPlaySoundStart = OnDecorationPlaySoundStart
BuildBubbleManager.OnRefreshRebirthHospital = OnRefreshRebirthHospital
BuildBubbleManager.OnBlackMarketUpdate = OnBlackMarketUpdate
BuildBubbleManager.OnPersonalFurnaceStateChange = OnPersonalFurnaceStateChange
BuildBubbleManager.OnHeroLotteryBubbleUpdate = OnHeroLotteryBubbleUpdate
BuildBubbleManager.UpdateSeasonDeathSoldierInfo = UpdateSeasonDeathSoldierInfo
BuildBubbleManager.OnDominatorMainBuildingRedChanged = OnDominatorMainBuildingRedChanged
BuildBubbleManager.OnT11IdleGameBubbleChanged = OnT11IdleGameBubbleChanged
BuildBubbleManager.OnDecorationNumChange = OnDecorationNumChange
BuildBubbleManager.HidePastureBubbleWithShow = HidePastureBubbleWithShow
BuildBubbleManager.RefreshDecorationShopBubble = RefreshDecorationShopBubble
BuildBubbleManager.RefreshT11BuildingBubbleSignal = RefreshT11BuildingBubbleSignal
BuildBubbleManager.UpdateRaceEntranceBubble = UpdateRaceEntranceBubble
BuildBubbleManager.RefreshSoldierBuildingBubble = RefreshSoldierBuildingBubble
BuildBubbleManager.OnGuideDone = OnGuideDone
BuildBubbleManager.RefreshT11IdleGameBubble = RefreshT11IdleGameBubble
BuildBubbleManager.RefreshSeasonTowerBubble = RefreshSeasonTowerBubble
BuildBubbleManager.RefreshPopupActivityBubble = RefreshPopupActivityBubble
return BuildBubbleManager
