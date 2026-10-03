local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local GetRoomlastMessage = BaseClass("GetRoomlastMessage", WebSocketBaseMessage)

local function setRoomIds(ids)
  local idToTimes = {}
  for _, id in ipairs(ids) do
    idToTimes[id] = "0"
  end
  return idToTimes
end

local function OnCreate(self, ids)
  local t = setRoomIds(ids)
  self.tableData.rooms = t
end

local function HandleMessage(self, msg)
  ChatManager2:GetInstance().Room:onRequestLatestMsg(msg)
  ChatManager2:GetInstance().Room:onJoinRoomOK()
  if not ChatManager2:GetInstance().Room:IsInitPullDone() then
    ChatManager2:GetInstance().Room:OnInitPullCmdBack()
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_INIT_PULL_DONE)
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_RESULT, msg.result)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_PRIVATE_ROOMLAST_UPDATE, msg.result)
end

GetRoomlastMessage.OnCreate = OnCreate
GetRoomlastMessage.HandleMessage = HandleMessage
return GetRoomlastMessage
