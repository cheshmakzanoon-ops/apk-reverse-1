local base = UIBaseContainer
local UIActValentineMatchEmojiItem = BaseClass("UIActValentineMatchEmojiItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIActValentineMatchEmojiItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActValentineMatchEmojiItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActValentineMatchEmojiItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnEmoji = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnEmoji:SetOnClick(function()
    self:OnBtnEmojiClick()
  end)
  self.imgEmoji = self.viewSkin:AddComponent(self, UIImage, 2)
end

function UIActValentineMatchEmojiItem:ComponentDestroy()
  self.btnEmoji = nil
  self.imgEmoji = nil
end

function UIActValentineMatchEmojiItem:DataDefine()
  self.emojiId = nil
end

function UIActValentineMatchEmojiItem:DataDestroy()
  self.emojiId = nil
end

function UIActValentineMatchEmojiItem:OnAddListener()
  base.OnAddListener(self)
end

function UIActValentineMatchEmojiItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActValentineMatchEmojiItem:OnBtnEmojiClick()
  if self.clickFunc then
    self.clickFunc()
  end
end

function UIActValentineMatchEmojiItem:ReInit(data)
  if not data then
    return
  end
  self.emojiId = data.emojiId
  self.clickFunc = data.onClick
  local line = LocalController:instance():getLine(TableName.LW_EMOJI, data.emojiId)
  if line and line.path then
    self.imgEmoji:LoadSpriteAsync("Assets/Main/Sprites/UI/LWChatEmoji/Default/" .. line.path .. ".png")
  end
end

return UIActValentineMatchEmojiItem
