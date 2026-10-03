local UIMainBottom = BaseClass("UIMainBottom", UIBaseContainer)
local base = UIBaseContainer
local Resource = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local DataCenter = _ENV.DataCenter
local MainAllianceBubbles = require("UI.LWMainUI.Component.UIMainBottom.MainAllianceBubbles")
local BuildBubbleTip = require("UI.BuildBubbleTip.View.BuildBubbleTip")
local UIMainBtnItem = require("UI.LWMainUI.Component.UIMainBottom.UIMainBtnItem")
local UIMainAisillaBubbleItem = require("UI.LWMainUI.Component.UIMainBottom.UIMainAisillaBubbleItem")
local UIMainAlarmObj = require("UI.LWMainUI.Component.UIMainBottom.UIMainAlarmObj")
local UIMainChangeScene = require("UI.LWMainUI.Component.UIMainBottom.UIMainChangeScene")
local UIMainChatItem = require("UI.LWMainUI.Component.UIMainBottom.UIMainChatItem")
local UIMainAllianceWarTip = require("UI.LWMainUI.Component.UIMainBottom.UIMainAllianceWarTip")
local UILWAlMailTip = require("UI.LWMainUI.Component.UIMainBottom.UILWAlMailTip")
local UIMainBuildItem = require("UI.LWMainUI.Component.UIMainBottom.LeftLayoutBtns.UIMainBLBtnBuild")
local UIMainDropItem = require("UI.LWMainUI.Component.UIMainBottom.LeftLayoutBtns.UIMainBLBtnDrop")
local UIMainRadarItem = require("UI.LWMainUI.Component.UIMainBottom.LeftLayoutBtns.UIMainBLBtnRadar")
local UIMainVisitorItem = require("UI.LWMainUI.Component.UIMainBottom.LeftLayoutBtns.UIMainBLBtnVisitor")
local UIMainSearchItem = require("UI.LWMainUI.Component.UIMainBottom.LeftLayoutBtns.UIMainBLBtnSearch")
local UIMainBLBtnTrain = require("UI.LWMainUI.Component.UIMainBottom.LeftLayoutBtns.UIMainBLBtnTrain")
local UIMainBLBtnSeasonBuild = require("UI.LWMainUI.Component.UIMainBottom.LeftLayoutBtns.UIMainBLBtnSeasonBuild")
local UIMainBLBtnTruck = require("UI.LWMainUI.Component.UIMainBottom.LeftLayoutBtns.UIMainBLBtnTruck")
local UIMainCureBtnItem = require("UI.LWMainUI.Component.UIMainBottom.UIMainCureBtnItem")
local UIMainKillZombie = require("UI.LWMainUI.Component.UIMainBottom.UIMainKillZombie")
local UIMainQuest = require("UI.LWMainUI.Component.UIMainBottom.UIMainQuest")
local UIMainQuestMsg = require("UI.LWMainUI.Component.UIMainBottom.UIMainQuestMsg")
local UIMainQuestItem = require("UI.LWMainUI.Component.UIMainBottom.UIMainQuestItem")
local UIMainDispatchTask = require("UI.LWMainUI.Component.UIMainBottom.UIMainDispatchTask")
local MarchDisplaySettings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
local UIMainWinterStormMatching = require("UI.LWMainUI.Component.UIMainBottom.UIMainWinterStormMatching")
local UIMainWinterStormTipMainBtn = require("UI.LWMainUI.Component.UIMainBottom.UIMainWinterStormTipMainBtn")
local UIMainReturnQuestionnaireBtn = require("UI.LWMainUI.Component.UIMainBottom.UIMainReturnQuestionnaireBtn")
local UIMainRaceEntranceTipBtn = require("UI.LWMainUI.Component.UIMainBottom.UIMainRaceEntranceTipBtn")
local UIMainLLGroupInvitationBtn = require("UI.Landlord.UIMainLLGroupInvitationBtn")
local UIMainLLBattleTipBtn = require("UI.Landlord.UIMainLLBattleTipBtn")
local UIMainChampionDuelSignTipBtn = require("UI.LWMainUI.Component.UIMainBottom.UIMainChampionDuelSignTipBtn")
local UIMainQueenOfBloodTipBtn = require("UI.LWMainUI.Component.UIMainBottom.UIMainQueenOfBloodTipBtn")
local UIMainTempObj = require("UI.LWMainUI.Component.UIMainBottom.UIMainTempObj")
local UIMainSandWormObj = require("UI.LWMainUI.Component.UIMainBottom.UIMainSandWormObj")
local ActMigrationMainBtn = require("UI.LWUIMigration.Component.LWUIMigrationView_MainBtn")
local LuckyPacketShareTipBtn = require("UI.LWMainUI.Component.UIMainBottom.LuckyPacketShareTipBtn")
local UIMainBtnLockHart = require("UI.LWMainUI.Component.UIMainBottom.UIMainBtnLockHart")
local LWMainUIPopupNotificationItemRender = require("UI.LWMainUI.Component.UIMainBottom.LWMainUIPopupNotificationItemRender")
local AlChallengeBossBubbleItem = require("UI.LWMainUI.Component.UIMainBottom.AlChallengeBossBubbleItem")
local NEW_AL_CHALLENGE_BUBBLE_PATH = "Assets/Main/Prefabs/UI/LWMainUI/AlChallengeBossBubble.prefab"
local UIMainHeroTrialMissileEnergyComponent = require("UI.LWMainUI.Component.UIMainBottom.UIMainHeroTrialMissileEnergyComponent")
local UIMainHeroTrialMissileEnergyPath = "Assets/Main/Prefabs/UI/LWMainUI/UIMainHeroTrialMissileEnergy.prefab"
local LWMainUIPopupNotificationItemPath = "Assets/Main/Prefabs/UI/LWMainUI/LWMainUIPopupNotificationItem.prefab"
local left_btn_layout_path = "LeftBtnLayout"
local drop_obj_path = "LeftBtnLayout/dropObj"
local visitor_obj_path = "LeftBtnLayout/visitorObj"
local detect_obj_path = "LeftBtnLayout/detectObj"
local build_obj_path = "LeftBtnLayout/buildObj"
local search_obj_path = "LeftBtnLayout/searchObj"
local season_build_obj_path = "LeftBtnLayout/seasonBuildObj"
local mail_obj_path = "RightBtnLayout/mailObj"
local alliance_obj_path = "RightBtnLayout/allianceObj"
local alliance_obj_name_path = "RightBtnLayout/allianceObj/allianceName"
local alliance_bubbles_path = "RightBtnLayout/allianceObj/AllianceBubbles"
local bag_obj_path = "RightBtnLayout/bagObj"
local UiLWAlMailTip_path = "RightBtnLayout/mailObj/UiLWAlMailTip"
local rally_tip_obj_path = "RightBtnLayout/rallyTipObj"
local chat_obj_path = "chatObj"
local pve_test_scene_btn_path = "BattleBtn/buildBtn"
local change_scene_path = "WorldBtn"
local hero_obj_path = "heroObj"
local msglist_content_path = "msglist/viewport/content"
local msg_layout_path = "msglist"
local questMsg_path = "QuestMsgMask/questMsg"
local questTip_obj_path = "QuestMsgMask"
local heroExpEffect = "heroObj/heroExpEffect"
local heroBubble = "heroObj/bubble"
local heroIcon = "heroObj/bubble/headPlayer/heroIcon"
local quest_obj_path = "questObj"
local quest_finger_path = "questFingerRoot/questFinger"
local dispatch_obj_path = "LeftBtnLayout/dispatchObj"
local march_display_downgrade_tip_path = "LeftTipLayout/MarchDowngradeTips"
local curIndex = 2
local objHeight = 100
local layoutSpacing = 5
local GuideEndWaitShowQuestTime = 0.8
local hideDelay = 3
local SAND_WORM_SYNC_CD = 5
local FIRST_JOIN_ALLIANCE_PLOT_ID = 12345

function UIMainBottom:OnCreate()
  base.OnCreate(self)
  local ok, errorMsg = pcall(function()
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
  end)
  if not ok and errorMsg then
    Logger.LogError(errorMsg)
  end
end

function UIMainBottom:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  self:ClearFingerHandle()
  base.OnDestroy(self)
end

function UIMainBottom:OnEnable()
  base.OnEnable(self)
  if self.killZombie ~= nil then
    self.killZombie:OnEnable()
  end
  self:MainTaskRefresh()
  self:ShowOrHideTempObj()
  self:ShowOrHideSandWorm()
  self:ShowOrHideJungleTrial()
  self:ShowOrHideWolfShadow()
  self:RefreshFingerLogic()
end

function UIMainBottom:OnDisable()
  if self.killZombie ~= nil then
    self.killZombie:OnDisable()
  end
  base.OnDisable(self)
end

