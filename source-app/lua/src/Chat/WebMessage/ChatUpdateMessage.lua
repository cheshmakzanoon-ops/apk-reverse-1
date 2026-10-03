local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local ChatUpdateMessage = BaseClass("ChatUpdateMessage", WebSocketBaseMessage)

local function OnCreate(self, roomId, seqId, clientUpdateExtra)
  local param = {
    roomId = roomId,
    seqId = seqId,
    clientUpdateExtra = clientUpdateExtra
  }
  self.tableData = param
end

local function HandleMessage(self, serverData)
  if serverData ~= nil then
  end
end

ChatUpdateMessage.OnCreate = OnCreate
ChatUpdateMessage.HandleMessage = HandleMessage
return ChatUpdateMessage
