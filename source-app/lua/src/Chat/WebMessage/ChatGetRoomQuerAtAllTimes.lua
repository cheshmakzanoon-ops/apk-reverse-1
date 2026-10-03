local base = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local ChatGetRoomQuerAtAllTimes = BaseClass("ChatGetRoomQuerAtAllTimes", base)

local function OnCreate(self, roomId)
  self.tableData = {roomId = roomId}
end

local function HandleMessage(self, msg)
  base.HandleMessage(self, msg)
  if msg.errorCode then
    UIUtil.ShowErrorCodeTips(msg)
  else
    ChatInterface.getRoomMgr():UpdateAtAllCount(msg.result)
  end
end

ChatGetRoomQuerAtAllTimes.OnCreate = OnCreate
ChatGetRoomQuerAtAllTimes.HandleMessage = HandleMessage
return ChatGetRoomQuerAtAllTimes