function UIMainBottom:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChapterTask, self.ChapterTaskRefresh)
  self:AddUIListener(EventId.MainTaskUpdate, self.ChapterTaskRefresh)
  self:AddUIListener(EventId.RefreshMainAlEvent, self.RefreshAlBtns)
  self:AddUIListener(EventId.AllianceQuitOK, self.OnAllianceQuitOK)
  self:AddUIListener(EventId.UpdateAllianceGiftNum, self.RefreshAlBtns)
  self:AddUIListener(EventId.AllianceWarNew, self.OnRefreshAllianceWarTip)
  self:AddUIListener(EventId.DetectEventComp, self.OnGetDetectEventCompMsg)
  self:AddUIListener(EventId.UpdateMainUIRallyTipRedPoint, self.OnCheckRallyTipRedPoint)
  self:AddUIListener(EventId.ALLIANCE_WAR_DELETE, self.OnCheckRallyTipRedPoint)
  self:AddUIListener(EventId.RefreshBagRedDot, self.RefreshBagRedDot)
  self:AddUIListener(EventId.BuildUpgradeBonusClose, self.ShowHeroUpLevelBubble)
  self:AddUIListener(EventId.AcquireHeroExp_FlyEnd, self.ShowHeroExpEffect)
  self:AddUIListener(EventId.WorldMarchUpdateDisplayMode, self.OnWorldMarchUpdateDisplayMode)
  self:AddUIListener(EventId.AllianceWarUpdate, self.AllianceWarDataUpdate)
  self:AddUIListener(EventId.MyBaseTemperatureInit, self.ShowOrHideTempObj)
  self:AddUIListener(EventId.SandWormActivityRefresh, self.ShowOrHideSandWorm)
  self:AddUIListener(EventId.JungleTrialMonsterRefresh, self.ShowOrHideJungleTrial)
  self:AddUIListener(EventId.WolfShadowRefresh, self.ShowOrHideWolfShadow)
  self:AddUIListener(EventId.WinterStormInfoRefresh, self.CheckWinterStormMatching)
  self:AddUIListener(EventId.WinterStormMatchRefresh, self.CheckWinterStormMatching)
  self:AddUIListener(EventId.ActMigrationInfoUpdate, self.CheckActMigration)
  self:AddUIListener(EventId.NoInputShowArrow, self.ShowFingerLogic)
  self:AddUIListener(EventId.StopShowQuestArrow, self.StopShowFingerLogic)
  self:AddUIListener(EventId.OnNewAllianceChallengeDonateInfoRefresh, self.RefreshNewAllianceChallengeDonateInfo)
  self:AddUIListener(EventId.ChallengeZombieNewAlDataChanged, self.RefreshNewAllianceChallengeDonateInfo)
  self:AddUIListener(EventId.RefreshRaceEntrance, self.CheckRaceEntranceTip)
  self:AddUIListener(EventId.LandlordActInfoRefresh, self.CheckLLGroupInvitation)
  self:AddUIListener(EventId.LandlordActStageChange, self.CheckLLBattleTip)
  self:AddUIListener(EventId.OnFinishHandleInitMsg, self.CheckLLBattleTip)
  self:AddUIListener(EventId.ChampionDuelUIRefresh, self.CheckChampionDuelSignTip)
  self:AddUIListener(EventId.ChampionDuelUpdateSigned, self.CheckChampionDuelSignTip)
  self:AddUIListener(EventId.MainLvUp, self.OnMainLevelUp)
  self:AddUIListener(EventId.UIPrivacy_Confirm, self.RefreshCoppaLimitChat)
  self:AddUIListener(EventId.RefreshMainQueenOfBloodTip, self.CheckQueenOfBloodTip)
  self:AddUIListener(EventId.OnDailySalaryChange, self.RefreshAllianceRedDot)
  self:AddUIListener(EventId.MeteoriteFuckIReceivedEnterWorldMessage, self.RefreshMeteoriteBtn)
  self:AddUIListener(EventId.LUCKY_PACKET_GAIN, self.RefreshLuckyPacketShareTip)
  self:AddUIListener(EventId.QuestionnaireDataMainUIRefresh, self.CheckReturnQuestionnaireTip)
  self:AddUIListener(EventId.Al_LockHartActivityTip, self.RefreshLockHartActivityTip)
  self:AddUIListener(EventId.CampScienceRefreshRed, self.RefreshAllianceRedDot)
  self:AddUIListener(EventId.RefreshMainUIPopupNotificationView, self.RefreshShowPopupNotificationBubble)
end

function UIMainBottom:OnRemoveListener()
  self:RemoveUIListener(EventId.ChapterTask, self.ChapterTaskRefresh)
  self:RemoveUIListener(EventId.MainTaskUpdate, self.ChapterTaskRefresh)
  self:RemoveUIListener(EventId.RefreshMainAlEvent, self.RefreshAlBtns)
  self:RemoveUIListener(EventId.AllianceQuitOK, self.OnAllianceQuitOK)
  self:RemoveUIListener(EventId.UpdateAllianceGiftNum, self.RefreshAlBtns)
  self:RemoveUIListener(EventId.AllianceWarNew, self.OnRefreshAllianceWarTip)
  self:RemoveUIListener(EventId.DetectEventComp, self.OnGetDetectEventCompMsg)
  self:RemoveUIListener(EventId.UpdateMainUIRallyTipRedPoint, self.OnCheckRallyTipRedPoint)
  self:RemoveUIListener(EventId.RefreshBagRedDot, self.RefreshBagRedDot)
  self:RemoveUIListener(EventId.BuildUpgradeBonusClose, self.ShowHeroUpLevelBubble)
  self:RemoveUIListener(EventId.AcquireHeroExp_FlyEnd, self.ShowHeroExpEffect)
  self:RemoveUIListener(EventId.WorldMarchUpdateDisplayMode, self.OnWorldMarchUpdateDisplayMode)
  self:RemoveUIListener(EventId.AllianceWarUpdate, self.AllianceWarDataUpdate)
  self:RemoveUIListener(EventId.MyBaseTemperatureInit, self.ShowOrHideTempObj)
  self:RemoveUIListener(EventId.SandWormActivityRefresh, self.ShowOrHideSandWorm)
  self:RemoveUIListener(EventId.JungleTrialMonsterRefresh, self.ShowOrHideJungleTrial)
  self:RemoveUIListener(EventId.WolfShadowRefresh, self.ShowOrHideWolfShadow)
  self:RemoveUIListener(EventId.WinterStormInfoRefresh, self.CheckWinterStormMatching)
  self:RemoveUIListener(EventId.WinterStormMatchRefresh, self.CheckWinterStormMatching)
  self:RemoveUIListener(EventId.ActMigrationInfoUpdate, self.CheckActMigration)
  self:RemoveUIListener(EventId.NoInputShowArrow, self.ShowFingerLogic)
  self:RemoveUIListener(EventId.StopShowQuestArrow, self.StopShowFingerLogic)
  self:RemoveUIListener(EventId.OnNewAllianceChallengeDonateInfoRefresh, self.RefreshNewAllianceChallengeDonateInfo)
  self:RemoveUIListener(EventId.ChallengeZombieNewAlDataChanged, self.RefreshNewAllianceChallengeDonateInfo)
  self:RemoveUIListener(EventId.RefreshRaceEntrance, self.CheckRaceEntranceTip)
  self:RemoveUIListener(EventId.LandlordActInfoRefresh, self.CheckLLGroupInvitation)
  self:RemoveUIListener(EventId.LandlordActStageChange, self.CheckLLBattleTip)
  self:RemoveUIListener(EventId.OnFinishHandleInitMsg, self.CheckLLBattleTip)
  self:RemoveUIListener(EventId.ChampionDuelUIRefresh, self.CheckChampionDuelSignTip)
  self:RemoveUIListener(EventId.ChampionDuelUpdateSigned, self.CheckChampionDuelSignTip)
  self:RemoveUIListener(EventId.MainLvUp, self.OnMainLevelUp)
  self:RemoveUIListener(EventId.UIPrivacy_Confirm, self.RefreshCoppaLimitChat)
  self:RemoveUIListener(EventId.RefreshMainQueenOfBloodTip, self.CheckQueenOfBloodTip)
  self:RemoveUIListener(EventId.OnDailySalaryChange, self.RefreshAllianceRedDot)
  self:RemoveUIListener(EventId.MeteoriteFuckIReceivedEnterWorldMessage, self.RefreshMeteoriteBtn)
  self:RemoveUIListener(EventId.LUCKY_PACKET_GAIN, self.RefreshLuckyPacketShareTip)
  self:RemoveUIListener(EventId.QuestionnaireDataMainUIRefresh, self.CheckReturnQuestionnaireTip)
  self:RemoveUIListener(EventId.Al_LockHartActivityTip, self.RefreshLockHartActivityTip)
  self:RemoveUIListener(EventId.CampScienceRefreshRed, self.RefreshAllianceRedDot)
  self:RemoveUIListener(EventId.RefreshMainUIPopupNotificationView, self.RefreshShowPopupNotificationBubble)
  base.OnRemoveListener(self)
end

