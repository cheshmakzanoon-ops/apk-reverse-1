local base = UIBaseContainer
local UIChatViewEmojiTabItem = BaseClass("UIChatViewEmojiTabItem", base)
local logger = require("Framework.Logger.Logger")
local compBook = {
  {
    path = "ActiveBg",
    name = "_ActiveBg",
    type = UIBaseComponent
  },
  {
    path = "ImgIcon",
    name = "_ImgIcon",
    type = UIImage
  },
  {
    path = "",
    name = "_BtnTab",
    type = UIButton,
    onClick = function(self)
      self:OnBtnSelectTab()
    end
  }
}

function UIChatViewEmojiTabItem:OnCreate()
  base.OnCreate(self)
  self:DefineCompsByBook(compBook)
  self.emojiTabCfg = nil
end

function UIChatViewEmojiTabItem:OnDestroy()
  self:ClearCompsByBook(compBook)
  self.emojiTabCfg = nil
  base.OnDestroy(self)
end

function UIChatViewEmojiTabItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CHAT_REFRESH_EMOJI_TAB_BY_TYPE, self.RefreshSelectedState)
end

function UIChatViewEmojiTabItem:OnRemoveListener()
  self:RemoveUIListener(EventId.CHAT_REFRESH_EMOJI_TAB_BY_TYPE, self.RefreshSelectedState)
  base.OnRemoveListener(self)
end

function UIChatViewEmojiTabItem:InitView(curActiveEmojiTabCfg)
  if curActiveEmojiTabCfg == nil then
    return
  end
  self.emojiTabCfg = curActiveEmojiTabCfg
  self._ImgIcon:LoadSprite(curActiveEmojiTabCfg.getImageFunc())
end

function UIChatViewEmojiTabItem:RefreshSelectedState(curActiveEmojiTabCfg)
  self._ActiveBg:SetActive(self.emojiTabCfg == curActiveEmojiTabCfg)
end

function UIChatViewEmojiTabItem:OnBtnSelectTab()
  EventManager:GetInstance():Broadcast(EventId.CHAT_REFRESH_EMOJI_TAB_BY_TYPE, self.emojiTabCfg)
end

return UIChatViewEmojiTabItem
