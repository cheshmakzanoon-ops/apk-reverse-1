local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local GetHistoryMsgsByTimeCommand = BaseClass("GetHistoryMsgsByTimeCommand", WebSocketBaseMessage)

local function setRoomId(roomId, sort, count)
  local roomMgr = ChatManager2:GetInstance().Room
  local roomData = roomMgr:GetRoomData(roomId)
  local firstTime = roomData:GetFirstMsgServerTime()
  local tbl = {}
  tbl.roomId = roomData.roomId
  tbl.start = 0
  tbl["end"] = tostring(firstTime)
  tbl.startSeqId = toInt(roomData:getFirstSeqId())
  tbl.endSeqId = toInt(roomData:GetLastMsgSeqId())
  if sort and sort == 1 then
    tbl.sort = sort
    tbl.start = tonumber(roomData:GetLastMsgServerTime())
    tbl["end"] = math.floor(UITimeManager:GetInstance():GetServerTime())
  end
  tbl.count = count or ChatOnePageItemCount
  tbl.queryType = 1
  return tbl
end

local function OnCreate(self, roomId, type, count)
  local tbl = setRoomId(roomId, type, count)
  self.tableData = tbl
end

local function HandleMessage(self, handle)
  local roomMgr = ChatManager2:GetInstance().Room
  local userMgr = ChatManager2:GetInstance().User
  if handle.result then
    local getType = handle.result.sort == 0 and RequestType.PullPrev or RequestType.PullLast
    if not table.IsNullOrEmpty(handle.result.msg) then
      local msg = handle.result.msg
      local first = msg[1]
      if first then
        if first.group == ChatGroupType.GROUP_EASTER_EGG_ROOM then
          DataCenter.ActEasterEggManager:OnParseServerChatData_EasterEggChat(msg)
        else
          roomMgr:OnParseServerChatDataByOneRoom(first.roomId, msg, getType)
        end
        userMgr:__processAllUserInfos()
        EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_RESULT_BY_TIME, handle.result)
      else
      end
    else
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_RESULT_BY_TIME, handle.result)
    end
    local msgEnd = table.IsNullOrEmpty(handle.result.msg)
    local room = ChatManager2:GetInstance().Room:GetRoomData(handle.result.roomId)
    if room then
      room:SetChatHistoryEnd(getType, msgEnd)
      roomMgr:OnServerPassRoom(room.roomId, getType)
    end
  else
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_RESULT_BY_TIME, nil)
  end
end

GetHistoryMsgsByTimeCommand.OnCreate = OnCreate
GetHistoryMsgsByTimeCommand.HandleMessage = HandleMessage
return GetHistoryMsgsByTimeCommand