function UIMainBottom:ComponentDefine()
  self.view:RegisterFunctionUnlock(LWFunctionUnlockType.MainUI_Chat, self.gameObject)
  self.mail_obj = self:AddComponent(UIMainBtnItem, mail_obj_path)
  self.mail_obj:SetRedPointType(CommonRedPointPriority.Level1)
  self.mail_obj:ReInit(UIMainFunctionInfo.Mail)
  self.functionList[UIMainFunctionInfo.Mail] = self.mail_obj
  self.view:RegisterFunctionUnlock(LWFunctionUnlockType.MainUI_MailBtn, self.mail_obj)
  self.main_alliance_bubbles = self:AddComponent(MainAllianceBubbles, alliance_bubbles_path)
  self.alliance_obj = self:AddComponent(UIMainBtnItem, alliance_obj_path)
  self.alliance_obj:SetRedPointType(CommonRedPointPriority.Level1)
  self.alliance_obj:ReInit(UIMainFunctionInfo.Alliance)
  self.functionList[UIMainFunctionInfo.Alliance] = self.alliance_obj
  self.view:RegisterFunctionUnlock(LWFunctionUnlockType.MainUI_AllianceBtn, self.alliance_obj)
  self.allianceBtnName = self:AddComponent(UIText, alliance_obj_name_path)
  self.uiLWAlMailTip = self:AddComponent(UILWAlMailTip, UiLWAlMailTip_path)
  self.alarmObj = self:AddComponent(UIMainAlarmObj, "RightBtnLayout/alarmObj")
  self.alarmObj:ReInit(AlarmUIOpenType.MainUI)
  self.hero_obj = self:AddComponent(UIMainBtnItem, hero_obj_path)
  self.hero_obj:ReInit(UIMainFunctionInfo.Hero)
  self.functionList[UIMainFunctionInfo.Hero] = self.hero_obj
  self.bag_obj = self:AddComponent(UIMainBtnItem, bag_obj_path)
  self.bag_obj:ReInit(UIMainFunctionInfo.Goods)
  self.functionList[UIMainFunctionInfo.Goods] = self.bag_obj
  self.view:RegisterFunctionUnlock(LWFunctionUnlockType.MainUI_BagBtn, self.bag_obj)
  self.bagRedDot = self:AddComponent(UIImage, "RightBtnLayout/bagObj/bagRedPointNum")
  self.bagRedDotNumer = self:AddComponent(UIText, "RightBtnLayout/bagObj/bagRedPointNum/bagText")
  self.bubbleTipLayout = self:AddComponent(UIAsyncProxy, "LeftTipLayout/BubbleTipLayout")
  self.popup_notification_layout = self:AddComponent(UIBaseContainer, "LeftTipLayout/BubbleTipLayout/PopupNotificationLayOut")
  self.zombie_debug_btn = self:AddComponent(UIButton, pve_test_scene_btn_path)
  self.zombie_debug_btn:SetOnClick(BindCallback(self, self.OnClickPveVtn))
  self.invasionBtn = self:AddComponent(UIMainAisillaBubbleItem, "LeftTipLayout/BubbleTipLayout/InvasionBtn")
  self.invasionBtn:ReInit()
  self:ShowAlChallengeBossBubbleAsync()
  self.change_scene = self:AddComponent(UIMainChangeScene, change_scene_path)
  if self.transform:Find("LeftTipLayout/BubbleTipLayout/KillZombie") ~= nil then
    self.killZombie = self:AddComponent(UIMainKillZombie, "LeftTipLayout/BubbleTipLayout/KillZombie")
  end
  self.chat_obj = self:AddComponent(UIMainChatItem, chat_obj_path)
  if Config.IsPC() then
    CS.RectTransformUtils.AdjustWidthForCanvasScaler(self.chat_obj.rectTransform, CS.UnityEngine.TextAnchor.MiddleLeft)
  end
  self.chat_obj:ReInit()
  self.chatCoppaLimit = self:AddComponent(UIBaseContainer, "UIMain_chatCoppaLimit")
  self:RefreshCoppaLimitChat()
  self.questObj = self:AddComponent(UIMainQuestItem, quest_obj_path)
  self.questObj:RefreshState()
  self.questObj:RefreshRedPoint()
  self.fingerGo = self:AddComponent(UIBaseContainer, quest_finger_path)
  self.rally_tip_obj = self:AddComponent(UIMainAllianceWarTip, rally_tip_obj_path)
  self.build_obj = self:AddComponent(UIMainBuildItem, build_obj_path)
  self.build_obj:ReInit(UIMainFunctionInfo.Build, LWFunctionUnlockType.MainUI_BuildBtn)
  self.functionList[UIMainFunctionInfo.Build] = self.build_obj
  self.visitor_obj = self:AddComponent(UIMainVisitorItem, visitor_obj_path)
  self.visitor_obj:ReInit(UIMainFunctionInfo.Visitor, LWFunctionUnlockType.MainUI_VisitorBtn)
  self.functionList[UIMainFunctionInfo.Visitor] = self.visitor_obj
  self.detect_obj = self:AddComponent(UIMainRadarItem, detect_obj_path)
  self.detect_obj:ReInit(UIMainFunctionInfo.Detect, LWFunctionUnlockType.MainUI_DetectBtn)
  self.functionList[UIMainFunctionInfo.Detect] = self.detect_obj
  self.left_layout = self:AddComponent(UIBaseContainer, left_btn_layout_path)
  self.drop_obj = self:AddComponent(UIMainDropItem, drop_obj_path)
  self.drop_obj:ReInit(UIMainFunctionInfo.HeroDrop, LWFunctionUnlockType.MainUI_DropBtn)
  self.functionList[UIMainFunctionInfo.HeroDrop] = self.drop_obj
  self.search_obj = self:AddComponent(UIMainSearchItem, search_obj_path)
  self.search_obj:ReInit(UIMainFunctionInfo.Search, nil)
  self.functionList[UIMainFunctionInfo.Search] = self.search_obj
  self.train_obj = self:AddComponent(UIMainBLBtnTrain, "LeftBtnLayout/trainObj")
  self.train_obj:ReInit(UIMainFunctionInfo.Train, nil)
  self.functionList[UIMainFunctionInfo.Train] = self.train_obj
  if self.transform:Find(season_build_obj_path) ~= nil then
    self.season_build_obj = self:AddComponent(UIMainBLBtnSeasonBuild, season_build_obj_path)
    self.season_build_obj:ReInit(UIMainFunctionInfo.SeasonBuild, nil)
    self.functionList[UIMainFunctionInfo.SeasonBuild] = self.season_build_obj
  end
  self.truck_obj = self:AddComponent(UIMainBLBtnTruck, "LeftBtnLayout/truckObj")
  self.truck_obj:ReInit(UIMainFunctionInfo.Truck, nil)
  self.functionList[UIMainFunctionInfo.Truck] = self.truck_obj
  self.heroExpEffect = self.transform:Find(heroExpEffect):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
  self.heroBubble = self:AddComponent(UIBaseContainer, heroBubble)
  self.heroIcon = self:AddComponent(UIImage, heroIcon)
  if self.transform:Find(dispatch_obj_path) ~= nil then
    self.dispatch_obj = self:AddComponent(UIMainDispatchTask, dispatch_obj_path)
    self.dispatch_obj:ReInit(UIMainFunctionInfo.DispatchTask, nil)
    self.functionList[UIMainFunctionInfo.DispatchTask] = self.dispatch_obj
  end
  self.marchDisplayDowngradeTip = self:AddComponent(UIBaseContainer, march_display_downgrade_tip_path)
  self.txtMarchDisplayDowngradeTip = self:AddComponent(UIText, march_display_downgrade_tip_path .. "/txtMarchDowngradeTips")
  self.txtMarchDisplayDowngradeTip:SetLocalText("jianhuamoshi_tips_10003")
  self.boxMarchDisplayDowngradeTip = self:AddComponent(UIBaseContainer, march_display_downgrade_tip_path .. "/boxMarchDowngradeTips")
  self.marchDisplayDowngradeTipLayout = self.marchDisplayDowngradeTip.transform:GetComponent(typeof(CS.BidirectionalHorizontalLayoutGroup))
  if self.marchDisplayDowngradeTipLayout ~= nil then
    self.marchDisplayDowngradeTipLayout.padding.right = 6
    self.marchDisplayDowngradeTipLayout.padding.left = 6
  end
  if self.boxMarchDisplayDowngradeTip ~= nll then
    self.boxMarchDisplayDowngradeTip:SetActive(false)
  end
  self.mainCureBtn = self:AddComponent(UIMainCureBtnItem, "LeftTipLayout/BubbleTipLayout/cureBtn")
  self:OnWorldMarchUpdateDisplayMode()
  self:RefreshAlBtns()
  self:RefreshBagRedDot()
end

function UIMainBottom:OnMainLevelUp()
  self:RefreshCoppaLimitChat()
end

function UIMainBottom:RefreshCoppaLimitChat()
  local isCoppaLimit = CoppaUtil.IsCoppaLimit()
  if isCoppaLimit then
    self.chat_obj:SetActive(false)
    self.chatCoppaLimit:SetActive(true)
  else
    self.chat_obj:SetActive(true)
    self.chatCoppaLimit:SetActive(false)
  end
end

function UIMainBottom:RefreshBagRedDot()
  self:OnUpdateRedPot(UIMainFunctionInfo.Goods)
end

function UIMainBottom:ShowHeroExpEffect()
  self.heroExpEffect:Play()
end

function UIMainBottom:ShowHeroUpLevelBubble()
  if self.heroBubble.gameObject.activeSelf then
    return
  end
  local hero = self.view.ctrl:GetUpLevelHero()
  if hero then
    local iconPath = HeroUtils.GetHeroIconPath(hero.modelId, HeroIconType.small_icon)
    self.heroIcon:LoadSpriteAuto(iconPath)
    self.heroBubble:SetActive(true)
    self.heroBubbleDelay = TimerManager:GetInstance():DelayInvoke(function()
      self.heroBubble:SetActive(false)
      self.heroBubbleDelay = nil
    end, hideDelay)
  end
end

function UIMainBottom:ComponentDestroy()
  self:HideTemp()
  self:HideSandWorm()
  if self.winterReq ~= nil then
    self.winterReq:Destroy()
    self.winterReq = nil
  end
  if self.actMigrationReq ~= nil then
    self.actMigrationReq:Destroy()
    self.actMigrationReq = nil
  end
  self.actMigrationObj = nil
  if self.winterStormTipReq then
    self.winterStormTipReq:Destroy()
    self.winterStormTipReq = nil
  end
  if self.returnQuestionnaireTipReq then
    self.returnQuestionnaireTipReq:Destroy()
    self.returnQuestionnaireTipReq = nil
  end
  if self.ranceEntranceTipReq then
    self.ranceEntranceTipReq:Destroy()
    self.ranceEntranceTipReq = nil
  end
  if self.llGroupInvitationReq then
    self.llGroupInvitationReq:Destroy()
    self.llGroupInvitationReq = nil
  end
  if self.llBattleTipObjReq then
    self.llBattleTipObjReq:Destroy()
    self.llBattleTipObjReq = nil
  end
  if self.championDuelSignTipReq then
    self.championDuelSignTipReq:Destroy()
    self.championDuelSignTipReq = nil
  end
  if self.queenOfBloodTipReq then
    self.queenOfBloodTipReq:Destroy()
    self.queenOfBloodTipReq = nil
  end
  self.luckyPacketShareTipReq = nil
  self.lockHartTipReq = nil
  self.queenOfBloodTipObj = nil
  self.winterStormTipObj = nil
  self.returnQuestionnaireTipObj = nil
  self.raceEntranceTipObj = nil
  self.llGroupInvitationObj = nil
  self.llBattleTipObj = nil
  self.championDuelSignTipObj = nil
  self.visitor_obj = nil
  self.mail_obj = nil
  self.alliance_obj = nil
  self.hero_obj = nil
  self.bag_obj = nil
  self.zombie_debug_btn = nil
  self.change_scene = nil
  self.killZombie = nil
  self.build_obj = nil
  self.chat_obj = nil
  self.chatCoppaLimit = nil
  self.questObj = nil
  self:ClearAlComponent()
  self.rally_tip_obj = nil
  self.allianceBtnName = nil
  self.winterStormMatchingObj = nil
  self.invasionBtn = nil
  self.fingerGo = nil
  self.alChallengeBossBubbleItem = nil
  self.luckyPacketShareTipComponent = nil
  self.lockHartTipComponent = nil
  self.boxMarchDisplayDowngradeTip = nil
  self.marchDisplayDowngradeTipLayout = nil
  if self.btnMeteoriteCd then
    self.btnMeteoriteCd:Delete()
    self.btnMeteoriteCd = nil
  end
  self:DestroyPopupNotificationBubble()
  self.popup_notification_layout = nil
end

