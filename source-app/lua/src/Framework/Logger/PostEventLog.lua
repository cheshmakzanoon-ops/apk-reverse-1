local CSPostEventLog = CS.PostEventLog
local Sdk = CS.GameEntry.Sdk
local rapidjson = require("rapidjson")
local PostEventLog = {}
PostEventLog.Defines = {
  BattleParkourStart = "BattleParkourStart",
  BattleBarrageStart = "BattleBarrageStart",
  BattleCountStart = "BattleCountStart",
  BattleParkourResult = "BattleParkourResult",
  BattleBarrageResult = "BattleBarrageResult",
  BattleCountResult = "BattleCountResult",
  BattleParkourSkip = "BattleParkourSkip",
  BattleCountSkip = "BattleCountSkip",
  BattleHeroSlot = "BattleHeroSlot",
  BattleMemRecord = "BattleMemRecord",
  PlotGroupStart = "PlotGroupStart",
  PlotGroupDone = "PlotGroupDone",
  PlotEnter = "PlotEnter",
  PlotExit = "PlotExit",
  GuideFlowBegin = "GuideFlowBegin",
  GuideFlowDone = "GuideFlowDone",
  GuideFlowSkip = "GuideFlowSkip",
  GuideFlowStepIn = "GuideFlowStepIn",
  GuideFlowStepOut = "GuideFlowStepOut",
  cg_start = "cg_start",
  cg_finish = "cg_finish",
  cg_skip = "cg_skip",
  open_window = "open_window",
  close_window = "close_window",
  change_to_city_start = "change_to_city_start",
  change_to_city_finish = "change_to_city_finish",
  change_to_world_start = "change_to_world_start",
  change_to_world_finish = "change_to_world_finish",
  pay_before_check = "pay_before_check",
  pay_before_check_error = "pay_before_check_error",
  cancel_pay = "cancel_pay",
  pay_google_step1 = "pay_google_step1",
  pay_google_step2 = "pay_google_step2",
  on_purchase_queried = "on_purchase_queried",
  on_purchase_callback = "on_purchase_callback",
  on_purchase_callback_break = "on_purchase_callback_break",
  on_purchase_callback_consumed_order = "on_purchase_callback_consumed_order",
  open_pay_select = "open_pay_select",
  pay_redirect = "pay_redirect",
  save_pay_redirect = "save_pay_redirect",
  save_pay_ios = "save_pay_ios",
  save_pay_gp = "save_pay_gp",
  save_pay_inquiry = "save_pay_inquiry",
  call_payment_google_send_goods = "call_payment_google_send_goods",
  pay_google_env_check_fail = "pay_google_env_check_fail",
  oneTapSpeedUp_item_open = "oneTapSpeedUp_item_open",
  OneTapSpeedUp_item_confirm = "OneTapSpeedUp_item_confirm",
  OneTapSpeedUp_diamond_confirm = "OneTapSpeedUp_diamond_confirm",
  OneTapSpeedUp_diamond_confirm_notenough = "OneTapSpeedUp_diamond_confirm_notenough",
  click_enter_replay = "click_enter_replay",
  click_quit_replay = "click_quit_replay",
  OpenWorkerDrawCardView = "OpenWorkerDrawCardView",
  MonopolyGroundFinish = "monopoly_ground_finish",
  OpenInfiniteGiftWindow = "open_infinite_gift_window",
  OpenGiftBoxRewardPreviewPanel = "OpenGiftBoxRewardPreviewPanel",
  OpenGiftBoxGetKeyPanel = "OpenGiftBoxGetKeyPanel",
  OpenGiftBoxRankPanel = "OpenGiftBoxRankPanel",
  OpenGiftBoxJumpAnimToggle = "OpenGiftBoxJumpAnimToggle",
  HeroMonthCardResLackTip = "HeroMonthCardResLackTip",
  HeroMonthCardPopViewOpen = "HeroMonthCardPopViewOpen",
  HeroMonthCardViewOpen = "HeroMonthCardViewOpen",
  Client_iOS_FB_PurchaseEvent = "Client_iOS_FB_PurchaseEvent",
  CurNetProxy = "CurNetProxy",
  WorldMarchDisplayUpgrade = "WorldMarchDisplayUpgrade",
  WorldMarchDisplayDowngrade = "WorldMarchDisplayDowngrade",
  OpenRefundWindow = "credit_mention_view_show",
  RefundClickRecharge = "credit_mention_view_go_exchange",
  RefundClickCustomerService = "credit_mention_view_contact_us",
  FiveStartScore = "five_start_score",
  CurCrossNetProxy = "CurCrossNetProxy",
  OpenWeekCardSpecialRewardList = "C_click_open_weekcard_special_rewardlist",
  OpenWeekCardSpecial = "C_click_open_weekcard_special",
  TranslationSpeed = "translation_speed",
  TranslationUrl = "translation_url",
  MultipleParkourMarch = "MultipleParkourMarch",
  MultipleParkourEnter = "MultipleParkourEnter",
  MultipleParkourExit = "MultipleParkourExit",
  MultipleParkourResult = "MultipleParkourResult",
  ActSlotMachineMainOpen = "ActSlotMachineMainOpen",
  ActSlotMachineTaskOpen = "ActSlotMachineTaskOpen",
  ActSlotMachineRateOpen = "ActSlotMachineRateOpen",
  ActSlotMachineTipOpen = "ActSlotMachineTipOpen",
  ActSlotMachineProgressOpen = "ActSlotMachineProgressOpen",
  ActSlotMachineBoxOpen = "ActSlotMachineBoxOpen",
  ActSlotMachineBoxClose = "ActSlotMachineBoxClose",
  ActSlotMachineBoxBtnClick = "ActSlotMachineBoxBtnClick",
  ActSlotMachineMultipleOpen = "ActSlotMachineMultipleOpen",
  ActSlotMachineMultipleClose = "ActSlotMachineMultipleClose",
  ActSlotMachineBoxAllGetBtnClick = "ActSlotMachineBoxAllGetBtnClick",
  ActSlotMachineSkipAniOpen = "ActSlotMachineSkipAniOpen",
  OpenCitySkinSkillView = "OpenCitySkinSkillView",
  DecorationBGMOpen = "DecorationBGMOpen",
  BanquetAttackMonsterOpen = "BanquetAttackMonsterOpen",
  BanquetAttackMonsterCost1LackOpen = "BanquetAttackMonsterCost1LackOpen",
  BanquetAttackMonsterCost2LackOpen = "BanquetAttackMonsterCost2LackOpen",
  BanquetAttackMonsterLevelRewardOpen = "BanquetAttackMonsterLevelRewardOpen",
  ActMonopolyLoopTaskOpen = "ActMonopolyLoopTaskOpen",
  ActMonopolyBoxRewardOpen = "ActMonopolyBoxRewardOpen",
  ActMonopolyActRadarTreasureListOpen = "ActMonopolyActRadarTreasureListOpen",
  ActMonopolyActRadarTreasureGotoBtnClick = "ActMonopolyActRadarTreasureGotoBtnClick",
  ActRadarTreasureGetResultOpen = "ActRadarTreasureGetResultOpen",
  ActRadarTreasureUseItemMsgClick = "ActRadarTreasureUseItemMsgClick",
  ActMonopolyAutoDice = "ActMonopolyAutoDice",
  ShakeCollectRes = "ShakeCollectRes",
  ActivityDecorationGachaOpen = "ActivityDecorationGachaOpen",
  ActivityDecorationGachaOpenBook = "ActivityDecorationGachaOpenBook",
  ActivityDecorationGachaOpenWish = "ActivityDecorationGachaOpenWish",
  ActivityDecorationGachaOpenProgress = "ActivityDecorationGachaOpenProgress",
  SendHelpStopFire = "SendHelpStopFire",
  ActivityTorchRelayEnterGameGrowUp = "ActivityTorchRelayEnterGameGrowUp",
  ActivityTorchRelayInGameControl = "ActivityTorchRelayInGameControl",
  ActivityTorchRelayPropsBorn = "ActivityTorchRelayPropsBorn",
  ActivityTorchRelayBuffGet = "ActivityTorchRelayBuffGet",
  ActivityTorchRelayObstaclesGet = "ActivityTorchRelayObstaclesGet",
  OpenForceUpdateView = "OpenForceUpdateView",
  CSTimeDiff = "CS_TIME_DIFF",
  HeroRecruitPreviewOpenNew = "HeroRecruitPreviewOpenNew",
  HeroRecruitPreviewOpenPreview = "HeroRecruitPreviewOpenPreview",
  HeroRecruitWishOpen = "HeroRecruitWishOpen",
  HeroRecruitWishGuideOpen = "HeroRecruitWishGuideOpen",
  FULL_PAGE_TRANSLATION = "FULL_PAGE_TRANSLATION",
  InvasionAisillaSummoned = "InvasionAisillaSummoned",
  LittleSmartActive = "LittleSmartActive",
  NewTroopLine = "NewTroopLine",
  WorldDisplaySettingsFpsLow = "WorldDisplaySettingsFpsLow",
  DelayLoadWorldCityEff = "DelayLoadWorldCityEff",
  UIActCommunityLink = "UIActCommunityLink",
  ShumeiCreateAccountRiskBan = "s_shu_mei_event",
  DecoSplitUpgradeClickTips = "DecoSplitUpgradeClickTips",
  OpenDecoConvertPanel = "OpenDecoConvertPanel",
  GoActDecorationGachaMainOpenFromLackPage = "GoActDecorationGachaMainOpenFromLackPage",
  HummerScenePlayTime = "HummerScenePlayTime",
  DMA_AGREE_RECORD = "DMA_AGREE_RECORD",
  ParkourNumberDoorDeath = "ParkourNumberDoorDeath",
  ParkourStaticNumberDoorDeath = "ParkourStaticNumberDoorDeath",
  FriendsCirlePost = "MOMENT_POST",
  CommonShopOpenView = "CommonShopOpenView",
  DecorationViewClickGoToBuy = "DecorationViewClickGoToBuy",
  DecorationViewClickGainWays = "DecorationViewClickGainWays",
  ArabicAutoMirrorOpen = "ArabicAutoMirrorOpen",
  OpenGoldBrickWebUrl = "OpenGoldBrickWebUrl",
  OpenExplorerTreasureView = "OpenExplorerTreasureView",
  NewbiesSoldierComing = "NewbiesSoldierComing",
  NewbiesChpaterStartOpen = "NewbiesChpaterStartOpen",
  NewbiesChpaterStartClose = "NewbiesChpaterStartClose",
  NewbiesClickGoBtn = "NewbiesClickGoBtn",
  NewbiesChpaterFinishOpen = "NewbiesChpaterFinishOpen",
  NewbiesChpaterFinishClose = "NewbiesChpaterFinishClose",
  NewbiesPlayHeroExhibit = "NewbiesPlayHeroExhibit",
  NewbiesClickUIGo = "NewbiesClickUIGo",
  RecommendTipOpen = "RecommendTipOpen",
  RecommendTipContinue = "RecommendTipContinue",
  RecommendTipCancel = "RecommendTipCancel",
  RecommendTipClose = "RecommendTipClose",
  RecommendBtnClick1 = "RecommendBtnClick1",
  RecommendBtnClick2 = "RecommendBtnClick2",
  RecommendClickNormal = "RecommendClickNormal",
  RecommendClickUpgrade = "RecommendClickUpgrade",
  RecommendClickGift = "RecommendClickGift",
  RecommendClickZan = "RecommendClickZan",
  RecommendClickLevelUp = "RecommendClickLevelUp",
  PlayFirstPayTimeline = "PlayFirstPayTimeline",
  OpenFirstPayUI = "OpenFirstPayUI",
  ReceiveChapterListReward = "ReceiveChapterListReward",
  ClickPowerUpActBubble = "ClickPowerUpActBubble",
  ClickPowerUpGoto = "ClickPowerUpGoto",
  ClickBattleFailBtn = "ClickBattleFailBtn",
  ClickBattleFailUIBtns = "ClickBattleFailUIBtns",
  DoomDayWhenOpenUI = "DoomDayWhenOpenUI",
  NewbiesUnlockFogLeft = "NewbiesUnlockFogLeft",
  NewbiesUnlockFogRight = "NewbiesUnlockFogRight",
  NewbiesMysteryTreasureBattleEnter = "NewbiesMysteryTreasureBattleEnter",
  NewbiesMysteryTreasureBattleWin = "NewbiesMysteryTreasureBattleWin",
  NewbiesMysteryTreasureBattleLose = "NewbiesMysteryTreasureBattleLose",
  NewbiesMysteryTreasureBattleBuffActive = "NewbiesMysteryTreasureBattleBuffActive",
  WelcomeJoinAllianceBubbleClick = "NewbiesWelcomeAllianceBubbleClick",
  CelebrationAllianceRewardBubbleClick = "CelebrationAllianceRewardBubbleClick",
  WelcomeJoinAllianceClickToGetReward = "WelcomeJoinAllianceClickToGetReward",
  CelebrationAllianceRewardClickToGetReward = "CelebrationAllianceRewardClickToGetReward",
  OpenRefundFAQView = "OpenRefundFAQView",
  OpenRefundApplicationView = "OpenRefundApplicationView",
  ClickGoldBrickWhenBrickLessZero = "ClickGoldBrickWhenBrickLessZero",
  OpenGoldBrickRetrieval = "OpenGoldBrickRetrieval",
  RecommendSortClick = "RecommendSortClick",
  MomentTabEnter = "MomentTabEnter",
  TransLateContentError = "TransLateContentError",
  UserSetting = "UserSetting",
  BountyHunterOpenMain = "BountyHunterOpenMain",
  BountyHunterOpenExchange = "BountyHunterOpenExchange",
  BountyHunterOpenProgressReward = "BountyHunterOpenProgressReward",
  BountyHunterOpenEventShop = "BountyHunterOpenEventShop",
  BountyHunterOpenReward = "BountyHunterOpenReward",
  BountyHunterOpenRules = "BountyHunterOpenRules",
  ItemBagOnGotoActivityByType = "ItemBagOnGotoActivityByType",
  FireworkCount = "FireworkCount",
  CLAP_HANDS_SUCCESS = "CLAP_HANDS_SUCCESS",
  CLAP_HANDS_WATCH = "CLAP_HANDS_WATCH",
  USER_ACTION_COLLECT = "c_action_collect",
  SEASON_DOWN_COLLECT = "season_down_collect",
  IOSVersionUpdateTip = "IOSVersionUpdateTip",
  NewsCenterLikeNum = "NEWSCENTER_LIKE_NUM",
  NewsCenterOpen = "NEWSCENTER_OPEN",
  NewsCenterRead = "NEWSCENTER_READ",
  NewsCenterCheck = "NEWSCENTER_CHECK",
  NewsCenterShare = "c_newscenter_share",
  CustomGroupAcceptInvitation = "c_group_chat_invite_click",
  Vip18SkinPageEnter = "vip18_skinpage_enter",
  Vip18InvitationLetterOpen = "vip18_invitation_letter_open",
  Vip18AnonToggle = "vip18_anon_toggle",
  Vip18ContactServiceClick = "vip18_contact_service_click",
  MailTipIconClick = "mail_tip_icon_click",
  SURFING_GAMING_ON_GET_ALLY_BUFF = "SURFING_GAMING_ON_GET_ALLY_BUFF",
  SURFING_GAMING_ON_START = "SURFING_GAMING_ON_START",
  SURFING_GAMING_ON_END = "SURFING_GAMING_ON_END",
  C_CALENDAR_USE = "c_calendar_use",
  C_PLAYERGIFTSHOW_SELF = "c_playergiftshow_self",
  C_PLAYERGIFTSHOW_OTHERS = "c_playergiftshow_others",
  MAIL_SEARCH = "MAIL_SEARCH",
  MAIL_FILTER = "MAIL_FILTER",
  on_firstpay_herotip_open = "on_firstpay_herotip_open",
  on_firstpay_herotip_chooseskill = "on_firstpay_herotip_chooseskill",
  goldbrick_IOS = "goldbrick_IOS",
  C_ALLIANCEFIRSTJOIN = "c_allianceFirstJoin",
  C_ALLIANCELIST_JOIN = "c_allianceList_join",
  C_ALLIANCELIST_CREAT = "c_allianceList_creat",
  C_ALLIANCEINVITE = "c_allianceInvite",
  C_ALLIANCENOTICE = "c_allianceNotice",
  C_ALLIANCEMAIL = "c_allianceMail",
  C_ALLIANCEDECLARATION = "c_allianceDeclaration",
  RedPacketShareChannelSwitch = "RedPacketShareChannelSwitch",
  OpenUpgradeTreasureBox = "OpenUpgradeTreasureBox",
  UpgradeTreasureBoxComplete = "UpgradeTreasureBoxComplete",
  UpgradeTreasureBoxLeftBoxNum = "UpgradeTreasureBoxLeftBoxNum",
  FlowerTrain_Share_Chat_Success = "FlowerTrain_Share_Chat_Success",
  FlowerTrain_Share_Moment_Success = "FlowerTrain_Share_Moment_Success",
  FlowerTrain_Show_Use_Panel = "FlowerTrain_Show_Use_Panel",
  FlowerTrain_Show_Rank_Panel = "FlowerTrain_Show_Rank_Panel",
  FlowerTrain_Show_Alliance_Panel = "FlowerTrain_Show_Alliance_Panel",
  FlowerTrain_Show_Arrive_Panel = "FlowerTrain_Show_Arrive_Panel",
  FlowerTrain_Show_Tip_Panel = "FlowerTrain_Show_Tip_Panel",
  FlowerTrain_Show_Info_Panel = "FlowerTrain_Show_Info_Panel",
  FlowerTrain_Show_Level_Panel = "FlowerTrain_Show_Level_Panel",
  FlowerTrain_Show_BoxRule_Panel = "FlowerTrain_Show_BoxRule_Panel",
  MiniGameTrackEvent = "MiniGameTrackEvent",
  LastStandEnterLevel = "LastStandEnterLevel",
  LastStandWinLevel = "LastStandWinLevel",
  LastStandLoseLevel = "LastStandLoseLevel",
  LastStandGiveUpLevel = "LastStandGiveUpLevel",
  c_migrate_ad_connect = "c_migrate_ad_connect",
  BattleSkyBattleStart = "Battle_SkyBattle_Start",
  BattleSkyBattleExit = "Battle_SkyBattle_Exit",
  BattleSkyBattleSuccess = "Battle_SkyBattle_Success",
  BattleSkyBattleFailed = "Battle_SkyBattle_Failed",
  BattleSkyBattleBubbleClick = "Battle_SkyBattle_Bubble_Click",
  C_clickHelpInfoBtn = "c_clickHelpInfoBtn",
  C_clickLoseShareBtn = "c_clickLoseShareBtn",
  GHOST_GAMING_ON_START = "GHOST_GAMING_ON_START",
  GHOST_GAMING_ON_END = "GHOST_GAMING_ON_END",
  BattleExitTimeByType = "c_battleExitTimeByType",
  GHOST_GAMING_ON_LOG_UPLOADED = "GHOST_GAMING_ON_LOG_UPLOADED",
  GHOST_GAMING_ON_LOG_LOADED = "GHOST_GAMING_ON_LOG_LOADED",
  c_migrate_ad_connect = "c_migrate_ad_connect",
  applovin_callback_break = "applovin_callback_break",
  ADLoadingSuccess = "ADLoadingSuccess",
  ADLoadingFail = "ADLoadingFail",
  AdShowFail = "AdShowFail",
  ADEventOpen = "ADEventOpen",
  ADIconClick = "ADIconClick",
  ADIncome = "ADIncome",
  ADClick = "ADClick",
  getmoreOpen = "getmoreOpen",
  ADViewSuccess = "ADViewSuccess",
  NAVIGATION_GESTURE_SWITCH = "navigation_gesture_switch",
  TRAIN_ROB_QUICK_BTN_CLICK = "TRAIN_ROB_QUICK_BTN_CLICK",
  ArmedUpgradeQTEClick = "c_armed_qte",
  c_enter_gold_store = "c_enter_gold_store",
  c_enter_store = "c_enter_store",
  c_amount_change = "c_amount_change",
  c_sound_dub_remote_success = "c_sound_dub_remote_success",
  ArmedUpgradeBtnClick = "c_armed_upgrade",
  OpenArmedUpgradePanel = "c_armed_upgrade_open",
  c_sticker_chat = "c_sticker_chat",
  c_pack_download_start = "c_pack_download_start",
  c_pack_download_complete = "c_pack_download_complete",
  c_pack_download_pause = "c_pack_download_pause",
  c_pack_del = "c_pack_del",
  c_one_click_go_battle = "c_one_click_go_battle",
  c_fail_settle_goto_show = "c_fail_settle_goto_show",
  c_fail_settle_goto = "c_fail_settle_goto",
  C_BUILDING_UPGRADE_FINISHED = "C_BUILDING_UPGRADE_FINISHED",
  c_open_build_main_detail_way = "c_open_build_main_detail_way",
  C_Activity_Calendar_Entry_Count = "c_activity_calendar_entry_count",
  PayCurrencyLock = "PayCurrencyLock",
  AccountScore_LogInScoreWeb = "AccountScore_LogInScoreWeb",
  c_show_sweep_reward_view = "c_show_sweep_reward_view",
  c_show_sweep_reward_view_cost_tips = "c_show_sweep_reward_view_cost_tips",
  c_show_sweep_reward_view_rewards_tips = "c_show_sweep_reward_view_rewards_tips",
  c_show_sweep_confirm_view_refresh_item = "c_show_sweep_confirm_view_refresh_item",
  c_show_full_screen_video = "c_show_full_screen_video",
  c_feature_exploration = "c_feature_exploration",
  c_quick_upgrade_goto_1 = "c_quick_upgrade_goto_1",
  c_quick_upgrade_goto_2 = "c_quick_upgrade_goto_2",
  c_black_land_alert_off = "c_black_land_alert_off"
}

