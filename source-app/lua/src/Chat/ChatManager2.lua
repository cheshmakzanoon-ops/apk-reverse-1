local ChatManager2 = BaseClass("ChatManager2", Singleton)
local ChatViewController = require("UI.UIChatNew.Controller.ChatViewUtils")
local Localization = CS.GameEntry.Localization
local reportCd = 60000
local reportLimit = 10
local CHAT_NONE = 0
local CHAT_DB = 1
local CHAT_NET = 2
local CHAT_OK = 3
local CHAT_ERROR = -1
local WAIT_GAME_SERVER = 4
local EMOJI_COMMENTS_KEY = "EMOJI_COMMENTS_KEY"
local CommentsClickCounter = {}

function ChatManager2:__init()
  self.cur_gameuid = ""
  self.status = CHAT_NONE
  self.DB = require("Chat.Controller.ChatDBManager").New()
  self.Net = require("Chat.Controller.ChatNetManager").New()
  self.Room = require("Chat.Controller.ChatRoomManager").New()
  self.Voice = require("Chat.Controller.VoiceRoomManager").New()
  self.User = require("Chat.Controller.UserManager").New()
  self.Translate = require("Chat.Controller.TranslateManager").New()
  self.Restrict = require("Chat.Controller.ChatRestrictManager").New()
  self.Filter = require("Chat.Controller.FilterWordsManager").New()
  self.Ctrl = require("Chat.Controller.ChatController").New()
  self.Moment = require("Chat.Controller.ChatMomentManager").New()
  self.Util = require("Chat.Controller.ChatUtil").New()
  self.GroupChat = require("Chat.Controller.ChatGroupChatManager").New()
  self.Sound = require("Chat.Controller.ChatSoundManager").New()
end

function ChatManager2:onDatabaseOK(status, reason)
  if status == "ok" then
    self.status = CHAT_DB
  end
end

function ChatManager2:Init(gameuid)
  self:Uninit()
  self.cur_gameuid = gameuid
  self.reportedChatDic = {}
  self:InitReportData()
  self.User:resetData()
  self.Ctrl:Init()
  self.Net:Init(gameuid)
  CS.DynamicResourceManager.Instance:DeleteCacheCompressedPhotoFolder()
  self.Room:StartMemoryReport()
end

function ChatManager2:Uninit()
  if self.Voice then
    self.Voice:UnbindCallbacks()
  end
  if self.Net then
    self.Net:Uninit()
  end
  if self.Room then
    self.Room:StopMemoryReport()
  end
end

function ChatManager2:SetGiveLikeMsgTime(type, index)
  local timeStamp = self.Room:getChatServerTime()
  self.Restrict:SetGiveLikeMsgTime(type, index, timeStamp)
end

function ChatManager2:GetGiveLikeMsgTime(type, index)
  local timeStamp = self.Restrict:GetGiveLikeMsgTime(type, index)
  if not timeStamp then
    if type and not index then
      Logger.LogError(" not linkeMsg" .. type)
    end
    return 0
  end
  local time = self.Room:getChatServerTime()
  local delta = timeStamp - time
  return delta
end

function ChatManager2:SetGiveLikeAnim(type, num)
  self.Restrict:SetGiveLikeAnim(type, num)
end

function ChatManager2:GetGiveLikeAnim(type)
  return self.Restrict:GetGiveLikeAnim(type)
end

function ChatManager2:IsInitOK()
  if self.status == CHAT_OK then
    return true
  end
  return false
end

function ChatManager2:onUserLoginSuccess(serverData)
  local roomManager = self.Room
  local isGameServerRoomIdEnabled = ChatInterface.isGameServerRoomIdEnabled()
  local tempClientId = serverData.server .. serverData.clientid
  ChatPrint("ClientId = %s, Uid = %s", tempClientId, serverData.data.uid)
  roomManager:resetData()
  roomManager:ClearRooms()
  roomManager:UpdateChatServerTime(math.floor(serverData.serverTime / 1000))
  DataCenter.ChatPrivateDataManager:ResetForReInit()
  self.User:SetRequestUserInfo(false)
  self.clientId = tempClientId
  self.cur_gameuid = serverData.data.uid
  self.serverData = serverData
  if not roomManager:GetGameServerRoomList() and isGameServerRoomIdEnabled then
    self.status = WAIT_GAME_SERVER
    return
  else
    self:StartChatSession()
  end
  ChatPrint("onUserLoginSuccess ok")
