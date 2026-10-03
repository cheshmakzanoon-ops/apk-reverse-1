local InteractiveUtil = {}
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local InteractiveDataQueue = {}
local InteractiveCounter = 0
InteractiveUtil.ThumbsUpType = {
  Unknown = 0,
  AllianceNotice = 1,
  ChatMessage = 2,
  AllianceMail = 3,
  KingMail = 4,
  CityInfo = 5,
  PlayerInfo = 6,
  ExchangeRecord = 7,
  MultipleParkour = 8,
  ChampionDuel = 9,
  ActRadarTreasure = 10,
  GHOST_RECON = 11,
  HelpStopFirePerson = 12,
  HelpStopFireAlliance = 13,
  GoodJobAresMissile = 14,
  ServerBattle = 15,
  FactionWarMVP = 16,
  GoldenEgg = 17,
  TrainDriver = 18,
  PLANE_FEATURE = 19,
  FriendsCirleUp = 20,
  SkillAddMummyArmy = 21,
  MeteoriteBattleRank = 22,
  GoodJobGoddessMummy = 23,
  VipLuckyTrainCard = 24,
  VipBigBroTrainCard = 25,
  AllianceStarCommend = 26,
  ChampionDuelReward = 27,
  EasterEggChat = 28,
  EpidemicBattleMvp = 29,
  LightMe = 30,
  SeasonPhotoMessage = 31,
  SeasonSheep = 32,
  MusicFestival2025_ScoreRank = 33,
  ActConcert = 34,
  OffSeasonDetect = 35,
  HighFive = 36,
  BloodyQueenRank = 37,
  SeasonTetris = 38,
  DsbDuelHistoryMvp = 39,
  SeasonSelectLocationGame = 40,
  BattleField = 41,
  AllyDuelRank = 42,
  BirthdayInformation = 43,
  BirthdayRedPacket = 44,
  FlowerTrainRank = 46,
  ThanksFlowerTrainCheer = 47,
  ThanksFlowerTrainLike = 48,
  BiuBiuRank = 49,
  PlaneFeatureShare = 50,
  DispatchRecordLike = 51,
  FireworkBox = 52,
  DEFEND_ZOMBIE_ATTACK_CITY = 53,
  DispatchMarkLike = 54,
  ActRecycleLike = 55,
  FrontBreakSunday = 56,
  FriendsCirleComment = 58,
  LLRankLike = 59,
  AllianceLuckSiphonBuff = 60,
  AllianceLuckSiphonRedPacket = 61,
  GGGoRank = 62,
  S0AllianceBossFirework = 63,
  GoodJobGoddessMummy = 99
}
local ITEM_KEY = {
  [InteractiveUtil.ThumbsUpType.AllianceNotice] = "k1",
  [InteractiveUtil.ThumbsUpType.ChatMessage] = "k2",
  [InteractiveUtil.ThumbsUpType.AllianceMail] = "k3",
  [InteractiveUtil.ThumbsUpType.KingMail] = "k4",
  [InteractiveUtil.ThumbsUpType.CityInfo] = "k5",
  [InteractiveUtil.ThumbsUpType.PlayerInfo] = "k6",
  [InteractiveUtil.ThumbsUpType.ExchangeRecord] = "k7",
  [InteractiveUtil.ThumbsUpType.MultipleParkour] = "k8",
  [InteractiveUtil.ThumbsUpType.GHOST_RECON] = "k10",
  [InteractiveUtil.ThumbsUpType.HelpStopFirePerson] = "k11",
  [InteractiveUtil.ThumbsUpType.HelpStopFireAlliance] = "k12",
  [InteractiveUtil.ThumbsUpType.ServerBattle] = "k13",
  [InteractiveUtil.ThumbsUpType.GoldenEgg] = "k14",
  [InteractiveUtil.ThumbsUpType.PLANE_FEATURE] = "k15",
  [InteractiveUtil.ThumbsUpType.SkillAddMummyArmy] = "k16",
  [InteractiveUtil.ThumbsUpType.AllianceStarCommend] = "k17",
  [InteractiveUtil.ThumbsUpType.EasterEggChat] = "k19",
  [InteractiveUtil.ThumbsUpType.SeasonPhotoMessage] = "k21",
  [InteractiveUtil.ThumbsUpType.SeasonSheep] = "k22",
  [InteractiveUtil.ThumbsUpType.MusicFestival2025_ScoreRank] = "k23",
  [InteractiveUtil.ThumbsUpType.OffSeasonDetect] = "k24",
  [InteractiveUtil.ThumbsUpType.HighFive] = "k25"
}
local InteractiveDataTemplate = {
  uid = "",
  type = InteractiveUtil.ThumbsUpType.Unknown,
  content = "",
  callback = "",
  sequence = "",
  time = 0,
  over = false
}
local InteractiveData = DataClass("InteractiveData", InteractiveDataTemplate)

