local ChatController = BaseClass("ChatController")
local rapidjson = require("rapidjson")
local ChatMessageHelper = require("Chat.Other.ChatMessageHelper")

function ChatController:__init()
  self.inited = false
  self.__event_handlers = {}
end

function ChatController:AddListener(msg_name, callback)
  local function bindFunc(...)
    callback(self, ...)
  end
  
  self.__event_handlers[msg_name] = bindFunc
  EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

function ChatController:RemoveListener(msg_name, callback)
  local bindFunc = self.__event_handlers[msg_name]
  if not bindFunc then
    Logger.LogError(msg_name, " not register")
    return
  end
  self.__event_handlers[msg_name] = nil
  EventManager:GetInstance():RemoveListener(msg_name, bindFunc)
end

function ChatController:Init()
  if self.inited then
    return
  end
  ChatPrint("ChatController:Init")
  self.inited = true
  local Event = self
  Event:AddListener(ChatEventEnum.CHAT_BLOCK_COMMAND, self.OnChatBlock)
  Event:AddListener(ChatEventEnum.CHAT_UNBLOCK_COMMAND, self.OnChatUnblock)
  Event:AddListener(ChatEventEnum.CHAT_BAN_COMMAND, self.OnChatBan)
  Event:AddListener(ChatEventEnum.CHAT_UNBAN_COMMAND, self.OnChatUnBan)
  Event:AddListener(ChatEventEnum.REPORT_CHAT_COMMAND, self.onReportChatMsg)
  Event:AddListener(ChatEventEnum.REPORT_CUSTUM_HEAD_PIC_COMMAND, self.onReportChatHeadPic)
  Event:AddListener(ChatEventEnum.SEARCH_PLAYER_COMMAND, self.OnSearchPlayer)
  Event:AddListener(ChatEventEnum.ROOM_INVITE_COMMAND, self.OnRoomInvite)
  Event:AddListener(ChatEventEnum.ROOM_KICK_COMMAND, self.OnRoomKick)
  Event:AddListener(ChatEventEnum.QUIT_ROOM_COMMAND, self.OnQuitRoom)
  Event:AddListener(EventId.ChatPrivateRemoveRoomIds, self.OnRemovePrivateRooms)
  Event:AddListener(ChatEventEnum.CHAT_ROOM_CHANGE_NAME_COMMAND, self.OnChangeRoomName)
  Event:AddListener(ChatEventEnum.GET_REDPACKET_COMMAND, self.OnGetRedPacket)
  Event:AddListener(ChatEventEnum.GET_REDPACKET_STATUS_COMMAND, self.OnGetRedPacketStatus)
  Event:AddListener(ChatEventEnum.CHAT_ROOM_DISMISS, self.OnRoomDismiss)
  Event:AddListener(ChatEventEnum.CHAT_ROOM_CREATE_COMMAND, self.OnChatRoomCreate)
  Event:AddListener(ChatEventEnum.CHAT_TEMP_ROOM_CREATE_COMMAND, self.OnChatTempRoomCreate)
  Event:AddListener(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_COMMAND, self.ChatRoomRequestHistoryMsg)
  Event:AddListener(ChatEventEnum.CHAT_SEND_ROOM_MSG_UP_COMMAND, self.OnChatMsgUp)
  Event:AddListener(ChatEventEnum.CHAT_SEND_ROOM_MSG_COMMAND, self.OnChatSendMsg)
  Event:AddListener(ChatEventEnum.CHAT_TRANSLATE, self.OnChatTranslate)
  Event:AddListener(ChatEventEnum.CHAT_ROOM_OPEN_BY_GROUP, self.OnChatRoomOpenByGroup)
  Event:AddListener(ChatEventEnum.CHAT_ROOM_OPEN_BY_ID, self.OnChatRoomOpenById)
  Event:AddListener(ChatEventEnum.CHAT_SEND_VOICE_MSG, self.OnChatSendVoiceMsg)
  Event:AddListener(ChatEventEnum.CHAT_VOICE_PLAY, self.OnChatVoicePlay)
  Event:AddListener(ChatEventEnum.CHAT_RESEND_ROOM_MSG_COMMAND, self.OnChatReSendMsg)
  Event:AddListener(ChatEventEnum.CHAT_SET_INFO, self.OnSetUserInfo)
  Event:AddListener(ChatEventEnum.CHAT_SHARE_COMMAND, self.OnChatShare)
  Event:AddListener(ChatEventEnum.CHAT_SHARE_EXECUTE_CMD, self.OnExecuteChatEvent)
  Event:AddListener(ChatEventEnum.CHAT_ROOM_PIN, self.OnRoomPin)
  Event:AddListener(ChatEventEnum.CHAT_VIEW_CLOSE, self.OnUIViewClose)
  Event:AddListener(ChatEventEnum.CHAT_CROSS_SERVER, self.OnCrossChatServer)
  Event:AddListener(EventId.CHAT_BLOCK_ADD, self.OnBlockAdd)
  Event:AddListener(EventId.CHAT_BLOCK_REMOVE, self.OnBlockRemove)
  Event:AddListener(EventId.AllianceApplySuccess, self.OnRefreshAlliance)
  Event:AddListener(EventId.AllianceCreateSuccess, self.OnRefreshAlliance)
  Event:AddListener(EventId.AllianceInitOK, self.OnRefreshAlliance)
  Event:AddListener(EventId.AllianceQuitOK, self.OnRefreshAlliance)
  Event:AddListener(EventId.RefreshAllianceArmsUI, self.OnRefreshCrossServer)
  Event:AddListener(EventId.Al_UpdateSelfRank, self.OnRefreshAlliance)
  Event:AddListener(EventId.APP_APPLICATION_PAUSE, self.OnAppLicationPause)
  Event:AddListener(EventId.EnterDragonWorld, self.OnEnterDragonWorld)
  Event:AddListener(EventId.QuitDragonWorld, self.OnExitDragonWorld)
  Event:AddListener(EventId.ActEpidemicOnActInfoRefresh, self.OnRefreshEpidemicRoom)
  Event:AddListener(EventId.LWSeasonFactionInfoUpdate, self.OnRefreshSeasonFactionWarRoom)
  Event:AddListener(EventId.LandlordActStageChange, self.OnRefreshActLandlordRoom)
  Event:AddListener(EventId.LandlordActInfoRefresh, self.OnRefreshActLandlordRoom)
  Event:AddListener(EventId.PushUserOff, self.OnPushUserOff)
  Event:AddListener(EventId.CHAT_ROOM_CREATE_RESULT, self.OnRoomCreate)
  Event:AddListener(EventId.SeasonStatusChanged, self.SeasonStatusChanged)
