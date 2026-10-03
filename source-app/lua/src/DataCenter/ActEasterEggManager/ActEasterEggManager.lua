local ActEasterEggManager = BaseClass("ActEasterEggManager")
local ActEasterEggTemplate = require("DataCenter.ActEasterEggManager.ActEasterEggTemplate")
local ActEasterEggMainData = require("DataCenter.ActEasterEggManager.ActEasterEggMainData")
local ActEasterEggTipsData = require("DataCenter.ActEasterEggManager.ActEasterEggTipsData")
local ActEasterEggAmazingEggData = require("DataCenter.ActEasterEggManager.ActEasterEggAmazingEggData")
local ActEasterEggUpgradeAmazingEggData = require("DataCenter.ActEasterEggManager.ActEasterEggUpgradeAmazingEggData")
local ActEasterEggMyPostEggsData = require("DataCenter.ActEasterEggManager.ActEasterEggMyPostEggsData")
local ActEasterEggMyCommentData = require("DataCenter.ActEasterEggManager.ActEasterEggMyCommentData")
local ActEasterEggThrowData = require("DataCenter.ActEasterEggManager.ActEasterEggThrowData")
local ActEasterEggData = require("DataCenter.ActEasterEggManager.ActEasterEggData")
local ActEasterEggMainAniEggData = require("DataCenter.ActEasterEggManager.ActEasterEggMainAniEggData")
local ActEasterEggTranslateData = require("DataCenter.ActEasterEggManager.ActEasterEggTranslateData")
local Localization = CS.GameEntry.Localization
local maxRecordNum = 20

local function __init(self)
  self:AddListener()
  self.eggConfig = nil
  self.eggActInfo = nil
  self.eggTipsData = nil
  self.myPostEggsInfo = nil
  self.myCommitEggsInfo = nil
  self.hasSeenEggIndexList = nil
  self.throwData = nil
  self.mainAniEggData = nil
  self.chatEggInfo = nil
  local key = self:GetAutoTranslateKey()
  self.isOpenAutoTranslate = CS.GameEntry.Setting:GetBool(key, false)
  self.sendChatMsgTime = 0
  self.eggTranslateTextDic = {}
  self.canSendTimestamp = 0
  self.remainSendTimes = 0
  self.readyForLikeDescendMsg = false
  self.readyForFirstPart = false
  self.topLikeChatData = nil
  self.isJumpTopLikeChatData = false
  self.isPlayingHook = false
end

local function __delete(self)
  self:RemoveListener()
  self.eggConfig = nil
  self.eggActInfo = nil
  self.eggTipsData = nil
  self.myPostEggsInfo = nil
  self.myCommitEggsInfo = nil
  self.hasSeenEggIndexList = nil
  self.throwData = nil
  self.mainAniEggData = nil
  self.showUIGamePlayFlag = nil
  self.chatEggInfo = nil
  self.isOpenAutoTranslate = false
  self.sendChatMsgTime = 0
  self.eggTranslateTextDic = nil
  self.canSendTimestamp = 0
  self.remainSendTimes = 0
  self.readyForLikeDescendMsg = false
  self.readyForFirstPart = false
  self.topLikeChatData = nil
  self.isJumpTopLikeChatData = false
  self:StopPickUpTimer()
  self.isPlayingHook = nil
end

local function AddListener(self)
end

local function RemoveListener(self)
end

function ActEasterEggManager:UpdateActInfo(message)
  if not message or not message.activityId then
    Logger.LogError("message or activityId is nil")
    return
  end
  if not self.eggActInfo then
    self.eggActInfo = ActEasterEggMainData.New()
  end
  self.eggActInfo:UpdateServerData(message)
  DataCenter.ActEasterEggTaskManager:UpdateServerData(message)
  if not self.eggConfig then
    local activityId = message.activityId
    local activityConfigInfo = LocalController:instance():getLine(TableName.Activity, toInt(activityId))
    local activityConfigId = activityConfigInfo and activityConfigInfo.tableInfoType or 0
    self:InitEggConfig(activityConfigId)
  end
  if not self.eggTipsData then
    self:InitEggTipsData()
  end
  if not self.mainAniEggData then
    self.mainAniEggData = ActEasterEggMainAniEggData.New()
  end
  EventManager:GetInstance():Broadcast(EventId.EasterEggGetActivityReceiveData)
end

function ActEasterEggManager:InitEggConfig(activityConfigId)
  self.eggConfig = nil
  local lineData = LocalController:instance():tryGetLine(TableName.ACTIVITY_EASTER_EGG, tonumber(activityConfigId))
  if not lineData then
    Logger.LogError("ActEasterEggManager:InitEggConfig error, id is nil,id = " .. activityConfigId)
    return
  end
  self.eggConfig = ActEasterEggTemplate.New()
  self.eggConfig:UpdateData(lineData)
end

function ActEasterEggManager:InitEggTipsData()
  self.eggTipsData = nil
  self.eggTipsData = ActEasterEggTipsData.New()
  self.eggTipsData:Init()
end

function ActEasterEggManager:GetEggConfigData()
  return self.eggConfig
end

function ActEasterEggManager:GetRandomQuestion(eggType)
  if self.eggTipsData then
    local questionInfo = self.eggTipsData:GetRandomQuestion(eggType)
    if questionInfo then
      return questionInfo.textKey
    end
  end
end

