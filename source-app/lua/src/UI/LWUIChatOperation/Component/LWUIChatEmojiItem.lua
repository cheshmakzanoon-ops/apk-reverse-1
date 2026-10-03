local LWUIChatEmojiItem = BaseClass("LWUIChatEmojiItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function LWUIChatEmojiItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWUIChatEmojiItem:ComponentDefine()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "bg")
  self.icon = self:AddComponent(UIImage, "icon")
  self.countText = self:AddComponent(UITextMeshProUGUIEx, "count")
  self.btn = self:AddComponent(UIButton, "btn")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.bg:LoadSprite(ChatInterface.GetChatUIPath("ChatWindow/zyf_reaction_dichen1.png"))
end

function LWUIChatEmojiItem:OnBtnClick()
  self.view:OnEmojiItemClick(self.index)
end

function LWUIChatEmojiItem:UpdateItem(data, index)
  self.index = index + 1
  self.countText:SetText(data.count)
  self.icon:LoadSprite(ChatInterface.GetChatUIPath(ChatEmojiLikePath[data.emoji]))
  self.bg:SetActive(false)
end

function LWUIChatEmojiItem:SetClickBg(index)
  self.bg:SetActive(self.index == index)
end

function LWUIChatEmojiItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIChatEmojiItem:DataDestroy()
end

function LWUIChatEmojiItem:ComponentDestroy()
  self.btnComponents = {}
end

return LWUIChatEmojiItem