function InteractiveUtil.Clean()
  InteractiveDataQueue = {}
end

function InteractiveUtil.GetLangKeyByThumbType(thumbType)
  local config = DataCenter.InteractionTemplateManager:GetLikeTemplateByType(thumbType)
  if config and config.desc then
    return config.desc
  else
    return "thumbs_up_nority"
  end
end

function InteractiveUtil.TryThumbsUp(targetUid, thumbsUpType, identifier, callback, extParam, notSendMessage_)
  if not InteractiveUtil.CanThumbsUp(thumbsUpType) then
    UIUtil.ShowTipsId("avatar_tips003")
    return
  end
  if callback and type(callback) == "function" then
    if not UIUtil.UseNewPlayerInfo() then
      CommonUtil.ProtectCall(callback)
      return
    end
    if targetUid == LuaEntry.Player.uid then
      UIUtil.ShowTipsId("avatar_tips001")
      return
    end
    local now = UITimeManager:GetInstance():GetServerTime()
    local sequence
    InteractiveCounter = toInt(InteractiveCounter) + 1
    if identifier == nil or identifier == "" then
      sequence = tostring(InteractiveCounter)
    else
      sequence = tostring(identifier)
    end
    if InteractiveDataQueue == nil then
      InteractiveDataQueue = {}
    else
      for _, v in ipairs(InteractiveDataQueue) do
        if v and v.over ~= true and v.uid == targetUid and v.type == thumbsUpType and v.sequence == sequence then
          if now - v.time < 3000 then
            UIUtil.ShowTipsId("avatar_tips002")
          else
            v.time = now
            v.callback = callback
            if not notSendMessage_ then
              InteractiveUtil.DoSendMessage(targetUid, thumbsUpType, v.sequence, extParam)
            end
            InteractiveUtil.TryDoFuncAtSendTryThumbsUpMsg(targetUid, thumbsUpType, v.sequence, extParam)
            return v.sequence
          end
          return
        end
      end
    end
    local data = InteractiveData.New()
    data.uid = targetUid
    data.type = thumbsUpType
    data.sequence = sequence
    data.callback = callback
    data.time = now
    data.over = false
    table.insert(InteractiveDataQueue, data)
    if not notSendMessage_ then
      InteractiveUtil.DoSendMessage(targetUid, thumbsUpType, data.sequence, extParam)
    end
    InteractiveUtil.TryDoFuncAtSendTryThumbsUpMsg(targetUid, thumbsUpType, data.sequence, extParam)
    return data.sequence
  end
end

function InteractiveUtil.DoSendMessage(targetUid, thumbsUpType, sequence, extParam)
  SFSNetwork.SendMessage(MsgDefines.TryThumbsUp, targetUid, thumbsUpType, sequence, extParam)
end

function InteractiveUtil.TryDoFuncAtSendTryThumbsUpMsg(targetUid, thumbsUpType, sequence, extParam)
  InteractiveUtil.TrySendActGiftGivingItem(targetUid)
  if sequence ~= "NotAutoSendGift" then
    InteractiveUtil.TrySendActValentineGivingItem(targetUid)
  end
end

