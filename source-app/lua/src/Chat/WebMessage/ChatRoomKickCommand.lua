local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local ChatRoomKickCommand = BaseClass("ChatRoomKickCommand", WebSocketBaseMessage)

local function OnCreate(self, roomId, uidArr)
end

local function HandleMessage(self, serverData)
  if serverData.errorCode then
    UIUtil.ShowErrorCodeTips(serverData)
  else
    EventManager:GetInstance():Broadcast(ChatEventEnum.ROOM_KICK_PLAYER_RESULT, serverData.result.status)
  end
end

ChatRoomKickCommand.OnCreate = OnCreate
ChatRoomKickCommand.HandleMessage = HandleMessage
return ChatRoomKickCommand