function UIMainBottom:DataDefine()
  self.functionList = {}
  self.quest_early = LuaEntry.DataConfig:CheckSwitch("quest_early")
  self.quest_earlyId = LuaEntry.DataConfig:TryGetNum("quest_pre", "k1")
  if self.alChallengeBossBubbleReq then
    self.alChallengeBossBubbleReq:Destroy()
    self.alChallengeBossBubbleReq = nil
  end
end

function UIMainBottom:DataDestroy()
  if self.heroBubbleDelay then
    self.heroBubbleDelay:Stop()
    self.heroBubbleDelay = nil
  end
  self.alChallengeBossBubbleReq = nil
end

function UIMainBottom:InitQuest()
  self:SetAllQuestCellDestroy()
  self.questCell = {}
  self.bubbleCell = {}
  local newList = self:QuestSortHandle()
  for i = 1, #newList do
    self.questList[i] = self:GameObjectInstantiateAsync(UIAssets.UIMainQuestObj, function(request)
      if request.isError then
        return
      end
      if i ~= 1 then
        curIndex = curIndex + 1
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.msgContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = "questViceObj" .. i
      local isMain = false
      if type(newList[i]) == "string" then
        isMain = true
      end
      go.name = nameStr
      local cell = self.msgContent:AddComponent(UIMainQuest, nameStr)
      cell.transform:SetSiblingIndex(curIndex)
      cell:GetObj(function()
        return self:GetQuestObjIsShow()
      end)
      cell:ReInit(newList[i], self.questMsg, isMain, self.msglist_scroll)
      cell:CheckIsShowMsgChapter()
      self.questCell[i] = cell
    end)
  end
end

function UIMainBottom:SetAllQuestCellDestroy()
  self.msgContent:RemoveComponents(UIMainQuest)
  if self.questList ~= nil then
    for k, v in pairs(self.questList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.questList = {}
end

function UIMainBottom:TaskArrowShow(list)
  self:QuestCellRefresh(9, list)
end

function UIMainBottom:CheckListShow()
  local lastList = DataCenter.ChapterTaskCellManager:CheckListShow()
  if lastList then
    local index
    for i = 1, #self.questCell do
      if self.questCell[i].chapterType == lastList then
        index = i
      end
    end
    if index then
      for i = index, #self.questCell do
        if i < table.count(self.questCell) then
          self.questCell[i + 1]:DoMoveAnim()
        end
      end
      return true
    end
  end
  return false
end

function UIMainBottom:GuidEndNoShow()
  self:QuestCellRefresh(10)
end

function UIMainBottom:QuestCellRefresh(types, param)
  local isMove = false
  if self.questCell == nil then
    return
  end
  local isIgnore = false
  local pushTask = types == 1 and param == 1
  local isWaitAnim = false
  if pushTask or types == 3 then
    if pushTask then
      isWaitAnim = self:CheckListShow()
    end
    for i = 1, #self.questCell do
      if self.questCell[i]:CheckListQuest() then
        if DataCenter.ChapterTaskManager:GetRewardGetType(self.questCell[i].chapterType) ~= self.questCell[i].chapterType + 100 then
          isIgnore = false
          break
        else
          isIgnore = true
        end
      else
        isIgnore = false
        break
      end
    end
  end
  for i = 1, #self.questCell do
    if types == 1 then
      if isWaitAnim then
        TimerManager:GetInstance():DelayInvoke(function()
          self.questCell[i]:RefreshTask(1, false, isIgnore)
        end, 0.5)
      else
        self.questCell[i]:RefreshTask(1, false, isIgnore)
      end
    elseif types == 2 then
      self.questCell[i]:PlaceBuildHandel()
    elseif types == 3 then
      if param == 1 then
        self.questCell[i]:RefreshGuideSignal()
      elseif self.questCell[i].taskData then
        local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(self.questCell[i].taskData.id)
        if questTemplate and questTemplate.autoopen ~= 1 and questTemplate.autoopen ~= 2 then
          self.questCell[i]:RefreshTask(3)
          break
        end
      end
    elseif types == 4 then
      self.questCell[i]:CheckIsShowMsgChapter(isMove)
    elseif types == 5 then
      self.questCell[i]:HideMsgChapter(2)
    elseif types == 9 then
      if self.questCell[i].chapterType == param then
        self.questCell[i]:RefreshArrowTimer()
      end
    elseif types == 10 then
      self.questCell[i]:GuidEndSetState(false)
    elseif types == 11 then
      if self.questCell[i].chapterType == param then
        self.questCell[i]:OnClickQuest(true)
        break
      end
    elseif types == 12 then
      self.questCell[i]:SetLod(param)
    end
  end
end

function UIMainBottom:ChapterTaskRefresh(isGetReward)
  if self.isInPve == true then
    return
  end
  local ok, err = pcall(function()
    self.questObj:RefreshState()
  end)
  if not ok then
    Logger.LogError("ChapterTaskRefresh", err)
  end
end

function UIMainBottom:GetQuestObjIsShow()
  for i = 1, #self.questCell do
    if self.questCell[i]:GetActive() then
      return self.questCell[i].chapterType
    end
  end
  return 0
end

function UIMainBottom:RefreshQuestCell(typeList)
  for i = 1, #self.questCell do
    local isMain = false
    if type(typeList[i]) == "string" then
      isMain = true
    end
    self.questCell[i]:ReInit(typeList[i], self.questMsg, isMain, self.msglist_scroll, true)
  end
end

function UIMainBottom:GuidQuestCell(param)
  if param.showType == GuideSetNormalVisible.Show then
    DataCenter.ChapterTaskCellManager:GuidSetState(true)
  else
    DataCenter.ChapterTaskCellManager:GuidSetState(false)
  end
end

function UIMainBottom:MainTaskRefresh(taskId)
  if self.isInPve == true then
    return
  end
  if self.quest_early then
    self:ChapterTaskRefresh()
    self:RefreshMainQuest()
  end
end

function UIMainBottom:RefreshMainQuest()
  local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
  local allNum = DataCenter.ChapterTaskManager:GetAllNum()
  if 0 < allNum and chapterId < self.quest_earlyId then
    return
  else
    DataCenter.NpcTaskBubbleManager:StartUp()
  end
end

function UIMainBottom:GetPveBtnPos()
  return self.zombie_debug_btn.gameObject.transform.position
end

function UIMainBottom:GetVisitorBtnPos()
  return self.visitor_obj.gameObject.transform.position
end

function UIMainBottom:GetMailBtnPos()
  return self.mail_obj.transform:Find("buildBtn").position
end

function UIMainBottom:GetAllianceBtnPos()
  return self.alliance_obj.transform:Find("buildBtn").position
end

function UIMainBottom:GetHeroBtnPos()
  return self.hero_obj.transform:Find("buildBtn").position
end

function UIMainBottom:GetBagBtnPos()
  return self.bag_obj.transform:Find("buildBtn").position
end

function UIMainBottom:GetBuildBtnPos()
  return self.build_obj.gameObject.transform.position
end

function UIMainBottom:GetQuestPosition()
  return self.questObj.descText.transform.position
end

function UIMainBottom:GetSearchBtnPos()
  return self.search_obj.transform.position
end

function UIMainBottom:GetMummyBtnPos()
  if self.season_build_obj then
    return self.season_build_obj.transform.position
  end
  return nil
end

function UIMainBottom:OnClickPveVtn()
  PveUtil.TryEnterBattle(DataCenter.StageManager.stageGroupMetaId, DataCenter.StageManager.stageId)
end

function UIMainBottom:UpdateLod(lod)
  self.lodCache = lod
  if self.invasionBtn ~= nil then
    self.invasionBtn:SetLod(lod)
  end
  self.change_scene:SetLod(lod)
  if self.killZombie ~= nil then
    self.killZombie:SetLod(lod)
  end
  if self.winterStormMatchingObj then
    self.winterStormMatchingObj:SetLod(lod)
  end
  if self.AlChallengeBossBubbleItem then
    self.AlChallengeBossBubbleItem:SetLod(lod)
  end
  if CS.SceneManager:IsInCity() then
    self.build_obj:SetActive(true)
    self.search_obj:SetActive(false)
  else
    self.build_obj:SetActive(false)
    self.search_obj:SetActive(true)
  end
end

function UIMainBottom:OnBeginDrag(eventData)
  DataCenter.ArrowManager:RemoveFingerArrow(true)
  DataCenter.ArrowManager:RemoveArrow()
  self.questMsg:AutoHideTaskTime()
end

function UIMainBottom:GetQuestCell()
  return self.questCell
end

function UIMainBottom:GetBallCell()
  return self.ball_obj
end

function UIMainBottom:MoveContent(index, isAnim, offsetY)
  if isAnim then
    self.moveContent = true
    local posY = self.msgContent:GetAnchoredPositionY()
    self.msgContent.rectTransform:DOAnchorPosY(posY + offsetY, 0.2):OnComplete(function()
      self.moveContent = false
    end)
  else
    local posX = self.msgContent:GetAnchoredPositionX()
    local moveToPos = {
      x = posX,
      y = (index - 1) * (objHeight - layoutSpacing)
    }
    self.msgContent:SetAnchoredPosition(moveToPos)
  end
end

function UIMainBottom:QuestSortHandle()
  local newList = {}
  local bubbleList = DataCenter.TaskManager:GetCurBubbleTaskType()
  local typeList = DataCenter.ChapterTaskManager:GetCurChapterAllType()
  for i = 1, #bubbleList do
    table.insert(newList, bubbleList[i])
  end
  for i = 1, #typeList do
    table.insert(newList, typeList[i])
  end
  table.sort(newList, function(a, b)
    if tonumber(a) < tonumber(b) then
      return true
    end
    return false
  end)
  return newList
end

function UIMainBottom:OnAllianceQuitOK()
  self:RefreshAlBtns()
  self:ShowOrHideJungleTrial()
end

function UIMainBottom:RefreshAlBtns(has_dialog)
  local hasAlBuid = DataCenter.BuildManager:IsExistBuildByTypeLv(BuildingTypes.LW_BUILD_ALLIANCE_CENTER, 1)
  self.alliance_obj:SetActive(hasAlBuid)
  self.alliance_obj:ReInit(UIMainFunctionInfo.Alliance)
end

function UIMainBottom:AlFirstEnterProcess()
  local function end_fly_1()
    if self.alFirstTimer2 then
      self.alFirstTimer2:Stop()
    end
    self.alliance_obj:SetActive(true)
    self.alFirstTimer2 = TimerManager:GetInstance():DelayInvoke(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlGuide, {
        anim = false,
        UIMainAnim = UIMainAnimType.AllHide
      }, {dialog_id = 1002})
    end, 1.0)
  end
  
  local function end_fly_2()
    self.alliance_obj:SetActive(true)
  end
  
  local my_point_id = LuaEntry.Player:GetMainWorldPos()
  local al_my = DataCenter.AllianceMemberDataManager:GetAllianceMemberMyself()
  local allianceInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  local is_leader = al_my.uid == allianceInfo.leaderUid
  if is_leader then
    local origin_pos = CS.CSUtils.WorldPositionToUISpacePosition(SceneUtils.TileIndexToWorld(my_point_id))
    local target_pos = UIUtil.GetUIMainSavePos(UIMainSavePosType.AllianceBtn)
    local icon = "Assets/Main/Sprites/UI/UILWAlliance/icon_alliance_flag_1.png"
    UIUtil.DoFly(ResourceType.None, 1, icon, origin_pos, target_pos, 125, 125, end_fly_1, false, 0.8, 1.5, nil)
  else
    DataCenter.ArrowManager:RemoveArrow()
    local leaderInfo = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(allianceInfo.leaderUid)
    local leaderUid = leaderInfo.uid
    local leaderPointId = leaderInfo.pointId
    if self.alFirstSequence then
      self.alFirstSequence:Kill()
    end
    self.bubbleList = {}
    self.bubbleIndex = 0
    self.alFirstSequence = CS.DG.Tweening.DOTween.Sequence()
    if leaderPointId then
      self.alFirstSequence:AppendCallback(function()
        GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(leaderPointId), CS.SceneManager.World.InitZoom, LookAtFocusTime)
      end):AppendInterval(LookAtFocusTime + 1.0):AppendCallback(function()
        local param = {
          uuid = leaderUid,
          pointId = leaderPointId,
          buildBubbleType = BuildBubbleType.AlWelcome,
          model = UIAssets.BuildStateIcon9,
          bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1),
          remindTxt = Localization:GetString(392003)
        }
        self:CreateBubble(param)
      end):AppendInterval(0.1):AppendCallback(function()
        local origin_pos = CS.CSUtils.WorldPositionToUISpacePosition(SceneUtils.TileIndexToWorld(leaderPointId))
        local target_pos = UIUtil.GetUIMainSavePos(UIMainSavePosType.AllianceBtn)
        local icon = "Assets/Main/Sprites/UI/UILWAlliance/icon_alliance_flag_1.png"
        UIUtil.DoFly(ResourceType.None, 1, icon, origin_pos, target_pos, 125, 125, end_fly_2, false, 0.8, 1.5, nil)
      end):AppendInterval(2.0):AppendCallback(function()
        local al_member_list = DataCenter.AllianceMemberDataManager:GetAllMember()
        local showNum = 2
        local al_members_region_list = {}
        table.walk(al_member_list, function(k, v)
          local w_pos = SceneUtils.TileIndexToWorld(v.pointId)
          local v_pos = CS.SceneManager.World:WorldToScreenPoint(w_pos)
          local i_i_view = v_pos.x > 0 and 0 < v_pos.y and v_pos.x < CS.UnityEngine.Screen.width and v_pos.y < CS.UnityEngine.Screen.height
          if i_i_view and table.count(al_members_region_list) < showNum and v.pointId ~= al_my.pointId and v.pointId ~= my_point_id and v.pointId ~= leaderPointId then
            table.insert(al_members_region_list, v)
          end
        end)
        for i = 1, #al_members_region_list do
          local v = al_members_region_list[i]
          local param = {
            uuid = v.uid,
            pointId = v.pointId,
            buildBubbleType = BuildBubbleType.AlWelcome,
            model = UIAssets.BuildStateIcon9,
            bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1),
            remindTxt = Localization:GetString(392003)
          }
          self:CreateBubble(param)
        end
      end):AppendInterval(3.0):AppendCallback(function()
        self:ClearAlBubbles()
      end):AppendInterval(0.5):AppendCallback(function()
        GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(my_point_id), CS.SceneManager.World.InitZoom, LookAtFocusTime)
      end):AppendInterval(LookAtFocusTime + 1.0):AppendCallback(function()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlGuide, {
          anim = false,
          UIMainAnim = UIMainAnimType.AllHide
        }, {dialog_id = 1002})
      end)
    else
      do
        local origin_pos = CS.CSUtils.WorldPositionToUISpacePosition(SceneUtils.TileIndexToWorld(my_point_id))
        local target_pos = UIUtil.GetUIMainSavePos(UIMainSavePosType.AllianceBtn)
        local icon = "Assets/Main/Sprites/UI/UILWAlliance/icon_alliance_flag_1.png"
        UIUtil.DoFly(ResourceType.None, 1, icon, origin_pos, target_pos, 125, 125, end_fly_1, false, 0.8, 1.5, nil)
      end
    end
  end