end

function ChatManager2:TryInitRoomAfterGameServerReady()
  if self.status == WAIT_GAME_SERVER and self.Net:IsRunning() then
    self:StartChatSession()
    self.status = CHAT_OK
    return true
  end
  return false
end

function ChatManager2:StartChatSession()
  local roomManager = self.Room
  roomManager:Init()
  self.status = CHAT_OK
  local Net = ChatManager2:GetInstance().Net
  ChatManager2:GetInstance().Room:ResetRoomFlag()
  Net:SendMessage(ChatMsgDefines.UserSetInfo, ChatInterface.getLastUpdateTime())
  Net:SendMessage(ChatMsgDefines.SetSwitchFlag)
  Net:SendMessage(ChatMsgDefines.GetCustomRoomListV2)
  Net:SendMessage(ChatMsgDefines.RoomJoinMulti)
  self:RequestChatAtInfo()
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_LOGIN_SUCCESS)
  ChatInterface.getMoment():InitMomentRedDot()
end

function ChatManager2:onErrorOrDisconnect()
  self:SetConnectionError(true)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ERROR_OR_DISCONNECT)
  __ChatPostBI(ChatBIEnum.CHAT_SERVER_DISCONNECT)
end

function ChatManager2:SetConnectionError(isOn)
  self.netError = isOn
end

function ChatManager2:GetConnectionError()
  return self.netError
end

function ChatManager2:__sendToPrivateNoRoom(uid, msg, extra)
  local RoomManager = self.Room
  local t = RoomManager:getTempPersonMsg(uid)
  if t == nil then
    local myUid = ChatInterface.getPlayerUid()
    local tbl = {}
    tbl.type = 1
    tbl.name = "PRIVATE_" .. tostring(myUid) .. "_to_" .. tostring(uid)
    tbl.memberList = {myUid, uid}
    if uid == ChatGMUserId then
      tbl.type = 3
      for i = 1, ChatGMUserCnt do
        tbl.memberList[#tbl.memberList + 1] = tostring(tonumber(ChatGMUserId) + i)
      end
    end
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_CREATE_COMMAND, tbl)
  end
  RoomManager:addTempPersonMsg(uid, msg, extra)
end

function ChatManager2:__sendToRoom(roomId, msg, extra, reply, isProxy, post)
  local RoomManager = self.Room
  local roomData = RoomManager:GetRoomData(roomId)
  local userMgr = ChatManager2:GetInstance().User
  if not roomData then
    return
  end
  local playerUid = ChatInterface.getPlayerUid()
  if string.IsNullOrEmpty(playerUid) then
    ChatPrint("OnChatSendMsg  playerUid is null!!!!!!")
    return
  end
  local serverTime = RoomManager:getChatServerTime()
  local chatTabData = {
    sender = playerUid,
    group = roomData.group,
    serverTime = serverTime,
    roomId = roomId,
    msg = msg,
    sendTime = serverTime,
    senderLevel = DataCenter.BuildManager.MainLv,
    extra = extra,
    reply = reply,
    post = post,
    isLocal = true,
    timeline = extra and extra.timeline or nil
  }
  local chatData = RoomManager:CreateChatMessage()
  chatData:onParseServerData(chatTabData)
  chatData:setSeqId(-1)
  chatData:setSendState(SendStateType.PENDING)
  chatData.isProxy = isProxy or 1
  local allianceRoomId = ChatInterface.getRoomMgr():GetAllianceRoomId()
  local countryRoomId = ChatInterface.getRoomMgr():GetCountryRoomId()
  if roomId == allianceRoomId then
    SFSNetwork.SendMessage(MsgDefines.UserChatStat, 2, chatData)
  elseif roomId == countryRoomId then
    SFSNetwork.SendMessage(MsgDefines.UserChatStat, 3, chatData)
  else
    SFSNetwork.SendMessage(MsgDefines.UserChatStat, 1, chatData)
  end
  if extra and extra.post == PostType.Chat_Moment then
    local uid = ChatManager2:GetInstance().Room:GetFriendsCirclePlayerUid(chatData.roomId, ChatGroupType.GROUP_FRIENDS_CIRCLE_COMMENT_ROOM)
    SFSNetwork.SendMessage(MsgDefines.SendFriendsCircleComment, uid, chatData, reply)
  else
    self.Net:SendMessage(ChatMsgDefines.ChatRoom, chatData)
  end
