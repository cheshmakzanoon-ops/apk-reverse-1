local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local ChatReadCommand = BaseClass("ChatReadCommand", WebSocketBaseMessage)
local Localization = CS.GameEntry.Localization

local function OnCreate(self, t)
  self.tableData = t
end

local function HandleMessage(self, serverData)
end

ChatReadCommand.OnCreate = OnCreate
ChatReadCommand.HandleMessage = HandleMessage
return ChatReadCommand
