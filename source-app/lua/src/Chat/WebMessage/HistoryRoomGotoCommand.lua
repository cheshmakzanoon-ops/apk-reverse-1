local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local HistoryRoomGotoCommand = BaseClass("HistoryRoomGotoCommand", WebSocketBaseMessage)
local RefreshType = {
  JumpTop = 1,
  HistoryMessage = 2,
  NewMessage = 3
}

local function OnCreate(self, roomId, seqId, sort)
  if sort ~= 1 then
    sort = nil
  end
  self.tableData = {
    roomId = roomId,
    seqId = seqId,
    sort = sort,
    count = ChatOnePageItemCount / 2
  }
end

local function HandleMessage(self, handle)
  local roomMgr = ChatManager2:GetInstance().Room
  if handle.result and not table.IsNullOrEmpty(handle.result.msg) then
    local msg = handle.result.msg
    local anchorSeqId = handle.result.seqId
    local first = msg[1]
    if first and first.group == ChatGroupType.GROUP_EASTER_EGG_ROOM then
      DataCenter.ActEasterEggManager:ClearRoomAndParseChatDataToRoom(msg, anchorSeqId)
      return
    end
  end
  roomMgr:UpdateJumpRoomMessage(handle)
end

HistoryRoomGotoCommand.OnCreate = OnCreate
HistoryRoomGotoCommand.HandleMessage = HandleMessage
return HistoryRoomGotoCommand