function InteractiveUtil.TrySendActGiftGivingItem(targetUid)
  local isInCrossServer = CrossServerUtil.CheckCrossServerWithWatchAndJoinType()
  if isInCrossServer then
    return
  end
  local targetActId = DataCenter.ActGiftGivingDataManager:GetOneOpenActId()
  if targetActId == nil or targetActId <= 0 then
    return
  end
  local isAuto = DataCenter.ActGiftGivingDataManager:GetIsAutoSend(targetActId)
  if not isAuto then
    return
  end
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(targetActId)
  if activityInfo == nil then
    return
  end
  local activityTemp = DataCenter.ActGiftGivingDataManager:GetTempByActInfo(activityInfo)
  if activityTemp == nil then
    return
  end
  local itemId = activityTemp.give_item
  if itemId == nil or itemId <= 0 then
    return
  end
  local curNum = DataCenter.ItemData:GetItemCount(itemId)
  if curNum < 1 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ThanksgivingGive, targetActId, targetUid, 1, 0, "")
end

function InteractiveUtil.TrySendActValentineGivingItem(targetUid)
  local activityList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.ActValentineSendGift.Type)
  local targetActId = 0
  if activityList and 0 < #activityList then
    targetActId = tonumber(activityList[1].id) or 0
  end
  if targetActId == nil or targetActId <= 0 then
    return
  end
  local isAuto = DataCenter.ValentineDataManager:GetIsAutoSend(targetActId)
  if not isAuto then
    return
  end
  local temp = DataCenter.ValentineDataManager:GetActSendTempByActId(targetActId)
  local itemId = 0
  if temp and 0 < #temp.send_fast then
    itemId = temp.send_fast[1]
  end
  if 0 < itemId then
    local curNum = DataCenter.GiftSystemManager:GetGiftNum(itemId)
    if 0 < curNum then
      DataCenter.GiftSystemManager:SendGift(itemId, targetUid, false, "", 1)
    end
  end
end

function InteractiveUtil.CanThumbsUp(thumbsUpType)
  local thumbsUpInfoObj = LuaEntry.Player.thumbsUpInfoObj or {}
  local lastThumbUpTime = thumbsUpInfoObj.time
  if not lastThumbUpTime then
    return true
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local year1, month1, day1 = UITimeManager:GetInstance():TimeStampToServerTime(lastThumbUpTime)
  local year2, month2, day2 = UITimeManager:GetInstance():TimeStampToServerTime(now)
  if year1 ~= year2 or month1 ~= month2 or day1 ~= day2 then
    return true
  end
  local num = thumbsUpInfoObj["type_" .. tostring(thumbsUpType)]
  if num == nil then
    return true
  end
  local max = InteractiveUtil.GetMaxThumbsUpCount(thumbsUpType)
  if max == nil then
    return true
  end
  return num < max
end

function InteractiveUtil.GetMaxThumbsUpCount(thumbsUpType)
  local config = DataCenter.InteractionTemplateManager:GetLikeTemplateByType(thumbsUpType)
  if config and config.daily_max then
    return config.daily_max
  end
end

function InteractiveUtil.GetMaxPopUpPerSecond(thumbsUpType)
  local config = DataCenter.InteractionTemplateManager:GetLikeTemplateByType(thumbsUpType)
  if config and config.pop_max then
    return config.pop_max
  end
  return 100
end

function InteractiveUtil.GetCanThumbsUpCount(thumbsUpType)
  local max = InteractiveUtil.GetMaxThumbsUpCount(thumbsUpType)
  if max == nil then
    return -1
  end
  local thumbsUpInfoObj = LuaEntry.Player.thumbsUpInfoObj or {}
  local lastThumbUpTime = thumbsUpInfoObj.time
  if not lastThumbUpTime then
    return max
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local year1, month1, day1 = UITimeManager:GetInstance():TimeStampToServerTime(lastThumbUpTime)
  local year2, month2, day2 = UITimeManager:GetInstance():TimeStampToServerTime(now)
  if year1 ~= year2 or month1 ~= month2 or day1 ~= day2 then
    return max
  end
  local num = thumbsUpInfoObj["type_" .. tostring(thumbsUpType)]
  if num ~= nil then
    return math.max(max - num, 0)
  end
  return max
end