function ActEasterEggManager:GetDefaultQuestion(eggType)
  if self.eggTipsData then
    local questionInfo = self.eggTipsData:GetDefaultQuestion(eggType)
    if questionInfo then
      return questionInfo.textKey
    end
  end
end

function ActEasterEggManager:GetActivityData()
  return self.eggActInfo
end

function ActEasterEggManager:GetShowThumbsUpView()
  if self.eggActInfo then
    return self.eggActInfo.fromLastReceive:GetShowThumbsUpView()
  end
end

function ActEasterEggManager:StopPickUpTimer()
  if self.handlePickUpTimer then
    self.handlePickUpTimer:Stop()
    self.handlePickUpTimer = nil
  end
end

function ActEasterEggManager:SetIsPlayingHook(isPlaying)
  self.isPlayingHook = isPlaying
end

function ActEasterEggManager:OnRecPickUpEgg(message)
  if not message then
    Logger.LogError("message is nil")
    return
  end
  local isPlaying = self.isPlayingHook
  local errCode = message.errorCode
  if not isPlaying then
    EventManager:GetInstance():Broadcast(EventId.EasterEggChatHandlePickUpEggs)
    if errCode then
      UIUtil.ShowTipsId(errCode)
      EventManager:GetInstance():Broadcast(EventId.EasterEggGetActivityRefreshMainEggAni)
    else
      self:HandlePickUpMessage(message)
    end
  else
    self:StopPickUpTimer()
    self.handlePickUpTimer = TimerManager:GetInstance():GetTimer(0.1, function()
      if not self.isPlayingHook then
        EventManager:GetInstance():Broadcast(EventId.EasterEggChatHandlePickUpEggs)
        self:StopPickUpTimer()
        if errCode then
          UIUtil.ShowTipsId(errCode)
          EventManager:GetInstance():Broadcast(EventId.EasterEggGetActivityRefreshMainEggAni)
        else
          self:HandlePickUpMessage(message)
        end
      end
    end, self, false, false, false)
    self.handlePickUpTimer:Start()
  end
end

function ActEasterEggManager:HandlePickUpMessage(message)
  local pickedUpEggData = {}
  if self.eggActInfo then
    self.eggActInfo:UpdateTodayPickUpNum(message.pickUpNumLimit, message.pickUpNum)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
  pickedUpEggData.type = message.type
  if message.amazingEggInfo then
    local amazingEgg = ActEasterEggAmazingEggData.New()
    amazingEgg:ParseEggInfo(message.amazingEggInfo)
    pickedUpEggData.amazingEgg = amazingEgg
  end
  if message.eggInfo then
    local eggData = ActEasterEggData.New()
    message.eggInfo.pickUpNum = message.pickUpNum
    eggData:ParseEggInfo(message.eggInfo)
    pickedUpEggData.eggInfo = eggData
  end
  if pickedUpEggData.type == ActEasterEggType.Amazing then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActEasterAmazingEgg, {anim = false}, {
      eggInfo = pickedUpEggData.amazingEgg,
      openType = ActEasterAmazingEggOpenType.PickUpEgg
    })
  else
    if pickedUpEggData.eggInfo == nil then
      Logger.LogError("\229\164\141\230\180\187\232\138\130\226\128\148\226\128\148\226\128\148\226\128\148\230\141\158\229\190\151\230\153\174\233\128\154\232\180\180\229\173\144\232\155\139\230\178\161\230\156\137\230\149\176\230\141\174\239\188\129")
      return
    end
    local chatView = UIManager:GetInstance():GetWindow(UIWindowNames.LWUIActEasterEggChat)
    if chatView and chatView.View and chatView.View.rectTransform then
      chatView.View.rectTransform:SetAsLastSibling()
      chatView.View:RefreshByData(pickedUpEggData.eggInfo)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActEasterEggChat, {anim = false}, {
        eggInfo = pickedUpEggData.eggInfo
      })
    end
  end
end

function ActEasterEggManager:OnRecUpgradeEgg(message)
  if not message then
    return
  end
  local upgradeAmazingEggData = ActEasterEggUpgradeAmazingEggData.New()
  upgradeAmazingEggData:ParseUpgradeInfo(message)
  EventManager:GetInstance():Broadcast(EventId.EasterEggGetActivityUpgradeAmazingEgg, upgradeAmazingEggData)
end

function ActEasterEggManager:HandleUnpackedAmazingEgg()
  local eggInfo = self.eggActInfo:GetFirstUnpackedAmazingEgg()
  if not eggInfo then
    local amazingEggView = UIManager:GetInstance():GetWindow(UIWindowNames.LWUIActEasterAmazingEgg)
    if amazingEggView then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActEasterAmazingEgg)
      EventManager:GetInstance():Broadcast(EventId.EasterEggRefreshUnpackEggs)
    end
    return
  end
  local amazingEggView = UIManager:GetInstance():GetWindow(UIWindowNames.LWUIActEasterAmazingEgg)
  if amazingEggView then
    amazingEggView.View:InitEggByInfo(eggInfo, ActEasterAmazingEggOpenType.UnpackEggList)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActEasterAmazingEgg, {anim = false}, {
      eggInfo = eggInfo,
      openType = ActEasterAmazingEggOpenType.UnpackEggList
    })
  end
end

function ActEasterEggManager:DeleteUnpackedAmazingEgg(uuid)
  if string.IsNullOrEmpty(uuid) then
    Logger.LogError("uuid is nil,delete fail")
    return
  end
  self.eggActInfo:DeleteUnpackAmazingEgg(uuid)
end