end

function ChatController:OnBlockAdd(blockInfo)
end

function ChatController:OnBlockRemove(blockInfo)
  ChatManager2:GetInstance().Room:ClearRoomFetchLimitForPlayer(blockInfo.uid)
end

function ChatController:SeasonStatusChanged()
  local roomData, newRoomId, curRoomId
  roomData = ChatInterface.getRoomMgr():GetRoomDataByGroup(ChatGroupType.GROUP_SEASON_ROOM)
  if roomData then
    curRoomId = roomData.roomId
  end
  newRoomId = ChatInterface.getRoomMgr():GenSeasonRoomId()
  if newRoomId ~= curRoomId then
    if roomData then
      ChatInterface.getRoomMgr():RemoveRoomData(curRoomId)
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RoomLeave, curRoomId)
    end
    if SeasonUtil.GetSeason() ~= 0 then
      ChatInterface.getRoomMgr():CreateChatRoom(newRoomId, ChatGroupType.GROUP_SEASON_ROOM)
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RoomJoinMulti, ChatGroupType.GROUP_SEASON_ROOM)
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomV2, newRoomId)
    end
  end
end

function ChatController:OnPushUserOff()
  ChatManager2:GetInstance():Uninit()
end

function ChatController:Release()
  ChatPrint("ChatController:Release")
  local Event = self
  local ChatEventEnum = _ENV.ChatEventEnum
  Event:RemoveListener(ChatEventEnum.CHAT_BLOCK_COMMAND, self.OnChatBlock)
  Event:RemoveListener(ChatEventEnum.CHAT_UNBLOCK_COMMAND, self.OnChatUnblock)
  Event:RemoveListener(ChatEventEnum.CHAT_BAN_COMMAND, self.OnChatBan)
  Event:RemoveListener(ChatEventEnum.CHAT_UNBAN_COMMAND, self.OnChatUnBan)
  Event:RemoveListener(ChatEventEnum.REPORT_CHAT_COMMAND, self.onReportChatMsg)
  Event:RemoveListener(ChatEventEnum.REPORT_CUSTUM_HEAD_PIC_COMMAND, self.onReportChatHeadPic)
  Event:RemoveListener(ChatEventEnum.SEARCH_PLAYER_COMMAND, self.OnSearchPlayer)
  Event:RemoveListener(ChatEventEnum.ROOM_INVITE_COMMAND, self.OnRoomInvite)
  Event:RemoveListener(ChatEventEnum.ROOM_KICK_COMMAND, self.OnRoomKick)
  Event:RemoveListener(ChatEventEnum.QUIT_ROOM_COMMAND, self.OnQuitRoom)
  Event:RemoveListener(EventId.ChatPrivateRemoveRoomIds, self.OnRemovePrivateRooms)
  Event:RemoveListener(ChatEventEnum.CHAT_ROOM_CHANGE_NAME_COMMAND, self.OnChangeRoomName)
  Event:RemoveListener(ChatEventEnum.GET_REDPACKET_COMMAND, self.OnGetRedPacket)
  Event:RemoveListener(ChatEventEnum.GET_REDPACKET_STATUS_COMMAND, self.OnGetRedPacketStatus)
  Event:RemoveListener(ChatEventEnum.CHAT_ROOM_DISMISS, self.OnRoomDismiss)
  Event:RemoveListener(ChatEventEnum.CHAT_ROOM_CREATE_COMMAND, self.OnChatRoomCreate)
  Event:RemoveListener(ChatEventEnum.CHAT_TEMP_ROOM_CREATE_COMMAND, self.OnChatTempRoomCreate)
  Event:RemoveListener(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_COMMAND, self.ChatRoomRequestHistoryMsg)
  Event:RemoveListener(ChatEventEnum.CHAT_SEND_ROOM_MSG_UP_COMMAND, self.OnChatMsgUp)
  Event:RemoveListener(ChatEventEnum.CHAT_SEND_ROOM_MSG_COMMAND, self.OnChatSendMsg)
  Event:RemoveListener(ChatEventEnum.CHAT_TRANSLATE, self.OnChatTranslate)
  Event:RemoveListener(ChatEventEnum.CHAT_ROOM_OPEN_BY_GROUP, self.OnChatRoomOpenByGroup)
  Event:RemoveListener(ChatEventEnum.CHAT_ROOM_OPEN_BY_ID, self.OnChatRoomOpenById)
  Event:RemoveListener(ChatEventEnum.CHAT_SEND_VOICE_MSG, self.OnChatSendVoiceMsg)
  Event:RemoveListener(ChatEventEnum.CHAT_VOICE_PLAY, self.OnChatVoicePlay)
  Event:RemoveListener(ChatEventEnum.CHAT_RESEND_ROOM_MSG_COMMAND, self.OnChatReSendMsg)
  Event:RemoveListener(ChatEventEnum.CHAT_SET_INFO, self.OnSetUserInfo)
  Event:RemoveListener(ChatEventEnum.CHAT_SHARE_COMMAND, self.OnChatShare)
  Event:RemoveListener(ChatEventEnum.CHAT_SHARE_EXECUTE_CMD, self.OnExecuteChatEvent)
  Event:RemoveListener(ChatEventEnum.CHAT_ROOM_PIN, self.OnRoomPin)
  Event:RemoveListener(ChatEventEnum.CHAT_VIEW_CLOSE, self.OnUIViewClose)
  Event:RemoveListener(EventId.AllianceApplySuccess, self.OnRefreshAlliance)
  Event:RemoveListener(EventId.AllianceCreateSuccess, self.OnRefreshAlliance)
  Event:RemoveListener(EventId.AllianceInitOK, self.OnRefreshAlliance)
  Event:RemoveListener(EventId.AllianceQuitOK, self.OnRefreshAlliance)
  Event:RemoveListener(EventId.RefreshAllianceArmsUI, self.OnRefreshCrossServer)
  Event:RemoveListener(EventId.Al_UpdateSelfRank, self.OnRefreshAlliance)
  Event:RemoveListener(ChatEventEnum.CHAT_CROSS_SERVER, self.OnCrossChatServer)
  Event:RemoveListener(EventId.EnterDragonWorld, self.OnEnterDragonWorld)
  Event:RemoveListener(EventId.ExitDragonWorld, self.OnExitDragonWorld)
  Event:RemoveListener(EventId.APP_APPLICATION_PAUSE, self.OnAppLicationPause)
  Event:RemoveListener(EventId.ActEpidemicOnActInfoRefresh, self.OnRefreshEpidemicRoom)
  Event:RemoveListener(EventId.LWSeasonFactionInfoUpdate, self.OnRefreshSeasonFactionWarRoom)
  Event:RemoveListener(EventId.LandlordActStageChange, self.OnRefreshActLandlordRoom)
  Event:RemoveListener(EventId.LandlordActInfoRefresh, self.OnRefreshActLandlordRoom)
  Event:RemoveListener(EventId.PushUserOff, self.OnPushUserOff)
  Event:RemoveListener(EventId.CHAT_ROOM_CREATE_RESULT, self.OnRoomCreate)
  Event:RemoveListener(EventId.CHAT_BLOCK_ADD, self.OnBlockAdd)
  Event:RemoveListener(EventId.CHAT_BLOCK_REMOVE, self.OnBlockRemove)
  Event:RemoveListener(EventId.SeasonStatusChanged, self.SeasonStatusChanged)
  self.inited = false
