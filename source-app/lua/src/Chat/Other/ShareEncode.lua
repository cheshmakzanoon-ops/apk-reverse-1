local rapidjson = require("rapidjson")
local ShareEncode = {}

local function Encode_PointShare(tbl)
  if tbl.x == nil or tbl.y == nil then
    return nil
  end
  local t = {}
  if not string.IsNullOrEmpty(tbl.sid) then
    t.sid = tbl.sid
  end
  if not string.IsNullOrEmpty(tbl.worldId) then
    t.worldId = tbl.worldId
  end
  if not string.IsNullOrEmpty(tbl.worldType) then
    t.worldType = tbl.worldType
  end
  if not string.IsNullOrEmpty(tbl.allianceId) then
    t.allianceId = tbl.allianceId
  end
  if not string.IsNullOrEmpty(tbl.actDragonGroup) then
    t.actDragonGroup = tbl.actDragonGroup
  end
  t.x = tbl.x
  t.y = tbl.y
  if not string.IsNullOrEmpty(tbl.msg) then
    t.msg = tbl.msg
  else
    if not string.IsNullOrEmpty(tbl.uname) then
      t.uname = tbl.uname
      t.abbr = tbl.abbr
    end
    if not string.IsNullOrEmpty(tbl.oname) then
      t.oname = tbl.oname
      t.olv = tbl.olv
      t.onameParam1 = tbl.onameParam1
      t.onameParam2 = tbl.onameParam2
      t.onameParamKey1 = tbl.onameParamKey1
      t.onameParamKey2 = tbl.onameParamKey2
    end
  end
  if tbl.uid then
    t.uid = tbl.uid
  end
  if tbl.posType then
    t.posType = tbl.posType
  end
  if tbl.shareType then
    t.shareType = tbl.shareType
  end
  if tbl.treasureId then
    t.treasureId = tbl.treasureId
  end
  if tbl.dispatch == 1 then
    t.dispatch = 1
    t.cfgId = tbl.cfgId
  end
  if tbl.ghostrecon == 1 then
    t.ghostrecon = 1
    t.cfgId = tbl.cfgId
  end
  if tbl.uuid then
    t.uuid = tbl.uuid
  end
  if tbl.statusLayer and tbl.statusLayer > 0 then
    t.statusLayer = tbl.statusLayer
    t.statusIcon = tbl.statusIcon
    t.askVirusHelp = tbl.askVirusHelp
  end
  return t
end

local function Encode_StorageShopShare(tbl)
  local t = {}
  if not string.IsNullOrEmpty(tbl.sid) then
    t.sid = tbl.sid
  end
  t.tradeName = tbl.tradeName
  t.itemIds = tbl.itemIds
  t.tradePoint = tbl.tradePoint
  t.uid = tbl.uid
  t.slots = tbl.slots
  return t
end

local function Encode_AllianceTaskShare(tbl)
  local t = {}
  t.taskId = tbl.taskId
  t.taskName = tbl.taskName
  t.curProg = tbl.curProg
  t.maxProg = tbl.maxProg
  t.tempTime = tbl.tempTime
  return t
end

local function Encode_AllianceRecruitShare(tbl)
  local t = {}
  t.uid = tbl.uid
  t.name = tbl.name
  t.abbr = tbl.abbr
  t.language = tbl.language
  t.recruitTip = tbl.recruitTip
  t.country = tbl.country
  t.memberNum = tbl.memberNum
  t.allianceFlag = tbl.allianceFlag
  t.needApply = tbl.needApply
  return t
end

local function Encode_MailScoutResultShare(tbl)
  local t = {}
  if not string.IsNullOrEmpty(tbl.sid) then
    t.sid = tbl.sid
  end
  if not string.IsNullOrEmpty(tbl.worldId) then
    t.worldId = tbl.worldId
  end
  if not string.IsNullOrEmpty(tbl.msg) then
    t.msg = tbl.msg
  end
  if not string.IsNullOrEmpty(tbl.uid) then
    t.uid = tbl.uid
  end
  if not string.IsNullOrEmpty(tbl.mailType) then
    t.mailType = tbl.mailType
  end
  if not string.IsNullOrEmpty(tbl.toUser) then
    t.toUser = tbl.toUser
  end
  if not string.IsNullOrEmpty(tbl.wolfEndTime) then
    t.wolfEndTime = tbl.wolfEndTime
  end
  return t
