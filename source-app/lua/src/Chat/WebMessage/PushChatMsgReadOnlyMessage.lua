local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushChatMsgReadOnlyMessage = BaseClass("PushChatMsgReadOnlyMessage", WebSocketBaseMessage)

local function OnCreate(self, roomId, seqId, clientUpdateExtra)
end

local function HandleMessage(self, serverData)
  local chatData
  if serverData ~= nil and serverData.data then
    local room = ChatInterface.getRoomData(serverData.data.roomId)
    if room == nil then
      return
    end
    chatData = room:getChatDataBySeqId(serverData.data.seqId)
    if chatData then
      chatData:onParseServerData(serverData.data)
    end
    EventManager:GetInstance():Broadcast(EventId.ChatGetChatMsgReadOnlyMsg)
  end
end

PushChatMsgReadOnlyMessage.OnCreate = OnCreate
PushChatMsgReadOnlyMessage.HandleMessage = HandleMessage
return PushChatMsgReadOnlyMessage
