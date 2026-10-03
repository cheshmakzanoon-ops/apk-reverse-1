local ChatGPTMessageLikeFetchMessage = BaseClass("ChatGPTMessageLikeFetchMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ChatGPTMessageLikeFetchMessage:OnCreate(roomId, msgSeqList)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("roomId", roomId)
  if msgSeqList ~= nil then
    if #msgSeqList == 1 then
      self.sfsObj:PutLong("msgSeq", msgSeqList[1])
      return
    end
    self.sfsObj:PutLongArray("msgSeqList", msgSeqList)
  end
end

function ChatGPTMessageLikeFetchMessage:HandleMessage(data)
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

return ChatGPTMessageLikeFetchMessage
