local base = UIBaseContainer
local EastereggChaEmojiItem = BaseClass("EastereggChaEmojiItem", UIBaseContainer)
local M = EastereggChaEmojiItem
local maxCountText = "99+"
local maxCount = 99

function M:OnCreate()
  base.OnCreate(self)
  self.emojiData = nil
  self.parent = nil
  self:ComponentDefine()
end

function M:ComponentDefine()
  self.icon_img = self:AddComponent(UIImage, "icon")
  self.self_img = self:AddComponent(UIImage, "self")
  self.count_text = self:AddComponent(UITextMeshProUGUIEx, "count")
  self.btn = self:AddComponent(UIButton, "")
  self.bg = self:AddComponent(UIImage, "")
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.compIsPosterLike = self:AddComponent(UIBaseContainer, "isPosterLike")
end

function M:ComponentDestroy()
  self.icon_img = nil
  self.self_img = nil
  self.count_text = nil
  self.btn = nil
  self.compIsPosterLike = nil
end

function M:UpdateData(emojiData, parent, isPosterLike, emojiWidth)
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
  self.bg:LoadSprite("Assets/Main/ActivityRes/2025EasterMod/Sprites/UI/LWUIActEasterEggChat/lrb_FHJ_dianzan_bg.png")
  local finalWidth = emojiWidth
  self.compIsPosterLike:SetActive(isPosterLike)
  self:SetSizeDeltaX(finalWidth)
end

function M:OnDestroy()
  self.emojiData = nil
  self.parent = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:OnEnable()
  base.OnEnable(self)
end

function M:OnDisable()
  base.OnDisable(self)
end

function M:OnClick()
  if not self.parent then
    return
  end
  if self.emojiData.self == 1 then
    UIUtil.ShowTipsId("activity_99144_9")
    return
  end
  self.parent:OnClickEmoji(self.emojiData.emoji)
end

return M