end

function ChatManager2:PushMessageReply(chatData)
  if not chatData or not chatData.roomId then
    return
  end
  local room = ChatInterface.getRoomData(chatData.roomId)
  if room and room:isPrivateChat() then
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.ChatRecv, chatData.roomId, chatData.seqId)
  end
end

function ChatManager2:SendChatMsg(msgTable)
  local roomId = msgTable.roomId
  local msg = msgTable.msg
  local extra = msgTable.extra
  local reply = msgTable.reply
  local post = msgTable.post
  local isProxy = msgTable.isProxy
  if string.IsNullOrEmpty(msg) and not ChatInterface.getMoment():GetIsMomentBody(post) then
    return
  end
  local roomData = ChatManager2:GetInstance().Room:GetRoomData(roomId)
  if roomData and #roomData.msgs == 0 and string.IsNullOrEmpty(roomData.owner) and roomData and roomData.category == ChatRoomCategory.PRIVATE then
    local member = roomData:getPrivateOtherMember()
    if member and member.uid then
      self:__sendToPrivateNoRoom(member.uid, msg, extra)
      return
    end
  end
  self:__sendToRoom(roomId, msg, extra, reply, isProxy, post)
  return
end

function ChatManager2:SendChatUpMsg(msgTable)
  local roomId = msgTable.roomId
  local RoomManager = self.Room
  local roomData = RoomManager:GetRoomData(roomId)
  if not roomData then
    roomData = ChatInterface.getMoment():GetMomentRoomData(roomId)
    if not roomData then
      return
    end
  end
  local playerUid = ChatInterface.getPlayerUid()
  if string.IsNullOrEmpty(playerUid) then
    ChatPrint("OnChatSendMsg  playerUid is null!!!!!!")
    return
  end
  local serverTime = RoomManager:getChatServerTime()
  local chatTabData = {
    sender = playerUid,
    group = roomData.group,
    serverTime = serverTime,
    roomId = roomId,
    sendTime = serverTime,
    msgSeq = msgTable.msgSeq,
    emoji = msgTable.emoji,
    interactLike = msgTable.interactLike,
    interactDislike = msgTable.interactDislike
  }
  self.Net:SendMessage(ChatMsgDefines.ChatUpRoom, chatTabData)
end

function ChatManager2:SendEasterChatMsg(msgTable)
  local roomId = msgTable.roomId
  local msg = msgTable.msg
  local extra = msgTable.extra
  local reply = msgTable.reply
  local post = msgTable.post
  local isProxy = msgTable.isProxy
  local RoomManager = self.Room
  local roomData = RoomManager:GetRoomData(roomId)
  if not roomData then
    return
  end
  local playerUid = ChatInterface.getPlayerUid()
  if string.IsNullOrEmpty(playerUid) then
    ChatPrint("OnChatSendMsg  playerUid is null!!!!!!")
    return
  end
  local serverTime = RoomManager:getChatServerTime()
  local chatTabData = {
    sender = playerUid,
    group = roomData.group,
    serverTime = serverTime,
    roomId = roomId,
    msg = msg,
    sendTime = serverTime,
    senderLevel = DataCenter.BuildManager.MainLv,
    extra = extra,
    reply = reply,
    post = post
  }
  local chatData = RoomManager:CreateChatMessage()
  chatData:onParseServerData(chatTabData)
  chatData:setSeqId(-1)
  chatData.isProxy = isProxy or 1
  if extra and extra.post ~= PostType.EasterEggChat then
    Logger.LogError("\229\164\141\230\180\187\232\138\130\226\128\148\226\128\148\226\128\148\226\128\148\232\175\165\229\135\189\230\149\176\228\187\133\233\153\144\228\186\142\229\164\141\230\180\187\232\138\130\229\143\145\233\128\129\230\182\136\230\129\175\239\188\140\232\175\183\230\163\128\230\159\165\239\188\129")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.EasterChatSendComment, chatData)
end

