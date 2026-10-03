local ChatDataEmojiItem2 = BaseClass("ChatDataEmojiItem2", UIBaseContainer)
local base = UIBaseContainer
local maxCountText = "99+"
local maxCount = 99
local twoDigitLength = 29
local threeDigitLength = 39

function ChatDataEmojiItem2:OnCreate()
  base.OnCreate(self)
  self.emojiData = nil
  self.parent = nil
  self:ComponentDefine()
end

function ChatDataEmojiItem2:ComponentDefine()
  self.icon_img = self:AddComponent(UIImage, "layout/icon")
  self.self_img = self:AddComponent(UIImage, "self")
  self.count_text = self:AddComponent(UITextMeshProUGUIEx, "layout/count")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    if not self.parent then
      return
    end
    self.parent:OnClickEmoji(self.emojiData.emoji)
  end)
end

function ChatDataEmojiItem2:ComponentDestroy()
  self.icon_img = nil
  self.self_img = nil
  self.count_text = nil
  self.btn = nil
end

function ChatDataEmojiItem2:UpdateData(emojiData, parent)
  self.emojiData = emojiData
  self.parent = parent
  if not (self.emojiData and self.parent) or not self.emojiData.count then
    return
  end
  self.icon_img:LoadSprite(ChatInterface.GetChatUIPath(ChatEmojiLikePath[self.emojiData.emoji]))
  self.count_text:SetActive(self.emojiData.count > 0)
  if self.emojiData.count > maxCount then
    self.count_text:SetText(maxCountText)
    self.count_text:SetSizeDeltaX(threeDigitLength)
  else
    self.count_text:SetText(self.emojiData.count)
    self.count_text:SetSizeDeltaX(twoDigitLength)
  end
  if self.emojiData.self == 1 then
    self.self_img:SetActive(true)
  else
    self.self_img:SetActive(false)
  end
end

function ChatDataEmojiItem2:OnDestroy()
  self.emojiData = nil
  self.parent = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ChatDataEmojiItem2:OnEnable()
  base.OnEnable(self)
end

function ChatDataEmojiItem2:OnDisable()
  base.OnDisable(self)
end

return ChatDataEmojiItem2
