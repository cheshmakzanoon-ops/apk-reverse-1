local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushChatP2PRoom = BaseClass("PushChatP2PRoom", WebSocketBaseMessage)
local RoomDataParser = require("Chat.WebMessage.Push.RoomDataParser")

local function OnCreate(self)
end

local function HandleMessage(self, serverData)
  local roomInfo = RoomDataParser.DecodeRoomInfo(serverData)
  local msgList = RoomDataParser.DecodeMsgList(serverData)
  if roomInfo == nil or msgList == nil then
    print("data nil")
    return
  end
  local roomManager = ChatManager2:GetInstance().Room
  local roomData = roomManager:CreateChatRoom(roomInfo.roomId, roomInfo.group)
  roomInfo.lastMsgTime = UITimeManager:GetInstance():GetServerTime()
  roomData:onParseServerData(roomInfo)
  local chatData
  for i = 1, #msgList do
    chatData = RoomDataParser.ProcessMsgs(msgList[i], "add")
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REFRESH_CHANNEL)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, chatData)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_CREATE_RESULT, roomData)
end

PushChatP2PRoom.OnCreate = OnCreate
PushChatP2PRoom.HandleMessage = HandleMessage
return PushChatP2PRoom
