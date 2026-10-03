local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local ChatCancelMessage = BaseClass("ChatCancelMessage", WebSocketBaseMessage)

function ChatCancelMessage:OnCreate(roomId, seqId)
  self.tableData = {roomId = roomId, seqId = seqId}
end

function ChatCancelMessage:HandleMessage(self, serverData)
end

return ChatCancelMessage