function ActEasterEggManager:OnRecMyPostEggsData(message)
  if not self.myPostEggsInfo then
    self.myPostEggsInfo = ActEasterEggMyPostEggsData.New()
  end
  self.myPostEggsInfo:ParseMyPostEggInfo(message)
  EventManager:GetInstance():Broadcast(EventId.EasterEggGetActivityGetMyPostEggsInfo)
end

function ActEasterEggManager:OnRecMyCommentEggsData(message)
  if not self.myCommitEggsInfo then
    self.myCommitEggsInfo = ActEasterEggMyCommentData.New()
  end
  self.myCommitEggsInfo:ParseMyCommentInfo(message)
end

function ActEasterEggManager:ClearMyCommentEggsData()
  if self.myCommitEggsInfo then
    self.myCommitEggsInfo:ClearData()
  end
end

function ActEasterEggManager:GetMyPostEggsInfo()
  return self.myPostEggsInfo
end

function ActEasterEggManager:GetMyCommentEggsInfo()
  return self.myCommitEggsInfo
end

function ActEasterEggManager:DeleteEggInfo(type, delSuccessArr)
  local targetArr = {}
  if type == ActEasterMessageTab.Send then
    targetArr = self.eggArr
  elseif type == ActEasterMessageTab.Comment then
    targetArr = self.commentArr
  end
  local deleteKeys = {}
  for k, v in pairs(targetArr) do
    for m, n in pairs(delSuccessArr) do
      if n and n.eggUuid == v then
        table.insert(deleteKeys, k)
      end
    end
  end
  for k, v in pairs(deleteKeys) do
    table.remove(targetArr, v)
  end
end

function ActEasterEggManager:InitHasSeenEgg()
  self.hasSeenEggIndexList = {}
  local pointIndexStr = CommonUtil.PlayerPrefsGetString("ActEasterEggSeenList")
  if not string.IsNullOrEmpty(pointIndexStr) then
    local pointIndexList = string.split(pointIndexStr, ",")
    for k, v in pairs(pointIndexList) do
      table.insert(self.hasSeenEggIndexList, tonumber(v))
    end
  end
end

function ActEasterEggManager:GetHasSeenEgg(pointIndex)
  if not self.hasSeenEggIndexList then
    self:InitHasSeenEgg()
  end
  for k, v in pairs(self.hasSeenEggIndexList) do
    if v == pointIndex then
      return true
    end
  end
  return false
end

function ActEasterEggManager:RecordHasSeenEgg(pointIndex)
  if not self.hasSeenEggIndexList then
    self:InitHasSeenEgg()
  end
  table.insert(self.hasSeenEggIndexList, pointIndex)
  if #self.hasSeenEggIndexList >= maxRecordNum then
    table.remove(self.hasSeenEggIndexList, 1)
  end
  local pointIndexStr = ""
  for k, v in pairs(self.hasSeenEggIndexList) do
    pointIndexStr = pointIndexStr .. v .. ","
  end
  CommonUtil.PlayerPrefsSetString("ActEasterEggSeenList", pointIndexStr)
end

function ActEasterEggManager:GetMainAniEggData()
  return self.mainAniEggData
end

function ActEasterEggManager:OnRecDeleteMyEggs(t)
  if not t then
    Logger.LogError("OnRecDeleteMyEggs message is nil")
  end
  local type = t.type
  local delArr = t.delSuccessArr
  if type == ActEasterEggDeleteType.DeleteMyEggs then
    self.myPostEggsInfo:DeletePostEggs(delArr)
  elseif type == ActEasterEggDeleteType.DeleteMyComments then
    self.myCommitEggsInfo:DeleteMyCommentEggs(delArr)
  end
  EventManager:GetInstance():Broadcast(EventId.EasterEggGetActivityDeleteEggs)
end

function ActEasterEggManager:GetRedCount()
  local result = 0
  if 0 < DataCenter.ActEasterEggTaskManager:GetRedDotNum() then
    result = 1
  end
  return result
end

function ActEasterEggManager:GetThrowData()
  return self.throwData
end

function ActEasterEggManager:OnRecThrow(message)
  if not message then
    Logger.LogError("message is nil")
    return
  end
  if message.errorCode then
    UIUtil.ShowTips(Localization:GetString(message.errorCode), nil, nil, nil, nil, 445)
    local editView = UIManager:GetInstance():GetWindow(UIWindowNames.LWUIActEasterEggEditView)
    if editView then
      editView.View:SetThrowFalse()
    end
  else
    self.throwData = ActEasterEggThrowData.New()
    self.throwData:ParseThrowInfo(message)
    EventManager:GetInstance():Broadcast(EventId.EasterEggGetActivityEditThrow)
    if self.eggActInfo then
      self.eggActInfo:UpdateThrowNum(message.throwNum)
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    end
  end
end

function ActEasterEggManager:OnRecWorldEggPoint(message)
  if not message then
    Logger.LogError("message is nil")
    return
  end
  if message.flag and message.pointId then
    GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(message.pointId, ForceChangeScene.World))
    GoToUtil.CloseAllWindows()
  else
    UIUtil.ShowTipsId("activity_99144_7")
  end
end

function ActEasterEggManager:ReportEgg(createTime, reportUid, reportTypes, content, custom, eggUuid)
  local param = {}
  param.msgCreateTime = createTime
  param.reportUid = reportUid
  param.reportTypes = reportTypes
  param.content = content
  param.custom = custom
  param.eggUuid = eggUuid
  SFSNetwork.SendMessage(MsgDefines.EasterEggReport, param)