end

function ChatController:OnAppLicationPause(isOn)
  if not isOn then
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.ChatRecvsync)
  end
end

local CrossGroup = {
  [ChatGroupType.GROUP_COUNTRY] = {
    genIdFun = "GenCountryRoomId",
    UpdateFun = "UpdateCountryRoomId"
  },
  [ChatGroupType.GROUP_LANGUAGE] = {
    genIdFun = "GenLanguageRoomId",
    UpdateFun = "UpdateLanguageRoomId"
  }
}

function ChatController:OnCrossChatServer()
  local isGameServerRoomIdEnabled = ChatInterface.isGameServerRoomIdEnabled()
  if isGameServerRoomIdEnabled then
    return
  end
  local roomData, newRoomId, curRoomId
  local roomIds = {}
  for group, funTable in pairs(CrossGroup) do
    roomData = ChatInterface.getRoomMgr():GetRoomDataByGroup(group)
    curRoomId = roomData.roomId
    newRoomId = ChatInterface.getRoomMgr()[funTable.genIdFun](ChatInterface.getRoomMgr())
    if newRoomId ~= curRoomId then
      ChatInterface.getRoomMgr():RemoveRoomData(curRoomId)
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RoomLeave, curRoomId)
      ChatInterface.getRoomMgr():CreateChatRoom(newRoomId, group)
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RoomJoinMulti, group)
      table.insert(roomIds, newRoomId)
    end
    ChatInterface.getRoomMgr()[funTable.UpdateFun](ChatInterface.getRoomMgr())
  end
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomsV2, roomIds)
end

