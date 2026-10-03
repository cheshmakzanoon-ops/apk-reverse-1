local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local GetHistoryRoomSeqIdListCommand = BaseClass("GetHistoryRoomSeqIdListCommand", WebSocketBaseMessage)

local function OnCreate(self, roomId, seqIds)
  local param = {roomId = roomId, seqIds = seqIds}
  self.tableData = param
end

local function HandleMessage(self, handle)
  if handle.result and not table.IsNullOrEmpty(handle.result.msg) then
    DataCenter.ActEasterEggManager:SetReadyForLikeDescendMsg(true)
    DataCenter.ActEasterEggManager:ParseAndAddChatDataToRoom(handle.result.msg)
  end
end

GetHistoryRoomSeqIdListCommand.OnCreate = OnCreate
GetHistoryRoomSeqIdListCommand.HandleMessage = HandleMessage
return GetHistoryRoomSeqIdListCommand
