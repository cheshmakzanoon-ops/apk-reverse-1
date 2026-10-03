local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local ChatRoomNotReadMessage = BaseClass("ChatRoomNotReadMessage", WebSocketBaseMessage)

function ChatRoomNotReadMessage:OnCreate(param)
  self.tableData = {
    activityId = param.activityId,
    rooms = param.roomIdList
  }
end

function ChatRoomNotReadMessage:HandleMessage(serverData)
  if not serverData.errorCode then
    DataCenter.ValentineDataManager:ParseMatchSuccessRedPoint(serverData)
  else
    UIUtil.ShowErrorCodeTips(serverData)
  end
end

return ChatRoomNotReadMessage
