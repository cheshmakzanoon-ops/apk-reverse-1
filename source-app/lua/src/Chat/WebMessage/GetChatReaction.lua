local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local ChatGetReaction = BaseClass("ChatGetReaction", WebSocketBaseMessage)

local function OnCreate(self, roomId, seqId, emojiId)
  local param = {
    roomId = roomId,
    seqId = seqId,
    emojiId = emojiId
  }
  self.tableData = param
end

local function HandleMessage(self, serverData)
  if serverData ~= nil then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_CHATDATA_REACTION_UPDATE, serverData.result)
  end
end

ChatGetReaction.OnCreate = OnCreate
ChatGetReaction.HandleMessage = HandleMessage
return ChatGetReaction
