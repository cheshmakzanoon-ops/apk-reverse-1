local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushLoginSuccessMessage = BaseClass("PushLoginSuccessMessage", WebSocketBaseMessage)

local function OnCreate(self)
end

local function HandleMessage(self, serverData)
  ChatManager2:GetInstance():onUserLoginSuccess(serverData)
end

PushLoginSuccessMessage.OnCreate = OnCreate
PushLoginSuccessMessage.HandleMessage = HandleMessage
return PushLoginSuccessMessage