function ChatController:OnSetUserInfo()
  ChatPrint("OnSetUserInfo")
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.UserSetInfo, ChatInterface.getLastUpdateTime())
end

function ChatController:OnRoomInvite(param)
  local roomId = param.roomId
  local uidArr = param.uidArr
  if string.IsNullOrEmpty(roomId) or #uidArr == 0 then
    ChatPrint("OnRoomInvite \229\143\130\230\149\176\228\184\141\229\175\185")
    return
  end
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RoomInviteRoom, roomId, uidArr)
end

function ChatController:OnRoomKick(param)
  local roomId = param.roomId
  local uidArr = param.uidArr
  if string.IsNullOrEmpty(roomId) or #uidArr == 0 then
    ChatPrint("OnRoomKick \229\143\130\230\149\176\228\184\141\229\175\185")
    return
  end
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RoomKickRoom, roomId, uidArr)
end

function ChatController:OnQuitRoom(roomId)
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RoomQuitRoom, roomId)
end

function ChatController:OnRemovePrivateRooms(roomIdDict)
  if roomIdDict == nil then
    return
  end
  local realRoomIds = {}
  local tempRoomIds = {}
  local stickyList = CommonUtil.PlayerPrefsGetTable("PRIVATE_CHAT_STICKY_LIST", {})
  for roomId, v in pairs(roomIdDict) do
    local roomData = ChatManager2:GetInstance().Room:GetRoomData(roomId)
    if roomData then
      local member = roomData:getPrivateOtherMember()
      if stickyList[tostring(member and member.uid)] then
        stickyList[tostring(member and member.uid)] = nil
      end
      local hasMsg = roomData.msgs and roomData.lastSeqId >= 1
      if hasMsg then
        table.insert(realRoomIds, roomId)
      else
        table.insert(tempRoomIds, roomId)
      end
    end
  end
  CommonUtil.PlayerPrefsSetTable("PRIVATE_CHAT_STICKY_LIST", stickyList)
  if 0 < #tempRoomIds then
    EventManager:GetInstance():Broadcast(ChatEventEnum.Chat_QuitRoom, {
      category = ChatRoomCategory.PRIVATE
    })
  end
  if 0 < #realRoomIds then
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RoomQuitCustomRoomList, realRoomIds)
  end
end

function ChatController:OnChangeRoomName(param)
  local roomId = param.roomId
  local roomName = param.roomName
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RoomChangeRoomName, roomId, roomName)
end

function ChatController:OnGetRedPacket(param)
  local redPacketId = param.redPacketId
  local serverId = param.serverId
  local isViewOnly = param.isViewOnly
  local command = require("Chat.NetMessage.RedPacketsGetCommand").create(redPacketId, serverId, isViewOnly)
  if command then
    command:send()
  end
end

function ChatController:OnGetRedPacketStatus(param)
  local redPacketId = param.redPacketId
  local serverId = param.serverId
  local command = require("Chat.NetMessage.GetRedPacketStatusCommand").create(redPacketId, serverId)
  if command then
    command:send()
  end
end

function ChatController:onReportChatMsg(chatData)
  local content = ""
  local type = 0
  if chatData.post == PostType.Text_Audio_Message then
    type = 6
    content = chatData:getMediaInfo("audio")
  else
    content = chatData.msg
  end
  local param = {}
  param.reportUid = chatData.senderUid
  param.type = type
  param.content = content
  param.msgCreateTime = chatData:getServerTime() / 1000
  ChatInterface.getUserManagerInst():recordChatMsg(param.reportUid)
  local command = require("Chat.NetMessage.ReportPlayChatCommand").create(param)
  command:send()
end

function ChatController:onReportChatHeadPic(uid)
  ChatManager2:GetInstance().User:recordUserHead(uid)
  ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.ReportPicVer, uid)
end

function ChatController:OnChatBlock(uid)
  if not uid then
    return
  end
  if ChatManager2:GetInstance().Restrict:isInRestrictList(uid, RestrictType.BLOCK) then
    UIUtil.ShowTips(ChatInterface.getString("141026"))
  elseif ChatManager2:GetInstance().Restrict:isReachShieldLimit() then
    UIUtil.ShowTips(ChatInterface.getString("290009"))
  else
    ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.ChatLock, uid)
  end
end

function ChatController:OnChatUnblock(uid)
  ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.ChatUnlock, uid)
end

function ChatController:OnChatBan(param)
  local uid = param.uid
  local time = param.time
  ChatManager2:GetInstance().Restrict:addBanList(uid)
  ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.ChatBan, uid, time)
end

function ChatController:OnChatUnBan(uid)
  ChatManager2:GetInstance().Restrict:removeRestrictUser(uid, RestrictType.BAN)
  ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.ChatUnban, uid)
end

function ChatController:OnRoomPin(roomId)
  local roomDatas = ChatManager2:GetInstance().Room:GetRoomDatas()
  for k, v in pairs(roomDatas) do
    if v.roomId == roomId then
      local b = v:IsPin()
      v:SetPin(not b)
    else
      v:SetPin(false)
    end
  end
end

function ChatController:OnUIViewClose()
  self:OnRefreshCrossServer()
end

function ChatController:OnSearchPlayer(param)
  ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.SearchPlayer, param)
end

function ChatController:OnChatRoomCreate(param)
  ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.ChatRoomCreate, param)
end

