local ChatGPTMessageLikeMessage = BaseClass("ChatGPTMessageLikeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ChatGPTMessageLikeMessage:OnCreate(roomId, msgSeq, msgTime, emoId, targetUid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("roomId", roomId)
  self.sfsObj:PutLong("msgSeq", msgSeq)
  self.sfsObj:PutLong("msgCreateTime", msgTime)
  self.sfsObj:PutInt("emoId", emoId)
  if targetUid ~= nil then
    self.sfsObj:PutUtfString("relationUserId", targetUid)
  end
end

function ChatGPTMessageLikeMessage:HandleMessage(msg)
  base.HandleMessage(self, msg)
  if msg.errorCode then
    local errorCode = "120289"
    if errorCode ~= nil and errorCode ~= "0" then
      local hintString = ChatInterface.getString(errorCode)
      ChatInterface.flyHint(hintString)
    end
  end
end

return ChatGPTMessageLikeMessage