end

function UIMainBottom:CreateBubble(param)
  local parent_tf = CS.SceneManager.World:GetWorldBuildingByPoint(param.pointId)
  if parent_tf then
    local req = Resource:InstantiateAsync(param.model)
    req:completed("+", function()
      if req.isError then
        return
      end
      CommonUtil.CallAutoArabicMirrorManually(req)
      req.gameObject:SetActive(true)
      req.gameObject.transform:SetParent(parent_tf.transform)
      req.gameObject.transform.localPosition = Vector3.New(0, 0, 0)
      req.gameObject.transform:Set_localScale(0, ResetScale.y, ResetScale.z)
      local bubbleTip = BuildBubbleTip.New()
      bubbleTip:OnCreate(req)
      bubbleTip:ReInit(param)
      self.bubbleIndex = self.bubbleIndex + 1
      self.bubbleList[self.bubbleIndex] = bubbleTip
      self.bubbleList[self.bubbleIndex].request = req
    end)
  end
end

function UIMainBottom:ClearAlBubbles()
  if self.bubbleList ~= nil and table.count(self.bubbleList) > 0 then
    table.walk(self.bubbleList, function(k, v)
      if v ~= nil and v.request ~= nil then
        v.request:Destroy()
      end
    end)
  end
end

function UIMainBottom:ClearAlComponent()
  if self.alFirstSequence then
    self.alFirstSequence:Kill()
  end
  if self.alFirstTimer then
    self.alFirstTimer:Stop()
  end
  if self.alFirstTimer2 then
    self.alFirstTimer2:Stop()
  end
  if self.bubbleList ~= nil and table.count(self.bubbleList) > 0 then
    table.walk(self.bubbleList, function(k, v)
      if v ~= nil then
        v:OnDestroy()
      end
    end)
  end
  self.bubbleList = nil
  self.bubbleIndex = nil
end

function UIMainBottom:ArrowToMainCity()
  local my_point_id = LuaEntry.Player:GetMainWorldPos()
  local param = {}
  param.position = CS.CSUtils.WorldPositionToUISpacePosition(SceneUtils.TileIndexToWorld(my_point_id)) + Vector3.New(0, 0, 0)
  param.arrowType = ArrowType.Capacity
  param.positionType = PositionType.Screen
  if param.position ~= nil then
    DataCenter.ArrowManager:ShowArrow(param)
    TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.ArrowManager:RemoveArrow()
    end, 5.0)
  end
end

function UIMainBottom:OnRefreshAllianceWarTip(data)
  self.rally_tip_obj:RefreshTip(data)
end

function UIMainBottom:OnCheckRallyTipRedPoint()
  self.rally_tip_obj:CheckRedPoint()
end

function UIMainBottom:ReInit()
  self.heroBubble:SetActive(false)
  self.allianceBtnName:SetLocalText(390002)
  self.alarmObj:RefreshMarchItemTargetMe()
  self:CheckWinterStormMatching()
  self:CheckActMigration()
  self:CheckWinterStormTip()
  self:CheckReturnQuestionnaireTip()
  self:CheckRaceEntranceTip()
  self:CheckLLGroupInvitation()
  self:CheckLLBattleTip()
  self:CheckChampionDuelSignTip()
  self:CheckQueenOfBloodTip()
  self:RefreshLuckyPacketShareTip()
  self:RefreshLockHartActivityTip()
  self:RefreshShowPopupNotificationBubble()
  self.mainCureBtn:ReInit()
end

function UIMainBottom:OnEnterWorld(data)
  self.change_scene:CheckImage()
  if self.killZombie ~= nil then
    self.killZombie:RefreshData()
  end
  if self.invasionBtn then
    self.invasionBtn:ReInit()
  end
  self:CheckWinterStormMatching()
  if self.mainCureBtn then
    self.mainCureBtn:RefreshCure()
  end
  self:CheckActMigration()
  self:CheckWinterStormTip()
  self:CheckReturnQuestionnaireTip()
  self:CheckRaceEntranceTip()
  self:CheckLLGroupInvitation()
  self:CheckLLBattleTip()
  self:CheckChampionDuelSignTip()
  self:CheckQueenOfBloodTip()
  self:RefreshNewAllianceChallengeDonateInfo()
  self:TryAddSeasonBtn()
  self:RefreshMeteoriteBtn()
  self:RefreshLuckyPacketShareTip()
  self:RefreshLockHartActivityTip()
  self:RefreshShowPopupNotificationBubble()
end

function UIMainBottom:OnEnterCity(data)
  self.change_scene:CheckImage()
  if self.killZombie ~= nil then
    self.killZombie:RefreshData()
  end
  if self.invasionBtn then
    self.invasionBtn:ReInit()
  end
  if self.season_power_task_btn ~= nil then
    self.season_power_task_btn:SetActive(false)
  end
  self:CheckWinterStormMatching()
  if self.mainCureBtn then
    self.mainCureBtn:RefreshCure()
  end
  self:CheckActMigration()
  self:CheckWinterStormTip()
  self:CheckReturnQuestionnaireTip()
  self:CheckRaceEntranceTip()
  self:CheckLLGroupInvitation()
  self:CheckLLBattleTip()
  self:CheckChampionDuelSignTip()
  self:CheckQueenOfBloodTip()
  self:RefreshNewAllianceChallengeDonateInfo()
  self:RefreshMeteoriteBtn()
  self:RefreshLuckyPacketShareTip()
  self:RefreshLockHartActivityTip()
  self:RefreshShowPopupNotificationBubble()