end

local function Encode_LandmineShare(tbl)
  return tbl
end

local function Encode_GoldRelicShare(tbl)
  return tbl
end

local function Encode_DisguiseShare(tbl)
  return tbl
end

local function Encode_AllianceInvite(tbl)
  local t = {}
  if tbl.allianceId then
    t.allianceId = tbl.allianceId
  end
  if tbl.language then
    t.language = tbl.language
  end
  if tbl.inviteAlliance then
    t.inviteAlliance = tbl.inviteAlliance
  end
  if tbl.abbr then
    t.abbr = tbl.abbr
  end
  if tbl.curMember then
    t.curMember = tbl.curMember
  end
  if tbl.maxMember then
    t.maxMember = tbl.maxMember
  end
  if tbl.country then
    t.country = tbl.country
  end
  if tbl.icon then
    t.icon = tbl.icon
  end
  return t
end

local function Encode_AllianceRankChange(tbl)
  if tbl.uid == nil then
    return nil
  end
  local t = {}
  t.uid = tbl.uid
  t.uname = tbl.uname
  t.old = tbl.old
  t.new = tbl.new
  t.selfName = tbl.selfName
  t.selfRank = tbl.selfRank
  return t
end

local function Encode_AllianceMemberChange(tb)
  if tb.name == nil then
    return nil
  end
  local t = {}
  t.name = tb.name
  return t
end

local function Encode_AllianceOfficialChange(tbl)
  if tbl.uid == nil then
    return nil
  end
  local t = {}
  t.uid = tbl.uid
  t.uname = tbl.uname
  t.new = tbl.new
  return t
end

local function Encode_ShareFightReport(tb)
  if tb.name == nil then
    return nil
  end
  local t = {}
  t.para = tb.para
  return t
end

local function Encode_SharePlayerFormation(tb)
  if tb.name == nil then
    return nil
  end
  local t = {}
  t.para = tb.para
  return t
end

local function Encode_Text_ChampionBattle_Report_Share(tb)
  if tb.name == nil then
    return nil
  end
  local t = {}
  t.para = tb.para
  return t
end

local function Encode_AllianceRedPacket(tb)
  if tb.name == nil then
    return nil
  end
  local t = {}
  t.para = tb.para
  return t
end

local function Encode_defaul(tb)
  return tb
end

local function Encode_Activity_Multiple_Parkour(tb)
  return tb
end

local function Encode_HelpMePutAresMissile(tb)
  return tb
end

local function Encode_ValentineRankCard(tbl)
  local t = {}
  t.small_msg = tbl.small_msg
  t.uid = tbl.uid
  t.pic = tbl.pic
  t.picVer = tbl.picVer
  t.name = tbl.name
  t.allianceAbbrName = tbl.allianceAbbrName
  t.allianceName = tbl.allianceName
  t.rank = tbl.rank
  t.curRankId = tbl.curRankId
  t.power = tbl.power
  t.gender = tbl.gender
  t.activityId = tbl.activityId
  return t
end

local function Encode_AlChallengeBoxShare(tbl)
  local t = {}
  if not string.IsNullOrEmpty(tbl.endTs) then
    t.endTs = tbl.endTs
  end
  if not string.IsNullOrEmpty(tbl.rewardCount) then
    t.rewardCount = tbl.rewardCount
  end
  if not string.IsNullOrEmpty(tbl.quality) then
    t.quality = tbl.quality
  end
  if not string.IsNullOrEmpty(tbl.bossId) then
    t.bossId = tbl.bossId
  end
  return t
end

local function Encode_SurfingBattleResultShare(tbl)
  local t = {}
  if not string.IsNullOrEmpty(tbl.endTs) then
    t.endTs = tbl.endTs
  end
  if not string.IsNullOrEmpty(tbl.context) then
    t.context = tbl.context
  end
  if not string.IsNullOrEmpty(tbl.contextId) then
    t.contextId = tbl.contextId
  end
  if not string.IsNullOrEmpty(tbl.para) then
    t.para = tbl.para
  end
  if not string.IsNullOrEmpty(tbl.activityId) then
    t.activityId = tbl.activityId
  end
  return t
