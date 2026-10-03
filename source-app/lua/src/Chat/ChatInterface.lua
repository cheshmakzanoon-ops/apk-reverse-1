local Localization = CS.GameEntry.Localization
local ChatInterface = {}
local pressureTestServer = 99
local pressureServerTab = "yace"
local CommonUtils = CS.CommonUtils
local StringUtils = CS.StringUtils
local SDKManager = CS.SDKManager
local ClientSwitch = CS.ClientSwitch
local ShareDecode = require("Chat.Other.ShareDecode")
local testUids = {
  "1294477543000273",
  "1226080208000359",
  "1159933899000194",
  "1312463532000528"
}
local postTypesNotSkip = {
  [PostType.Text_Normal] = true,
  [PostType.Text_ChatRoomSystemMsg] = true,
  [PostType.Text_MemberJoin] = true,
  [PostType.Text_MemberQuit] = true,
  [PostType.Text_FightReport] = true,
  [PostType.Text_FBAlliance_missile_share] = true,
  [PostType.Detect_Treasure_Fin_Info] = true,
  [PostType.NewAllianceRallyPoint] = true,
  [PostType.ActDetectTreasureItemUse] = true,
  [PostType.Text_StorageShopShare] = true,
  [PostType.Text_Formation_Fight_Share] = true,
  [PostType.Text_ScoutReport] = true,
  [PostType.Landmine] = true,
  [PostType.GoldRelic] = true,
  [PostType.Disguise] = true,
  [PostType.DefaultMarch] = true,
  [PostType.Text_AllianceTaskShare] = true,
  [PostType.Text_Formation_Share] = true,
  [PostType.Text_ChampionBattleReportShare] = true,
  [PostType.RedPackge] = true,
  [PostType.Text_PointShare] = true,
  [PostType.Text_PointShare_Alliance] = true,
  [PostType.March] = true,
  [PostType.Text_AllianceInvite] = true,
  [PostType.Text_AllianceRecruitShare] = true,
  [PostType.Abandon_AllianceCity] = true,
  [PostType.Alliance_LeaderChange] = true,
  [PostType.Alliance_OfficialChange] = true,
  [PostType.Alliance_CityUnderAttack] = true,
  [PostType.Train_Rob] = true,
  [PostType.Train_Departure] = true,
  [PostType.Train_Driver] = true,
  [PostType.Train] = true,
  [PostType.Alliance_Notice] = true,
  [PostType.Text_AllianceNotice] = true,
  [PostType.Text_MsgShare] = true,
  [PostType.Activity_BargainShop] = true,
  [PostType.Truck_Send_Record] = true,
  [PostType.SeasonDesert] = true,
  [PostType.Alliance_War] = true,
  [PostType.Activity_MultipleParkour] = true,
  [PostType.RedPackge_New] = true,
  [PostType.DetectEventGetDoubleTreasure] = true,
  [PostType.RedPacket_MSG] = true,
  [PostType.Dispatch_Treasure] = true,
  [PostType.ZombieRush] = true,
  [PostType.BestReward] = true,
  [PostType.MasterySkillShare] = true,
  [PostType.SuppliesPositionShare] = true,
  [PostType.Chat_Stickers] = true,
  [PostType.HELP_STOP_FIRE] = true,
  [PostType.TorchRelayCheer] = true,
  [PostType.HELP_STOP_FIRE_PERSION] = true,
  [PostType.HELP_STOP_FIRE_ALLIANCEE] = true,
  [PostType.SeasonTrendsShare] = true,
  [PostType.Chat_SendPhoto] = true,
  [PostType.GHOST_RECON_TASK_TEAM] = true,
  [PostType.GHOST_RECON_SHARE_POINT] = true,
  [PostType.GHOST_RECON_REMIND_LEADER] = true,
  [PostType.ActMigration] = true,
  [PostType.MessageRecall] = true,
  [PostType.MONSTER_INVASION_BIG_BOSS] = true,
  [PostType.Detect_Treasure_Reward_Fin_Info] = true,
  [PostType.SKILL_ADD_MUMMY_ARMY] = true,
  [PostType.STAGE_FEATURE_CHAPTER] = true,
  [PostType.DiggingGameShareSingle] = true,
  [PostType.DiggingGameShareAlliance] = true,
  [PostType.SeasonTradeShopRefresh] = true,
  [PostType.MONSTER_INVASION_BOSS_SELF_PROTECTED] = true,
  [PostType.INVASION_BOSS_SHARE] = true,
  [PostType.TradeOpenLevel] = true,
  [PostType.CaptureHugeSandWorm] = true,
  [PostType.OccupyTradePlayer] = true,
  [PostType.FriendsCirleBody] = true,
  [PostType.FriendsCirleBodyHasIcon] = true,
  [PostType.Chat_Moment] = true,
  [PostType.MIGRATE_INVITE] = true,
  [PostType.GiftGiving] = true,
  [PostType.TrainVipInvite] = true,
  [PostType.ValentineRankCard] = true,
  [PostType.ZOMBIE_RUSH_ELITE_BOSS_ATTACK] = true,
  [PostType.MAD_COW_RUSH] = true,
  [PostType.ZOMBIE_RUSH_ELITE_ALTER_BOSS_REWARD] = true,
  [PostType.ZOMBIE_RUSH_ELITE_ALTER_BOSS_ATTACK] = true,
  [PostType.SeasonPhoto] = true,
  [PostType.Title] = true,
  [PostType.ZONE_MOBILIZATION_AL_RES_CREATE] = true,
  [PostType.ZONE_MOBILIZATION_SUPPLIES_CREATE] = true,
  [PostType.ZONE_MOBILIZATION_SUPPLIES_TRIGGER_RED] = true,
  [PostType.UseMasterySkill] = true,
  [PostType.EasterEggChat] = true,
  [PostType.DigTreasure] = true,
  [PostType.ALLIANCE_MONSTER_CHALLENGE_NEW_REWARD] = true,
  [PostType.ALLIANCE_MONSTER_CHALLENGE_NEW_BATTLE] = true,
  [PostType.TacticalCard] = true,
  [PostType.TacticalCard_Deck] = true,
  [PostType.TacticalCard_EquipPlan] = true,
  [PostType.ActConcertReward] = true,
  [PostType.Electrician_Gather] = true,
  [PostType.GroupChatInviter] = true,
  [PostType.MusicFestival2025_Share] = true,
  [PostType.FIREWORK_GIFT_REWARD] = true,
  [PostType.FIREWORK_GIFT_REWARD_DOUBLE] = true,
  [PostType.FirstJoinAlliance] = true,
  [PostType.NewBattleReportShare] = true,
  [PostType.OffSeasonDiggingGameShareAlliance] = true,
  [PostType.SeasonBankReport] = true,
  [PostType.SurfingInviteShare] = true,
  [PostType.SurfingBattleResultShare] = true,
  [PostType.Alliance_Feature_Invite] = true,
  [PostType.T11IdleGameAllianceHelp] = true,
  [PostType.FLOWER_TRAIN_SHARE] = true,
  [PostType.FLOWER_TRAIN_POSITION_SHARE] = true,
  [PostType.FLOWER_TRAIN_USE_SHARE] = true,
  [PostType.SummonWeather] = true,
  [PostType.SeasonAllianceWarTime] = true,
  [PostType.Season_BiuBiuInvite] = true,
  [PostType.ALLIANCE_CONGRATULATION] = true,
  [PostType.NewsCenterLink] = true,
  [PostType.Season_BiuBiuResult] = true,
  [PostType.ZOMBIE_ATTACK_CITY_ASSISTANCE_DEFEND] = true,
  [PostType.StageFeatureHelpInvite] = true,
  [PostType.StageFeatureHelpAccept] = true,
  [PostType.StageFeatureComplete] = true,
  [PostType.StageFeatureHelpInviteAlliance] = true,
  [PostType.BF_WINTER_HISTORY_SHARE] = true,
  [PostType.GhostBattleResultShare] = true,
  [PostType.GhostParkourRecordType] = true,
  [PostType.MilitaryPayShare] = true,
  [PostType.FrontBreakSunday] = true,
  [PostType.WorldBossNewRecord] = true,
  [PostType.ALLIANCE_INVITE_SHARE_NEW] = true,
  [PostType.ALLIANCE_INVITE_FRIEND] = true,
  [PostType.ALLIANCE_ASSISTANCE_FRIEND] = true,
  [PostType.Season_LittleGame_Invite] = true,
  [PostType.Season_LittleGame_Result] = true,
  [PostType.ALLIANCE_LUCK_SIPHON_BUFF] = true,
  [PostType.ALLIANCE_LUCK_SIPHON_NORMAL] = true,
  [PostType.SeasonCampDestroyCity] = true,
  [PostType.SeasonOccupyAltar] = true,
  [PostType.S0_ALLIANCE_BOSS_GIFT_REWARD] = true
}
local PostTypeCanShare = {
  [PostType.Text_FightReport] = true,
  [PostType.NewsCenterLink] = true
}
local PostTypeCanRecall = {
  [PostType.Text_Normal] = true,
  [PostType.Chat_SendPhoto] = true,
  [PostType.EasterEggChat] = true,
  [PostType.Text_PointShare] = true,
  [PostType.GHOST_RECON_TASK_TEAM] = true,
  [PostType.Text_ScoutReport] = true,
  [PostType.Text_FightReport] = true,
  [PostType.March] = true,
  [PostType.Dispatch_Treasure] = true,
  [PostType.INVASION_BOSS_SHARE] = true,
  [PostType.NewsCenterLink] = true
}

