local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushAnotherLoginMessage = BaseClass("PushAnotherLoginMessage", WebSocketBaseMessage)
local ChatService = CS.ChatService.Instance

local function OnCreate(self)
end

local function HandleMessage(self, serverData)
  ChatPrint("Another user login!")
  ChatManager2:GetInstance().Net:CloseWebSocket()
end

PushAnotherLoginMessage.OnCreate = OnCreate
PushAnotherLoginMessage.HandleMessage = HandleMessage
return PushAnotherLoginMessage
