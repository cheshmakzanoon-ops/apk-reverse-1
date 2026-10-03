local ChatGroupChatManager = BaseClass("ChatGroupChatManager")
local cd = 60000

function ChatGroupChatManager:__init()
  self.sendMsgPlayersDic = {}
  self.createRoomCdTime = nil
end

function ChatGroupChatManager:OnGroupRoomCreate(room)
  if not room then
    return
  end
  room:readMsg(room:getRoomLastSeqId())
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_COMMAND, room.roomId)
end

function ChatGroupChatManager:SendCreateRoom(playerList)
  if not playerList then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local cdTime = curTime - self.createRoomCdTime
  if cdTime >= cd then
    local tbl = {type = 4, memberList = playerList}
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_CREATE_COMMAND, tbl)
  else
    UIUtil.ShowTipsId("group_create_error_03")
  end
end

function ChatGroupChatManager:InitData(message)
  if message.create_chat_group_cd then
    self.createRoomCdTime = message.create_chat_group_cd
  end
  if message.room_set_infos then
    for i, info in pairs(message.room_set_infos) do
      self:UpdateNotDisturbingRoom(info.roomId, info.notDisturb)
    end
  end
end

function ChatGroupChatManager:DetectionCd(playerUid, roomId)
  local playerCdTime, curTime, playerInfo
  playerInfo = self.sendMsgPlayersDic[playerUid]
  if not playerInfo then
    return true
  end
  playerCdTime = 0
  if playerInfo and playerInfo[roomId] then
    playerCdTime = playerInfo[roomId]
  end
  curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime - playerCdTime >= cd then
    return true
  end
end

function ChatGroupChatManager:ReportName(roomData, extraNote, reTypeDic)
  ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.GroupChatNameReport, roomData.roomId, reTypeDic, roomData:getRoomName(), extraNote)
end

function ChatGroupChatManager:UpdateCdTime(playerInfoList, roomId)
  if not playerInfoList or not roomId then
    return
  end
  local serverPlayerInfo, playerInfo
  for i = 1, #playerInfoList do
    serverPlayerInfo = playerInfoList[i]
    playerInfo = self.sendMsgPlayersDic[serverPlayerInfo.uid]
    if not playerInfo then
      self.sendMsgPlayersDic[serverPlayerInfo.uid] = {}
      self.sendMsgPlayersDic[serverPlayerInfo.uid][roomId] = serverPlayerInfo.cd
    elseif not playerInfo[roomId] then
      playerInfo[roomId] = serverPlayerInfo.cd
    end
  end
end

function ChatGroupChatManager:SendInvitation(playerList, room)
  if not playerList or not room then
    return
  end
  local roomId = room.roomId
  local isShowTip, detectionCd
  for i = #playerList, 1, -1 do
    detectionCd = self:DetectionCd(playerList[i], roomId)
    if not detectionCd then
      table.remove(playerList, i)
      isShowTip = true
    end
  end
  if isShowTip then
    UIUtil.ShowTipsId("group_invite_limit_tips")
  end
  if 0 < #playerList then
    ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.ChatRoomMembersInvite, roomId, room.group, playerList)
  end
end

function ChatGroupChatManager:OnClearKickRoomInfo(roomId)
  if not roomId then
    return
  end
  local room = ChatManager2:GetInstance().Room:GetRoomData(roomId)
  if room then
    local category = room.category
    ChatInterface.getRoomMgr():RemoveRoomData(roomId)
    if category then
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REMOVE_KICKEDROOM, {category = category, roomId = roomId})
      EventManager:GetInstance():Broadcast(ChatEventEnum.Chat_QuitRoom, {category = category, roomId = roomId})
    end
  end
end

function ChatGroupChatManager:IsInviteBlocked(room, uid)
  local info = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  local userInfo = ChatManager2:GetInstance().User:getChatUserInfo(uid)
  local openLv = LuaEntry.DataConfig:TryGetNum("chat_group_limit", "k3")
  if not (info and info:IsInSameChatGroup(userInfo:getServerId())) or room and room:HasUserByUid(uid) or openLv > userInfo.mainBuildingLevel then
    return true
  else
    return false
  end
end

function ChatGroupChatManager:SetRoomNotDisturbing(roomId, isOn)
  ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.ChatRoomNotDisturd, roomId, isOn)
end

function ChatGroupChatManager:UpdateNotDisturbingRoom(roomId, isNotDisturbing)
  if not self.NotDisturbingRoomDic then
    self.NotDisturbingRoomDic = {}
  end
  if isNotDisturbing then
    self.NotDisturbingRoomDic[roomId] = true
  else
    self.NotDisturbingRoomDic[roomId] = nil
  end
  local room = ChatInterface.getRoomData(roomId)
  if room then
    room:SetNotDisturbing(isNotDisturbing)
  end
end

function ChatGroupChatManager:GetIsNotDisturbingRoom(roomId)
  if self.NotDisturbingRoomDic and self.NotDisturbingRoomDic[roomId] then
    return self.NotDisturbingRoomDic[roomId]
  end
  return false
end

function ChatGroupChatManager:__delete()
  self.sendMsgPlayersDic = nil
  self.createRoomCdTime = nil
end

function ChatGroupChatManager:Startup()
end

return ChatGroupChatManager