function ChatInterface.IsCanShare(postType)
  return PostTypeCanShare[postType]
end

function ChatInterface.IsCanRecall(postType)
  return PostTypeCanRecall[postType]
end

function ChatInterface.IsCanAt(roomData)
  return roomData ~= nil and ChatInterface.IsCanAtRoomGroup(roomData.group)
end

function ChatInterface.IsCanAtRoomGroup(roomGroup)
  return roomGroup == ChatGroupType.GROUP_ALLIANCE or roomGroup == ChatGroupType.GROUP_ALLIANCE_MANAGER or roomGroup == ChatGroupType.GROUP_CUSTOM_GROUP
end

function ChatInterface.getRoomMgr()
  return ChatManager2:GetInstance().Room
end

function ChatInterface.GetUtil()
  return ChatManager2:GetInstance().Util
end

function ChatInterface.getGroupChatMgr()
  return ChatManager2:GetInstance().GroupChat
end

function ChatInterface.getAllRoomData()
  return ChatManager2:GetInstance().Room.roomDatas
end

function ChatInterface.getRoomData(roomId)
  return ChatManager2:GetInstance().Room:GetRoomData(roomId)
end

function ChatInterface.getCountryRoomId()
  return ChatManager2:GetInstance().Room:GetCountryRoomId()
end

function ChatInterface.getAllianceRoomId()
  return ChatManager2:GetInstance().Room:GetAllianceRoomId()
end

function ChatInterface.getMoment()
  return ChatManager2:GetInstance().Moment
end

function ChatInterface.GetFixedType(strs, index)
  if string.IsNullOrEmpty(strs[index]) then
    return
  end
  strs = string.split(strs[index], ".")
  if strs and 2 < #strs then
    for i, type in pairs(ProxyType) do
      if strs[1] == type then
        return type
      end
    end
  end
end

function ChatInterface.GetUrlType(url, isGame)
  if string.IsNullOrEmpty(url) then
    return
  end
  local strs = string.split(url, "-")
  local type = ChatInterface.GetFixedType(strs)
  if not string.IsNullOrEmpty(type) then
    return type
  end
  for i, type in pairs(ProxyType) do
    if string.find(url, type) then
      return type
    end
  end
end

function ChatInterface:getCrossServerRoomId()
  return ChatManager2:GetInstance().Room:GetCrossServerRoomId()
end

function ChatInterface.getUserMgr()
  return ChatManager2:GetInstance().User
end

function ChatInterface.getUserData(uid)
  return ChatManager2:GetInstance().User:getChatUserInfo(uid)
end

function ChatInterface.getTranslateMgr()
  return ChatManager2:GetInstance().Translate
end

function ChatInterface.isDebug()
  return CS.NetworkURLConfig.URLGroupType == CS.URLGroupType.Local or CS.NetworkURLConfig.URLGroupType == CS.URLGroupType.PressureTest or CS.NetworkURLConfig.URLGroupType == CS.URLGroupType.AWS
end

function ChatInterface.isPressureTestURL()
  return CS.NetworkURLConfig.URLGroupType == CS.URLGroupType.PressureTest
end

function ChatInterface.isAwsURL()
  return CS.NetworkURLConfig.URLGroupType == CS.URLGroupType.AWS
end

function ChatInterface.isOnline()
  return CS.NetworkURLConfig.URLGroupType == CS.URLGroupType.Online
end

function ChatInterface.IsUnlockEmojiInput()
  if CS.SDKManager.IS_UNITY_EDITOR() or Config.IsPC() then
    return true
  end
  if StringUtils.VersionCompare(CS.GameEntry.Sdk.Version, "1.0.247") >= 0 then
    return true
  end
  return false
end

function ChatInterface.isTestingServer()
  return true
end

function ChatInterface.IsPressureTest()
  local isPressure = CS.GameEntry.Network:IsPressureTestServer()
  return ChatInterface.isPressureTestURL() and isPressure
end

function ChatInterface.getPlayer()
  return LuaEntry.Player
end

function ChatInterface.getPlayerServerId()
  return LuaEntry.Player.serverId
end

function ChatInterface.getSelfServerId()
  return ChatInterface.getPlayer():GetSourceServerId()
end

function ChatInterface.getAllianceId()
  return ChatInterface.getPlayer().allianceId
end

function ChatInterface.getAllianceAbbr()
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if data ~= nil then
    return data.abbr
  end
  return nil
end

function ChatInterface.isInAlliance()
  return ChatInterface.getPlayer():IsInAlliance()
end

function ChatInterface.isDragonServerOpen()
  return BattleFieldUtil.InBattleField(BattleFieldType.Desert) or BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) or BattleFieldUtil.InBattleField(BattleFieldType.DsbDuel)
