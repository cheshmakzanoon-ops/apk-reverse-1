local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushChatCancelMessage = BaseClass("PushChatCancelMessage", WebSocketBaseMessage)

local function OnCreate(self, tbl)
end

local function HandleMessage(self, serverData)
  if serverData == nil then
    return
  end
  if serverData.data == nil then
    return
  end
  local roomMgr = ChatManager2:GetInstance().Room
  local chatData = roomMgr:GetChatDataByMessage(serverData.data)
  if chatData == nil then
    return
  end
  chatData.attachmentMsg = nil
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REFRESH_VIEW)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REFRESH_SINGLE_CHAT_SHOW, chatData)
end

PushChatCancelMessage.OnCreate = OnCreate
PushChatCancelMessage.HandleMessage = HandleMessage
return PushChatCancelMessage
