ChatItemPosts = {
  [PostType.Text_AllianceNotice] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.AllianceNotice"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostAllianceNotice.prefab",
    offset = 15,
    hasTranslateBtn = true
  },
  [PostType.GroupChatInviter] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.GroupChatInvitation"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostGroupChatInvitation.prefab",
    offset = 15
  },
  [PostType.RedPackge_New] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.RedPackage"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostRedPacket.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.Truck_Send_Record] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.TruckRobShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostTruckRobShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.Text_AllianceRecruitShare] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.AllianceRecruitShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostAllianceRecruitShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.Text_ScoutReport] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.MailScoutResultShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostMailScoutResultShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.Text_FightReport] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.MailReportShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostMailReportShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.NewBattleReportShare] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.MailReportShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostMailReportShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.Landmine] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.LandmineShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostLandmineShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.Electrician_Gather] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.ElectricianGather"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostElectricianGather.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.GoldRelic] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.GoldRelicShare"),
    assetPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/Chat/PostGoldRelicShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.Disguise] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.DisguiseShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostDisguiseShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.DefaultMarch] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.DefaultMarchShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostDefaultMarch.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.Activity_MultipleParkour] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.MultipleParkour"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostMultipleParkour.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.Text_AllianceTaskShare] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.AllianceTaskShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostAllianceTaskShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.SeasonTrendsShare] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.SeasonTrendsShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostSeasonTrendsShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.Text_Normal] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.NormalChatNew"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostNormalChat.prefab",
    offset = 15,
    hasTranslateBtn = true
  },
  [ChatGroupType.GROUP_ALLIANCE_NOTICE .. PostType.Text_Normal] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.NoticeRemark"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostNoticeRemark.prefab",
    offset = 15,
    hasTranslateBtn = true,
    hasBg = true
  },
  [PostType.GHOST_RECON_TASK_TEAM] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.GhostReconTaskTeam"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostGhostReconTaskTeam.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.GHOST_RECON_SHARE_POINT] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.GhostReconSharePoint"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostGhostReconSharePoint.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.GHOST_RECON_REMIND_LEADER] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.GhostReconRemindLeader"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostGhostReconRemindLeader.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.Text_PointShare] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.PointShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostPointShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.INVASION_BOSS_SHARE] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.PointShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostPointShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.Train] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.TrainChat"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostTrain.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.MasterySkillShare] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.MasterySkillShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostMasterySkillShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.Title] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.PostTitleItem"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostTitleItem.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.Chat_Stickers] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.Sticker"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostSticker.prefab",
    offset = 45,
    hasTranslateBtn = false
  },
  [PostType.Chat_SendPhoto] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.SendPhoto"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostSendPhoto.prefab",
    offset = 35,
    hasTranslateBtn = false
  },
  [PostType.T11IdleGameAllianceHelp] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.T11IdleGameAllianceHelp"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostT11IdleGameAllianceHelp.prefab",
    offset = 35,
    hasTranslateBtn = false
  },
  [PostType.NewsCenterLink] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.NewsCenterLink"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/NewsCenterLink.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.SeasonDesert] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.DesertShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostDesertShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.Alliance_War] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.AllianceWar"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostAllianceWar.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.Activity_BargainShop] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.BargainShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostBargainShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.HELP_STOP_FIRE_PERSION] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.HelpStopFirePerson"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostHelpStopFirePerson.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.Dispatch_Treasure] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.DispatchTreasureShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostDispatchTreasureShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.Text_AllianceInvite] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.AllianceShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostAllianceShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.TorchRelayCheer] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.TorchRelayCheer"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostTorchRelayShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.SKILL_ADD_MUMMY_ARMY] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.SkillAddMummyArmy"),
    assetPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/Component/PostSkillAddMummyArmy.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.DiggingGameShareSingle] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.DiggingGameShare"),
    assetPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/Component/DiggingGameShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.SeasonPhoto] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.PostSeasonPhoto"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostSeasonPhoto.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.SeasonBankReport] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.PostSeasonBankReport"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostSeasonBankReport.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.STAGE_FEATURE_CHAPTER] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.StageFeatureChapter"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostStageFeatureChapterShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.ActMigration] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.ActMigrationShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostActMigrationShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.MIGRATE_INVITE] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.AllianceShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostAllianceShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.ValentineRankCard] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.ValentineRankCard"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostValentineRankShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.GiftGiving] = {
    postClass = require("UI.UIChatNew.Component.ChatItem.ChatGiftGivingPrivate"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostGiftGivingPrivate.prefab",
    offset = 15,
    hasTranslateBtn = true,
    translateTxtShowDiff = true,
    sendGiftBtn = true
  },
  [PostType.ZOMBIE_ATTACK_CITY_ASSISTANCE_DEFEND] = {
    postClass = require("UI.UIChatNew.Component.ChatItem.ChatZombieAttackCityAssistanceDefend"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostChatZombieAttackCityAssistanceDefend.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.TrainVipInvite] = {
    postClass = require("UI.UIChatNew.Component.ChatItem.ChatTrainVipInvite"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostTrainVipInvite.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.UseMasterySkill] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.UseMasterySkill"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostUseMasterySkill.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.DigTreasure] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.DigTreasureShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostDigTreasureShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.ALLIANCE_MONSTER_CHALLENGE_NEW_REWARD] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.KillZombieBoxShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostKillZombieBoxShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.TacticalCard] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.TacticalCardShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostTacticalCard.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.TacticalCard_Deck] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.TacticalCardShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostTacticalCard.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.TacticalCard_EquipPlan] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.TacticalCardShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostTacticalCard.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.FirstJoinAlliance] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.FirstJoinAllianceShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostFirstJoinAlliance.prefab",
    offset = 15,
    hasTranslateBtn = true
  },
  [PostType.SurfingInviteShare] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.SurfingInviteAllyShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostSurfingInviteAllyShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.SurfingBattleResultShare] = {
    postClass = require("UI.UIChatNew.Component.ChatItem.ChatItemClientPlayerShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/UILWChatClientPlayerShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.Alliance_Feature_Invite] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.AllianceInvite"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostAllianceInvite.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.Season_BiuBiuInvite] = {
    postClass = require("UI.UIChatNew.Component.ChatItem.ChatSeasonBiuBiuInviteMsg"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/ChatSeasonBiuBiuInviteMsg.prefab",
    offset = 15,
    hasTranslateBtn = true
  },
  [PostType.Season_BiuBiuResult] = {
    postClass = require("UI.UIChatNew.Component.ChatItem.ChatSeasonBiuBiuResultMsg"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/ChatSeasonBiuBiuResultMsg.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.Season_LittleGame_Invite] = {
    postClass = require("UI.UIChatNew.Component.ChatItem.ChatSeasonLittleGameInviteMsg"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/ChatSeasonLittleGameInviteMsg.prefab",
    offset = 15,
    hasTranslateBtn = true
  },
  [PostType.Season_LittleGame_Result] = {
    postClass = require("UI.UIChatNew.Component.ChatItem.ChatSeasonLittleGameResultMsg"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/ChatSeasonLittleGameResultMsg.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.FLOWER_TRAIN_SHARE] = {
    postClass = require("UI.FlowerTrain.UIFlowerTrainChatShare.PostFlowerTrainShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostFlowerTrainShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.FLOWER_TRAIN_POSITION_SHARE] = {
    postClass = require("UI.FlowerTrain.UIFlowerTrainChatShare.PostFlowerTrainPositionShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostFlowerTrainPositionShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.StageFeatureHelpInvite] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.StageFeatureHelpInvite"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostStageFeatureHelpInvite.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.StageFeatureHelpAccept] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.StageFeatureHelpAccept"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostStageFeatureHelpAccept.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.StageFeatureComplete] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.StageFeatureComplete"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostStageFeatureComplete.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.StageFeatureHelpInviteAlliance] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.StageFeatureHelpInviteAlliance"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostStageFeatureHelpInviteAlliance.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.BF_WINTER_HISTORY_SHARE] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.BFWinterHistoryShare"),
    assetPath = "Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/S0/PostBFWinterHistoryShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.GhostBattleResultShare] = {
    postClass = require("UI.UIChatNew.Component.ChatItem.ChatItemClientPlayerShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/UILWChatClientPlayerShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.GhostParkourRecordType] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.PostGhostParkourRecordShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostGhostParkourRecordShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.MilitaryPayShare] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.PostMilitaryPayShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostMilitaryPayShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.WorldBossNewRecord] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.PostWorldBossNewRecord"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostWorldBossNewRecord.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.FrontBreakSunday] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.FrontBreakSundayShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostFrontBreakSundayShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.ALLIANCE_INVITE_SHARE_NEW] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.AllianceShareNew"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostAllianceShareNew.prefab",
    offset = 15,
    hasTranslateBtn = true,
    translateTxtShowDiff = true
  }
}
local ChatHint = {
  postClass = require("UI.UIChatNew.Component.ChatItem.ChatHint"),
  assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemObj/ChatHint.prefab",
  offset = 15,
  hasTranslateBtn = false
}
local ChatCancelMsg = {
  postClass = require("UI.UIChatNew.Component.ChatItem.ChatCancelMsg"),
  assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemObj/ChatCancelMsg.prefab",
  offset = 15,
  hasTranslateBtn = false
}
local ChatAllianceRankChange = {
  postClass = require("UI.UIChatNew.Component.ChatItem.ChatAllianceRankChange"),
  assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatAllianceRankChange.prefab",
  offset = 15,
  hasTranslateBtn = false
}
local ChatAllianceMemberChange = {
  postClass = require("UI.UIChatNew.Component.ChatItem.ChatAllianceMemberChange"),
  assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatAllianceMemberChange.prefab",
  offset = 15,
  hasTranslateBtn = false
}
local ChatTrainDeparture = {
  postClass = require("UI.UIChatNew.Component.ChatItem.ChatTrainDeparture"),
  assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatTrainDeparture.prefab",
  offset = 15,
  hasTranslateBtn = false
}
local UILWChatGetDoubleRewardMsg = {
  postClass = require("UI.UIChatNew.Component.ChatPushMsg.UILWChatGetDoubleRewardMsg"),
  assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatPushMsg/UILWChatGetDoubleRewardMsg.prefab",
  offset = 15,
  hasTranslateBtn = false
}
local UILWChatZREliteBossAttackMsg = {
  postClass = require("UI.UIChatNew.Component.ChatPushMsg.UILWChatZREliteBossAttackMsg"),
  assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatPushMsg/UILWChatZREliteBossAttackMsg.prefab",
  offset = 15,
  hasTranslateBtn = false
}
local ChatPushMsg = {
  postClass = require("UI.UIChatNew.Component.ChatPushMsg.ChatPushMsg"),
  assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatPushMsg/ChatPushMsg.prefab",
  offset = 15,
  hasTranslateBtn = false
}
local ChatItemPlayersTriggerPushMsg = {
  postClass = require("UI.UIChatNew.Component.ChatItem.ChatItemPlayersTriggerPushMsg"),
  assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatPushMsg/UILWChatPlayersTriggerPushMsg.prefab",
  offset = 15,
  hasTranslateBtn = false
}
local ChatItemZoneMobilizationPushMsg = {
  postClass = require("UI.UIChatNew.Component.ChatItem.ChatItemZoneMobilizationPushMsg"),
  assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatPushMsg/UILWChatPlayersTriggerPushMsg.prefab",
  offset = 15,
  hasTranslateBtn = false
}
ChatItemPostsType2 = {
  Time = {
    postClass = require("UI.UIChatNew.Component.ChatItem.ChatTime"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemObj/ChatTime.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  Tip = {
    postClass = require("UI.UIChatNew.Component.ChatItem.ChatTip"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemObj/ChatTip.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  ChatAIAssistant = {
    postClass = require("UI.UIChatNew.Component.AIAssistant.ChatAIAssistantCell"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatAI/ChatAIAssistant.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.Detect_Treasure_Fin_Info] = ChatPushMsg,
  [PostType.NewAllianceRallyPoint] = ChatPushMsg,
  [PostType.DiggingGameShareAlliance] = ChatPushMsg,
  [PostType.OffSeasonDiggingGameShareAlliance] = ChatPushMsg,
  [PostType.SummonWeather] = {
    postClass = require("UI.UIChatNew.Component.ChatPushMsg.ChatSummonWeather"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatPushMsg/ChatSummonWeather.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.ZombieRush] = {
    postClass = require("UI.UIChatNew.Component.ChatZombieRush.UILWChatZombieRushMsg"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatZombieRush/UILWChatZombieRushMsg.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.Text_ChatRoomSystemMsg] = ChatHint,
  [PostType.Text_AllianceRankChange] = ChatHint,
  [PostType.Text_MemberJoin] = ChatAllianceMemberChange,
  [PostType.Abandon_AllianceCity] = ChatHint,
  [PostType.Text_MemberQuit] = ChatAllianceMemberChange,
  [PostType.MessageRecall] = ChatCancelMsg,
  [PostType.Alliance_OfficialChange] = ChatAllianceRankChange,
  [PostType.Alliance_LeaderChange] = ChatAllianceRankChange,
  [PostType.Train_Driver] = ChatTrainDeparture,
  [PostType.Train_Departure] = ChatTrainDeparture,
  [PostType.DetectEventGetDoubleTreasure] = UILWChatGetDoubleRewardMsg,
  [PostType.BestReward] = UILWChatGetDoubleRewardMsg,
  [PostType.SeasonTradeShopRefresh] = {
    postClass = require("UI.UIChatNew.Component.ChatPushMsg.ChatSeasonTradeShopRefreshMsg"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatPushMsg/ChatSeasonTradeShopRefresh.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.TradeOpenLevel] = {
    postClass = require("UI.UIChatNew.Component.ChatPushMsg.ChatSeasonTradeBattleStartMsg"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatPushMsg/ChatSeasonTradeBattleStart.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.OccupyTradePlayer] = {
    postClass = require("UI.UIChatNew.Component.ChatPushMsg.ChatSeasonTradeLordChangeMsg"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatPushMsg/ChatSeasonTradeLordChange.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.CaptureHugeSandWorm] = {
    postClass = require("UI.UIChatNew.Component.ChatPushMsg.ChatCaptureSandWormMsg"),
    assetPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/Chat/ChatCaptureSandworm.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.GiftGiving] = {
    postClass = require("UI.UIChatNew.Component.ChatItem.ChatGiftGiving"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostGiftGiving.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.ZOMBIE_RUSH_ELITE_BOSS_ATTACK] = {
    postClass = require("UI.UIChatNew.Component.ChatItem.ChatItemZombieRushEliteBossNotice"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatZombieRush/UILWChatZombieRushEliteBossMsg.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.MAD_COW_RUSH] = {
    postClass = require("UI.UIChatNew.Component.ChatItem.ChatItemMadCowRush"),
    assetPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/MadCow/UILWChatMadCowRush.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.TrainVipInvite] = {
    postClass = require("UI.UIChatNew.Component.ChatItem.ChatTrainVipInvite"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostTrainVipInvite.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.ZOMBIE_RUSH_ELITE_ALTER_BOSS_REWARD] = UILWChatGetDoubleRewardMsg,
  [PostType.ZOMBIE_RUSH_ELITE_ALTER_BOSS_ATTACK] = UILWChatZREliteBossAttackMsg,
  [PostType.ZONE_MOBILIZATION_AL_RES_CREATE] = ChatItemZoneMobilizationPushMsg,
  [PostType.ZONE_MOBILIZATION_SUPPLIES_CREATE] = ChatItemZoneMobilizationPushMsg,
  [PostType.ZONE_MOBILIZATION_SUPPLIES_TRIGGER_RED] = ChatItemPlayersTriggerPushMsg,
  [PostType.ActConcertReward] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.ActConcertRewardShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostActConcertRewardShare.prefab"
  },
  [PostType.MusicFestival2025_Share] = {
    postClass = require("UI.UIActCrazyRock.ChatShare.PostMusicFestival2025Share"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostMusicFestival2025Share.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.FIREWORK_GIFT_REWARD_DOUBLE] = UILWChatGetDoubleRewardMsg,
  [PostType.FIREWORK_GIFT_REWARD] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.FireworkGift"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostFireworkGift.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.SeasonAllianceWarTime] = {
    postClass = require("UI.UIChatNewV2.Component.ChatItem.Post.AllianceWarTimeStateChatNotice"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostAllianceWarTimeStateNotice.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.FLOWER_TRAIN_USE_SHARE] = {
    postClass = require("UI.FlowerTrain.UIFlowerTrainChatShare.PostFlowerTrainRunningShare"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemNew/PostFlowerTrainRunningShare.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.ALLIANCE_LUCK_SIPHON_BUFF] = {
    postClass = require("UI.UIChatNew.Component.ChatPushMsg.UILWChatGetLuckyMsg"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatPushMsg/UILWChatGetLuckyMsg.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.ALLIANCE_LUCK_SIPHON_NORMAL] = {
    postClass = require("UI.UIChatNew.Component.ChatPushMsg.UILWChatGetLuckyMsg"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatPushMsg/UILWChatGetLuckyMsg.prefab",
    offset = 15,
    hasTranslateBtn = false
  },
  [PostType.S0_ALLIANCE_BOSS_GIFT_REWARD] = {
    postClass = require("UI.UIChatNew.Component.ChatItem.ChatItemS0AllianceBossPushMsg"),
    assetPath = "Assets/Main/Prefabs/UI/ChatNew/ChatPushMsg/UILWChatPlayersTriggerPushMsg.prefab",
    offset = 15,
    hasTranslateBtn = false
  }
}
FriendsCirlePosts = {
  [PostType.FriendsCirleBody] = {
    postClass = require("UI/LWPlayerInfo/FriendCirclePost/post/FriendsCirleBody"),
    assetPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/FriendsCirclePost/FriendsCirleBody.prefab",
    offset = 15,
    hasTranslateBtn = true
  },
  [PostType.FriendsCirleBodyHasIcon] = {
    postClass = require("UI/LWPlayerInfo/FriendCirclePost/post/FriendsCirleBody"),
    assetPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/FriendsCirclePost/FriendsCirleBody.prefab",
    offset = 15,
    hasTranslateBtn = true
  },
  [PostType.Chat_Moment] = {
    postClass = require("UI/LWPlayerInfo/FriendCirclePost/post/FriendsCirleBody"),
    assetPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/FriendsCirclePost/FriendsCirleBody.prefab",
    offset = 15,
    hasTranslateBtn = true
  }
}
EasterEggChatPosts = {
  [ActEasterEggChatScrollItemType.Comment] = {
    postClass = require("UI.LWUIActEasterEgg.LWUIActEasterEggChat.Component.ChatItem.Post.EasterEggComment"),
    assetPath = "Assets/Main/ActivityRes/2025EasterMod/Prefabs/UI/LWUIActEasterEggChat/Post/EasterEggComment.prefab",
    offset = 0,
    hasTranslateBtn = true
  }
}