end

function ChatInterface.getDragonGroupType(bSelf)
  return bSelf and ChatGroupType.GROUP_DRAGON_SELF_SERVER or ChatGroupType.GROUP_DRAGON_ALL_SERVER
end

function ChatInterface.IsChatRoomDebug()
  return LuaEntry.Player.uid == "1116107684000019"
end

function ChatInterface.TempGetIsNewCross()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  return 1719799200000 <= curTime
end

function ChatInterface.isCrossServerOpen()
  local chatOpenState = LuaEntry.DataConfig:CheckSwitch("alliance_dule_crosschat")
  if not chatOpenState then
    return false
  end
  local configOpenState = LuaEntry.DataConfig:CheckSwitch("alliance_duel")
  if not configOpenState then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if ChatInterface.TempGetIsNewCross() then
    local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    if not activityInfo then
      return false
    end
    local mainBuildLV = DataCenter.BuildManager.MainLv
    if DataCenter.BuildManager.MainLv == nil or mainBuildLV < activityInfo.needMainCityLevel then
      return false
    end
    local matchGroupId = activityInfo.matchGroupId
    if matchGroupId == nil or matchGroupId == "" then
      return false
    end
    return true
  else
    local tempStage = DataCenter.LeagueMatchManager:GetLeagueMatchStage()
    local isInMatch = DataCenter.LeagueMatchManager:CheckIfInMatch()
    if tempStage ~= LeagueMatchStage.None then
      if isInMatch then
        if not LuaEntry.Player:IsInAlliance() then
          return false
        end
        local duelInfo = DataCenter.LeagueMatchManager:GetMyCurDuelInfo()
        if duelInfo and not string.IsNullOrEmpty(duelInfo.group) then
          return true
        else
          return false
        end
      else
        return false
      end
    else
      local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
      if not activityInfo then
        return false
      end
      local mainBuildLV = DataCenter.BuildManager.MainLv
      if DataCenter.BuildManager.MainLv == nil or mainBuildLV < activityInfo.needMainCityLevel then
        return false
      end
      local matchGroupId = activityInfo.matchGroupId
      if matchGroupId == nil or matchGroupId == "" then
        return false
      end
      return true
    end
  end
end

function ChatInterface.getCrossServerIdFlag()
  if ChatInterface.TempGetIsNewCross() then
    local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    if activityInfo ~= nil then
      local matchGroupId = activityInfo.matchGroupId
      if matchGroupId ~= nil and matchGroupId ~= "" then
        return matchGroupId
      end
    end
  else
    local tempStage = DataCenter.LeagueMatchManager:GetLeagueMatchStage()
    if tempStage ~= LeagueMatchStage.None then
      local duelInfo = DataCenter.LeagueMatchManager:GetMyCurDuelInfo()
      if duelInfo and not string.IsNullOrEmpty(duelInfo.group) then
        return duelInfo.group
      end
    else
      local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
      if activityInfo ~= nil then
        local matchGroupId = activityInfo.matchGroupId
        if matchGroupId ~= nil and matchGroupId ~= "" then
          return matchGroupId
        end
      end
    end
  end
  return ""
end

function ChatInterface.getPlayerUid()
  return ChatInterface.getPlayer().uid
end

function ChatInterface.getPlayerName()
  return ChatInterface.getPlayer().name
end

function ChatInterface.getLastUpdateTime()
  return toInt(ChatInterface.getPlayer().lastUpdateTime)
end

function ChatInterface.getVersionName()
  return "1.250.001"
end

function ChatInterface.getServerTime()
  return math.floor(UITimeManager:GetInstance():GetServerTime() / 1000)
end

function ChatInterface.checkIsOpenByKey(key)
  return LuaEntry.DataConfig:CheckSwitch(key)
end

function ChatInterface.IsAssistantChatMessage(post)
  if ChatInterface.AssistantChatMessageList == nil then
    ChatInterface.AssistantChatMessageList = {
      [PostType.FixAllianceBuilding] = true,
      [PostType.Text_FBAlliance_missile_share] = true,
      [PostType.HelpMePutAresMissile] = true,
      [PostType.SkillGuardianTower] = true,
      [PostType.SkillAresMissile] = true,
      [PostType.GoddessMummy] = true,
      [PostType.PutSeasonAllianceBuild] = true,
      [PostType.SeasonAllianceBuildFinish] = true,
      [PostType.SeasonAllianceBuildLevelUp] = true,
      [PostType.SeasonStoveCenterMove] = true,
      [PostType.SeasonStoveCenterWork] = true,
      [PostType.SeasonStoveCenterInterrupt] = true,
      [PostType.SeasonStoveCenterOverload] = true,
      [PostType.SeasonStoveCenterWillStop] = true,
      [PostType.HelpMeAttackCityStronghold] = true,
      [PostType.CityBeDeclareWar] = true,
      [PostType.CityAttachmentBuildFinish] = true,
      [PostType.CityAttachmentBuildStart] = true,
      [PostType.CityAttachmentConvert] = true,
      [PostType.CityBattleBuffRefresh] = true,
      [PostType.BloodyQueenBattleStart] = true,
      [PostType.BloodyQueenBattleGunnerLastBlood] = true,
      [PostType.ALLIANCE_INVITE_FRIEND] = true,
      [PostType.ALLIANCE_ASSISTANCE_FRIEND] = true,
      [PostType.ALLIANCE_SKILL_TESLACOIL_TIP] = true,
      [PostType.ALLIANCE_SKILL_ABUNDANT_HARVEST_TIP] = true,
      [PostType.ALLIANCE_SKILL_REINFORCEMENT_TIP] = true,
      [PostType.ALLIANCE_SKILL_REFRESH_BALL_TIP] = true,
      [PostType.SeasonCampDestroyCity] = true,
      [PostType.SeasonOccupyAltar] = true
    }
  end
  return ChatInterface.AssistantChatMessageList[post]
end

function ChatInterface.isCanSkip(post)
  return not postTypesNotSkip[post] and not ChatInterface.IsAssistantChatMessage(post)
end

function ChatInterface.getLanguageName()
  local lang = Localization.Language
  local LanguageType = CS.GameFramework.Localization.Language
  if lang == LanguageType.ChineseSimplified then
    return "zh_CN"
  end
  if lang == LanguageType.ChineseTraditional then
    return "zh_TW"
  end
  if lang == LanguageType.English then
    return "en"
  end
  if lang == LanguageType.PortuguesePortugal then
    return "pt"
  end
  if lang == LanguageType.Turkish then
    return "tr"
  end
  if lang == LanguageType.French then
    return "fr"
  end
  if lang == LanguageType.Norwegian then
    return "no"
  end
  if lang == LanguageType.Korean then
    return "ko"
  end
  if lang == LanguageType.Japanese then
    return "ja"
  end
  if lang == LanguageType.Dutch then
    return "nl"
  end
  if lang == LanguageType.Italian then
    return "it"
  end
  if lang == LanguageType.German then
    return "de"
  end
  if lang == LanguageType.Spanish then
    return "es"
  end
  if lang == LanguageType.Russian then
    return "ru"
  end
  if lang == LanguageType.Arabic then
    return "ar"
  end
  if lang == LanguageType.Persian then
    return "pr"
  end
  return Localization:GetLanguageName()