end

function UIMainBottom:TryAddSeasonBtn()
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType == SeasonMapType.Darkness and self.left_layout then
    local hasTask = DataCenter.SeasonPowerWorkerManager:HasPowerBuildTask()
    if hasTask then
      if self.season_power_task_btn == nil then
        local luaPath = "UI.LWMainUI.Component.UIMainBottom.LeftLayoutBtns.UIMainBLBtnSeasonPowerTask"
        local prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Component/SeasonPowerTask.prefab"
        self.season_power_task_btn = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.bubbleTipLayout)
      end
      self.season_power_task_btn:SetActive(true)
    elseif self.season_power_task_btn ~= nil then
      self.season_power_task_btn:SetActive(false)
    end
  end
  DataCenter.WorldBattleGuideManager:SetBubbleTipLayoutRoot(self.bubbleTipLayout)
end

function UIMainBottom:RefreshMeteoriteBtn()
  if not self.left_layout then
    return
  end
  local freeMoveCd = MeteoriteBattleUtils.GetFreeMoveCdTime()
  local inWorld = SceneUtils.GetIsInWorld()
  local showBtn = 0 <= freeMoveCd and inWorld
  if showBtn then
    if not self.btnMeteoriteCd then
      self.btnMeteoriteCd = UIAsyncLoaderBridge.New(self, "btnMeteoriteCd", self.bubbleTipLayout.transform, UIAssets.UIMeteoriteMainUIMoveCity, "UI.LWMainUI.Component.UIMainBottom.LeftLayoutBtns.UIMainBLBtnMeteoriteMoveCity", false)
    end
    self.btnMeteoriteCd:SetActive(true)
  elseif not showBtn and self.btnMeteoriteCd then
    self.btnMeteoriteCd:SetActive(false)
  end
end

function UIMainBottom:OnUpdateRedPot(type)
  if self.functionList[type] ~= nil then
    self.functionList[type]:OnUpdateRedPot()
  end
end

function UIMainBottom:UpdateWhenAnim(animName)
  if self.killZombie ~= nil then
    self.killZombie:UpdateWhenAnim(animName)
  end
  if self.winterStormMatchingObj then
    local stackCount = UIManager:GetInstance():GetStackWindowCount()
    if 1 < stackCount and animName ~= UIMainAnimType.AllShow or animName == UIMainAnimType.AllHide then
      self.winterStormMatchingObj:HideSelf()
    else
      self:CheckWinterStormMatching()
    end
  end
  self:CheckActMigration()
  self:CheckWinterStormTip()
  self:CheckReturnQuestionnaireTip()
  self:CheckRaceEntranceTip()
  self:CheckLLGroupInvitation()
  self:CheckLLBattleTip()
  self:CheckChampionDuelSignTip()
  self:CheckQueenOfBloodTip()
  self:RefreshMeteoriteBtn()
  self:RefreshLuckyPacketShareTip()
  self:CheckFingerSoundWhenAnim(animName)
  self:RefreshLockHartActivityTip()
end

function UIMainBottom:CheckFingerSoundWhenAnim(animName)
  local isBottomShow = animName == UIMainAnimType.AllShow or animName == UIMainAnimType.ChangeAllShow or animName == UIMainAnimType.LeftRightBottomShow or animName == UIMainAnimType.BottomShow
  self.isBottomVisible = isBottomShow
  if isBottomShow then
    if self.fingerHandle then
      self:StartTimer()
    end
  else
    self:StopFingerSound()
    self:DeleteTimer()
  end
end

function UIMainBottom:OnGetDetectEventCompMsg(info)
  if not SceneUtils.GetIsInWorld() then
    return
  end
  local uuid = info.uuid
  local event = DataCenter.RadarCenterDataManager:GetDetectEventInfo(uuid)
  if event == nil or toInt(event.pointId) <= 0 then
    return
  end
  if event.IsShowFlyEffectInMainUI ~= nil and not event:IsShowFlyEffectInMainUI() then
    return
  end
  local mainWorldPos = SceneUtils.TileIndexToWorld(event.pointId, ForceChangeScene.World)
  if info.position then
    mainWorldPos = info.position
  end
  local world = CS.SceneManager.World
  local mainScreenPos = world:WorldToScreenPoint(mainWorldPos)
  local pos = CS.GameEntry.UICamera:ScreenToWorldPoint(mainScreenPos)
  local effectPath = "Assets/_Art/Effect/prefab/ui/VFX_leida_trail.prefab"
  local startPos = pos
  local endPos = self.detect_obj.transform.position
  UIUtil.DoFlySimpleFunc(effectPath, startPos, endPos, 1, nil, function()
  end)
end

function UIMainBottom:OnWorldMarchUpdateDisplayMode()
  local isOn = MarchDisplaySettings.LevelAdjustment < 0
  isOn = isOn or MarchDisplaySettings.LevelLimit == MarchDisplaySettings.Levels.Low
  if self.marchDisplayDowngradeTip ~= nil then
    self.marchDisplayDowngradeTip:SetActive(isOn)
  end
end

function UIMainBottom:AllianceWarDataUpdate()
  if self.rally_tip_obj then
    self.rally_tip_obj:CheckRedPoint()
  end
end

function UIMainBottom:GetBtnPosByType(mainUITipType)
  if mainUITipType == MainUITipType.Alliance and self.alliance_obj:GetActive() then
    return self.alliance_obj.transform.position
  end
  return nil
end

function UIMainBottom:ShowOrHideSandWorm()
  self.sandWormRefreshCountdown = DataCenter.SandWormHuntDataManager:IsInActivity() and SAND_WORM_SYNC_CD
  if DataCenter.SandWormHuntDataManager:IsShowOnMainUI() then
    if self.sandWorm then
      self.sandWorm:Refresh()
    elseif not self.sandWormReq then
      self.sandWormReq = self:GameObjectInstantiateAsync("Assets/Main/SeasonRes/S3/Prefabs/UI/LWMainUI/SandWormObj.prefab", function(req)
        local gameObject = req.gameObject
        if IsNull(gameObject) then
          return
        end
        local transform = gameObject.transform
        gameObject:SetActive(true)
        transform:SetParent(self.bubbleTipLayout.transform)
        transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        transform:SetSiblingIndex(0)
        local name = gameObject.name
        self.sandWorm = self.bubbleTipLayout:AddComponent(UIMainSandWormObj, name)
        self.sandWorm:Refresh()
      end)
    end
  else
    self:HideSandWorm()
  end
end

function UIMainBottom:HideSandWorm()
  if self.sandWorm then
    self.bubbleTipLayout:RemoveComponents(UIMainSandWormObj)
    self.sandWorm = nil
  end
  if self.sandWormReq then
    self.sandWormReq:Destroy()
    self.sandWormReq = nil
  end
end

local JungleTrialLuaPath = "UI.LWMainUI.Component.UIMainBottom.UIMainJungleTrialObj"
local JungleTrialPrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/JungleTrial/JungleTrialObj.prefab"

function UIMainBottom:ShowOrHideJungleTrial()
  local isShow = DataCenter.JungleTrialDataManager:IsShowOnMainUI()
  self.bubbleTipLayout:SetActiveAsyncWithPath(isShow, JungleTrialLuaPath, JungleTrialPrefabPath)
end

local WolfShadowLuaPath = "UI.LWSeason.LWSeasonHunter.Component.UIMainWolfShadowObj"
local WolfShadowPrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Hunter/Component/WolfShadow.prefab"

function UIMainBottom:ShowOrHideWolfShadow()
  local isShow = DataCenter.SeasonHunterManager:GetShadow() ~= nil
  self.bubbleTipLayout:SetActiveAsyncWithPath(isShow, WolfShadowLuaPath, WolfShadowPrefabPath)
end

function UIMainBottom:ShowOrHideTempObj()
  if SeasonUtil.IsInSeasonSnowModeWithoutGroup() and DataCenter.TemperatureManager:GetMyBaseConductor().Inited then
    self:ShowTemp()
  else
    self:HideTemp()
  end
end

function UIMainBottom:ShowTemp()
  if self.tempObj then
    self.tempObj:Refresh()
  elseif not self.tempObjReq then
    self.tempObjReq = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWMainUI/tempObj.prefab", function(req)
      local gameObject = req.gameObject
      if IsNull(gameObject) then
        return
      end
      local transform = gameObject.transform
      gameObject:SetActive(true)
      transform:SetParent(self.left_layout.transform)
      transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      transform:SetSiblingIndex(0)
      local name = gameObject.name
      self.tempObj = self.left_layout:AddComponent(UIMainTempObj, name)
      self.tempObj:Refresh()
    end)
  end
end

function UIMainBottom:HideTemp()
  if self.tempObj then
    self.left_layout:RemoveComponents(UIMainTempObj)
    self.tempObj = nil
  end
  if self.tempObjReq then
    self.tempObjReq:Destroy()
    self.tempObjReq = nil
  end
end

function UIMainBottom:CheckWinterStormMatching()
  if self.winterStormMatchingObj then
    self.winterStormMatchingObj:Refresh()
    return
  end
  if self.winterReq ~= nil then
    return
  end
  local lod = self.lodCache or 1
  if 3 < lod then
    return
  end
  local status = DataCenter.ActWinterStormManager:CheckMatchingShow()
  if status == 0 then
    return
  end
  local request = Resource:InstantiateAsync("Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/LWWinterStormMatching.prefab")
  self.winterReq = request
  request:completed("+", function(req)
    local _go = req.gameObject
    if IsNull(_go) then
      if self.winterReq ~= nil then
        self.winterReq:Destroy()
        self.winterReq = nil
      end
      return
    end
    local pTF = _go.transform
    pTF:SetParent(self.transform)
    pTF:Set_localPosition(0, 380, 0)
    pTF:Set_localScale(1, 1, 1)
    self.winterStormMatchingObj = self:AddComponent(UIMainWinterStormMatching, _go.name)
    self.winterStormMatchingObj:SetLod(lod)
    self.winterStormMatchingObj:Refresh()
  end)
