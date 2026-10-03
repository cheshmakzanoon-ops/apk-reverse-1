local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushChatRoomChangeLeaderMessage = BaseClass("PushChatRoomChangeLeaderMessage", WebSocketBaseMessage)

local function OnCreate(self, tbl)
end

local function HandleMessage(self, serverData)
  if serverData == nil then
    return
  end
  if serverData and serverData.data.msgs then
    local chatData = ChatInterface.getRoomMgr():GetChatDataByMessage(serverData.data.msgs)
    local room = ChatInterface.getRoomMgr():GetRoomData(chatData.roomId)
    if chatData.msg and chatData.type == ChatSystemMessageType.ROOM_OP_CHANGE_LEADER then
      room.owner = chatData.msg
    end
    ChatInterface.getRoomMgr():AddChat(chatData, true, true)
    EventManager:GetInstance():Broadcast(EventId.CHAT_CHANGE_OWNER, {
      roomId = chatData.roomId,
      owner = room.owner
    })
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, chatData)
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_HISTORYMSG_UPDATA, {
      roomId = chatData.roomId,
      requestType = RequestType.ReceivePush,
      seqId = chatData.seqId
    })
  end
end

PushChatRoomChangeLeaderMessage.OnCreate = OnCreate
PushChatRoomChangeLeaderMessage.HandleMessage = HandleMessage
return PushChatRoomChangeLeaderMessage