end

local function Encode_Season_BiuBiuInvite(tbl)
  return tbl.param
end

local function Encode_Season_BiuBiuResult(tb1)
  return tb1.param
end

local function Encode_Season_LittleGame_Invite(tbl)
  return tbl.param
end

local function Encode_Season_LittleGame_Result(tb1)
  return tb1.param
end

local function Encode_GhostBattleResultShare(tbl)
  local t = {}
  if not string.IsNullOrEmpty(tbl.endTs) then
    t.endTs = tbl.endTs
  end
  if not string.IsNullOrEmpty(tbl.contextId) then
    t.contextId = tbl.contextId
  end
  if not string.IsNullOrEmpty(tbl.para) then
    t.para = tbl.para
  end
  if not string.IsNullOrEmpty(tbl.activityId) then
    t.activityId = tbl.activityId
  end
  return t
end

local function Encode_None(tb)
  return {}
end

local EncodeTable = {
  [PostType.Text_PointShare] = Encode_PointShare,
  [PostType.Activity_BargainShop] = Encode_defaul,
  [PostType.SeasonDesert] = Encode_defaul,
  [PostType.Text_PointShare_Alliance] = Encode_PointShare,
  [PostType.Text_AllianceInvite] = Encode_AllianceInvite,
  [PostType.Text_AllianceRankChange] = Encode_AllianceRankChange,
  [PostType.Text_AllianceOfficialChange] = Encode_AllianceOfficialChange,
  [PostType.Text_MemberQuit] = Encode_AllianceMemberChange,
  [PostType.Text_MemberJoin] = Encode_AllianceMemberChange,
  [PostType.Text_StorageShopShare] = Encode_StorageShopShare,
  [PostType.Text_AllianceTaskShare] = Encode_AllianceTaskShare,
  [PostType.Text_AllianceRecruitShare] = Encode_AllianceRecruitShare,
  [PostType.Text_Formation_Fight_Share] = Encode_ShareFightReport,
  [PostType.Text_Formation_Share] = Encode_SharePlayerFormation,
  [PostType.RedPackge] = Encode_AllianceRedPacket,
  [PostType.Text_ScoutReport] = Encode_MailScoutResultShare,
  [PostType.Landmine] = Encode_LandmineShare,
  [PostType.GoldRelic] = Encode_GoldRelicShare,
  [PostType.Disguise] = Encode_DisguiseShare,
  [PostType.DefaultMarch] = Encode_defaul,
  [PostType.Text_MsgShare] = Encode_defaul,
  [PostType.Text_ChampionBattleReportShare] = Encode_Text_ChampionBattle_Report_Share,
  [PostType.Text_FightReport] = Encode_defaul,
  [PostType.March] = Encode_defaul,
  [PostType.Train] = Encode_defaul,
  [PostType.Truck_Send_Record] = Encode_defaul,
  [PostType.Truck_Rob_Record] = Encode_defaul,
  [PostType.Alliance_War] = Encode_defaul,
  [PostType.Activity_MultipleParkour] = Encode_Activity_Multiple_Parkour,
  [PostType.DetectEventGetDoubleTreasure] = Encode_defaul,
  [PostType.ZombieRush] = Encode_defaul,
  [PostType.MasterySkillShare] = Encode_defaul,
  [PostType.SuppliesPositionShare] = Encode_PointShare,
  [PostType.HELP_STOP_FIRE] = Encode_PointShare,
  [PostType.TorchRelayCheer] = Encode_defaul,
  [PostType.GHOST_RECON_TASK_TEAM] = Encode_defaul,
  [PostType.GHOST_RECON_SHARE_POINT] = Encode_PointShare,
  [PostType.SeasonTrendsShare] = Encode_defaul,
  [PostType.HelpMePutAresMissile] = Encode_HelpMePutAresMissile,
  [PostType.GHOST_RECON_REMIND_LEADER] = Encode_defaul,
  [PostType.ActMigration] = Encode_defaul,
  [PostType.STAGE_FEATURE_CHAPTER] = Encode_defaul,
  [PostType.DiggingGameShareSingle] = Encode_defaul,
  [PostType.MONSTER_INVASION_BOSS_SELF_PROTECTED] = Encode_defaul,
  [PostType.INVASION_BOSS_SHARE] = Encode_defaul,
  [PostType.MIGRATE_INVITE] = Encode_AllianceInvite,
  [PostType.ValentineRankCard] = Encode_ValentineRankCard,
  [PostType.ZOMBIE_RUSH_ELITE_BOSS_ATTACK] = Encode_defaul,
  [PostType.MAD_COW_RUSH] = Encode_defaul,
  [PostType.ZOMBIE_RUSH_ELITE_ALTER_BOSS_ATTACK] = Encode_defaul,
  [PostType.SeasonPhoto] = Encode_defaul,
  [PostType.Title] = Encode_defaul,
  [PostType.ZONE_MOBILIZATION_AL_RES_CREATE] = Encode_defaul,
  [PostType.ZONE_MOBILIZATION_SUPPLIES_CREATE] = Encode_defaul,
  [PostType.ZONE_MOBILIZATION_SUPPLIES_TRIGGER_RED] = Encode_defaul,
  [PostType.DigTreasure] = Encode_defaul,
  [PostType.ALLIANCE_MONSTER_CHALLENGE_NEW_REWARD] = Encode_AlChallengeBoxShare,
  [PostType.TacticalCard] = Encode_None,
  [PostType.TacticalCard_Deck] = Encode_None,
  [PostType.TacticalCard_EquipPlan] = Encode_None,
  [PostType.ActConcertReward] = Encode_defaul,
  [PostType.Electrician_Gather] = Encode_None,
  [PostType.GroupChatInviter] = Encode_None,
  [PostType.MusicFestival2025_Share] = Encode_defaul,
  [PostType.FIREWORK_GIFT_REWARD] = Encode_defaul,
  [PostType.FIREWORK_GIFT_REWARD_DOUBLE] = Encode_defaul,
  [PostType.NewBattleReportShare] = Encode_defaul,
  [PostType.SeasonBankReport] = Encode_defaul,
  [PostType.SurfingInviteShare] = Encode_defaul,
  [PostType.SurfingBattleResultShare] = Encode_SurfingBattleResultShare,
  [PostType.T11IdleGameAllianceHelp] = Encode_defaul,
  [PostType.SeasonAllianceWarTime] = Encode_defaul,
  [PostType.Season_BiuBiuInvite] = Encode_Season_BiuBiuInvite,
  [PostType.T11IdleGameAllianceHelp] = Encode_defaul,
  [PostType.FLOWER_TRAIN_POSITION_SHARE] = Encode_defaul,
  [PostType.FLOWER_TRAIN_SHARE] = Encode_defaul,
  [PostType.FLOWER_TRAIN_USE_SHARE] = Encode_defaul,
  [PostType.NewsCenterLink] = Encode_defaul,
  [PostType.Season_BiuBiuResult] = Encode_Season_BiuBiuResult,
  [PostType.ZOMBIE_ATTACK_CITY_ASSISTANCE_DEFEND] = Encode_defaul,
  [PostType.BF_WINTER_HISTORY_SHARE] = Encode_defaul,
  [PostType.GhostBattleResultShare] = Encode_GhostBattleResultShare,
  [PostType.GhostParkourRecordType] = Encode_defaul,
  [PostType.FrontBreakSunday] = Encode_defaul,
  [PostType.WorldBossNewRecord] = Encode_defaul,
  [PostType.ALLIANCE_INVITE_SHARE_NEW] = Encode_AllianceInvite,
  [PostType.Season_LittleGame_Invite] = Encode_Season_LittleGame_Invite,
  [PostType.Season_LittleGame_Result] = Encode_Season_LittleGame_Result,
  [PostType.S0_ALLIANCE_BOSS_GIFT_REWARD] = Encode_defaul
}

function ShareEncode.Encode(tbl)
  if tbl == nil then
    return nil
  end
  local t
  local f = EncodeTable[tbl.post]
  if f then
    t = f(tbl.param)
  else
    ChatPrint("share encode not found! type : " .. tbl.post)
  end
  if t then
    return rapidjson.encode(t)
  end
  return nil
end

return ShareEncode