end

function ActEasterEggManager:SetChatEggInfo(eggInfo)
  self.chatEggInfo = eggInfo
end

function ActEasterEggManager:GetChatEggInfo()
  return self.chatEggInfo
end

function ActEasterEggManager:GetIsOnLikeDescendOrder()
  return CS.GameEntry.Setting:GetPrivateBool(SettingKeys.EASTER_EGG_LIKE_DESCEND_ORDER, false)
end

function ActEasterEggManager:SetIsOnLikeDescendOrder(state)
  CS.GameEntry.Setting:SetPrivateBool(SettingKeys.EASTER_EGG_LIKE_DESCEND_ORDER, state)
  EventManager:GetInstance():Broadcast(EventId.EasterEggChatChangeCommentLikeOrderState, state)
end

function ActEasterEggManager:GetIsOpenAutoTranslate()
  return self.isOpenAutoTranslate and self.eggConfig:GetOneKeyToTranslate()
end

function ActEasterEggManager:SetIsOpenAutoTranslate(state)
  self.isOpenAutoTranslate = state
  local key = self:GetAutoTranslateKey()
  CS.GameEntry.Setting:SetBool(key, state)
end

function ActEasterEggManager:GetIsAnonymousState()
  return self.eggActInfo.anonymousState
end

function ActEasterEggManager:SetIsAnonymousState(state)
  if not self.eggActInfo then
    return
  end
  self.eggActInfo:SetAnonymousState(state)
end

function ActEasterEggManager:GetCurAnonymousInfo()
  if not self.eggActInfo then
    return ""
  end
  return self.eggActInfo:GetCurAnonymousInfo()
end

function ActEasterEggManager:GetSendChatMsgTime()
  return self.sendChatMsgTime
end

function ActEasterEggManager:SetSendChatMsgTime(time)
  self.sendChatMsgTime = time
end

function ActEasterEggManager:SendEggChatThumbsUp_Comment(chatData)
  if not chatData or chatData.group ~= ChatGroupType.GROUP_EASTER_EGG_ROOM then
    return
  end
  if not InteractiveUtil.CanThumbsUp(InteractiveUtil.ThumbsUpType.EasterEggChat) then
    UIUtil.ShowTipsId("avatar_tips003")
    return
  end
  local extParam = string.format("%s|%s|%s|%s", tostring(ActEasterEggChatOpType.LikeCommenter), self.chatEggInfo:GetId(), tostring(chatData:getSeqId()), tostring(chatData:getEmojiCount(EmojiCommentsType.Up)))
  InteractiveUtil.TryThumbsUp(chatData:getSenderUid(), InteractiveUtil.ThumbsUpType.EasterEggChat, chatData:getSeqId(), function()
  end, extParam)
end

function ActEasterEggManager:SendEggChatThumbsUp_PostOrVote()
  if self.chatEggInfo:GetPosterUid() == LuaEntry.Player.uid then
    UIUtil.ShowTipsId("avatar_tips001")
    return
  end
  if not InteractiveUtil.CanThumbsUp(InteractiveUtil.ThumbsUpType.EasterEggChat) then
    UIUtil.ShowTipsId("avatar_tips003")
    return
  end
  if self.chatEggInfo:GetPraise() == 1 then
    UIUtil.ShowTipsId("activity_99144_9")
    return
  end
  local extParam = string.format("%s|%s|0|0", tostring(ActEasterEggChatOpType.LikePoster), self.chatEggInfo:GetId())
  InteractiveUtil.TryThumbsUp(self.chatEggInfo:GetPosterUid(), InteractiveUtil.ThumbsUpType.EasterEggChat, "", function()
  end, extParam)
  self.chatEggInfo:SetPraise(1)
  self.chatEggInfo:SetThumbsUp(self.chatEggInfo:GetThumbsUp() + 1)
  EventManager:GetInstance():Broadcast(ChatEventEnum.EasterEggChatClientFakeLikeNum)
end

local SHWO_GAMEPLAY_FALG_KEY = "ActEggEaster_UI_Gameplay_showFlag"

function ActEasterEggManager:CheckFirstEnterActivity()
  if self.showUIGamePlayFlag == nil then
    local key = SHWO_GAMEPLAY_FALG_KEY .. LuaEntry.Player.uid
    local flag = CommonUtil.PlayerPrefsGetBool(key, false)
    if flag == false then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActEasterEggRulesGamePlay, {anim = true})
      CommonUtil.PlayerPrefsSetBool(key, true)
    end
    self.showUIGamePlayFlag = true
  end
end

function ActEasterEggManager:AddorGetEggTranslateDatas(eggUuid, i, postContent, postLang)
  self.eggTranslateTextDic = self.eggTranslateTextDic or {}
  local transDataList = self.eggTranslateTextDic[eggUuid]
  if transDataList == nil then
    self.eggTranslateTextDic[eggUuid] = {}
  end
  if self.eggTranslateTextDic[eggUuid][i] == nil then
    self.eggTranslateTextDic[eggUuid][i] = ActEasterEggTranslateData.New()
  end
  local transData = self.eggTranslateTextDic[eggUuid][i]
  transData:SetIndex(i)
  transData:SetEggUuid(eggUuid)
  transData:SetSourceMsg(postContent)
  transData:SetSourceLang(postLang)
  return transData
end

