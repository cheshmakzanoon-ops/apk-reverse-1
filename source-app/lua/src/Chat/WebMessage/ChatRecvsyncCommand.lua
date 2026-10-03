local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local ChatRecvsyncCommand = BaseClass("ChatRecvsyncCommand", WebSocketBaseMessage)

local function OnCreate(self, t)
  self.tableData = {}
end

local function HandleMessage(self, serverData)
end

ChatRecvsyncCommand.OnCreate = OnCreate
ChatRecvsyncCommand.HandleMessage = HandleMessage
return ChatRecvsyncCommand