end

function UIMainBottom:CheckActMigration()
  if self.actMigrationObj then
    self.actMigrationObj:Refresh()
    return
  end
  if self.actMigrationReq ~= nil then
    return
  end
  local flag = DataCenter.ActMigrationManager:CheckCanMigrate()
  if not flag then
    return
  end
  local request = Resource:InstantiateAsync("Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigrationMainBtn.prefab")
  self.actMigrationReq = request
  request:completed("+", function(req)
    local _go = req.gameObject
    if IsNull(_go) then
      if self.actMigrationReq ~= nil then
        self.actMigrationReq:Destroy()
        self.actMigrationReq = nil
      end
      return
    end
    local pTF = _go.transform
    pTF:SetParent(self.bubbleTipLayout.transform)
    pTF:Set_localScale(1, 1, 1)
    self.actMigrationObj = self.bubbleTipLayout:AddComponent(ActMigrationMainBtn, _go.name)
    self.actMigrationObj:Refresh()
  end)
end

function UIMainBottom:CheckWinterStormTip()
  if RaceEntranceUtil.IsNewEntranceOpen() or not RaceEntranceUtil.IsOldEntranceOpen() then
    return
  end
  if self.winterStormTipObj then
    self.winterStormTipObj:Refresh()
    return
  end
  if self.winterStormTipReq ~= nil then
    return
  end
  local flag = DataCenter.ActWinterStormManager:CheckInBattleTime()
  if not flag then
    return
  end
  local request = Resource:InstantiateAsync("Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/LWWinterStormTipMainBtn.prefab")
  self.winterStormTipReq = request
  request:completed("+", function(req)
    local _go = req.gameObject
    if IsNull(_go) then
      if self.winterStormTipReq ~= nil then
        self.winterStormTipReq:Destroy()
        self.winterStormTipReq = nil
      end
      return
    end
    local pTF = _go.transform
    pTF:SetParent(self.bubbleTipLayout.transform)
    pTF:Set_localScale(1, 1, 1)
    self.winterStormTipObj = self.bubbleTipLayout:AddComponent(UIMainWinterStormTipMainBtn, _go.name)
    self.winterStormTipObj:Refresh()
  end)
end

function UIMainBottom:CheckReturnQuestionnaireTip()
  if self.returnQuestionnaireTipObj then
    self.returnQuestionnaireTipObj:Refresh()
    return
  end
  if self.returnQuestionnaireTipReq ~= nil then
    return
  end
  local data = DataCenter.LWQuestionnaireManager:HasReturnQuestionnaireNeedPrompt()
  if data == nil then
    return
  end
  local request = Resource:InstantiateAsync("Assets/Main/Prefabs/UI/LWMainUI/returnQuestionnaireBtn.prefab")
  self.returnQuestionnaireTipReq = request
  request:completed("+", function(req)
    local _go = req.gameObject
    if IsNull(_go) then
      if self.returnQuestionnaireTipReq ~= nil then
        self.returnQuestionnaireTipReq:Destroy()
        self.returnQuestionnaireTipReq = nil
      end
      return
    end
    local pTF = _go.transform
    pTF:SetParent(self.bubbleTipLayout.transform)
    pTF:Set_localScale(1, 1, 1)
    self.returnQuestionnaireTipObj = self.bubbleTipLayout:AddComponent(UIMainReturnQuestionnaireBtn, _go.name)
    self.returnQuestionnaireTipObj:Refresh()
  end)
end

function UIMainBottom:CheckRaceEntranceTip()
  if not RaceEntranceUtil.IsNewEntranceOpen() then
    return
  end
  if self.raceEntranceTipObj then
    self.raceEntranceTipObj:Refresh()
    return
  end
  if self.ranceEntranceTipReq ~= nil then
    return
  end
  local actType = RaceEntranceUtil.CheckCanShowTip()
  if actType <= 0 then
    return
  end
  local request = Resource:InstantiateAsync("Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/LWMainRaceEntranceTipBtn.prefab")
  self.ranceEntranceTipReq = request
  request:completed("+", function(req)
    local _go = req.gameObject
    if IsNull(_go) then
      if self.ranceEntranceTipReq ~= nil then
        self.ranceEntranceTipReq:Destroy()
        self.ranceEntranceTipReq = nil
      end
      return
    end
    local pTF = _go.transform
    pTF:SetParent(self.bubbleTipLayout.transform)
    pTF:Set_localScale(1, 1, 1)
    self.raceEntranceTipObj = self.bubbleTipLayout:AddComponent(UIMainRaceEntranceTipBtn, _go.name)
    self.raceEntranceTipObj:Refresh()
  end)
end

function UIMainBottom:CheckLLGroupInvitation()
  if self.llGroupInvitationObj then
    self.llGroupInvitationObj:Refresh()
    return
  end
  if self.llGroupInvitationReq ~= nil then
    return
  end
  local flag = DataCenter.LandlordMgr:CheckBeInvited()
  if not flag then
    return
  end
  local request = Resource:InstantiateAsync("Assets/Main/Prefabs/UI/Landlord/LWMainLLGroupInvitationBtn.prefab")
  self.llGroupInvitationReq = request
  request:completed("+", function(req)
    local _go = req.gameObject
    if IsNull(_go) then
      if self.llGroupInvitationReq ~= nil then
        self.llGroupInvitationReq:Destroy()
        self.llGroupInvitationReq = nil
      end
      return
    end
    local pTF = _go.transform
    pTF:SetParent(self.bubbleTipLayout.transform)
    pTF:Set_localScale(1, 1, 1)
    self.llGroupInvitationObj = self.bubbleTipLayout:AddComponent(UIMainLLGroupInvitationBtn, _go.name)
    self.llGroupInvitationObj:Refresh()
  end)
end

function UIMainBottom:CheckLLBattleTip()
  if self.llBattleTipObj then
    self.llBattleTipObj:Refresh()
    return
  end
  if self.llBattleTipObjReq ~= nil then
    return
  end
  local flag = DataCenter.LandlordMgr:IsInBattle() and LuaEntry.Player:GetServerId() ~= DataCenter.LandlordMgr:GetCenterServerId()
  if not flag then
    return
  end
  local request = Resource:InstantiateAsync("Assets/Main/Prefabs/UI/Landlord/LWMainLLBattleTipBtn.prefab")
  self.llBattleTipObjReq = request
  request:completed("+", function(req)
    local _go = req.gameObject
    if IsNull(_go) then
      if self.llBattleTipObjReq ~= nil then
        self.llBattleTipObjReq:Destroy()
        self.llBattleTipObjReq = nil
      end
      return
    end
    local pTF = _go.transform
    pTF:SetParent(self.bubbleTipLayout.transform)
    pTF:Set_localScale(1, 1, 1)
    self.llBattleTipObj = self.bubbleTipLayout:AddComponent(UIMainLLBattleTipBtn, _go.name)
    self.llBattleTipObj:Refresh()
  end)
end

function UIMainBottom:CheckChampionDuelSignTip()
  if self.championDuelSignTipObj then
    self.championDuelSignTipObj:Refresh()
    return
  end
  if self.championDuelSignTipReq ~= nil then
    return
  end
  local flag = DataCenter.ChampionDuelManager:GetSignRed()
  if flag == 0 then
    return
  end
  local request = Resource:InstantiateAsync("Assets/Main/Prefabs/UI/UIChampionDuel/UIChampionDuelMainSignTipBtn.prefab")
  self.championDuelSignTipReq = request
  request:completed("+", function(req)
    local _go = req.gameObject
    if IsNull(_go) then
      if self.championDuelSignTipReq ~= nil then
        self.championDuelSignTipReq:Destroy()
        self.championDuelSignTipReq = nil
      end
      return
    end
    local pTF = _go.transform
    pTF:SetParent(self.bubbleTipLayout.transform)
    pTF:Set_localScale(1, 1, 1)
    self.championDuelSignTipObj = self.bubbleTipLayout:AddComponent(UIMainChampionDuelSignTipBtn, _go.name)
    self.championDuelSignTipObj:Refresh()
  end)
end

function UIMainBottom:CheckQueenOfBloodTip(needShowTip)
  if self.queenOfBloodTipObj then
    self.queenOfBloodTipObj:Refresh(needShowTip)
    return
  end
  if self.queenOfBloodTipReq ~= nil then
    return
  end
  local point = DataCenter.OffSeason1QueenOfBloodManager:GetGunnerJumpPoint()
  if point == nil then
    return
  end
  local request = Resource:InstantiateAsync("Assets/Main/Prefabs/UI/LWOffSeason1/QueenOfBlood/LWMainQueenOfBloodBtn.prefab")
  self.queenOfBloodTipReq = request
  request:completed("+", function(req)
    local _go = req.gameObject
    if IsNull(_go) then
      if self.queenOfBloodTipReq ~= nil then
        self.queenOfBloodTipReq:Destroy()
        self.queenOfBloodTipReq = nil
      end
      return
    end
    local pTF = _go.transform
    pTF:SetParent(self.bubbleTipLayout.transform)
    pTF:Set_localScale(1, 1, 1)
    self.queenOfBloodTipObj = self.bubbleTipLayout:AddComponent(UIMainQueenOfBloodTipBtn, _go.name)
    self.queenOfBloodTipObj:Refresh(true)
  end)
end

function UIMainBottom:RefreshFingerLogic()
  local showFinger = false
  if DataCenter.LWGuideManager:CheckShowFinger() then
    showFinger = true
  end
  if showFinger then
    self:ShowFingerLogic()
  else
    self:StopShowFingerLogic()
  end
end

function UIMainBottom:ShowFingerLogic()
  self:ClearFingerHandle()
  self.fingerHandle = DataCenter.LWGuideVFXManager:InstantiateAsync("Assets/Main/Prefabs/Guide/UIArrowFinger.prefab", self.OnVfxLoaded, self, 0, GuideVFXPriority.Low)
  if self.isBottomVisible ~= false then
    self:StartTimer()
  end
end

function UIMainBottom:OnVfxLoaded(handle)
  if handle.isError then
    return
  end
  local gameObject = handle.gameObject
  local transform = gameObject.transform
  transform:SetParent(self.fingerGo.transform, false)
  transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  transform:SetParent(self.transform, true)