function ActEasterEggManager:GetEggTranslateDatas(eggUuid, i)
  local transDataList = self.eggTranslateTextDic[eggUuid]
  if transDataList == nil then
    Logger.LogError("\232\142\183\229\143\150\229\189\147\229\137\141\232\155\139\231\154\132\231\191\187\232\175\145\231\188\147\229\173\152\228\184\186\231\169\186!")
    return
  end
  if self.eggTranslateTextDic[eggUuid][i] == nil then
    Logger.LogError("\232\142\183\229\143\150\229\189\147\229\137\141\232\155\139\231\154\132\231\191\187\232\175\145\231\188\147\229\173\152\228\184\186\231\169\186!index\228\184\186\239\188\154  " .. i)
    return
  end
  return self.eggTranslateTextDic[eggUuid][i]
end

function ActEasterEggManager:GetEggTranslateDataList(eggUuid)
  local transDataList = self.eggTranslateTextDic[eggUuid]
  if transDataList == nil then
    Logger.LogError("\232\142\183\229\143\150\229\189\147\229\137\141\232\155\139\231\154\132\231\191\187\232\175\145\231\188\147\229\173\152\228\184\186\231\169\186!")
    return
  end
  return transDataList
end

function ActEasterEggManager:CheckCanSendMsg()
  if self.chatEggInfo:GetEggType() == ActEasterEggType.Vote and self.chatEggInfo:GetMyVoteRes() == 0 then
    UIUtil.ShowTipsId("activity_99144_12")
    return
  end
  return true
end

function ActEasterEggManager:RequestVote(uuid, answer)
  if not self.eggActInfo then
    return
  end
  local param = {}
  param.activityId = self.eggActInfo.activityId
  param.eggUuid = uuid
  param.answer = answer
  SFSNetwork.SendMessage(MsgDefines.EasterEggSelect, param)
end

function ActEasterEggManager:UpdateVoteInfo(message)
  if not self.chatEggInfo then
    return
  end
  self.chatEggInfo:UpdateVoteInfo(message)
  EventManager:GetInstance():Broadcast(EventId.EasterEggChatOnVoteUpdate, true)
end

function ActEasterEggManager:OpenWorldEgg(uuid)
  if not self.eggActInfo or string.IsNullOrEmpty(uuid) then
    return
  end
  local param = {}
  param.activityId = self.eggActInfo.activityId
  param.eggUuid = tostring(uuid)
  SFSNetwork.SendMessage(MsgDefines.EasterOpenWorldEgg, param)
end

function ActEasterEggManager:OnRecOpenWorldEgg(message)
  if message.eggInfo then
    local eggData = ActEasterEggData.New()
    eggData:ParseEggInfo(message.eggInfo)
    local chatView = UIManager:GetInstance():GetWindow(UIWindowNames.LWUIActEasterEggChat)
    if chatView and chatView.View and chatView.View.rectTransform then
      chatView.View.rectTransform:SetAsLastSibling()
      chatView.View:RefreshByData(eggData)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActEasterEggChat, {anim = false}, {eggInfo = eggData})
    end
  end
end

function ActEasterEggManager:ViewEgg(uuid)
  if not self.eggActInfo or string.IsNullOrEmpty(uuid) then
    return
  end
  local param = {}
  param.activityId = self.eggActInfo.activityId
  param.eggUuid = tostring(uuid)
  SFSNetwork.SendMessage(MsgDefines.EasterEggView, param)
end

function ActEasterEggManager:OnRecViewEgg(message)
  if message.eggInfo then
    local eggData = ActEasterEggData.New()
    eggData:ParseEggInfo(message.eggInfo)
    local chatView = UIManager:GetInstance():GetWindow(UIWindowNames.LWUIActEasterEggChat)
    if chatView and chatView.View and chatView.View.rectTransform then
      chatView.View.rectTransform:SetAsLastSibling()
      chatView.View:RefreshByData(eggData)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActEasterEggChat, {anim = false}, {eggInfo = eggData})
    end
  end
end

function ActEasterEggManager:RequestRedDot()
  if not self.eggActInfo then
    return
  end
  local activityId = self.eggActInfo.activityId
  SFSNetwork.SendMessage(MsgDefines.EasterEggRedPoint, toInt(activityId))
end

function ActEasterEggManager:SetIsJumpTopLikeChatData(state)
  self.isJumpTopLikeChatData = state
end

function ActEasterEggManager:GetIsJumpTopLikeChatData()
  return self.isJumpTopLikeChatData
end

function ActEasterEggManager:ClearTopLikeChatData()
  self.topLikeChatData = nil
end

function ActEasterEggManager:GetTopLikeChatData()
  return self.topLikeChatData
end

function ActEasterEggManager:SetReadyForLikeDescendMsg(state)
  self.readyForLikeDescendMsg = state
end

function ActEasterEggManager:GetReadyForLikeDescendMsg()
  return self.readyForLikeDescendMsg
end

function ActEasterEggManager:SetReadyForFirstPart(state)
  self.readyForFirstPart = state
end

function ActEasterEggManager:GetReadyForFirstPart()
  return self.readyForFirstPart
end