function InteractiveUtil.OnThumbsUpMessage(msg)
  if msg == nil or InteractiveDataQueue == nil then
    InteractiveUtil.OnThumbsUpMessageTarget(msg)
    return
  end
  if msg.thumbsUpInfoObj then
    LuaEntry.Player.thumbsUpInfoObj = msg.thumbsUpInfoObj
  end
  if not msg.result and msg.num ~= 0 and msg.max ~= 0 and toInt(msg.num) >= toInt(msg.max) then
    UIUtil.ShowTipsId("avatar_tips003")
  end
  local activeCount = 0
  local now = UITimeManager:GetInstance():GetServerTime()
  for _, v in ipairs(InteractiveDataQueue) do
    if v and v.callback and v.over ~= true and type(v.callback) == "function" then
      if v.sequence == msg.content and v.type == msg.type and v.uid == msg.targetUid then
        v.over = true
        if v.type == InteractiveUtil.ThumbsUpType.ChatMessage or v.type == InteractiveUtil.ThumbsUpType.GoodJobAresMissile or v.type == InteractiveUtil.ThumbsUpType.GoodJobGoddessMummy or v.type == InteractiveUtil.ThumbsUpType.PLANE_FEATURE then
          CommonUtil.ProtectCall(function()
            v.callback(msg)
          end)
        elseif msg.result then
          CommonUtil.ProtectCall(v.callback)
        end
      elseif now - v.time < 60000 then
        activeCount = activeCount + 1
      end
    end
  end
  if activeCount == 0 then
    InteractiveDataQueue = {}
  end
  InteractiveUtil.OnThumbsUpMessageTarget(msg)
  InteractiveUtil.OnReportData(msg)
end

function InteractiveUtil.OnThumbsUpMessageTarget(t)
  if not (t and t.targetUid) or not t.type then
    return
  end
  if t.likeRewardInfo then
    DataCenter.SeasonCallbackManager:SetThumbsInfo(t.likeRewardInfo.targetUid, t.likeRewardInfo.activityId)
    EventManager:GetInstance():Broadcast(EventId.LWQueryThumbsInfoUpdate)
    if t.likeRewardInfo.reward then
      local callbackData = DataCenter.SeasonCallbackManager:GetFirstData(SeasonCallbackType.Base)
      local tips = callbackData and callbackData.like_reward_tips
      if string.IsNullOrEmpty(tips) then
        tips = "season_s2_callback_tips_1"
      end
      DataCenter.RewardManager:AddRewardsAndRes(t.likeRewardInfo)
      if t.type == InteractiveUtil.ThumbsUpType.PLANE_FEATURE then
        local rewards = DataCenter.RewardManager:ReturnRewardParamForMessage(t.likeRewardInfo.reward) or {}
        for i, reward in ipairs(rewards) do
          if reward.count and reward.count > 0 then
            local name = DataCenter.ResourceManager:GetResourceNameByType(ResourceType.Gold)
            local num = reward.count
            UIUtil.ShowTips(Localization:GetString("500216", name, num))
          end
        end
      else
        tips = Localization:GetString(tips)
        if t.type == InteractiveUtil.ThumbsUpType.CityInfo then
          local cur = LuaEntry.Player.thumbsUpInfoObj and LuaEntry.Player.thumbsUpInfoObj.callBackRewardNum or 0
          local max = tonumber(LuaEntry.DataConfig:GetValue("callback_like_reward_daily_limit", "k1") or 10)
          tips = string.format([[
%s
%s]], tips, Localization:GetString("season_s4_callback_tips_1", cur, max))
        end
        DataCenter.RewardManager:ShowCommonReward(t.likeRewardInfo, nil, nil, nil, nil, nil, nil, tips, nil, true)
      end
    end
  end
  if t.type == InteractiveUtil.ThumbsUpType.BirthdayInformation then
    DataCenter.BirthdayDataManager:SetBirthdayHistoriey(t.targetUid)
    EventManager:GetInstance():Broadcast(EventId.BirthdayThumbsUpSuccess, t)
    return
  end
  if t.thumbsUpNum then
    local info = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(t.targetUid)
    if info then
      info.updateTime = UITimeManager:GetInstance():GetServerTime()
      info.thumbsUpCount = toInt(t.thumbsUpNum)
      EventManager:GetInstance():Broadcast(EventId.GetNewUserInfoSucc)
      return
    end
  end
  SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, t.targetUid)
  EventManager:GetInstance():Broadcast(EventId.OnThumbUpSuccess, t)
end

