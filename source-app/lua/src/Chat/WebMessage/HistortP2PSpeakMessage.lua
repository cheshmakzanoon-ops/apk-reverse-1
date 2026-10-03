local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local HistortP2PSpeakMessage = BaseClass("HistortP2PSpeakMessage", WebSocketBaseMessage)

local function OnCreate(self, roomId)
  self.tableData.roomId = roomId
end

local function HandleMessage(self, msg)
  if msg and msg.result then
    ChatInterface.getRoomMgr():UpdateChatSpeakUidByMsg(msg)
    EventManager:GetInstance():Broadcast(EventId.CHAT_SPEAK_UID_DATA_GET)
  else
    ChatInterface.getRoomMgr():ClearAllChatSpeakUidRequestState()
  end
end

HistortP2PSpeakMessage.OnCreate = OnCreate
HistortP2PSpeakMessage.HandleMessage = HandleMessage
return HistortP2PSpeakMessage