end

function ChatInterface.getString(langId, ...)
  return Localization:GetString(langId, ...)
end

function ChatInterface.flyHint(msg)
  UIUtil.ShowTips(msg)
end

function ChatInterface.getWritablePath()
  return device.writablePath
end

function ChatInterface.getCustomPicUrl(uid, picVer)
  local isok, url, key = CS.CommonUtils.GetCustomPicUrl(uid, picVer, url, key)
  return url
end

function ChatInterface.httpPostData(url, param)
  CS.LuaChatHelper.HttpPostData(url, param)
end

function ChatInterface.getHttpResponseString()
  return CS.LuaChatHelper.GetResponseString()
end

function ChatInterface.getTranslateKey()
  return ChatInterface.getPlayer().translateKey
end

function ChatInterface.GetRoomIdPrefix()
  if not ChatInterface.isExternalNetDebug() and not ChatInterface.isOnline() then
    return "test_"
  end
  return ""
end

function ChatInterface.isExternalNetDebug()
  return CS.NetworkURLConfig.URLGroupType == CS.URLGroupType.Online
end

function ChatInterface.isChina()
  return CS.LF.LuaInterfaceCommon.IsChinaRegion()
end

function ChatInterface.refreshMainUILastChat()
  EventManager:GetInstance():Broadcast(ChatEventEnum.LF_UPDATE_UIMAIN_CHAT_MSG)
end

function ChatInterface.getRoomName(roomId)
  local roomData = ChatManager2:GetInstance().Room:GetRoomData(roomId)
  if roomData then
    return roomData:getRoomName()
  end
  return ""
end

function ChatInterface.isChatGM(playerUid)
  if string.len(playerUid) == 5 then
    local i = toInt(playerUid)
    if 10000 <= i and i <= 10020 then
      return true
    end
  end
  return false
end

function ChatInterface.ChatShareMsg(roomId, dialogId, dialogParamNum, unUseDialogParamList, useDialogParamList)
  local chat_data = {}
  chat_data.roomId = roomId
  chat_data.post = PostType.Text_MsgShare
  local chat_param = {}
  chat_param.dialogId = dialogId
  chat_param.dialogParamNum = dialogParamNum
  chat_param.unUseDialogParamList = unUseDialogParamList
  chat_param.useDialogParamList = useDialogParamList
  chat_data.param = chat_param
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chat_data)
end

function ChatInterface.isTimestamp(num)
  return type(num) == "number" and 0 < num and num < 2.147483648E9
end

function ChatInterface.GetIsNewChatItem(chatData)
  if chatData.post == PostType.Alliance_War then
  end
  local uids = {}
  if not string.IsNullOrEmpty(chatData.clientUpdateExtra) then
    uids = string.split(chatData.clientUpdateExtra, "|")
  end
  if uids and uids[1] and ChatInterface.isTimestamp(uids[1]) then
    uids[1] = nil
    if not string.IsNullOrEmpty(uids[1]) then
      uids = string.split(uids[1], ",")
    end
  end
  return uids
end

function ChatInterface.GetChatTranslateLanguage()
  return ChatManager2:GetInstance().Translate:GetChatTranslateLanguage()
end

function ChatInterface.GetChatTranslateLanguageAbbr()
  local language = ChatManager2:GetInstance().Translate:GetChatTranslateLanguage()
  local abbr = LanageAbbr[language]
  if not abbr then
    local sytemAbbr = Localization:GetLanguage()
    if not LanageAbbr[sytemAbbr] then
      return LanageAbbr[Language.English]
    end
  end
  return abbr
end

function ChatInterface.SetEmojiTextProperty(textCompoent, richTextFixed)
  DataCenter.CacheData:LoadEmojiAsset(function(asset)
    if textCompoent and textCompoent.SetSpriteAsset then
      textCompoent:SetSpriteAsset(asset)
      textCompoent:SetEmojiAnalysis(true, richTextFixed)
    end
  end)
end

function ChatInterface.GetChatDataPriveName(chatData)
  if not chatData then
    return
  end
  local count = 4
  local off = 0
  if ChatInterface.isDebug() or ChatInterface.isPressureTestURL() then
    off = 1
  end
  local arr = string.split(chatData.roomId, "_")
  if #arr ~= count + off then
    return
  end
  if arr[count + off] == "v2" then
    local uid1 = arr[2 + off]
    local uid2 = arr[3 + off]
    local myUid = ChatInterface.getPlayerUid()
    if chatData.extra and chatData.extra.post == PostType.MIGRATE_INVITE and (uid1 == myUid or uid2 == myUid) then
      return uid1, uid2
    end
    if uid1 == myUid and uid2 == chatData.sender then
      return uid1, uid2
    elseif uid2 == myUid and uid1 == chatData.sender then
      return uid1, uid2
    end
  end
end

function ChatInterface.CreatePriveChatDataByNewMessage(data)
  local uid1, uid2 = ChatInterface.GetChatDataPriveName(data)
  if uid1 and uid2 then
    local room = ChatManager2:GetInstance().Room:CreateChatRoom(data.roomId, ChatGroupType.GROUP_CUSTOM)
    room.name = "PRIVATE_" .. uid1 .. "_to_" .. uid2
    room:addMembers({uid1, uid2})
    local chatData = ChatManager2:GetInstance().Room:GetChatDataByMessage(data)
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomsV2, {
      data.roomId
    })
    return chatData
  elseif data.group == ChatGroupType.GROUP_CUSTOM_GROUP then
    ChatManager2:GetInstance().Room:CreateChatRoom(data.roomId, ChatGroupType.GROUP_CUSTOM_GROUP)
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.ChatCustomRoomInfo, {
      data.roomId
    }, data.group)
    local chatData = ChatManager2:GetInstance().Room:GetChatDataByMessage(data)
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomV2, data.roomId)
    return chatData
  end
end

function ChatInterface.GetChatDataUid1Uid2ByRoomIdAtPrivate(roomId)
  if string.IsNullOrEmpty(roomId) then
    return
  end
  local count = 4
  local off = 0
  if ChatInterface.isDebug() or ChatInterface.isPressureTestURL() then
    off = 1
  end
  local arr = string.split(roomId, "_")
  if #arr ~= count + off then
    return
  end
  if arr[count + off] == "v2" then
    local uid1 = arr[2 + off]
    local uid2 = arr[3 + off]
    local myUid = ChatInterface.getPlayerUid()
    return uid1, uid2
  end
end

