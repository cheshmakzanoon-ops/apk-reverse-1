local ChatGPTMessageLikePushMessage = BaseClass("ChatGPTMessageLikePushMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ChatGPTMessageLikePushMessage:OnCreate()
  base.OnCreate(self)
end

function ChatGPTMessageLikePushMessage:HandleMessage(data)
  base.HandleMessage(self, data)
  if data ~= nil and data.infos ~= nil then
    local roomId = data.roomId
    local romMgr = ChatManager2:GetInstance().Room
    for msgSeqId, emoji_data in pairs(data.infos) do
      if msgSeqId ~= nil and emoji_data ~= nil then
        romMgr:SetMineChatEmojiData(roomId, msgSeqId, emoji_data)
      end
    end
    EventManager:GetInstance():Broadcast(EventId.CHAT_GPT_EMOJI_UPDATE, data)
  end
end

return ChatGPTMessageLikePushMessage
