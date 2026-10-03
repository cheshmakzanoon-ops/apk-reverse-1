local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushRoomKickMessage = BaseClass("PushRoomKickMessage", WebSocketBaseMessage)
local RoomDataParser = require("Chat.WebMessage.Push.RoomDataParser")
local rapidjson = require("rapidjson")

local function OnCreate(self)
end

local function HandleMessage(self, serverData)
  local msgs = RoomDataParser.DecodeMsgs(serverData)
  if msgs == nil then
    ChatPrint("Kick error!")
    return
  end
  local chatData = RoomDataParser.ProcessMsgs(msgs, "remove")
  if chatData then
    local roomData = ChatManager2:GetInstance().Room:GetRoomData(chatData.roomId)
    if roomData then
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, chatData)
    end
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.LF_Enum_UpdateRoomOperateInfo)
end

PushRoomKickMessage.OnCreate = OnCreate
PushRoomKickMessage.HandleMessage = HandleMessage
return PushRoomKickMessage
