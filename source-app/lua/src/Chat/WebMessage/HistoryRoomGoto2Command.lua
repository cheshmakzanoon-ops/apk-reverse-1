local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local HistoryRoomGoto2Command = BaseClass("HistoryRoomGoto2Command", WebSocketBaseMessage)

local function OnCreate(self, roomId, seqId)
  self.tableData = {
    roomId = roomId,
    seqId = seqId,
    count = ChatOnePageItemCount / 2
  }
end

local function HandleMessage(self, handle)
  local roomMgr = ChatManager2:GetInstance().Room
  roomMgr:InitJumpRoomMessage(handle)
end

HistoryRoomGoto2Command.OnCreate = OnCreate
HistoryRoomGoto2Command.HandleMessage = HandleMessage
return HistoryRoomGoto2Command