function PostEventLog.InitTaData()
  if Sdk.LoginTracking ~= nil then
    Sdk:LoginTracking(DataCenter.PlayerInfoDataManager:GetSelfUid())
    local power = LuaEntry.Player.power
    local allianceId = LuaEntry.Player.allianceId
    local abTest = LuaEntry.Player.abTest
    PostEventLog.TaUserSet({lwu_alliance_id = allianceId, lwu_power = power})
    PostEventLog.TaUserSetOnce({lwu_ab = abTest})
    PostEventLog.SetSuperProperties({
      lw_alliance_id = allianceId,
      lw_power = power,
      lw_ab = abTest
    })
    DataCenter.AccountManager:Odm2_PostAggregateConversionInfo()
  end
end

function PostEventLog.TaUserSet(tbl)
  if CSPostEventLog.TaUserSet ~= nil then
    local value = tbl and rapidjson.encode(tbl) or ""
    CSPostEventLog.TaUserSet(value)
  end
end

function PostEventLog.TaUserSetOnce(tbl)
  if CSPostEventLog.TaUserSetOnce ~= nil then
    local value = tbl and rapidjson.encode(tbl) or ""
    CSPostEventLog.TaUserSetOnce(value)
  end
end

function PostEventLog.SetSuperProperties(tbl)
  if CSPostEventLog.SetSuperProperties ~= nil then
    local value = tbl and rapidjson.encode(tbl) or ""
    CSPostEventLog.SetSuperProperties(value)
  end
