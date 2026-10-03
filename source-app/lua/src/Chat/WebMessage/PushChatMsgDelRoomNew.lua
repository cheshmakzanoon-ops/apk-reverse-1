local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushChatMsgDelRoomNew = BaseClass("PushChatMsgDelRoomNew", WebSocketBaseMessage)

local function OnCreate(self, roomId)
end

local function HandleMessage(self, msg)
  if msg.data and msg.data.roomid and msg.data.seqId then
    DataCenter.ChatCacheMsgManager:AddDelMsg(msg.data)
  end
end

PushChatMsgDelRoomNew.OnCreate = OnCreate
PushChatMsgDelRoomNew.HandleMessage = HandleMessage
return PushChatMsgDelRoomNew
