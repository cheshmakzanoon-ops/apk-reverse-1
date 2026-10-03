local base = UIBaseContainer
local UIChatViewEmojiAreaItem_v2 = BaseClass("UIChatViewEmojiAreaItem_v2", base)
local compBook = {
  {
    path = "",
    name = "btnItem",
    type = UIButton,
    onClick = function(self)
      self:OnClick()
    end
  },
  {
    path = "imgEmoji",
    name = "imgEmoji",
    type = UIImage
  }
}

function UIChatViewEmojiAreaItem_v2:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIChatViewEmojiAreaItem_v2:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChatViewEmojiAreaItem_v2:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIChatViewEmojiAreaItem_v2:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIChatViewEmojiAreaItem_v2:UpdateItem(emoji, idx)
  self.emoji = emoji
  self.imgEmoji:LoadSprite(emoji.path)
end

function UIChatViewEmojiAreaItem_v2:OnClick()
  self.view.ctrl:SendMessage("<lwEmoji:" .. self.emoji.id .. ":>", 0, PostType.Text_Normal, {isSendEmoji = true})
end

return UIChatViewEmojiAreaItem_v2