function ChatController:OnRoomDismiss(roomId)
  if string.IsNullOrEmpty(roomId) then
    return
  end
  ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.ChatRoomDismiss, roomId)
end

function ChatController:OnChatTempRoomCreate(param)
end

function ChatController:ChatRoomRequestHistoryMsg(roomId, sort)
  if type(roomId) ~= "string" then
    printError("ChatRoomRequestHistoryMsg roomId is not string type!!")
    return
  end
  local roomData = ChatManager2:GetInstance().Room:GetRoomData(roomId)
  if roomData then
    local count
    if roomData.group == ChatGroupType.GROUP_FRIENDS_CIRCLE_ROOM then
      count = MomentMsgCount
    end
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomV2, roomId, sort, count)
  end
end

function ChatController:OnChatShare(param)
  local attachmentId = ChatMessageHelper.getAttachmentId(param)
  if attachmentId == nil then
    ChatPrint("share message error!")
    return
  end
  local p = {}
  p.post = param.post
  p.lang = ChatManager2:GetInstance().Translate:GetLangString(ChatInterface.getLanguageName())
  p.msg = "?"
  p.attachmentId = attachmentId
  p.tradeName = param.param.tradeName
  p.itemIds = param.param.itemIds
  p.tradePoint = param.param.tradePoint
  p.reportUid = param.param.reportUid
  p.toUser = param.param.toUser
  p.reportLang = param.param.reportLang
  if param.param.ossAddress then
    p.ossAddress = param.param.ossAddress
  end
  if param.param.introductionEx then
    p.introductionEx = param.param.introductionEx
  end
  if param.param.freeEx ~= nil then
    p.freeEx = param.param.freeEx
  end
  local SFSNetwork = ChatManager2:GetInstance().Net
  local channelType = ChatMessageHelper.getChannelFromRoomId(param.roomId, param.post, param.group)
  local msgType
  if channelType == ChatShareChannel.TO_COUNTRY then
    msgType = ChatMsgDefines.ChatShareCountry
  elseif channelType == ChatShareChannel.TO_ALLIANCE then
    msgType = ChatMsgDefines.ChatShareAlliance
  elseif channelType == ChatShareChannel.TO_LANGUAGE then
    p.chatType = ChatShareChannel.TO_LANGUAGE
    p.langRoomLang = ChatInterface.getLanguageName()
    msgType = ChatMsgDefines.ChatShareCountry
  elseif channelType == ChatShareChannel.TO_PERSON then
    p.roomId = param.roomId
    if param.newTypeMsg then
      msgType = ChatMsgDefines.ChatRoomSendOrCreateSend
    else
      msgType = ChatMsgDefines.ChatSharePerson
    end
  end
  if param.post == PostType.TacticalCard or param.post == PostType.TacticalCard_Deck or param.post == PostType.TacticalCard_EquipPlan then
    p.chatType = channelType
    if param.post == PostType.TacticalCard then
      p.cardUuid = param.param.cardUuid
    elseif param.post == PostType.TacticalCard_EquipPlan then
      p.planIndex = param.param and param.param.planIndex or param.planIndex
    end
    msgType = ChatMsgDefines.ChatShareSend
  end
  if LocalController:instance():hasTable(TableName.chat_sharetype_config) then
    local config = LocalController:instance():tryGetLine(TableName.chat_sharetype_config, param.post)
    if config then
      p.chatType = channelType
      msgType = ChatMsgDefines.ChatShareSend
    end
  end
  if param.post == PostType.Text_PointShare and param.param.dispatch == 1 then
    p.uuid = param.param.uuid
    p.targetServer = param.param.sid
    p.type = channelType
    msgType = ChatMsgDefines.ChatHeroDispatchShare
  end
  if param.post == PostType.INVASION_BOSS_SHARE then
    p.bossUid = param.param.uuid
    p.serverIdEx = param.param.srcServer
  end
  if param.param and param.param.shareType == WorldPointUIType.Treasure then
    msgType = ChatMsgDefines.ChatTreasureShare
    p.treasureUid = param.param.uuid
  end
  if msgType then
    SFSNetwork:SendSFSMessage(msgType, p)
  end
end

function ChatController:OnExecuteChatEvent(chatMsg)
  ChatMessageHelper.executeChatData(chatMsg)
end

function ChatController:OnChatSendMsg(msgTable)
  ChatManager2:GetInstance():SendChatMsg(msgTable)
end

function ChatController:OnChatMsgUp(msgTable)
  ChatManager2:GetInstance():SendChatUpMsg(msgTable)
end

function ChatController:OnChatReSendMsg(chatData)
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.ChatRoom, chatData)
end

function ChatController:OnChatTranslate(chatData)
  ChatManager2:GetInstance().Translate:DoTranslate(chatData)
end

