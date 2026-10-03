local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushNotRoomMemberMessage = BaseClass("PushNotRoomMemberMessage", WebSocketBaseMessage)

local function OnCreate(self)
end

local function HandleMessage(self, serverData)
  if serverData and serverData.result then
    ChatInterface.getRoomMgr():RemoveRoomData(serverData.result.roomId)
    UIUtil.ShowTipsId("group_no_in_room")
    EventManager:GetInstance():Broadcast(EventId.CHAT_REFRESH_CHANNEL)
    Logger.LogWarning("chat error\239\188\154 Speaking in a room not yet owned")
  end
end

PushNotRoomMemberMessage.OnCreate = OnCreate
PushNotRoomMemberMessage.HandleMessage = HandleMessage
return PushNotRoomMemberMessage
