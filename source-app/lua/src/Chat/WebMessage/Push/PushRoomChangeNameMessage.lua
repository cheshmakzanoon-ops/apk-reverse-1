local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushRoomChangeNameMessage = BaseClass("PushRoomChangeNameMessage", WebSocketBaseMessage)
local RoomDataParser = require("Chat.WebMessage.Push.RoomDataParser")
local rapidjson = require("rapidjson")

local function OnCreate(self)
end

local function HandleMessage(self, serverData)
  local msgs, roomData, roomName, chatData, roomId
  if not serverData.data.name or not serverData.data.roomId then
    msgs = RoomDataParser.DecodeMsgs(serverData)
    if msgs == nil then
      print("data nil")
      return
    end
    chatData = RoomDataParser.ProcessMsgs(msgs)
    roomId = msgs.roomId
    local roomMgr = ChatManager2:GetInstance().Room
    roomData = roomMgr:GetRoomData(msgs.roomId)
    roomName = msgs.msg
  else
    roomData = ChatManager2:GetInstance().Room:GetRoomData(serverData.data.roomId)
    roomName = serverData.data.name
    roomId = serverData.data.roomId
  end
  if roomData then
    roomData:setName(roomName)
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_UPDATE_ROOM_NAME, roomId)
  end
  if chatData then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, chatData)
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REFRESH_CHANNEL)
  EventManager:GetInstance():Broadcast(ChatEventEnum.LF_Enum_UpdateRoomOperateInfo)
end

PushRoomChangeNameMessage.OnCreate = OnCreate
PushRoomChangeNameMessage.HandleMessage = HandleMessage
return PushRoomChangeNameMessage
