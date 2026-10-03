local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local SetUserInfoCommand = BaseClass("SetUserInfoCommand", WebSocketBaseMessage)

local function OnCreate(self, lastUpdateTime)
  self.tableData.info = {}
  self.tableData.info.userName = ChatInterface.getPlayerName()
  self.tableData.info.abbr = ChatInterface.getAllianceAbbr()
  if string.IsNullOrEmpty(self.tableData.info.abbr) then
    self.tableData.info.abbr = nil
  end
  lastUpdateTime = lastUpdateTime or ChatInterface.getServerTime()
  self.tableData.info.lastUpdateTime = lastUpdateTime
end

local function HandleMessage(self, msg)
  ChatPrint("SetUserInfoCommand %s,%s", msg.cmd, msg.result.status)
end

SetUserInfoCommand.OnCreate = OnCreate
SetUserInfoCommand.HandleMessage = HandleMessage
return SetUserInfoCommand
