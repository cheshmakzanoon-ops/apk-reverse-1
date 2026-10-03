local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local ChatCustomRoomInfoMessage = BaseClass("ChatCustomRoomInfoMessage", WebSocketBaseMessage)

function ChatCustomRoomInfoMessage:OnCreate(roomIdList, group)
  self.tableData = {roomIdList = roomIdList, group = group}
end

function ChatCustomRoomInfoMessage:HandleMessage(serverData)
  if serverData then
    ChatInterface.getRoomMgr():UpDateRoomInfo(serverData.result)
  end
end

return ChatCustomRoomInfoMessage
