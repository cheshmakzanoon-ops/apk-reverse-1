local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local ChatClearKickInfoMessage = BaseClass("ChatClearKickInfoMessage", WebSocketBaseMessage)

function ChatClearKickInfoMessage:OnCreate(roomId)
  self.tableData = {roomId = roomId}
end

function ChatClearKickInfoMessage:HandleMessage(serverData)
  if serverData.errorCode then
    UIUtil.ShowErrorCodeTips(serverData)
  else
    ChatInterface.getGroupChatMgr():OnClearKickRoomInfo(serverData.result.roomId)
  end
end

return ChatClearKickInfoMessage
