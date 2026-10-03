local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushRoomAcceptMessage = BaseClass("PushRoomAcceptMessage", WebSocketBaseMessage)
local RoomDataParser = require("Chat.WebMessage.Push.RoomDataParser")

local function OnCreate(self)
end

local function HandleMessage(self, serverData)
  local roomInfo = RoomDataParser.DecodeRoomInfo(serverData)
  local msgs = RoomDataParser.DecodeMsgs(serverData)
  if msgs == nil then
    print("data nil")
    return
  end
  local roomManager = ChatManager2:GetInstance().Room
  local roomData, isNew = roomManager:CreateChatRoom(roomInfo.roomId, roomInfo.group)
  roomInfo.lastMsgTime = UITimeManager:GetInstance():GetServerTime()
  roomData:onParseServerData(roomInfo)
  local chatData = RoomDataParser.ProcessMsgs(msgs, "add")
  ChatInterface.getGroupChatMgr():OnGroupRoomCreate(roomData)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REFRESH_CHANNEL)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, chatData)
  if isNew then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_CREATE_RESULT, roomData)
  end
end

PushRoomAcceptMessage.OnCreate = OnCreate
PushRoomAcceptMessage.HandleMessage = HandleMessage
return PushRoomAcceptMessage
