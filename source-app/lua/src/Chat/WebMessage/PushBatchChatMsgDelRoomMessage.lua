local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushBatchChatMsgDelRoomMessage = BaseClass("PushBatchChatMsgDelRoomMessage", WebSocketBaseMessage)

local function OnCreate(self, roomId)
end

local function HandleMessage(self, msg)
  if msg.data and msg.data.roomid then
    DataCenter.ChatCacheMsgManager:AddBatchDelMsg(msg.data)
  end
end

PushBatchChatMsgDelRoomMessage.OnCreate = OnCreate
PushBatchChatMsgDelRoomMessage.HandleMessage = HandleMessage
return PushBatchChatMsgDelRoomMessage