function ChatManager2:SendEmojiComments(seqId, index, roomId, senderUid, skipCheck, upType)
  upType = upType or InteractiveUtil.ThumbsUpType.ChatMessage
  if senderUid == LuaEntry.Player.uid then
    UIUtil.ShowTipsId("avatar_tips001")
    return
  end
  local chatData = self.Room:GetChat(roomId, seqId)
  local name = string.format("%s_%s_%s", senderUid, seqId, index)
  
  local function sendEmoji(onlyRecord)
    if not CommentsClickCounter[name] then
      CommentsClickCounter[name] = {
        seqId = seqId,
        index = index,
        roomId = roomId,
        senderUid = senderUid,
        count = 0
      }
    end
    CommentsClickCounter[name].count = CommentsClickCounter[name].count + 1
    if onlyRecord then
      return
    end
    if not chatData then
      chatData = ChatInterface.getMoment():GetMomentChatData(roomId, seqId)
    end
    if chatData then
      chatData:changeEmojiState(index)
      EventManager:GetInstance():Broadcast(ChatEventEnum.UPDATE_USER_MSG, chatData)
    end
    self:EmojiComments(seqId, index, roomId, chatData, senderUid)
  end
  
  if skipCheck then
    sendEmoji()
    return
  end
  if chatData and index == EmojiCommentsType.Up and chatData:isPlayerFollowEmoji(index) then
    sendEmoji()
    return
  end
  self:CheckThumbsUp(index, senderUid, seqId, sendEmoji, upType)
end

function ChatManager2:CheckThumbsUp(index, senderUid, seqId, callback, upType)
  if index ~= EmojiCommentsType.Up then
    callback()
    return
  end
  local name = string.format("%s_%s_%s", senderUid, seqId, index)
  self.commentsHistory = self.commentsHistory or {}
  if self.commentsHistory[name] then
    callback()
    return
  end
  if not InteractiveUtil.CanThumbsUp(InteractiveUtil.ThumbsUpType.ChatMessage) then
    UIUtil.ShowTipsId("avatar_tips003")
    return
  end
  self.commentsHistory[name] = true
  callback()
  InteractiveUtil.TryThumbsUp(senderUid, upType, seqId, function()
  end)
end

function ChatManager2:EmojiComments()
  if self.delaySend then
    return
  end
  self.delaySend = TimerManager:GetInstance():DelayInvoke(function()
    for _, v in pairs(CommentsClickCounter) do
      if v.count % 2 ~= 0 then
        local chatData = self.Room:GetChat(v.roomId, v.seqId)
        chatData = chatData or ChatInterface.getMoment():GetMomentChatData(v.roomId, v.seqId)
        if chatData then
          chatData:cacheEmojiState(v.index)
        end
        self:MessageUpCommand(v.seqId, v.index, v.roomId)
      end
    end
    CommentsClickCounter = {}
    self.delaySend = nil
  end, 1)
end

function ChatManager2:MessageUpCommand(seqId, index, roomId)
  local msgTable = {
    roomId = roomId,
    msgSeq = seqId,
    emoji = index
  }
  if string.IsNullOrEmpty(roomId) or ChatViewController:GetInstance():IsTmpPrivateChat(roomId) or roomId == ChatGMRoomId then
    local tui = ChatViewController:GetInstance():GetPrivateUserInfo()
    if tui == nil then
      return
    end
    msgTable.toUid = tui.uid
  end
  ChatManager2:GetInstance():SetGiveLikeMsgTime(seqId, index)
  ChatManager2:GetInstance():SetGiveLikeAnim(seqId, 1)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SEND_ROOM_MSG_UP_COMMAND, msgTable)
end

function ChatManager2:SendEmojiComments_EasterEgg(seqId, index, roomId, senderUid)
  if senderUid == LuaEntry.Player.uid then
    UIUtil.ShowTipsId("avatar_tips001")
    return
  end
  if not InteractiveUtil.CanThumbsUp(InteractiveUtil.ThumbsUpType.EasterEggChat) then
    UIUtil.ShowTipsId("avatar_tips003")
    return
  end
  local chatData = self.Room:GetChat(roomId, seqId)
  if chatData then
    chatData:changeEmojiState(index)
    chatData:cacheEmojiState(index)
    EventManager:GetInstance():Broadcast(ChatEventEnum.UPDATE_USER_MSG, chatData)
  end
  self:MessageUpCommand(seqId, index, roomId)
end

function ChatManager2:OnHandleMessage(cmd, t)
  if self.Net then
    return self.Net:OnHandleMessage(cmd, t)
  end
  return false
end

function ChatManager2:OnReportSucceed(uid)
  UIUtil.ShowMessage(Localization:GetString("block_guide_after_report"), 2, "290007", "", function()
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_BLOCK_COMMAND, uid)
  end, nil, nil, "290007")
