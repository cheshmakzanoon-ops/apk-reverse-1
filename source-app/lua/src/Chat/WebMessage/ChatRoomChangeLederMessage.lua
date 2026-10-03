local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local ChatRoomChangeLederMessage = BaseClass("ChatRoomChangeLederMessage", WebSocketBaseMessage)

function ChatRoomChangeLederMessage:OnCreate(roomId, group, toUid)
  self.tableData = {
    roomId = roomId,
    group = group,
    toUid = toUid
  }
end

function ChatRoomChangeLederMessage:HandleMessage(serverData)
  if serverData.errorCode then
    UIUtil.ShowErrorCodeTips(serverData)
  end
end

return ChatRoomChangeLederMessage