function InteractiveUtil.OnPictureUpload(ret, reason)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlayerHeadIconSelect)
  if ret ~= "true" then
    UIUtil.ShowTipsId("avatar_tips010")
    Logger.LogInfo("\228\184\138\228\188\160\232\182\133\230\151\182 9 ret:" .. tostring(ret) .. " reason:" .. tostring(reason))
    LuaEntry.Player:UploadPicEnd()
    return
  end
  if reason then
    local serverMsg = rapidjson.decode(reason)
    if serverMsg and serverMsg.status and toInt(serverMsg.code) == 0 then
      if UIUtil.UseNewPlayerInfo() then
        local slotId = toInt(LuaEntry.GlobalData.serverPicSlotId)
        local picVer = toInt(LuaEntry.GlobalData.serverPicVer)
        if slotId ~= 0 and picVer ~= 0 then
          SFSNetwork.SendMessage(MsgDefines.NotifyPhotoAlbumUpdate, slotId, picVer)
        end
        LuaEntry.Player:UploadPicEnd()
      else
        SFSNetwork.SendMessage(MsgDefines.UpdatePic)
      end
      return
    end
  end
  UIUtil.ShowTipsId("avatar_tips009")
  LuaEntry.Player:UploadPicEnd()
end

function InteractiveUtil.OnPhotoClick()
  local picVer = LuaEntry.Player.picVer
  if UIUtil.UseNewPlayerInfo() then
    picVer = toInt(LuaEntry.GlobalData.serverPicVer)
    if picVer <= 0 then
      UIUtil.ShowTipsId("avatar_tips006")
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlayerHeadIconSelect)
      return
    end
  end
  DataCenter.ChatSendPhotoManager:SetCurPhotoFuncType(PhotoFuncType.PlayerHeadPickPhoto)
  CS.UploadImageManager.Instance:OnUploadImage(PhotoFuncType.PlayerHeadPickPhoto, LuaEntry.Player.uid, picVer, InteractiveUtil.OnPictureUpload)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlayerHeadIconSelect)
end

function InteractiveUtil.OnCameraClick()
  local picVer = LuaEntry.Player.picVer
  if UIUtil.UseNewPlayerInfo() then
    picVer = toInt(LuaEntry.GlobalData.serverPicVer)
    if picVer <= 0 then
      UIUtil.ShowTipsId("avatar_tips006")
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlayerHeadIconSelect)
      return
    end
  end
  local state = PermissionType.Accept
  if CS.GameEntry.Sdk.GetPermissionByType ~= nil then
    local stateStr = CS.GameEntry.Sdk:GetPermissionByType(0)
    state = tonumber(stateStr)
    if state == nil then
      state = PermissionType.Request
    end
  end
  if state == PermissionType.Accept then
    DataCenter.ChatSendPhotoManager:SetCurPhotoFuncType(PhotoFuncType.PlayerHeadCamera)
    CS.UploadImageManager.Instance:OnUploadImage(PhotoFuncType.PlayerHeadCamera, LuaEntry.Player.uid, picVer, InteractiveUtil.OnPictureUpload)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlayerHeadIconSelect)
  elseif state == PermissionType.Refuse then
    UIUtil.ShowMessage(Localization:GetString("431703"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlayerHeadIconSelect)
  else
    UIUtil.ShowMessage(Localization:GetString("431702"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      DataCenter.ChatSendPhotoManager:SetCurPhotoFuncType(PhotoFuncType.PlayerHeadCamera)
      CS.UploadImageManager.Instance:OnUploadImage(PhotoFuncType.PlayerHeadCamera, LuaEntry.Player.uid, picVer, InteractiveUtil.OnPictureUpload)
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlayerHeadIconSelect)
    end)
  end
end

function InteractiveUtil.OnReportData(msg)
  if not msg.result and msg.num ~= 0 and msg.max ~= 0 and toInt(msg.num) >= toInt(msg.max) then
    return
  end
  if msg.type == InteractiveUtil.ThumbsUpType.HighFive then
    PostEventLog.Track(PostEventLog.Defines.CLAP_HANDS_SUCCESS, {
      uid = msg.targetUid,
      sid = LuaEntry.Player:GetAllianceUid()
    })
  end
end

return ConstClass("InteractiveUtil", InteractiveUtil)
