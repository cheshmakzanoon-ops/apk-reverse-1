local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushChatStickerMessage = BaseClass("PushChatStickerMessage", WebSocketBaseMessage)

local function OnCreate(self)
end

local function HandleMessage(self, serverData)
  DataCenter.ChatEmojiTemplateManager:SetStickerDataByMsg(serverData)
end

PushChatStickerMessage.OnCreate = OnCreate
PushChatStickerMessage.HandleMessage = HandleMessage
return PushChatStickerMessage
