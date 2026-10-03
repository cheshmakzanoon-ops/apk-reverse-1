local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushChatUpMessage = BaseClass("PushChatUpMessage", WebSocketBaseMessage)

function PushChatUpMessage:OnCreate(tbl)
end

function PushChatUpMessage:HandleMessage(serverData)
  if serverData.data == nil then
    print("push chat error!!!")
    return
  end
  local roomMgr = ChatManager2:GetInstance().Room
  local chatData = roomMgr:CreateChatMessage()
  local userMgr = ChatManager2:GetInstance().User
  chatData:onParseServerData(serverData.data)
  roomMgr:UpdateChatData(chatData)
  chatData = roomMgr:GetChat(chatData.roomId, chatData.seqId)
  EventManager:GetInstance():Broadcast(ChatEventEnum.UPDATE_USER_MSG, chatData)
end

return PushChatUpMessage