function ChatInterface.CreatePriveChatDataByRoomIds(roomIds)
  local needReqRoomIds = {}
  local roomsData = {}
  for _, roomId in ipairs(roomIds) do
    local room = ChatManager2:GetInstance().Room:GetRoomData(roomId)
    local uid1, uid2 = ChatInterface.GetChatDataUid1Uid2ByRoomIdAtPrivate(roomId)
    if room then
      table.insert(roomsData, room)
    end
    if room == nil and uid1 and uid2 then
      local room = ChatManager2:GetInstance().Room:CreateChatRoom(roomId, ChatGroupType.GROUP_CUSTOM)
      room.name = "PRIVATE_" .. uid1 .. "_to_" .. uid2
      room:addMembers({uid1, uid2})
      table.insert(needReqRoomIds, roomId)
      table.insert(roomsData, room)
    end
  end
  if 0 < #needReqRoomIds then
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomsV2, needReqRoomIds)
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.Roomlast, needReqRoomIds)
  end
  return roomsData
end

function ChatInterface.CreateRoomDataByRoomInfos(roomInfos)
  local needReqRoomIds = {}
  local roomsData = {}
  local newGroupRoomIdList = {}
  for _, roomInfo in ipairs(roomInfos) do
    local roomId = roomInfo.roomId
    local group = roomInfo.group
    local room = ChatManager2:GetInstance().Room:GetRoomData(roomId)
    if room then
      table.insert(roomsData, room)
    else
      local room
      if group == ChatGroupType.GROUP_CUSTOM then
        local uid1, uid2 = ChatInterface.GetChatDataUid1Uid2ByRoomIdAtPrivate(roomId)
        if uid1 and uid2 then
          room = ChatManager2:GetInstance().Room:CreateChatRoom(roomId, ChatGroupType.GROUP_CUSTOM)
          room.name = "PRIVATE_" .. uid1 .. "_to_" .. uid2
          room:addMembers({uid1, uid2})
        end
      elseif group == ChatGroupType.GROUP_CUSTOM_GROUP then
        room = ChatManager2:GetInstance().Room:CreateChatRoom(roomId, ChatGroupType.GROUP_CUSTOM_GROUP)
        table.insert(newGroupRoomIdList, roomId)
      end
      if room then
        table.insert(needReqRoomIds, roomId)
        table.insert(roomsData, room)
      end
    end
  end
  if 0 < #needReqRoomIds then
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomsV2, needReqRoomIds)
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.Roomlast, needReqRoomIds)
  end
  if 0 < #newGroupRoomIdList then
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.ChatCustomRoomInfo, newGroupRoomIdList, ChatGroupType.GROUP_CUSTOM_GROUP)
  end
  return roomsData
end

function ChatInterface.SendRoomTest(uidList)
  local roomId
  local roomTable = {}
  for i = 1, #uidList do
    if uidList[i] ~= LuaEntry.Player.uid then
      TimerManager:GetInstance():DelayInvoke(function()
        roomId = "chattemp_privateRoomId" .. uidList[i]
        roomTable = {}
        roomTable.isProxy = 0
        roomTable.msg = tostring(i)
        roomTable.roomId = roomId
        roomTable.toUid = tostring(uidList[i])
        EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SEND_ROOM_MSG_COMMAND, roomTable)
      end, i)
    end
  end
end

function ChatInterface.IsSharePoint(postType)
  if postType == PostType.Text_PointShare or postType == PostType.Text_PointShare_Alliance or postType == PostType.Text_Favour_Point_Share or postType == PostType.March or postType == PostType.SuppliesPositionShare or postType == PostType.HELP_STOP_FIRE then
    return true
  else
    return false
  end
end

function ChatInterface.GetOldEmojiStr(singleEmoji)
  local emojiName = StringUtils.GetLWEmojiName(singleEmoji, lwEmojiScope.uncodeStart, lwEmojiScope.uncodeEnd)
  if string.IsNullOrEmpty(emojiName) then
    return
  end
  local temp = DataCenter.ChatEmojiTemplateManager:GetEmojiDataByName(emojiName)
  if temp then
    return "<lwEmoji:" .. temp.id .. ":>"
  end
end

function ChatInterface.GetisTestUid(tempUid)
  local uid = LuaEntry.Player.uid
  if tempUid == uid then
    for i, v in pairs(testUids) do
      if uid == v then
        return true
      end
    end
  end
end

function ChatInterface.CheckMessage(msg)
  msg = string.gsub(msg, "\239\191\188", "")
  msg = msg:gsub("\226\128\152", "'")
  msg = msg:gsub("\226\128\153", "'")
  msg = msg:gsub("\r", "")
  return msg
end

function ChatInterface.IsTranslateAllOpen()
  return true
end

local chatThemeIndex

function ChatInterface.GetChatTheme()
  if chatThemeIndex == nil and not string.IsNullOrEmpty(LuaEntry.Player.uid) then
    local mode = CommonUtil.PlayerPrefsGetInt("CHAT_THEME_TYPE", 0)
    if mode == 0 or mode > table.count(ChatUIThemeConfig.ChatMode) then
      chatThemeIndex = ChatUIThemeConfig.ChatMode.Normal
      CommonUtil.PlayerPrefsSetInt("CHAT_THEME_TYPE", chatThemeIndex)
    else
      chatThemeIndex = mode
    end
  end
  return chatThemeIndex or ChatUIThemeConfig.ChatMode.Normal
end

function ChatInterface.SwitchChatTheme(chatMode)
  if chatMode < 1 and chatMode > table.count(ChatUIThemeConfig.ChatMode) then
    Logger.LogError("SwitchChatTheme Error " .. tostring(chatMode))
    return
  end
  chatThemeIndex = chatMode
  CommonUtil.PlayerPrefsSetInt("CHAT_THEME_TYPE", chatMode)
end

function ChatInterface.GetChatUIPath(name, isRaw)
  local prefix
  if isRaw then
    prefix = ChatUIThemeConfig.UIRawPrefix
  else
    prefix = ChatUIThemeConfig.UIPrefix
  end
  return prefix[chatThemeIndex or ChatUIThemeConfig.ChatMode.Normal] .. tostring(name)
end

function ChatInterface.GetChatBigUIPath(name)
  local prefix
  prefix = ChatUIThemeConfig.UIBigPrefix
  return prefix[chatThemeIndex or ChatUIThemeConfig.ChatMode.Normal] .. tostring(name)
end

function ChatInterface.GetMobilSupportMultiple()
  if StringUtils.VersionCompare(CS.GameEntry.Sdk.Version, "1.0.280") >= 0 or ChatInterface.isDebug() then
    return true
  end
  return false
end

function ChatInterface.GetMobilSupportChangeColor()
  if StringUtils.VersionCompare(CS.GameEntry.Sdk.Version, "1.0.280") >= 0 or ChatInterface.isDebug() then
    return true
  end
  return false
end

function ChatInterface.GetPostKey_Player(chatData)
  if chatData.group == ChatGroupType.GROUP_ALLIANCE_NOTICE then
    return chatData.group .. chatData.post
  end
  if ChatInterface.IsSharePoint(chatData.post) then
    return PostType.Text_PointShare
  end
  return chatData.post
end

function ChatInterface.GetPostConfig_Player(chatData)
  local postConfig = ChatItemPosts[ChatInterface.GetPostKey_Player(chatData)]
  if postConfig == nil then
    postConfig = ChatItemPosts[PostType.Text_Normal]
  end
  return postConfig
end

