local ChatDataEmojiItem = BaseClass("ChatDataEmojiItem", UIBaseContainer)
local base = UIBaseContainer
local maxCountText = "99+"
local maxCount = 99
local emojiOtherBg = "Assets/Main/Sprites/UI/UIChatNew1/zyf_liaotian_tiao1.png"
local emojiBg = "Assets/Main/Sprites/UI/UIChatNew1/zyf_liaotian_tiao1.png"

function ChatDataEmojiItem:OnCreate()
  base.OnCreate(self)
  self.emojiData = nil
  self.parent = nil
  self:ComponentDefine()
end

function ChatDataEmojiItem:ComponentDefine()
  self.icon_img = self:AddComponent(UIImage, "icon")
  self.self_img = self:AddComponent(UIImage, "self")
  self.count_text = self:AddComponent(UITextMeshProUGUIEx, "count")
  self.btn = self:AddComponent(UIButton, "")
  self.bg = self:AddComponent(UIImage, "")
  self.btn:SetOnClick(function()
    if not self.parent then
      return
    end
    self.parent:OnClickEmoji(self.emojiData.emoji)
  end)
end

function ChatDataEmojiItem:ComponentDestroy()
  self.icon_img = nil
  self.self_img = nil
  self.count_text = nil
  self.btn = nil
end

function ChatDataEmojiItem:UpdateData(emojiData, parent)
  self.emojiData = emojiData
  self.parent = parent
  if not (self.emojiData and self.parent) or not self.emojiData.count then
    return
  end
  self.icon_img:LoadSprite(ChatInterface.GetChatUIPath(ChatEmojiLikePath[self.emojiData.emoji]))
  if self.emojiData.count > maxCount then
    self.count_text:SetText(maxCountText)
  else
    self.count_text:SetText(self.emojiData.count)
  end
  if self.emojiData.self == 1 then
    self.self_img:SetActive(true)
  else
    self.self_img:SetActive(false)
  end
  self.bg:LoadSprite(ChatInterface.GetChatUIPath("ChatNotice/zyf_liaotian_tiao1.png"))
end

function ChatDataEmojiItem:OnDestroy()
  self.emojiData = nil
  self.parent = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ChatDataEmojiItem:OnEnable()
  base.OnEnable(self)
end

function ChatDataEmojiItem:OnDisable()
  base.OnDisable(self)
end

return ChatDataEmojiItem
