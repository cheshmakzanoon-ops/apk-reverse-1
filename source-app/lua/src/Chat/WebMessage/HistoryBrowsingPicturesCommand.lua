local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local HistoryBrowsingPicturesCommand = BaseClass("HistoryBrowsingPicturesCommand", WebSocketBaseMessage)

local function OnCreate(self, roomId, seqId)
  local tbl = {}
  tbl.roomId = roomId
  tbl.seqId = toInt(seqId)
  self.tableData = tbl
end

local function HandleMessage(self, handle)
  DataCenter.ChatFriendCirclePhotoChatDataSaveManager:AddPhotoChatDataByMsg(handle)
  if handle.result and not table.IsNullOrEmpty(handle.result.msg) then
    local msg = handle.result.msg
    local first = msg[1]
    if first then
      local roomId = first.roomId
      if not string.IsNullOrEmpty(roomId) then
        EventManager:GetInstance():Broadcast(EventId.GetChatPhotoDataListRefreshMsg, roomId)
      end
    end
  end
end

HistoryBrowsingPicturesCommand.OnCreate = OnCreate
HistoryBrowsingPicturesCommand.HandleMessage = HandleMessage
return HistoryBrowsingPicturesCommand