function ChatInterface.AddOnePointShareDataToLast(baseNotice, extraJsonData, shareData)
  local wordLen = baseNotice == nil and 0 or string.word_count(baseNotice)
  if extraJsonData[ChatAlNoticeSpecialDataType.PointShare] == nil then
    extraJsonData[ChatAlNoticeSpecialDataType.PointShare] = {}
  end
  table.insert(extraJsonData[ChatAlNoticeSpecialDataType.PointShare], {
    [ChatAlNoticeSpecialDataParamType.Index] = wordLen + 1,
    [ChatAlNoticeSpecialDataParamType.shareData] = shareData
  })
  if extraJsonData[ChatAlNoticeSpecialDataType.SortTag] == nil then
    extraJsonData[ChatAlNoticeSpecialDataType.SortTag] = {}
  end
  table.insert(extraJsonData[ChatAlNoticeSpecialDataType.SortTag], {
    [ChatAlNoticeSpecialDataParamType.Tag] = ChatAlNoticeSpecialDataType.PointShare,
    [ChatAlNoticeSpecialDataParamType.Index] = #extraJsonData[ChatAlNoticeSpecialDataType.PointShare]
  })
end

function ChatInterface.AddOnePointShareDataInsertToTarget(baseNotice, extraJsonData, insertPosData, shareData, saveParam)
  if insertPosData == nil or insertPosData.type == ChatAlNoticeTagInsertType.None then
    ChatInterface.AddOnePointShareDataToLast(baseNotice, extraJsonData, shareData)
    return
  end
  local chatData = {}
  if shareData.postType ~= nil then
    chatData.post = shareData.postType
  else
    chatData.post = PostType.Text_PointShare
  end
  chatData.param = shareData
  local shareStr = ShareDecode.Decode(chatData, shareData, true)
  local shareStrWordLen = string.word_count(shareStr)
  if saveParam and saveParam.selectionAtIndex then
    saveParam.selectionAtIndex = saveParam.selectionAtIndex + shareStrWordLen
  end
  local sortTagInsertIndex = -1
  if insertPosData.type == ChatAlNoticeTagInsertType.SortTagIndex then
    sortTagInsertIndex = insertPosData.index
  elseif insertPosData.type == ChatAlNoticeTagInsertType.CharIndex then
    if extraJsonData[ChatAlNoticeSpecialDataType.SortTag] == nil then
      sortTagInsertIndex = 1
    else
      local sortTagList = extraJsonData[ChatAlNoticeSpecialDataType.SortTag]
      for i = 1, #sortTagList do
        local tagData = sortTagList[i]
        local tag = tagData[ChatAlNoticeSpecialDataParamType.Tag]
        local index = tagData[ChatAlNoticeSpecialDataParamType.Index]
        if tag == ChatAlNoticeSpecialDataType.PointShare or tag == ChatAlNoticeSpecialDataType.NewsCenterURL then
          local pointShareData = extraJsonData[tag][index]
          local pointShareIndex = pointShareData[ChatAlNoticeSpecialDataParamType.Index]
          if pointShareIndex >= insertPosData.index then
            sortTagInsertIndex = i
            break
          end
        end
      end
      if sortTagInsertIndex == -1 then
        sortTagInsertIndex = #sortTagList + 1
      end
    end
  end
  if extraJsonData[ChatAlNoticeSpecialDataType.SortTag] == nil then
    extraJsonData[ChatAlNoticeSpecialDataType.SortTag] = {}
  end
  if extraJsonData[ChatAlNoticeSpecialDataType.PointShare] == nil then
    extraJsonData[ChatAlNoticeSpecialDataType.PointShare] = {}
  end
  local pointShareDataIndex = 1
  for i = 1, sortTagInsertIndex - 1 do
    local tagData = extraJsonData[ChatAlNoticeSpecialDataType.SortTag][i]
    local tag = tagData[ChatAlNoticeSpecialDataParamType.Tag]
    local index = tagData[ChatAlNoticeSpecialDataParamType.Index]
    if tag == ChatAlNoticeSpecialDataType.PointShare then
      pointShareDataIndex = pointShareDataIndex + 1
    end
  end
  table.insert(extraJsonData[ChatAlNoticeSpecialDataType.PointShare], pointShareDataIndex, {
    [ChatAlNoticeSpecialDataParamType.Index] = insertPosData.charIndex,
    [ChatAlNoticeSpecialDataParamType.shareData] = shareData
  })
  table.insert(extraJsonData[ChatAlNoticeSpecialDataType.SortTag], sortTagInsertIndex, {
    [ChatAlNoticeSpecialDataParamType.Tag] = ChatAlNoticeSpecialDataType.PointShare,
    [ChatAlNoticeSpecialDataParamType.Index] = pointShareDataIndex
  })
  for i = sortTagInsertIndex + 1, #extraJsonData[ChatAlNoticeSpecialDataType.SortTag] do
    local tagData = extraJsonData[ChatAlNoticeSpecialDataType.SortTag][i]
    local tag = tagData[ChatAlNoticeSpecialDataParamType.Tag]
    local index = tagData[ChatAlNoticeSpecialDataParamType.Index]
    if tag == ChatAlNoticeSpecialDataType.PointShare then
      index = index + 1
      tagData[ChatAlNoticeSpecialDataParamType.Index] = index
    end
  end
end