end

function ChatManager2:ReportChat(chatData, type, reportType, extraNote)
  self:SetAsReported(chatData)
  self:CacheReportTime()
  local reportUid = chatData.senderUid
  local content = chatData.msg
  local msgCreateTime = chatData:getServerTime()
  self:ReqReportChat(reportUid, content, type, reportType, chatData, msgCreateTime, extraNote)
end

function ChatManager2:ReqReportChat(reportUid, content, type, reportType, extraData, msgCreateTime, extraNote)
  SFSNetwork.SendMessage(MsgDefines.ReportChat, reportUid, content, type, reportType, extraData, msgCreateTime, extraNote)
end

function ChatManager2:CacheReportTime()
  self.reportTimes = self.reportTimes or {}
  local now = UITimeManager:GetInstance():GetServerTime()
  table.insert(self.reportTimes, now)
end

function ChatManager2:ReportData(param)
  self:CacheReportTime()
  SFSNetwork.SendMessage(MsgDefines.ReportChat, param.playerUid, param.msg, param.type, param.reportTypeList, param.extraData, nil, param.extraNote)
end

function ChatManager2:InitReportData()
  self.reportedChatDic = {}
  local strK = LuaEntry.Player.uid .. "_ChatReport"
  local reported = CS.GameEntry.Setting:GetString(strK, "")
  if not string.IsNullOrEmpty(reported) then
    local arr = string.split(reported, ";")
    for i, v in pairs(arr) do
      if not string.IsNullOrEmpty(v) then
        self.reportedChatDic[v] = 1
      end
    end
  end
end

function ChatManager2:SetAsReported(chatData)
  local uid = chatData.senderUid .. "_" .. chatData:getServerTime()
  self.reportedChatDic[uid] = 1
  local strK = LuaEntry.Player.uid .. "_ChatReport"
  local reported = CS.GameEntry.Setting:GetString(strK, "")
  CS.GameEntry.Setting:SetString(strK, uid .. ";" .. reported)
end

function ChatManager2:CleanOldReports(now)
  if not self.reportTimes then
    return
  end
  local newList = {}
  for i = 1, #self.reportTimes do
    local t = self.reportTimes[i]
    if now - t <= reportCd then
      table.insert(newList, t)
    end
  end
  self.reportTimes = newList
end

function ChatManager2:CheckReportTime()
  if not self.reportTimes then
    return true
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  self:CleanOldReports(now)
  if #self.reportTimes >= reportLimit then
    return false
  end
  return true
end

function ChatManager2:CheckIfReported(chatData)
  local uid = chatData.senderUid .. "_" .. chatData:getServerTime()
  return self.reportedChatDic[uid]
end

function ChatManager2:CheckMainLvEnough()
  return true
end

function ChatManager2:IsStrEmoji(str)
  if string.IsNullOrEmpty(str) then
    return false
  end
  if string.startswith(str, "<lwEmoji:") and string.endswith(str, ":>") then
    return true
  else
    return false
  end
end

function ChatManager2:IsSticker(postType)
  return postType == PostType.Chat_Stickers
end

function ChatManager2:SendPicToPrivateNeedLv()
  return 20
end

function ChatManager2:IsActivePhotoAlbum(roomGroup)
  local isPass = false
  local tipStr = ""
  if roomGroup == ChatGroupType.GROUP_CUSTOM or roomGroup == ChatGroupType.GROUP_CUSTOM_GROUP then
    local mainLv = DataCenter.BuildManager.MainLv
    local limitLevel = self:SendPicToPrivateNeedLv()
    local isLvPass = mainLv >= limitLevel
    if not isLvPass then
      tipStr = Localization:GetString("picture_send_private_tips", limitLevel)
    end
    isPass = isLvPass
  else
    local curLevel = DataCenter.AllianceGiftDataManager:GetCurLevel() or 0
    local limitLevel = LuaEntry.DataConfig:TryGetNum("alliance_pic_send_config", "k1")
    local isLvPass = curLevel >= limitLevel
    if not isLvPass then
      tipStr = Localization:GetString("alliance_album_lock_notice", limitLevel)
    end
    isPass = isLvPass
  end
  return isPass, tipStr
end