end

function PostEventLog.Track(eventName, tbl)
  if CSPostEventLog.Track ~= nil then
    local value = tbl and rapidjson.encode(tbl) or ""
    CSPostEventLog.Track(eventName, value)
  end
end

function PostEventLog.Record(action, ...)
  CSPostEventLog.Record(action, ...)
end

local _result_event_map

function PostEventLog.BattleResultLog(pveType, isWin)
  if not _result_event_map then
    _result_event_map = {
      [PVEType.Parkour] = PostEventLog.Defines.BattleParkourResult,
      [PVEType.Barrage] = PostEventLog.Defines.BattleBarrageResult,
      [PVEType.Count] = PostEventLog.Defines.BattleCountResult
    }
  end
  local event = _result_event_map[pveType]
  local battleLogic = DataCenter.LWBattleManager:GetCurBattleLogic()
  local myStageId = tostring(battleLogic:GetStageId())
  local myStageCostTime = battleLogic:GetCostTime()
  local myStageKill = battleLogic:GetTotalKill()
  local myAvgFPS = battleLogic:GetAvgFPS()
  local myLowestFPS = battleLogic:GetLowestFPS()
  local remainUnitCount = -1
  local testId
  if pveType == PVEType.Parkour then
    if battleLogic.GetRemainUnitCount then
      remainUnitCount = battleLogic:GetRemainUnitCount()
    end
    testId = LuaEntry.Player:GetGrayTestParkourStage(battleLogic:GetStageId())
  end
  local highestFps = CS.UnityEngine.Application.targetFrameRate
  PostEventLog.Track(event, {
    stageId = myStageId,
    stageCostTime = myStageCostTime,
    stageKill = myStageKill,
    stageResult = isWin,
    fps = myAvgFPS,
    minFps = myLowestFPS,
    remain_count = remainUnitCount,
    doorid = testId,
    pcurfps = highestFps
  })
end

function PostEventLog.QuitReplayLog(quit)
  local event = PostEventLog.Defines.click_quit_replay
  local battleLogic = DataCenter.LWBattleManager:GetCurBattleLogic()
  local mailUuid = battleLogic:GetMailUuid()
  local myWatchTime = battleLogic:GetWatchTime()
  local myFightDuration = battleLogic:GetFightDuration()
  local myFPS = battleLogic:GetAvgFPS()
  PostEventLog.Track(event, {
    uuid = tostring(mailUuid),
    fps = myFPS,
    quitType = quit,
    watchTime = myWatchTime,
    fightDuration = myFightDuration
  })
end

return PostEventLog