function ChatInterface.GetShowNoticeAndAddTempData(baseNotice, extraJsonData, addNoTranslateTag)
  local showNotice = baseNotice or ""
  local addTempData = {}
  if extraJsonData == nil then
    extraJsonData = {}
  end
  local NoticeStartSpace = 0
  local NoticeEndSpace = 0
  if extraJsonData[ChatAlNoticeSpecialDataType.NoticeStartSpace] then
    NoticeStartSpace = extraJsonData[ChatAlNoticeSpecialDataType.NoticeStartSpace]
  end
  if extraJsonData[ChatAlNoticeSpecialDataType.NoticeEndSpace] then
    NoticeEndSpace = extraJsonData[ChatAlNoticeSpecialDataType.NoticeEndSpace]
  end
  if 0 < NoticeStartSpace then
    showNotice = string.rep(" ", NoticeStartSpace) .. showNotice
  end
  if 0 < NoticeEndSpace then
    showNotice = showNotice .. string.rep(" ", NoticeEndSpace)
  end
  local NoticeTrimStartStr = ""
  local NoticeTrimEndStr = ""
  if not string.IsNullOrEmpty(extraJsonData[ChatAlNoticeSpecialDataType.NoticeTrimStartStr]) then
    NoticeTrimStartStr = extraJsonData[ChatAlNoticeSpecialDataType.NoticeTrimStartStr]
  end
  if not string.IsNullOrEmpty(extraJsonData[ChatAlNoticeSpecialDataType.NoticeTrimEndStr]) then
    NoticeTrimEndStr = extraJsonData[ChatAlNoticeSpecialDataType.NoticeTrimEndStr]
  end
  showNotice = NoticeTrimStartStr .. showNotice .. NoticeTrimEndStr
  if extraJsonData[ChatAlNoticeSpecialDataType.SortTag] then
    addTempData[ChatAlNoticeSpecialDataType.SortTag] = extraJsonData[ChatAlNoticeSpecialDataType.SortTag]
    local sortTagList = addTempData[ChatAlNoticeSpecialDataType.SortTag]
    local insertWordLen = 0
    for i = 1, #sortTagList do
      local tagData = sortTagList[i]
      local tag = tagData[ChatAlNoticeSpecialDataParamType.Tag]
      local index = tagData[ChatAlNoticeSpecialDataParamType.Index]
      if tag == ChatAlNoticeSpecialDataType.PointShare then
        local pointShareList = extraJsonData[tag]
        if pointShareList and pointShareList[index] then
          local pointShareData = pointShareList[index]
          local insertIndex = pointShareData[ChatAlNoticeSpecialDataParamType.Index]
          local shareData = pointShareData[ChatAlNoticeSpecialDataParamType.shareData]
          local chatData = {}
          if shareData.postType ~= nil then
            chatData.post = shareData.postType
          else
            chatData.post = PostType.Text_PointShare
          end
          chatData.param = shareData
          local shareStr = ShareDecode.Decode(chatData, shareData, true)
          if addNoTranslateTag then
            shareStr = "<span class=\"notranslate\">" .. shareStr .. "</span>"
          end
          local strLen = #shareStr
          local wordLen = string.word_count(shareStr)
          local shareStrWordInsertIndex = insertIndex + insertWordLen
          insertWordLen = insertWordLen + wordLen
          local shareStrInsertIndex = string.wordIndexToLenIndex(showNotice, shareStrWordInsertIndex - 1)
          showNotice = string.insert(showNotice, shareStrInsertIndex + 1, shareStr)
          local tempData = {
            [ChatAlNoticeSpecialDataParamType.Index] = shareStrWordInsertIndex,
            [ChatAlNoticeSpecialDataParamType.shareData] = shareData,
            str = shareStr,
            strLen = strLen,
            wordLen = wordLen
          }
          if addTempData[ChatAlNoticeSpecialDataType.PointShare] == nil then
            addTempData[ChatAlNoticeSpecialDataType.PointShare] = {}
          end
          addTempData[ChatAlNoticeSpecialDataType.PointShare][index] = tempData
        end
      elseif tag == ChatAlNoticeSpecialDataType.NewsCenterURL then
        local tagDataList = extraJsonData[tag]
        if tagDataList and tagDataList[index] then
          local tagData = tagDataList[index]
          local insertIndex = tagData[ChatAlNoticeSpecialDataParamType.Index]
          local shareData = tagData[ChatAlNoticeSpecialDataParamType.shareData]
          local wikiChain = StringUtils.GetMD5(shareData)
          local dataState, data = DataCenter.LWNewsCenterManager:GetCacheInfoByWikiChain(wikiChain)
          local shareStr = Localization:GetString("newscenter_desc2")
          if dataState == NewsChainDataState.NoData then
            shareStr = Localization:GetString("newscenter_desc1")
          elseif dataState == NewsChainDataState.HaveData then
            shareStr = data.title
          end
          local strLen = #shareStr
          local wordLen = string.word_count(shareStr)
          local shareStrWordInsertIndex = insertIndex + insertWordLen
          insertWordLen = insertWordLen + wordLen
          local shareStrInsertIndex = string.wordIndexToLenIndex(showNotice, shareStrWordInsertIndex - 1)
          showNotice = string.insert(showNotice, shareStrInsertIndex + 1, shareStr)
          local tempData = {
            [ChatAlNoticeSpecialDataParamType.Index] = shareStrWordInsertIndex,
            [ChatAlNoticeSpecialDataParamType.shareData] = shareData,
            str = shareStr,
            strLen = strLen,
            wordLen = wordLen,
            dataState = dataState
          }
          if addTempData[tag] == nil then
            addTempData[tag] = {}
          end
          addTempData[tag][index] = tempData
        end
      end
    end
  end
  return showNotice, addTempData
end

function ChatInterface.GetBaseNoticeAndExtraJsonData(showNotice, addTempData, isStringTrim)
  local baseNotice = showNotice
  local extraJsonData = {}
  if isStringTrim and 0 < #showNotice then
    baseNotice = string.trim(baseNotice)
    local matchStr = string.match(showNotice, "^%s*(.-)%s*$")
    local sStart, sEnd
    if not string.IsNullOrEmpty(matchStr) then
      sStart, sEnd = string.find(showNotice, matchStr, 1, true)
    end
    local spaceLen = 0
    if sStart then
      spaceLen = sStart - 1
    end
    if 0 < spaceLen and addTempData then
      for i = 1, #ChatAlNoticePosChangeTag do
        local tag = ChatAlNoticePosChangeTag[i]
        if addTempData[tag] then
          for k, v in pairs(addTempData[tag]) do
            local insertIndex = v[ChatAlNoticeSpecialDataParamType.Index]
            v[ChatAlNoticeSpecialDataParamType.Index] = insertIndex - spaceLen
          end
        end
      end
    end
  end
  if addTempData and addTempData[ChatAlNoticeSpecialDataType.SortTag] then
    extraJsonData[ChatAlNoticeSpecialDataType.SortTag] = addTempData[ChatAlNoticeSpecialDataType.SortTag]
    local sortTagList = extraJsonData[ChatAlNoticeSpecialDataType.SortTag]
    local delWordLen = 0
    for i = 1, #sortTagList do
      local tagData = sortTagList[i]
      local tag = tagData[ChatAlNoticeSpecialDataParamType.Tag]
      local index = tagData[ChatAlNoticeSpecialDataParamType.Index]
      if tag == ChatAlNoticeSpecialDataType.PointShare then
        local pointShareList = addTempData[tag]
        if pointShareList and pointShareList[index] then
          local pointShareData = pointShareList[index]
          local insertWordIndex = pointShareData[ChatAlNoticeSpecialDataParamType.Index]
          local shareData = pointShareData[ChatAlNoticeSpecialDataParamType.shareData]
          local wordLen = pointShareData.wordLen
          local strLen = pointShareData.strLen
          local removeWordStartIndex = insertWordIndex - delWordLen
          delWordLen = delWordLen + wordLen
          local delStrIndex = string.wordIndexToLenIndex(baseNotice, removeWordStartIndex - 1)
          baseNotice = string.removeByIndex(baseNotice, delStrIndex + 1, delStrIndex + 1 + strLen - 1)
          local tagData = {
            [ChatAlNoticeSpecialDataParamType.Index] = removeWordStartIndex,
            [ChatAlNoticeSpecialDataParamType.shareData] = shareData
          }
          if extraJsonData[tag] == nil then
            extraJsonData[tag] = {}
          end
          extraJsonData[tag][index] = tagData
        end
      elseif tag == ChatAlNoticeSpecialDataType.NewsCenterURL then
        local tagDataList = addTempData[tag]
        if tagDataList and tagDataList[index] then
          local tagData = tagDataList[index]
          local insertWordIndex = tagData[ChatAlNoticeSpecialDataParamType.Index]
          local shareData = tagData[ChatAlNoticeSpecialDataParamType.shareData]
          local wordLen = tagData.wordLen
          local strLen = tagData.strLen
          local removeWordStartIndex = insertWordIndex - delWordLen
          delWordLen = delWordLen + wordLen
          local delStrIndex = string.wordIndexToLenIndex(baseNotice, removeWordStartIndex - 1)
          baseNotice = string.removeByIndex(baseNotice, delStrIndex + 1, delStrIndex + 1 + strLen - 1)
          local tagData = {
            [ChatAlNoticeSpecialDataParamType.Index] = removeWordStartIndex,
            [ChatAlNoticeSpecialDataParamType.shareData] = shareData
          }
          if extraJsonData[tag] == nil then
            extraJsonData[tag] = {}
          end
          extraJsonData[tag][index] = tagData
        end
      end
    end
  end
  if isStringTrim then
    local NoticeTrimStartStr = ""
    local NoticeTrimEndStr = ""
    if 0 < #baseNotice then
      local matchStr = string.match(baseNotice, "^%s*(.-)%s*$")
      local sStart, sEnd
      if not string.IsNullOrEmpty(matchStr) then
        sStart, sEnd = string.find(baseNotice, matchStr, 1, true)
      end
      if sStart then
        NoticeTrimStartStr = string.sub(baseNotice, 1, sStart - 1)
      end
      local strLen = #baseNotice
      if sEnd and strLen and sEnd < strLen then
        NoticeTrimEndStr = string.sub(baseNotice, sEnd + 1)
      end
      baseNotice = baseNotice:trim()
    end
    baseNotice = string.gsub(baseNotice, "\003", "\226\128\139")
    extraJsonData[ChatAlNoticeSpecialDataType.NoticeTrimStartStr] = NoticeTrimStartStr
    extraJsonData[ChatAlNoticeSpecialDataType.NoticeTrimEndStr] = NoticeTrimEndStr
  end
  return baseNotice, extraJsonData
