local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushRoomQuitMessage = BaseClass("PushRoomQuitMessage", WebSocketBaseMessage)
local RoomDataParser = require("Chat.WebMessage.Push.RoomDataParser")

local function OnCreate(self)
end

local function HandleMessage(self, serverData)
  local msgs = RoomDataParser.DecodeMsgs(serverData)
  if msgs == nil then
    print("data nil")
    return
  end
  if msgs.sender == ChatInterface.getPlayerUid() then
    local roomMgr = ChatManager2:GetInstance().Room
    local data = roomMgr:GetRoomData(msgs.roomId)
    local category
    if data then
      category = data.category
    end
    roomMgr:RemoveRoomData(msgs.roomId)
    DataCenter.ChatPrivateSearchDataManager:RemoveRoomData(msgs.roomId)
    if category then
      EventManager:GetInstance():Broadcast(ChatEventEnum.Chat_QuitRoom, {
        category = category,
        roomId = msgs.roomId
      })
    end
    return
  end
  local chatData = RoomDataParser.ProcessMsgs(msgs, "quit")
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, chatData)
end

PushRoomQuitMessage.OnCreate = OnCreate
PushRoomQuitMessage.HandleMessage = HandleMessage
return PushRoomQuitMessage
