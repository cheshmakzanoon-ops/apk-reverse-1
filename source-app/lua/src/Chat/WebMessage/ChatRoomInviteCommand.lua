local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local ChatRoomInviteCommand = BaseClass("ChatRoomInviteCommand", WebSocketBaseMessage)

local function OnCreate(self, roomId, uidArr)
  self.tableData.group = "custom"
  self.tableData.roomId = roomId
  self.tableData.members = table.concat(uidArr, "|")
end

local function HandleMessage(self, serverData)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_INVITE_PLAYER_RESULT, serverData.result.status)
end

ChatRoomInviteCommand.OnCreate = OnCreate
ChatRoomInviteCommand.HandleMessage = HandleMessage
return ChatRoomInviteCommand