end

function ChatInterface.GetAlNoticePointShareMaxNum()
  return 10
end

function ChatInterface.GetIsChatViewRoom(group)
  if group == ChatGroupType.GROUP_FRIENDS_CIRCLE_ROOM or group == ChatGroupType.GROUP_FRIENDS_CIRCLE_COMMENT_ROOM then
    return false
  end
  return true
end

function ChatInterface.GetMomentIsOpen()
  return true
end

function ChatInterface.IsAtOpen()
  if ChatInterface.isDebug() then
    return true
  end
  if StringUtils.VersionCompare(CS.GameEntry.Sdk.Version, "1.0.292") >= 0 or Config.IsPC() then
    return true
  end
  return false
end

function ChatInterface.GetShowRoomUserName(uid)
  local chatUserInfo = ChatManager2:GetInstance().User:getChatUserInfo(uid)
  local name = ""
  if chatUserInfo then
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(chatUserInfo.uid, chatUserInfo.userName)
    if not string.IsNullOrEmpty(chatUserInfo.allianceSimpleName) then
      name = string.format("(%s)%s", chatUserInfo.allianceSimpleName, showName)
    else
      name = string.format("%s", showName)
    end
  end
  return name
end

function ChatInterface.GetGroupChatIsOpen()
  if CS.NetworkURLConfig.IsLocal or CS.NetworkURLConfig.IsPressureTest or CS.NetworkURLConfig.IsAWS then
    return true
  end
  local k1 = LuaEntry.DataConfig:TryGetNum("group_chat_control", "k1")
  if k1 == 0 then
    return false
  elseif k1 == 1 then
    local selfServerId = LuaEntry.Player:GetSourceServerId()
    if 1 <= selfServerId and selfServerId <= 68 then
      return true
    end
  elseif k1 == 2 then
    return true
  end
  return false
end

function ChatInterface.TranslateAllIsOpen()
  local k1 = LuaEntry.DataConfig:TryGetNum("full_page_trans_test_set", "k1")
  local selfServerId = LuaEntry.Player:GetSourceServerId()
  if CS.NetworkURLConfig.IsPressureTest then
    if k1 == 1 then
      if selfServerId <= 46 then
        return true
      end
    elseif k1 == 2 then
      if selfServerId <= 74 then
        return true
      end
    elseif k1 == 3 then
      return true
    end
  elseif k1 == 1 then
    if selfServerId <= 68 then
      return true
    end
  elseif k1 == 2 then
    if selfServerId <= 360 then
      return true
    end
  elseif k1 == 3 then
    return true
  end
  return DataCenter.MonthCardNewManager:CheckIfMonthCardActive()
end

function ChatInterface.IsJoinAlHighFiveOpen()
  local open = false
  local openServer = LuaEntry.DataConfig:TryGetStr("clap_hands", "k1", "")
  if string.IsNullOrEmpty(openServer) then
    open = false
  elseif CS.NetworkURLConfig.IsLocal or CS.NetworkURLConfig.IsPressureTest then
    open = true
  else
    local serverIdsTab = string.string2array_num(openServer, "-", ";")
    for _, serverIds in ipairs(serverIdsTab) do
      if #serverIds == 2 and CommonUtil.IsGrayServer(tonumber(serverIds[1]), tonumber(serverIds[2])) then
        open = true
        break
      end
    end
  end
  return open
end

function ChatInterface.ServiceBubbleIsOpen()
  local k1 = LuaEntry.DataConfig:TryGetNum("gm_contact_control", "k1")
  local selfServerId = LuaEntry.Player:GetSourceServerId()
  if k1 == 0 then
    return false
  elseif k1 == 1 then
    if selfServerId <= 196 then
      return true
    end
  elseif k1 == 2 then
    return true
  end
  return false
end

function ChatInterface.GetAtAllPermission(room)
  if room.group == ChatGroupType.GROUP_ALLIANCE or room.group == ChatGroupType.GROUP_ALLIANCE_MANAGER then
    return DataCenter.AllianceBaseDataManager:IsR4orR5()
  elseif room.group == ChatGroupType.GROUP_CUSTOM_GROUP then
    return room.owner == LuaEntry.Player.uid
  end
  return false
end

function ChatInterface.isGameServerRoomIdEnabled()
  return CS.ClientSwitch.IsOn(CS.ClientSwitch.CHAT_SERVER_ROOMLIST)
end

function ChatInterface.IsDuringSeason()
  return SeasonUtil.GetSeason() > 0 or SeasonUtil.IsInSeasonPrepareMode()
end

function ChatInterface.NewsWikiTokenVerification()
  local k1 = LuaEntry.DataConfig:TryGetNum("wiki_id_token", "k1")
  if k1 == 0 then
    return false
  else
    return true
  end
end

function ChatInterface.GetIsMomentGroup(group)
  return ChatInterface.getMoment():IsMomentGroup(group)
end

function ChatInterface.DarkMode(gameObject, alpha)
  alpha = alpha or ChatInterface.GetChatTheme() == ChatUIThemeConfig.ChatMode.Night and 0.2 or 0
  local blackMask = ChatInterface.GetUtil().CreateOrGetBlackMask(gameObject, alpha)
  return blackMask
end

return ChatInterface
