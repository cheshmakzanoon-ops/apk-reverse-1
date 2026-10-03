local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushChatMessage = BaseClass("PushChatMessage", WebSocketBaseMessage)

local function handleAllianceEvent(tabData)
  if type(tabData) ~= "table" then
    return
  end
  local extraData = tabData.extra
  if not extraData then
    return
  end
  local post = 0
  if extraData.post then
    post = checknumber(extraData.post)
  end
  if post == 2 then
    local isReload = false
    local isRemove = false
    local dialog = extraData.dialog
    if dialog == "115184" or dialog == "115185" then
      isReload = true
    elseif dialog == "115187" then
      isRemove = true
    end
    local name
    local msgarr = extraData.msgarr
    if msgarr ~= nil and 0 < #msgarr then
      name = msgarr[1]
    end
    if name ~= nil then
      local uid = ChatManager2:GetInstance().User:getUIDWithUserName(name)
      if uid ~= nil then
        if isReload then
          ChatManager2:GetInstance().User:requestSingleUserInfo(uid)
        end
        if isRemove then
          ChatManager2:GetInstance().Room:GetAllianceRoomData():removeMembers({uid})
        end
      end
    end
  end
end

local function OnCreate(self, tbl)
end

local function HandleMessage(self, serverData)
  if serverData.data == nil then
    print("push chat error!!!")
    return
  end
  local roomMgr = ChatManager2:GetInstance().Room
  local userMgr = ChatManager2:GetInstance().User
  handleAllianceEvent(serverData.data)
  local chatData = roomMgr:GetChatDataByMessage(serverData.data)
  if not chatData then
    chatData = ChatInterface.CreatePriveChatDataByNewMessage(serverData.data)
    if not chatData then
      return
    end
  end
  if chatData.group == ChatGroupType.GROUP_EASTER_EGG_ROOM then
    DataCenter.ActEasterEggManager:ParseReceiveChatData(chatData)
    return
  end
  if chatData.post == PostType.Chat_SendPhoto and chatData:getExtra() then
    DataCenter.ChatSendPhotoManager:RemoveFakePhotoChatData(chatData:getRoomId(), chatData:getExtra().picVer, false)
  elseif chatData.post == PostType.Chat_Stickers then
    chatData:SetDiceRollState(false)
  elseif chatData.post == PostType.TorchRelayCheer and chatData.senderUid == LuaEntry.Player.uid then
    SFSNetwork.SendMessage(MsgDefines.ActivityTorchRelayToChatShareRoom, chatData.attachmentIdJsonObj.activityId, chatData.roomId, chatData.seqId)
  end
  if chatData:canSkip() then
    return
  end
  local roomData = roomMgr:GetRoomData(chatData.roomId)
  local isNewMessage = true
  if roomData then
    local isExist = roomData:getChatDataBySeqId(chatData.seqId)
    isNewMessage = not isExist or chatData:GetIsBlockMessages()
    roomMgr:AddClassifyRoomDic(roomData)
  end
  roomMgr:AddChat(chatData, true, true)
  ChatManager2:GetInstance():PushMessageReply(chatData)
  roomMgr:UpdateChatSpeakUidByChatData(chatData)
  if isNewMessage then
    if not ChatManager2:GetInstance().Restrict:GetMsgIsCanShow(chatData) then
      return
    end
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, chatData)
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_HISTORYMSG_UPDATA, {
      roomId = chatData.roomId,
      requestType = RequestType.ReceivePush,
      seqId = chatData.seqId
    })
  end
  if chatData:IsMessageAtMe() then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ONPUSH_MENTION)
  end
end

PushChatMessage.OnCreate = OnCreate
PushChatMessage.HandleMessage = HandleMessage
return PushChatMessage
