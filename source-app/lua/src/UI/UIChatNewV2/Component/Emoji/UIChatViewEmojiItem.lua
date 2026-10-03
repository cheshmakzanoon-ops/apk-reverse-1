local base = UIBaseContainer
local UIChatViewEmojiItem = BaseClass("UIChatViewEmojiItem", base)
local compBook = {
  {
    path = "",
    name = "emojiBtn",
    type = UIButton,
    onClick = function(self)
      self:OnCLickEmoji()
    end
  },
  {
    path = "imgEmoji",
    name = "emojiImg",
    type = UIImage
  }
}

function UIChatViewEmojiItem:OnCreate()
  base.OnCreate(self)
  self.mobilInputId = nil
  self:ComponentDefine()
end

function UIChatViewEmojiItem:OnDestroy()
  self:ComponentDestroy()
  self.mobilInputId = nil
  base.OnDestroy(self)
end

function UIChatViewEmojiItem:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.emojiBtn.unity_uibutton.onClick:RemoveAllListeners()
  self.emojiBtn:SetOnClick(function()
    self:OnCLickEmoji()
  end)
end

function UIChatViewEmojiItem:OnCLickEmoji()
  if ChatInterface.IsUnlockEmojiInput() then
    EventManager:GetInstance():Broadcast(EventId.Chat_Emoji_Clcik, {
      text = self.emoji.name,
      mobilInputId = self.mobilInputId
    })
  else
    self.view.ctrl:SendMessage("<lwEmoji:" .. self.emoji.id .. ":>", 0, PostType.Text_Normal, {isSendEmoji = true})
    if ChatInterface.IsTranslateAllOpen() and self.view and self.view.middle and self.view.middle.scrollMsgs then
      self.view.middle.scrollMsgs:ScrollToTail()
    end
  end
  DataCenter.ChatEmojiManager:SaveRecentUseEmoji(self.emoji.id)
end

function UIChatViewEmojiItem:ReInit(emoji, mobilInputId)
  self.emoji = emoji
  self.mobilInputId = mobilInputId
  self.emojiImg:LoadSprite(emoji.path)
end

function UIChatViewEmojiItem:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIChatViewEmojiItem:UpdateItems()
end

return UIChatViewEmojiItem