function ActEasterEggManager:ParseAndAddChatDataToRoom(msgs)
  if msgs == nil then
    return
  end
  local userMgr = ChatManager2:GetInstance().User
  local roomData = ChatManager2:GetInstance().Room:GetEasterEggRoom()
  if roomData == nil then
    return
  end
  for i = 1, #msgs do
    local chatData = ChatManager2:GetInstance().Room:CreateChatMessage()
    chatData:onParseServerData(msgs[i])
    roomData:AddChatDataOnly(DeepCopy(chatData))
    local chatUserInfo = userMgr:getChatUserInfo(chatData.senderUid)
    if not chatUserInfo then
      userMgr:requestSingleUserInfo(chatData.senderUid)
    end
  end
  userMgr:SetRequestUserInfo(true)
  if self.readyForFirstPart and self.readyForLikeDescendMsg then
    EventManager:GetInstance():Broadcast(EventId.EasterEggChatInitComment)
  end
end

function ActEasterEggManager:GetTimeOrderData()
  local isLikeDescendOrder = DataCenter.ActEasterEggManager:GetIsOnLikeDescendOrder()
  if isLikeDescendOrder then
    return
  end
  local roomData = ChatManager2:GetInstance().Room:GetEasterEggRoom()
  local showChatDataList = roomData:GetMsgs()
  if self.topLikeChatData then
    roomData:AddChatDataOnly(self.topLikeChatData)
  end
  table.sort(showChatDataList, function(a, b)
    return a.serverTime < b.serverTime
  end)
  local isReachTop = roomData:GetOriginalFirstSeqId() == roomData:getFirstSeqId()
  if isReachTop then
    local maxLikeCount = 0
    local maxLikeChatDataIndex = 0
    for i, chatData in ipairs(showChatDataList) do
      local likeCount = chatData:getEmojiCount(EmojiCommentsType.Up)
      if maxLikeCount < likeCount then
        maxLikeCount = likeCount
        maxLikeChatDataIndex = i
      end
    end
    if maxLikeChatDataIndex ~= 0 then
      local tmpChatData = showChatDataList[maxLikeChatDataIndex]
      table.remove(showChatDataList, maxLikeChatDataIndex)
      table.insert(showChatDataList, 1, tmpChatData)
    end
    if showChatDataList[1] then
      local firstChatDataUpNum = showChatDataList[1]:getEmojiCount(EmojiCommentsType.Up)
      if 0 < firstChatDataUpNum and (self.topLikeChatData == nil or firstChatDataUpNum > self.topLikeChatData:getEmojiCount(EmojiCommentsType.Up)) then
        self.topLikeChatData = DeepCopy(showChatDataList[1])
        self.topLikeChatData.chatScrollItemType = ActEasterEggChatScrollItemType.Comment
      end
    end
  end
end

function ActEasterEggManager:GetLikeDescendOrderData()
  local isLikeDescendOrder = DataCenter.ActEasterEggManager:GetIsOnLikeDescendOrder()
  if not isLikeDescendOrder then
    return
  end
  local roomData = ChatManager2:GetInstance().Room:GetEasterEggRoom()
  local showChatDataList = roomData:GetMsgs()
  if self.topLikeChatData then
    roomData:AddChatDataOnly(self.topLikeChatData)
  end
  table.sort(showChatDataList, function(a, b)
    local likeCount_A = a:getEmojiCount(EmojiCommentsType.Up)
    local likeCount_B = b:getEmojiCount(EmojiCommentsType.Up)
    if likeCount_A ~= likeCount_B then
      return likeCount_A > likeCount_B
    end
    return a.serverTime < b.serverTime
  end)
  if showChatDataList[1] then
    local firstChatDataUpNum = showChatDataList[1]:getEmojiCount(EmojiCommentsType.Up)
    if 0 < firstChatDataUpNum and (self.topLikeChatData == nil or firstChatDataUpNum > self.topLikeChatData:getEmojiCount(EmojiCommentsType.Up)) then
      self.topLikeChatData = DeepCopy(showChatDataList[1])
      self.topLikeChatData.chatScrollItemType = ActEasterEggChatScrollItemType.Comment
    end
  end
end

