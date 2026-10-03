local SeasonPhotoEmojiItem = BaseClass("SeasonPhotoEmojiItem", UIBaseContainer)
local base = UIBaseContainer
local maxCountText = "99+"
local maxCount = 99
local ChatEmojiLikePath = {
  "ChatWindow/icon_great_light.png",
  "ChatWindow/mjc_liaotiangonggao_sahua.png"
}

function SeasonPhotoEmojiItem:OnCreate()
  base.OnCreate(self)
  self.emojiData = nil
  self.parent = nil
  self:ComponentDefine()
end

function SeasonPhotoEmojiItem:ComponentDefine()
  self.icon_img = self:AddComponent(UIImage, "icon")
  self.self_img = self:AddComponent(UIImage, "self")
  self.count_text = self:AddComponent(UITextMeshProUGUIEx, "count")
  self.btn = self:AddComponent(UIButton, "")
  self.bg = self:AddComponent(UIImage, "")
  self.btn:SetOnClick(function()
    if not self.parent then
      return
    end
    if self.emojiData.hasThumbs then
      UIUtil.ShowTipsId("season_alliance_photo_tips_33")
      return
    end
    self.parent:OnClickEmoji(self.emojiData.thumbsType)
  end)
end

function SeasonPhotoEmojiItem:ComponentDestroy()
  self.icon_img = nil
  self.self_img = nil
  self.count_text = nil
  self.btn = nil
end

function SeasonPhotoEmojiItem:UpdateData(emojiData, parent)
  self.emojiData = emojiData
  self.parent = parent
  if not (self.emojiData and self.parent and self.emojiData.thumbsCount) or self.emojiData.thumbsCount <= 0 then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.icon_img:LoadSprite(ChatInterface.GetChatUIPath(ChatEmojiLikePath[self.emojiData.thumbsType]))
  if self.emojiData.thumbsCount > maxCount then
    self.count_text:SetText(maxCountText)
  else
    self.count_text:SetText(self.emojiData.thumbsCount)
  end
  if self.emojiData.hasThumbs then
    self.self_img:SetActive(true)
  else
    self.self_img:SetActive(false)
  end
  self.bg:LoadSprite(ChatInterface.GetChatUIPath("ChatNotice/zyf_liaotian_tiao1.png"))
end

function SeasonPhotoEmojiItem:OnDestroy()
  self.emojiData = nil
  self.parent = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonPhotoEmojiItem:OnEnable()
  base.OnEnable(self)
end

function SeasonPhotoEmojiItem:OnDisable()
  base.OnDisable(self)
end

return SeasonPhotoEmojiItem
