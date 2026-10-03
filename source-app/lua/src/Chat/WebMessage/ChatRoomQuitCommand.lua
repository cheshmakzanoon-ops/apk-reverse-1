local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local ChatRoomQuitCommand = BaseClass("ChatRoomQuitCommand", WebSocketBaseMessage)

local function OnCreate(self, roomId)
  self.tableData.group = "custom"
  self.tableData.roomId = roomId
end

local function HandleMessage(self, serverData)
  ChatPrint("room quit : %s", serverData.result.status)
end

ChatRoomQuitCommand.OnCreate = OnCreate
ChatRoomQuitCommand.HandleMessage = HandleMessage
return ChatRoomQuitCommand