function ChatManager2:SendMessage_ChatPhoto(msg, postType, picVer, smallHeight, smallWidth, bigHeight, bigWidth)
  local targetRoomId = LuaEntry.GlobalData.targetRoomId
  if targetRoomId == -1 then
    Logger.LogError("\229\143\145\233\128\129\229\155\190\231\137\135\230\151\182\239\188\140\229\189\147\229\137\141\233\128\137\228\184\173\231\154\132\230\136\191\233\151\180Id\228\184\186\231\169\186")
    return
  end
  local levelLimit = LuaEntry.DataConfig:TryGetNum("chat_level", "k1")
  local mainLv = DataCenter.BuildManager.MainLv
  if levelLimit > mainLv then
    UIUtil.ShowTipsId(457538)
    return
  end
  local cmdTbl = {
    roomId = targetRoomId,
    msg = msg,
    isProxy = 0
  }
  if postType then
    cmdTbl.extra = {
      post = postType,
      smallHeight = smallHeight,
      smallWidth = smallWidth,
      bigHeight = bigHeight,
      bigWidth = bigWidth,
      picVer = picVer
    }
  end
  local userInfoUid = LuaEntry.GlobalData.targetUserInfoUid
  if userInfoUid ~= -1 then
    cmdTbl.toUid = userInfoUid
  end
  self:SyncMessageToServer(cmdTbl, cmdTbl.roomId)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SEND_ROOM_MSG_COMMAND, cmdTbl)
end

function ChatManager2:SyncMessageToServer(cmdTbl, roomId)
  if cmdTbl == nil or roomId == nil then
    return
  end
  if cmdTbl.msg == nil then
    return
  end
  local msg = cmdTbl.msg
  local currRoom = self.Room:GetRoomData(roomId)
  if currRoom == nil then
    return
  end
  local userInfo = currRoom:getPrivateOtherMember()
  local isAtAll = cmdTbl.extra and cmdTbl.extra.atAll or false
  if ChatInterface.IsCanAtRoomGroup(currRoom.group) and cmdTbl.extra and not table.IsNullOrEmpty(cmdTbl.extra.atUids) then
    local send = true
    local check = {}
    local res = {}
    for _, v in ipairs(cmdTbl.extra.atUids) do
      if not check[v] then
        res[#res + 1] = v
        check[v] = true
      end
    end
    if isAtAll then
      local count = currRoom.atAllCount or 0
      if count <= 0 then
        send = false
      end
    end
    if send then
      SFSNetwork.SendMessage(MsgDefines.LWUserPushChatMsg, nil, msg, roomId, 4100044, res, isAtAll)
    end
  elseif currRoom.group == ChatGroupType.GROUP_CUSTOM_GROUP then
    SFSNetwork.SendMessage(MsgDefines.LWUserPushChatMsg, nil, msg, roomId, 4100045, nil, isAtAll)
  elseif userInfo then
    SFSNetwork.SendMessage(MsgDefines.LWUserPushChatMsg, userInfo and userInfo.uid or "", msg, roomId)
  elseif currRoom.group == ChatGroupType.GROUP_ALLIANCE_MANAGER then
    SFSNetwork.SendMessage(MsgDefines.LWUserPushChatMsg, userInfo and userInfo.uid or "", msg, roomId)
  end
end

function ChatManager2:CanNotPickRedPacket(extraJson)
  if extraJson == nil then
    return false
  end
  if extraJson.campId and extraJson.campId > 0 then
    return extraJson.campId ~= DataCenter.ZoneWarManager:GetServerCampIndex(LuaEntry.Player:GetSourceServerId())
  end
  return extraJson.banServerId == LuaEntry.Player:GetSourceServerId()
end

function ChatManager2:GetReplyMsgByChatMsg(chatMsg)
  local replyMsg = ""
  if chatMsg then
    replyMsg = chatMsg.msg or ""
    if chatMsg.post then
      if chatMsg.post == PostType.Chat_SendPhoto then
        replyMsg = Localization:GetString("picture_msg_preview")
      elseif chatMsg.post == PostType.NewsCenterLink then
        replyMsg = "[" .. Localization:GetString("news_center_share_default") .. "]"
      end
    end
  end
  return replyMsg
end

function ChatManager2:RequestChatAtInfo()
  if ChatInterface.IsAtOpen() and ChatManager2:GetInstance():IsInitOK() and ChatInterface.isInAlliance() then
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.ChatAt)
  end
end

return ChatManager2
