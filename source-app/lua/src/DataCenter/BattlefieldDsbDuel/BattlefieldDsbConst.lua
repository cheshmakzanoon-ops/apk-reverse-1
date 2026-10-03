local Localization = CS.GameEntry.Localization
local BattlefieldDsbConst = {}
BattlefieldDsbConst = {}
BattlefieldDsbConst.RoleType = {
  None = 0,
  MIN = 1,
  A = 1,
  B = 2,
  C = 3,
  D = 4,
  MAX = 4,
  Mine = 9527
}
BattlefieldDsbConst.TeamType = {
  None = 0,
  A = 1,
  B = 2
}
BattlefieldDsbConst.Colors = {
  [BattlefieldDsbConst.RoleType.None] = {
    colorLabel = CityLabelWhiteColor,
    battlefieldHeadBg = "lrb_DLDzhanchang_qipao0.png",
    battlefieldHeadArrow = "lrb_DLDzhanchang_qipaojiao0",
    battlefieldPointBg = "lrb_DLDzhanchangjifen_0",
    battlefieldProgressBar = "lrb_DLDzhanchang_jindutiao05",
    buildTemplateIconIndex = 11
  },
  [BattlefieldDsbConst.RoleType.A] = {
    colorLabel = CityLabelBattlefieldDsbRole1Color,
    spBattlefieldBorder = "lrb_daluandou_zhanchang_1",
    spEnterBg = "lrb_daluandou_zanli_duiwu1",
    spPlayerTopBg = "lrb_daluandou_qipao_1",
    actAllianceItemBg = string.format(LoadPath.LWBattleFieldDsbDuelPath, "lrb_daluandou_jifen_1.png"),
    actMvpBg1 = string.format(LoadPath.LWBattleFieldDsbDuelPath, "lrb_daluandou_lishijilu_mvp_1.png"),
    actMvpBg2 = string.format(LoadPath.LWBattleFieldDsbDuelPath, "lrb_daluandou_lishijilu_mvp_tiao_1.png"),
    rankBg = "lrb_daluandou_jiesuan_1",
    txtColor = "#ffb644",
    battlefieldHeadBg = "lrb_DLDzhanchang_qipao1",
    battlefieldHeadArrow = "lrb_DLDzhanchang_qipaojiao1",
    battlefieldPointBg = "lrb_DLDzhanchangjifen_1",
    battlefieldProgressBar = "lrb_DLDzhanchang_jindutiao01",
    bfMaterialIndex = 0,
    buildTemplateIconIndex = 1
  },
  [BattlefieldDsbConst.RoleType.B] = {
    colorLabel = CityLabelBattlefieldDsbRole2Color,
    spBattlefieldBorder = "lrb_daluandou_zhanchang_2",
    spEnterBg = "lrb_daluandou_zanli_duiwu2",
    spPlayerTopBg = "lrb_daluandou_qipao_2",
    actAllianceItemBg = string.format(LoadPath.LWBattleFieldDsbDuelPath, "lrb_daluandou_jifen_2.png"),
    actMvpBg1 = string.format(LoadPath.LWBattleFieldDsbDuelPath, "lrb_daluandou_lishijilu_mvp_2.png"),
    actMvpBg2 = string.format(LoadPath.LWBattleFieldDsbDuelPath, "lrb_daluandou_lishijilu_mvp_tiao_2.png"),
    rankBg = "lrb_daluandou_jiesuan_2",
    txtColor = "#f97077",
    battlefieldHeadBg = "lrb_DLDzhanchang_qipao2",
    battlefieldHeadArrow = "lrb_DLDzhanchang_qipaojiao2",
    battlefieldPointBg = "lrb_DLDzhanchangjifen_2",
    battlefieldProgressBar = "lrb_DLDzhanchang_jindutiao02",
    bfMaterialIndex = 1,
    buildTemplateIconIndex = 2
  },
  [BattlefieldDsbConst.RoleType.C] = {
    colorLabel = CityLabelBattlefieldDsbRole3Color,
    spBattlefieldBorder = "lrb_daluandou_zhanchang_3",
    spEnterBg = "lrb_daluandou_zanli_duiwu3",
    spPlayerTopBg = "lrb_daluandou_qipao_3",
    actAllianceItemBg = string.format(LoadPath.LWBattleFieldDsbDuelPath, "lrb_daluandou_jifen_3.png"),
    actMvpBg1 = string.format(LoadPath.LWBattleFieldDsbDuelPath, "lrb_daluandou_lishijilu_mvp_3.png"),
    actMvpBg2 = string.format(LoadPath.LWBattleFieldDsbDuelPath, "lrb_daluandou_lishijilu_mvp_tiao_3.png"),
    rankBg = "lrb_daluandou_jiesuan_3",
    txtColor = "#ccab88",
    battlefieldHeadBg = "lrb_DLDzhanchang_qipao3",
    battlefieldHeadArrow = "lrb_DLDzhanchang_qipaojiao3",
    battlefieldPointBg = "lrb_DLDzhanchangjifen_3",
    battlefieldProgressBar = "lrb_DLDzhanchang_jindutiao03",
    bfMaterialIndex = 2,
    buildTemplateIconIndex = 3
  },
  [BattlefieldDsbConst.RoleType.D] = {
    colorLabel = CityLabelBattlefieldDsbRole4Color,
    spBattlefieldBorder = "lrb_daluandou_zhanchang_4",
    spEnterBg = "lrb_daluandou_zanli_duiwu4",
    spPlayerTopBg = "lrb_daluandou_qipao_4",
    actAllianceItemBg = string.format(LoadPath.LWBattleFieldDsbDuelPath, "lrb_daluandou_jifen_4.png"),
    actMvpBg1 = string.format(LoadPath.LWBattleFieldDsbDuelPath, "lrb_daluandou_lishijilu_mvp_4.png"),
    actMvpBg2 = string.format(LoadPath.LWBattleFieldDsbDuelPath, "lrb_daluandou_lishijilu_mvp_tiao_4.png"),
    rankBg = "lrb_daluandou_jiesuan_4",
    txtColor = "#eb86ff",
    battlefieldHeadBg = "lrb_DLDzhanchang_qipao4",
    battlefieldHeadArrow = "lrb_DLDzhanchang_qipaojiao4",
    battlefieldPointBg = "lrb_DLDzhanchangjifen_4",
    battlefieldProgressBar = "lrb_DLDzhanchang_jindutiao04",
    bfMaterialIndex = 3,
    buildTemplateIconIndex = 4
  },
  [BattlefieldDsbConst.RoleType.Mine] = {
    colorLabel = CityLabelBattlefieldDsbRoleMineColor,
    spBattlefieldBorder = "lrb_daluandou_zhanchang_5",
    spEnterBg = "lrb_daluandou_zanli_duiwu5",
    spPlayerTopBg = "lrb_daluandou_qipao_5",
    actAllianceItemBg = string.format(LoadPath.LWBattleFieldDsbDuelPath, "lrb_daluandou_jifen_5.png"),
    actMvpBg1 = string.format(LoadPath.LWBattleFieldDsbDuelPath, "lrb_daluandou_lishijilu_mvp_5.png"),
    actMvpBg2 = string.format(LoadPath.LWBattleFieldDsbDuelPath, "lrb_daluandou_lishijilu_mvp_tiao_5.png"),
    rankBg = "lrb_daluandou_jiesuan_5",
    txtColor = "#72E6F0",
    battlefieldHeadBg = "lrb_DLDzhanchang_qipao5",
    battlefieldHeadArrow = "lrb_DLDzhanchang_qipaojiao5",
    battlefieldPointBg = "lrb_DLDzhanchangjifen_5",
    battlefieldProgressBar = "lrb_DLDzhanchang_jindutiao05",
    bfMaterialIndex = 4,
    buildTemplateIconIndex = 5
  }
}
BattlefieldDsbConst.SelfAllianceColor = Color.New(0.4470589, 0.9019608, 0.9411765, 1)
BattlefieldDsbConst.GroupRewardType = {
  Min = 1,
  G1 = 1,
  G2 = 2,
  G3 = 3,
  G4 = 4,
  Max = 4
}
BattlefieldDsbConst.BF_DSB_MAIN_VIEW_TOGGLE_INDEX = {
  None = 0,
  SignUp = 1,
  EditBattle = 2,
  ScoreRank = 3
}
BattlefieldDsbConst.BF_DSB_BIG_PHASE_INDEX = {
  None = 0,
  SignUp = 1,
  Group = 2,
  BattleWeekMin = 3,
  BattleWeek1 = 3,
  BattleWeek2 = 4,
  BattleWeek3 = 5,
  BattleWeek4 = 6,
  BattleWeek5 = 7,
  BattleWeekMax = 7,
  Result = 8
}
BattlefieldDsbConst.BF_DSB_SMALL_PHASE_INDEX = {
  None = 0,
  SignUp = 1,
  Group = 2,
  TeamWaitSignUp = 3,
  TeamSignUp = 4,
  TeamMatch = 5,
  TeamWaitBattle = 6,
  TeamBattleReady = 7,
  TeamBattle = 8,
  TeamResult = 9,
  Result = 10
}
BattlefieldDsbConst.BF_DSB_GUIDE_TYPE = {
  TimeDetail = 1,
  GroupRules = 2,
  Match = 3,
  Reward = 4
}
BattlefieldDsbConst.BF_DSB_GUIDE_TYPE1_SUBTYPE = {
  SignUp = 11,
  Battle1 = 12,
  Battle2 = 13,
  Result = 14
}
BattlefieldDsbConst.BF_DSB_GUIDE_TYPE2_SUBTYPE = {OnlyPicture = 21, PicAndText = 22}
BattlefieldDsbConst.BF_DSB_TEAM_STATE = {
  NotSignUp = 0,
  SignUp = 1,
  GiveUp = 2,
  Bye = 3,
  MatchSuccess = 4
}
BattlefieldDsbConst.BF_DSB_OPERATE_LOG_TYPE = {
  PlayerRemove = 1,
  PlayerGroupAddMain = 2,
  PlayerGroupAddSub = 3,
  GroupBCancel = 5,
  GroupBOpen = 6
}
BattlefieldDsbConst.BF_DSB_REWARD_STATE = {
  CantReceive = 0,
  CanReceive = 1,
  Received = 2
}
BattlefieldDsbConst.BF_DSB_REWARD_Type = {AllianceReward = 0, ZoneReward = 1}
BattlefieldDsbConst.BF_DSB_REWARD_GROUP_TYPE = {InGroupReward = 1, TotalReward = 2}
BattlefieldDsbConst.BF_DSB_PLAYER_STATE = {
  None = 0,
  Main = 1,
  Sub = 2
}
BattlefieldDsbConst.BF_DSB_GROUP_TYPE = {
  ALL = 0,
  G1 = 1,
  G2 = 2,
  G3 = 3,
  G4 = 4
}
BattlefieldDsbConst.BF_DSB_REWARD_RANK = {
  Rank1 = 1,
  Rank2 = 2,
  Rank3 = 3,
  Rank4 = 4,
  Max = 4
}
BattlefieldDsbConst.EFF_HOSPITAL_TIME = 3
BattlefieldDsbConst.ENTRANCE_TIPS = {
  None = 0,
  GoToTeamSignUp = 1,
  GoToSeeInTeam = 2,
  GoToSeeOutTeam = 3
}
BattlefieldDsbConst.EnterBattleState = {
  None = 0,
  InBattle = 1,
  LeaveBattle = 2
}
BattlefieldDsbConst.ScoreIconPath = "Assets/Main/Sprites/UI/BF_Dsb_Duel/UI/zxl_shamo_jifen_xiao.png"
BattlefieldDsbConst.EmptyRole = {}
return BattlefieldDsbConst