function ActEasterEggManager:OnParseServerChatData_EasterEggChat(msgs)
  if msgs == nil or #msgs == 0 then
    return
  end
  local roomData = ChatManager2:GetInstance().Room:GetEasterEggRoom()
  if roomData == nil then
    return
  end
  local showChatDataList = roomData:GetMsgs()
  local tmpChatDataList = DeepCopy(showChatDataList) or {}
  if 1 < #tmpChatDataList then
    table.sort(tmpChatDataList, function(a, b)
      return a.serverTime < b.serverTime
    end)
    if self.topLikeChatData and (self.topLikeChatData:getSeqId() == tmpChatDataList[1]:getSeqId() and tmpChatDataList[1]:getSeqId() + 1 ~= tmpChatDataList[2]:getSeqId() or self.topLikeChatData:getSeqId() == tmpChatDataList[#tmpChatDataList]:getSeqId() and tmpChatDataList[#tmpChatDataList]:getSeqId() ~= tmpChatDataList[#tmpChatDataList - 1]:getSeqId() + 1) then
      self:RemoveChatDataBySeqId(tmpChatDataList, self.topLikeChatData:getSeqId())
    end
  end
  local curRoomFirstSeqId, curRoomLastSeqId
  if 0 < #tmpChatDataList then
    curRoomFirstSeqId = tmpChatDataList[1]:getSeqId()
    curRoomLastSeqId = tmpChatDataList[#tmpChatDataList]:getSeqId()
  end
  local firstMsgSeqId = msgs[1].seqId
  local lastMsgSeqId = msgs[#msgs].seqId
  if curRoomFirstSeqId and curRoomLastSeqId and curRoomFirstSeqId ~= firstMsgSeqId and curRoomFirstSeqId ~= lastMsgSeqId and curRoomLastSeqId ~= firstMsgSeqId and curRoomLastSeqId ~= lastMsgSeqId then
    return
  end
  local isRemovedTopLikeChatData = false
  if 1 < #showChatDataList then
    table.sort(showChatDataList, function(a, b)
      return a.serverTime < b.serverTime
    end)
    if self.topLikeChatData and (self.topLikeChatData:getSeqId() == showChatDataList[1]:getSeqId() and showChatDataList[1]:getSeqId() + 1 ~= showChatDataList[2]:getSeqId() or self.topLikeChatData:getSeqId() == showChatDataList[#showChatDataList]:getSeqId() and showChatDataList[#showChatDataList]:getSeqId() ~= showChatDataList[#showChatDataList - 1]:getSeqId() + 1) then
      isRemovedTopLikeChatData = true
      self:RemoveChatDataBySeqId(showChatDataList, self.topLikeChatData:getSeqId())
    end
  end
  local refreshType
  for i = 1, #msgs do
    local newchatData = ChatManager2:GetInstance().Room:CreateChatMessage()
    newchatData:onParseServerData(msgs[i])
    roomData:AddChatDataOnly(newchatData)
  end
  roomData:sort()
  local newFirstSeqId = roomData:getFirstSeqId()
  local newLastSeqId = roomData:GetLastMsgSeqId()
  if curRoomFirstSeqId and curRoomFirstSeqId ~= newFirstSeqId then
    refreshType = ActEasterEggChatRefreshType.HistoryMessage
  elseif curRoomLastSeqId and curRoomLastSeqId ~= newLastSeqId then
    refreshType = ActEasterEggChatRefreshType.NewMessage
  end
  if isRemovedTopLikeChatData and self.topLikeChatData then
    roomData:AddChatDataOnly(self.topLikeChatData)
  end
  if curRoomFirstSeqId == nil and curRoomLastSeqId == nil or curRoomFirstSeqId == newFirstSeqId and curRoomLastSeqId == newLastSeqId then
    refreshType = ActEasterEggChatRefreshType.OnlyOrderByTime
  end
  EventManager:GetInstance():Broadcast(EventId.EasterEggChatRefreshMsgsByTime, {refreshType = refreshType})
end

function ActEasterEggManager:GetTimeOrderDataByTimeRes()
  local isLikeDescendOrder = DataCenter.ActEasterEggManager:GetIsOnLikeDescendOrder()
  if isLikeDescendOrder then
    return
  end
  local roomData = ChatManager2:GetInstance().Room:GetEasterEggRoom()
  local showChatDataList = roomData:GetMsgs()
  table.sort(showChatDataList, function(a, b)
    return a.serverTime < b.serverTime
  end)
  local isReachTop = roomData:GetOriginalFirstSeqId() == roomData:getFirstSeqId()
  if isReachTop then
    if self.topLikeChatData then
      roomData:AddChatDataOnly(self.topLikeChatData, 1)
    end
    local maxLikeCount = 0
    local maxLikeChatDataIndex = 0
    for i, chatData in ipairs(showChatDataList) do
      local likeCount = chatData:getEmojiCount(EmojiCommentsType.Up)
      if maxLikeCount < likeCount then
        maxLikeCount = likeCount
        maxLikeChatDataIndex = i
      end
    end
    if maxLikeChatDataIndex ~= 0 then
      local tmpChatData = showChatDataList[maxLikeChatDataIndex]
      table.remove(showChatDataList, maxLikeChatDataIndex)
      table.insert(showChatDataList, 1, tmpChatData)
    end
    if showChatDataList[1] then
      local firstChatDataUpNum = showChatDataList[1]:getEmojiCount(EmojiCommentsType.Up)
      if 0 < firstChatDataUpNum and (self.topLikeChatData == nil or firstChatDataUpNum > self.topLikeChatData:getEmojiCount(EmojiCommentsType.Up)) then
        self.topLikeChatData = DeepCopy(showChatDataList[1])
        self.topLikeChatData.chatScrollItemType = ActEasterEggChatScrollItemType.Comment
      end
    end
  end
end

function ActEasterEggManager:ParseReceiveChatData(chatData)
  local userMgr = ChatManager2:GetInstance().User
  local chatUserInfo = userMgr:getChatUserInfo(chatData.senderUid)
  if not chatUserInfo then
    userMgr:requestSingleUserInfo(chatData.senderUid)
  end
  local roomData = ChatManager2:GetInstance().Room:GetEasterEggRoom()
  if roomData == nil then
    return
  end
  local roomMsgs = roomData:GetMsgs()
  local isLikeDescendOrder = DataCenter.ActEasterEggManager:GetIsOnLikeDescendOrder()
  if 0 < #roomMsgs and isLikeDescendOrder and chatData:getSenderUid() == LuaEntry.Player.uid then
    DataCenter.ActEasterEggManager:SetIsOnLikeDescendOrder(false)
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomGoto, chatData:getRoomId(), chatData:getSeqId(), 2)
    return
  end
  local roomLastSeqId = roomData:getRoomLastSeqId()
  if roomLastSeqId == -1 or roomData:isExistSeqId(roomLastSeqId) then
    roomData:AddChatDataOnly(chatData)
    EventManager:GetInstance():Broadcast(EventId.EasterEggChatReceiveOneData, chatData)
  elseif chatData:getSenderUid() == LuaEntry.Player.uid then
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomGoto, chatData:getRoomId(), chatData:getSeqId(), 2)
  end
  if roomLastSeqId < chatData:getSeqId() then
    roomData:setRoomLastSeqId(chatData:getSeqId())
    roomData:SetLastChatTime(chatData:getServerTime())
  else
    Logger.LogError("\229\164\141\230\180\187\232\138\130\226\128\148\226\128\148\226\128\148\226\128\148\232\167\163\230\158\144\230\156\128\230\150\176\231\154\132\229\141\149\230\157\161\230\182\136\230\129\175\230\151\182\239\188\140\232\175\165\230\182\136\230\129\175seqId\230\175\148\230\136\191\233\151\180lastSeqId \232\166\129\229\176\143\239\188\129")
  end
end

function ActEasterEggManager:ClearRoomAndParseChatDataToRoom(msgs, anchorSeqId)
  if msgs == nil then
    return
  end
  local userMgr = ChatManager2:GetInstance().User
  local roomData = ChatManager2:GetInstance().Room:GetEasterEggRoom()
  if roomData == nil then
    return
  end
  roomData:SetMsgs({})
  for i = 1, #msgs do
    local chatData = ChatManager2:GetInstance().Room:CreateChatMessage()
    chatData:onParseServerData(msgs[i])
    roomData:AddChatDataOnly(DeepCopy(chatData))
    local chatUserInfo = userMgr:getChatUserInfo(chatData.senderUid)
    if not chatUserInfo then
      userMgr:requestSingleUserInfo(chatData.senderUid)
    end
  end
  roomData:sort()
  userMgr:SetRequestUserInfo(true)
  local refreshType
  local roomMsgs = roomData:GetMsgs()
  if anchorSeqId == roomMsgs[1]:getSeqId() then
    refreshType = ActEasterEggChatRefreshType.NewMessage
  elseif anchorSeqId == roomMsgs[#roomMsgs]:getSeqId() then
    refreshType = ActEasterEggChatRefreshType.HistoryMessage
  end
  EventManager:GetInstance():Broadcast(EventId.EasterEggChatRefreshGoToMsg, {refreshType = refreshType})
end

function ActEasterEggManager:SetChatDatqaListToRoomData(chatDataList)
  local roomData = ChatManager2:GetInstance().Room:GetEasterEggRoom()
  local msgs = {}
  for i = 1, #chatDataList do
    table.insert(msgs, DeepCopy(chatDataList[i]))
  end
  roomData:SetMsgs(msgs)
end

function ActEasterEggManager:GetJumpTimeOrderData()
  local roomData = ChatManager2:GetInstance().Room:GetEasterEggRoom()
  local showChatDataList = roomData:GetMsgs()
  table.sort(showChatDataList, function(a, b)
    return a.serverTime < b.serverTime
  end)
  local isReachTop = roomData:GetOriginalFirstSeqId() == roomData:getFirstSeqId()
  if isReachTop and self.topLikeChatData then
    for i, chatData in ipairs(showChatDataList) do
      if chatData:getSeqId() == self.topLikeChatData:getSeqId() then
        table.remove(showChatDataList, i)
        break
      end
    end
    table.insert(showChatDataList, 1, self.topLikeChatData)
  end
end

function ActEasterEggManager:IsReachTopChatData()
  local roomData = ChatManager2:GetInstance().Room:GetEasterEggRoom()
  local showChatDataList = roomData:GetMsgs()
  if #showChatDataList == 0 then
    return true
  end
  local originalFirstSeqId = roomData:GetOriginalFirstSeqId()
  if originalFirstSeqId == showChatDataList[1]:getSeqId() or originalFirstSeqId == showChatDataList[2]:getSeqId() then
    return true
  end
  return false
end

function ActEasterEggManager:IsReachBottomChatData()
  local roomData = ChatManager2:GetInstance().Room:GetEasterEggRoom()
  local showChatDataList = roomData:GetMsgs()
  if #showChatDataList == 0 then
    return true
  end
  local roomLastSeqId = roomData:getRoomLastSeqId()
  local roomMsgs = roomData:GetMsgs()
  if roomLastSeqId == roomMsgs[#roomMsgs]:getSeqId() then
    return true
  end
  return false
end

function ActEasterEggManager:RemoveChatDataBySeqId(chatDataList, seqId)
  for i = 1, #chatDataList do
    local chatData = chatDataList[i]
    if chatData and chatData:getSeqId() == seqId then
      table.remove(chatDataList, i)
      return
    end
  end
end

function ActEasterEggManager:GoToTask()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActEasterEggTask)
end

function ActEasterEggManager:GetTranslateName(anonymousName)
  if string.IsNullOrEmpty(anonymousName) then
    return ""
  end
  local nameList = string.split(anonymousName, "#")
  local adj = ""
  local nameLocal = ""
  if not string.IsNullOrEmpty(nameList[1]) then
    adj = Localization:GetString(nameList[1])
  end
  if not string.IsNullOrEmpty(nameList[2]) then
    nameLocal = Localization:GetString(nameList[2])
  end
  local num = nameList[3] or ""
  return adj .. nameLocal .. num
end

function ActEasterEggManager:GetAutoTranslateKey()
  return "AcrEasterEggAutoTranslate_" .. LuaEntry.Player.uid
end

ActEasterEggManager.__init = __init
ActEasterEggManager.__delete = __delete
ActEasterEggManager.AddListener = AddListener
ActEasterEggManager.RemoveListener = RemoveListener
return ActEasterEggManager