function ChatController:OnChatRoomOpenByGroup(group)
  if group == ChatGroupType.GROUP_ALLIANCE and not ChatInterface.isInAlliance() then
    return
  end
  local localization = CS.LF.LuaGameEntry.GetLocalization()
  local room = RoomManager:GetRoomDataByGroup(group)
  if room then
    RoomManager:SetCurrentRoomId(room.roomId)
    if room.group == ChatGroupType.GROUP_ALLIANCE or room.group == ChatGroupType.GROUP_COUNTRY then
      CS.LF.LuaGameEntry.GetUI():OpenUIForm(CS.GameDefines.UIAssets.UIChatMain, "UIResourcePopUp")
    else
      ChatPrint("\233\128\154\232\191\135CHAT_ROOM_OPEN_BY_GROUP\230\137\147\229\188\128\231\154\132\232\129\138\229\164\169\229\174\164\230\152\175\228\184\141\231\161\174\229\174\154\231\154\132\239\188\140\229\155\160\228\184\186\229\143\175\232\131\189\229\173\152\229\156\168\229\164\154\228\184\170\232\129\138\229\164\169\229\174\164\239\188\140\232\175\183\228\189\191\231\148\168CHAT_ROOM_OPEN_BY_ID\230\140\135\229\174\154RoomId")
      CS.LF.LuaGameEntry.GetUI():OpenUIForm(CS.GameDefines.UIAssets.UIChatRoom, "UIResourcePopUp")
    end
  elseif group == ChatGroupType.GROUP_ALLIANCE then
    UIUtil.ShowMessage(localization:GetString("290028"))
  elseif group == ChatGroupType.GROUP_CUSTOM then
    UIUtil.ShowMessage(localization:GetString("290020"), localization:GetString("290027"))
  else
    ChatPrint("%s is not exist!", group)
  end
end

function ChatController:OnChatRoomOpenById(roomId)
  local RoomManager = ChatManager2:GetInstance().Room
  local roomData = RoomManager:GetRoomData(roomId)
  if not roomData then
    ChatPrint("%s is not exist!", roomId)
    return
  end
  RoomManager:SetCurrentRoomId(roomData.roomId)
end

function ChatController:OnChatSendVoiceMsg(voiceRecordParam)
  local playerUid = ChatInterface.getPlayerUid()
  local senderInfo = {
    userName = ChatInterface.getPlayerName(),
    lastUpdateTime = ChatInterface.getLastUpdateTime()
  }
  local chatData = {
    sender = playerUid,
    senderInfo = senderInfo,
    group = RoomManager:GetCurrentRoomData().group,
    roomId = RoomManager:GetCurrentRoomId(),
    msg = "90800185",
    sendTime = CS.LF.LuaGameEntry.GetTimer():GetServerTimeSeconds(),
    extra = {
      post = PostType.VOICE
    }
  }
  self:UploadAndSendVoiceMsg({param = voiceRecordParam, data = chatData})
end

function ChatController:OnChatVoicePlay(chatData)
  if chatData.extra and not string.IsNullOrEmpty(chatData.extra.media) then
    local media = rapidjson.decode(chatData.extra.media)
    local ret, url, cacheKey = CS.UrlUtils.GenCustomVoiceMsgUrl(media.audio)
    if ret then
      CS.DynamicResourceManager.Instance:LoadMultimediaFromUrl(url, CS.AudioType.MPEG, self.OnDownloadAudio, "Audio", cacheKey)
    end
  end
end

function ChatController:OnDownloadAudio(key, clip)
  if clip and clip.samples > 0 then
    ChatPrint(string.format("Play: len = {0}, channels = {1}, samples = {2}, frequency = {3}", clip.length, clip.channels, clip.samples, clip.frequency))
    CS.MicrophoneController.Instance:Play(clip)
  end
end

function ChatController:UploadAndSendVoiceMsg(voiceMsgInfo)
  local playerUid = ChatInterface.getPlayerUid()
  ChatPrint(info.param.filePath)
  local uploadName = CS.Path.GetFileNameWithoutExtension(info.param.filePath)
  ChatPrint(uploadName)
  local url = string.format("%s/%s/%s/%s/%s/fsafmpoewfmawpofmom", CS.UrlUtils.GetAudioUrl(), CS.ChatService.UPLOAD_AUDIO_URL, CS.ChatService.APP_ID, playerUid, uploadName)
  ChatPrint(url)
  local form = CS.UnityEngine.WWWForm()
  form:AddBinaryData("file", info.param.bytedata, uploadName)
  CS.WebRequestManager.Instance:Post(url, form, OnUploadAudio, 0, 0, info)
end

function ChatController:OnUploadAudio(www, err, voiceMsgInfo)
  if www.isDone and voiceMsgInfo then
    if err then
      UIUtil.ShowTips("81000705")
      printError(www.error .. "\n" .. voiceMsgInfo.param.filePath)
    else
      local filename = www.downloadHandler.text
      local duration = voiceMsgInfo.param.duration.ToString()
      if CS.File.Exists(voiceMsgInfo.param.filePath) then
        CS.File.Move(voiceMsgInfo.param.filePath, CS.Path.GetDirectoryName(voiceMsgInfo.param.filePath) .. "/" .. filename)
      end
      local media = {audio = filename, duration = duration}
      voiceMsgInfo.data.extra.media = rapidjson.encode(media)
      print(voiceMsgInfo.data.extra.media)
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SEND_ROOM_MSG_COMMAND, voiceMsgInfo.data)
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_CLOSE_POP_UP_KEYBOARD)
    end
  end
end

function ChatController:GetAllianceMember()
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.ChatRoomInvitee)
end

function ChatController:GetRedPacketInfos()
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RedPacketsRvdId)
end

