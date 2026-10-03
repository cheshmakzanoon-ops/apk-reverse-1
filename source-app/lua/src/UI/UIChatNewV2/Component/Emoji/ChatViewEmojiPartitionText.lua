local base = UIBaseContainer
local ChatViewEmojiPartitionText = BaseClass("ChatViewEmojiPartitionText", base)
local compBook = {
  {
    path = "emojiText",
    name = "emojiText",
    type = UITextMeshProUGUIEx
  }
}

function ChatViewEmojiPartitionText:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatViewEmojiPartitionText:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ChatViewEmojiPartitionText:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function ChatViewEmojiPartitionText:ReInit(text)
  self.emojiText:SetText(text.text)
end

function ChatViewEmojiPartitionText:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

return ChatViewEmojiPartitionText
