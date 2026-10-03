local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local ChatTransferMessage = BaseClass("ChatTransferMessage", WebSocketBaseMessage)

function ChatTransferMessage:OnCreate(roomId, seqId, toRoomId)
  self.tableData = {
    roomId = roomId,
    seqId = seqId,
    toRoomId = toRoomId
  }
end

function ChatTransferMessage:HandleMessage(self, serverData)
end

return ChatTransferMessage
