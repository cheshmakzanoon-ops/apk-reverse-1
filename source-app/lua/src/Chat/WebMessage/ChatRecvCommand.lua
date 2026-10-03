local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local ChatRecvCommand = BaseClass("ChatRecvCommand", WebSocketBaseMessage)

local function OnCreate(self, roomId, seqId)
  self.tableData = {roomId = roomId, seqId = seqId}
end

local function HandleMessage(self, serverData)
end

ChatRecvCommand.OnCreate = OnCreate
ChatRecvCommand.HandleMessage = HandleMessage
return ChatRecvCommand
