local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushRoomDismissMessage = BaseClass("PushRoomDismissMessage", WebSocketBaseMessage)

local function OnCreate(self)
end

local function HandleMessage(self, serverData)
  if string.IsNullOrEmpty(serverData.data) then
    ChatPrint("PushDismiss: no serverdata")
    return
  end
  local roomId = serverData.data
  ChatPrint("PushDismiss HandleMessage: " .. roomId)
  local roomMgr = ChatManager2:GetInstance().Room
  roomMgr:RemoveRoomData(roomId)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REFRESH_CHANNEL)
end

PushRoomDismissMessage.OnCreate = OnCreate
PushRoomDismissMessage.HandleMessage = HandleMessage
return PushRoomDismissMessage