function ChatController:OnRefreshAlliance()
  local chatInst = ChatManager2:GetInstance()
  if chatInst:IsInitOK() == false then
    ChatPrint("OnRefreshAlliance but not initok")
    return
  end
  local refresh = false
  local roomMgr = ChatManager2:GetInstance().Room
  local Net = ChatManager2:GetInstance().Net
  local room = roomMgr:GetRoomDataByGroup(ChatGroupType.GROUP_ALLIANCE)
  local inAlliance = ChatInterface.isInAlliance()
  ChatPrint("OnRefreshAlliance")
  local nowRoomId = roomMgr:GetAllianceRoomId()
  if room ~= nil and nowRoomId ~= room.roomId then
    Net:SendMessage(ChatMsgDefines.RoomLeave, room.roomId)
    roomMgr:RemoveAllianceRoom()
    room = nil
    refresh = true
  end
  local roomData = roomMgr:GetRoomDataByGroup(ChatGroupType.GROUP_ALLIANCE_MANAGER)
  if inAlliance == true then
    local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
    if isR4orR5 then
      if not roomData then
        roomData = roomMgr:AddAllianceManagerRoom()
        if roomData then
          Net:SendMessage(ChatMsgDefines.RoomJoinMulti, ChatGroupType.GROUP_ALLIANCE_MANAGER)
          self:ChatRoomRequestHistoryMsg(roomData.roomId)
        end
        refresh = true
      end
      SFSNetwork.SendMessage(MsgDefines.AllianceNoticeListInfo, 0, 30)
    elseif roomData then
      Net:SendMessage(ChatMsgDefines.RoomLeave, roomData.roomId)
      roomMgr:RemoveAllianceManangerRoom()
      refresh = true
    end
    if room == nil then
      room = roomMgr:AddAllianceRoom()
      if room then
        Net:SendMessage(ChatMsgDefines.RoomJoinMulti, ChatGroupType.GROUP_ALLIANCE)
        self:ChatRoomRequestHistoryMsg(room.roomId)
        ChatManager2:GetInstance():RequestChatAtInfo()
        refresh = true
      end
      roomMgr:AddAllianceNoticeRoom()
    end
  elseif room ~= nil then
    Net:SendMessage(ChatMsgDefines.RoomLeave, room.roomId)
    roomMgr:RemoveAllianceRoom()
    if roomData then
      Net:SendMessage(ChatMsgDefines.RoomLeave, roomData.roomId)
      roomMgr:RemoveAllianceManangerRoom()
    end
    refresh = true
  end
  if refresh then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REFRESH_CHANNEL)
  end
end

function ChatController:OnRefreshSeasonFactionWarRoom()
  local chatInst = ChatManager2:GetInstance()
  if chatInst:IsInitOK() == false then
    ChatPrint("OnRefreshAlliance but not initok")
    return
  end
  local roomMgr = ChatManager2:GetInstance().Room
  local Net = ChatManager2:GetInstance().Net
  local isNeedJoinRoom = false
  local seasonType = SeasonUtil.GetSeasonType(false, true)
  if SeasonUtil.SeasonHasFactionWar(seasonType) and SeasonUtil.IsInSeason() then
    local campInfo = DataCenter.SeasonFactionWarDataManager:GetGroupingData()
    if campInfo ~= nil and DataCenter.SeasonFactionWarDataManager:IsGroupingShownMode() then
      isNeedJoinRoom = true
    end
  end
  local roomData = roomMgr:GetRoomDataByGroup(ChatGroupType.GROUP_SEASON_FACTION_WAR_ROOM)
  if isNeedJoinRoom then
    if roomData == nil then
      roomData = roomMgr:AddSeasonFactionWarRoom()
      Net:SendMessage(ChatMsgDefines.RoomJoinMulti, ChatGroupType.GROUP_SEASON_FACTION_WAR_ROOM)
      self:ChatRoomRequestHistoryMsg(roomData.roomId)
    end
  elseif roomData then
    roomMgr:RemoveSeasonFactionWarRoom()
  end
end

function ChatController:OnRefreshActLandlordRoom()
  local chatInst = ChatManager2:GetInstance()
  if chatInst:IsInitOK() == false then
    ChatPrint("OnRefreshActLandlordRoom but not initok")
    return
  end
  local roomMgr = ChatManager2:GetInstance().Room
  local Net = ChatManager2:GetInstance().Net
  local isNeedJoinRoom = false
  local compId = DataCenter.LandlordMgr:GetMyGroup()
  if roomMgr:GetActLandlordOpenAndGrouped() then
    isNeedJoinRoom = true
  end
  local roomData
  if compId ~= LLConst.LandLordGroup.NONE then
    local chatGroupType = compId == LLConst.LandLordGroup.LORD and ChatGroupType.GROUP_LANDLORD_LORD or ChatGroupType.GROUP_LANDLORD_FARMER
    roomData = roomMgr:GetRoomDataByGroup(chatGroupType)
  end
  if isNeedJoinRoom then
    if roomData == nil then
      roomData = roomMgr:AddActLandlordRoom()
      local chatGroupType = compId == LLConst.LandLordGroup.LORD and ChatGroupType.GROUP_LANDLORD_LORD or ChatGroupType.GROUP_LANDLORD_FARMER
      Net:SendMessage(ChatMsgDefines.RoomJoinMulti, chatGroupType)
      if roomData then
        self:ChatRoomRequestHistoryMsg(roomData.roomId)
      end
    end
  else
    roomMgr:RemoveActLandlordRoom()
  end
