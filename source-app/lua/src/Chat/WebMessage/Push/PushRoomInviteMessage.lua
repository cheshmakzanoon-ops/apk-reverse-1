local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushRoomInviteMessage = BaseClass("PushRoomInviteMessage", WebSocketBaseMessage)
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
  local roomData = roomManager:CreateChatRoom(roomInfo.roomId, roomInfo.group)
  roomInfo.lastMsgTime = UITimeManager:GetInstance():GetServerTime()
  roomData:onParseServerData(roomInfo)
  local chatData = RoomDataParser.ProcessMsgs(msgs, "add")
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, chatData)
  EventManager:GetInstance():Broadcast(ChatEventEnum.LF_Enum_UpdateRoomOperateInfo)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REFRESH_CHANNEL)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_PRIVATE_ROOMLAST_UPDATE)
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomsV2, {
    roomInfo.roomId
  })
end

PushRoomInviteMessage.OnCreate = OnCreate
PushRoomInviteMessage.HandleMessage = HandleMessage
return PushRoomInviteMessage