end

function UIMainBottom:StopShowFingerLogic()
  self:ClearFingerHandle()
end

function UIMainBottom:ClearFingerHandle()
  if self.fingerHandle then
    DataCenter.LWGuideVFXManager:StopCurrent(self.fingerHandle)
    self.fingerHandle = nil
  end
  self:DeleteTimer()
  self:StopFingerSound()
end

function UIMainBottom:StartTimer()
  self:DeleteTimer()
  self.fingerSoundTimer = TimerManager:GetInstance():GetTimer(5, self.PlayFingerSound, self, false, false, false)
  self.fingerSoundTimer:Start()
end

function UIMainBottom:DeleteTimer()
  if self.fingerSoundTimer ~= nil then
    self.fingerSoundTimer:Stop()
    self.fingerSoundTimer = nil
  end
end

function UIMainBottom:PlayFingerSound()
  self:StopFingerSound()
  self.playingFingerSoundId = DataCenter.LWSoundManager:PlaySound(62294, false)
end

function UIMainBottom:StopFingerSound()
  if self.playingFingerSoundId then
    DataCenter.LWSoundManager:StopSound(self.playingFingerSoundId)
    self.playingFingerSoundId = nil
  end
end

function UIMainBottom:PlayHitScale(tr)
  local sequence = CS.DG.Tweening.DOTween.Sequence()
  sequence:Append(tr:DOScale(Vector3.New(0.9, 0.9, 1), 0.05):SetEase(CS.DG.Tweening.Ease.Linear))
  sequence:Append(tr:DOScale(Vector3.New(1.1, 1.1, 1), 0.1):SetEase(CS.DG.Tweening.Ease.Linear))
  sequence:Append(tr:DOScale(Vector3.New(1, 1, 1), 0.1):SetEase(CS.DG.Tweening.Ease.Linear))
end

function UIMainBottom:ShowAlChallengeBossBubbleAsync()
  if not DataCenter.ActivityKillZombieManager.isNewFuncOpen then
    if self.alChallengeBossBubbleItem then
      self.alChallengeBossBubbleItem:SetActive(false)
    end
    return
  end
  if self.alChallengeBossBubbleReq == nil then
    self.alChallengeBossBubbleReq = self:GameObjectInstantiateAsync(NEW_AL_CHALLENGE_BUBBLE_PATH, function(request)
      if request.isError then
        request:Destroy()
        return
      end
      if self.bubbleTipLayout then
        local go = request.gameObject
        go.transform:SetParent(self.bubbleTipLayout.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        self.alChallengeBossBubbleItem = self.bubbleTipLayout:AddComponent(AlChallengeBossBubbleItem, go.name)
        self.alChallengeBossBubbleItem:ReInit()
      end
    end)
  elseif self.alChallengeBossBubbleItem then
    self.alChallengeBossBubbleItem:ReInit()
  end
end

function UIMainBottom:ShowHeroTrialMissileEnergy()
  if self.heroTrialMissileEnergyReq == nil then
    self.heroTrialMissileEnergyReq = self:GameObjectInstantiateAsync(UIMainHeroTrialMissileEnergyPath, function(request)
      if request.isError then
        request:Destroy()
        return
      end
      if self.left_layout and self.left_layout.transform then
        local go = request.gameObject
        go.transform:SetParent(self.left_layout.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        self.heroTrialMissileEnergyComponent = self:AddComponent(UIMainHeroTrialMissileEnergyComponent, left_btn_layout_path .. "/" .. go.name)
        self.heroTrialMissileEnergyComponent:SetAnchoredPositionXY(110, 68)
        self.heroTrialMissileEnergyComponent:ReInit()
      end
    end)
  elseif self.heroTrialMissileEnergyComponent then
    self.heroTrialMissileEnergyComponent:ReInit()
  end
end

function UIMainBottom:HideHeroTrialMissileEnergy()
  if self.heroTrialMissileEnergyComponent then
    self.heroTrialMissileEnergyComponent:Hide()
  end
end

function UIMainBottom:RefreshNewAllianceChallengeDonateInfo()
  self:ShowAlChallengeBossBubbleAsync()
  if not SceneUtils.GetIsInWorld() then
    self:HideHeroTrialMissileEnergy()
    return
  end
  if DataCenter.ActivityKillZombieManager:CheckNewAllianceChallengeDonateInfoShow() then
    self:ShowHeroTrialMissileEnergy()
    return
  end
  self:HideHeroTrialMissileEnergy()
end

function UIMainBottom:RefreshAllianceRedDot()
  self:OnUpdateRedPot(UIMainFunctionInfo.Alliance)
end

function UIMainBottom:RefreshLuckyPacketShareTip()
  local end_time = DataCenter.LuckyBuffManager:GetShortestExpireTime()
  if end_time <= 0 then
    if self.luckyPacketShareTipComponent then
      self.luckyPacketShareTipComponent:SetActive(false)
    end
    return
  end
  if self.luckyPacketShareTipReq == nil then
    self.luckyPacketShareTipReq = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWMainUI/ShareButton.prefab", function(request)
      if request.isError then
        self:GameObjectDestroy(self.luckyPacketShareTipReq)
        self.luckyPacketShareTipReq = nil
        return
      end
      local _go = request.gameObject
      local pTF = _go.transform
      pTF:SetParent(self.bubbleTipLayout.transform)
      pTF:Set_localScale(1, 1, 1)
      self.luckyPacketShareTipComponent = self.bubbleTipLayout:AddComponent(LuckyPacketShareTipBtn, _go.name)
      self.luckyPacketShareTipComponent:RefreshTime()
    end)
  elseif self.luckyPacketShareTipComponent then
    self.luckyPacketShareTipComponent:SetActive(true)
    self.luckyPacketShareTipComponent:RefreshTime()
  end
end

function UIMainBottom:RefreshLockHartActivityTip()
  if not DataCenter.LWActivityLockhartManager:IsShowLockHartMain() then
    if self.lockHartTipComponent then
      self.lockHartTipComponent:SetActive(false)
    end
    return
  end
  local activityData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.LockhartActivity.Type)
  local activityId = activityData.id
  if activityId ~= nil and self.lockHartTipReq == nil then
    self.lockHartTipReq = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWMainUI/UIMainBtnLockHart.prefab", function(request)
      if request.isError then
        self:GameObjectDestroy(self.lockHartTipReq)
        self.lockHartTipReq = nil
        return
      end
      if not DataCenter.LWActivityLockhartManager:IsShowLockHartMain() then
        self:GameObjectDestroy(self.lockHartTipReq)
        self.lockHartTipReq = nil
        return
      end
      local _go = request.gameObject
      local pTF = _go.transform
      pTF:SetParent(self.bubbleTipLayout.transform)
      pTF:Set_localScale(1, 1, 1)
      self.lockHartTipComponent = self.bubbleTipLayout:AddComponent(UIMainBtnLockHart, _go.name)
      self.lockHartTipComponent:SetActivityIcon(activityId)
    end)
  elseif self.lockHartTipComponent then
    self.lockHartTipComponent:SetActive(true)
    self.lockHartTipComponent:SetActivityIcon(activityId)
  end
end

function UIMainBottom:RefreshShowPopupNotificationBubble()
  local curPopupList = DataCenter.LWPopupManager:GetPopupNotificationList()
  local curPopupCount = #curPopupList
  if curPopupCount == 0 then
    self.popup_notification_layout:SetActive(false)
    return
  end
  if self.popupNotificationBubbleCompDict == nil then
    self.popupNotificationBubbleCompDict = {}
  end
  if self.popupNotificationBubbleReqList == nil then
    self.popupNotificationBubbleReqList = {}
  end
  local showMaxCount = DataCenter.LWPopupManager:GetPopupNotificationMaxShowCount()
  local finalShowCount = curPopupCount
  if curPopupCount > showMaxCount then
    finalShowCount = showMaxCount
  end
  self.popup_notification_layout:SetActive(true)
  local width = 82 * finalShowCount + (finalShowCount - 1) * 10
  self.popup_notification_layout:SetSizeDeltaXY(width, 82)
  self.popup_notification_layout:SetAsLastSibling()
  for i = 1, finalShowCount do
    if self.popupNotificationBubbleReqList[i] == nil then
      local index = i
      self.popupNotificationBubbleReqList[i] = self:GameObjectInstantiateAsync(LWMainUIPopupNotificationItemPath, function(request)
        local go = request.gameObject
        if IsNull(go) or self.bubbleTipLayout == nil then
          request:Destroy()
          return
        end
        if self.popup_notification_layout == nil then
          request:Destroy()
          return
        end
        go.transform:SetParent(self.popup_notification_layout.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.name = "PopupNotificationItem" .. index
        go.transform:SetSiblingIndex(index - 1)
        local itemRenderComp = self.popup_notification_layout:AddComponent(LWMainUIPopupNotificationItemRender, go.name)
        self.popupNotificationBubbleCompDict[index] = itemRenderComp
        local latestPopupList = DataCenter.LWPopupManager:GetPopupNotificationList()
        local latestPopupCount = #latestPopupList
        local popupData = latestPopupCount >= index and latestPopupList[index] or nil
        if popupData then
          itemRenderComp:ReInit(popupData)
        else
          itemRenderComp:SetActive(false)
        end
      end)
    else
      local itemRenderComp = self.popupNotificationBubbleCompDict[i]
      if itemRenderComp then
        local popupData = curPopupCount >= i and curPopupList[i] or nil
        if popupData then
          itemRenderComp:ReInit(popupData)
        else
          itemRenderComp:SetActive(false)
        end
      end
    end
  end
  if self.popupNotificationBubbleCompDict then
    for i, v in pairs(self.popupNotificationBubbleCompDict) do
      if finalShowCount < i and v then
        v:SetActive(false)
      end
    end
  end
end

function UIMainBottom:DestroyPopupNotificationBubble()
  if self.popup_notification_layout then
    self.popup_notification_layout:RemoveComponents(LWMainUIPopupNotificationItemRender)
  end
  if self.popupNotificationBubbleReqList ~= nil then
    for k, v in pairs(self.popupNotificationBubbleReqList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.popupNotificationBubbleReqList = {}
  self.popupNotificationBubbleCompDict = {}
end

return UIMainBottom