end

function ChatController:OnRefreshCrossServer()
  local chatInst = ChatManager2:GetInstance()
  if chatInst:IsInitOK() == false then
    return
  end
  local refresh = false
  local roomMgr = ChatManager2:GetInstance().Room
  local Net = ChatManager2:GetInstance().Net
  local room = roomMgr:GetRoomDataByGroup(ChatGroupType.GROUP_CROSS_SERVER)
  local inCanCross = ChatInterface.isCrossServerOpen()
  local nowRoomId = roomMgr:GetCrossServerRoomId()
  if room ~= nil and nowRoomId ~= room.roomId then
    Net:SendMessage(ChatMsgDefines.RoomLeave, room.roomId)
    roomMgr:RemoveCrossServerRoom()
    room = nil
    refresh = true
  end
  if inCanCross == true then
    if room == nil then
      room = roomMgr:AddCrossServerRoom()
      if room then
        Net:SendMessage(ChatMsgDefines.RoomJoinMulti, ChatGroupType.GROUP_CROSS_SERVER)
        self:ChatRoomRequestHistoryMsg(room.roomId)
        refresh = true
      end
    end
  elseif room ~= nil then
    Net:SendMessage(ChatMsgDefines.RoomLeave, room.roomId)
    roomMgr:RemoveCrossServerRoom()
    refresh = true
  end
  if refresh then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REFRESH_CHANNEL)
  end
end

function ChatController:OnRefreshEpidemicRoom()
  local roomMgr = ChatManager2:GetInstance().Room
  roomMgr:RefreshEpidemicRoom()
end

function ChatController:OnEnterDragonWorld()
  self:OnRefreshDragonWorld(true)
end

function ChatController:OnExitDragonWorld()
  self:OnRefreshDragonWorld(false)
end

function ChatController:OnRefreshDragonWorld(isInBattleWorld)
  local chatInst = ChatManager2:GetInstance()
  if chatInst:IsInitOK() == false then
    return
  end
  local refresh = false
  local roomMgr = ChatManager2:GetInstance().Room
  local Net = ChatManager2:GetInstance().Net
  local selfRoom = roomMgr:GetRoomDataByGroup(ChatInterface.getDragonGroupType(true))
  local allRoom = roomMgr:GetRoomDataByGroup(ChatInterface.getDragonGroupType(false))
  local inBattleWorld = ChatInterface.isDragonServerOpen() and isInBattleWorld
  local nowSelfRoomId = roomMgr:GetDragonServerSelfRoomId()
  if selfRoom ~= nil and (nowSelfRoomId ~= selfRoom.roomId or not inBattleWorld) then
    Net:SendMessage(ChatMsgDefines.RoomLeave, selfRoom.roomId)
    roomMgr:RemoveDragonSeverSelfRoom()
    selfRoom = nil
    refresh = true
  end
  local nowAllRoomId = roomMgr:GetDragonServerAllRoomId()
  if allRoom ~= nil and (nowAllRoomId ~= allRoom.roomId or not inBattleWorld) then
    Net:SendMessage(ChatMsgDefines.RoomLeave, allRoom.roomId)
    roomMgr:RemoveDragonSeverAllRoom()
    allRoom = nil
    refresh = true
  end
  if inBattleWorld then
    if selfRoom == nil then
      selfRoom = roomMgr:AddDragonSelfRoom()
      if selfRoom and selfRoom.__todo__inited == false then
        Net:SendMessage(ChatMsgDefines.RoomJoinMulti, ChatInterface.getDragonGroupType(true))
        local roomData = ChatManager2:GetInstance().Room:GetRoomData(selfRoom.roomId)
        if roomData then
          ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomsV2, {
            selfRoom.roomId
          })
        end
        refresh = true
      end
    end
    if allRoom == nil then
      allRoom = roomMgr:AddDragonAllRoom()
      if allRoom and allRoom.__todo__inited == false then
        Net:SendMessage(ChatMsgDefines.RoomJoinMulti, ChatInterface.getDragonGroupType(false))
        local roomData = ChatManager2:GetInstance().Room:GetRoomData(allRoom.roomId)
        if roomData then
          ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomsV2, {
            allRoom.roomId
          })
        end
        refresh = true
      end
    end
  else
    if selfRoom ~= nil then
      Net:SendMessage(ChatMsgDefines.RoomLeave, selfRoom.roomId)
      roomMgr:RemoveDragonSeverSelfRoom()
      refresh = true
    end
    if allRoom ~= nil then
      Net:SendMessage(ChatMsgDefines.RoomLeave, allRoom.roomId)
      roomMgr:RemoveDragonSeverAllRoom()
      refresh = true
    end
  end
  if refresh then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REFRESH_CHANNEL)
  end
end

function ChatController:OnRoomCreate(roomData)
  if not roomData or not roomData.group then
    return
  end
  if roomData.group == ChatGroupType.GROUP_CUSTOM_GROUP and UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIChatNew_v2) then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_CHANGE_ROOM_ATVIEW, roomData.roomId)
  end
end

return ChatController
