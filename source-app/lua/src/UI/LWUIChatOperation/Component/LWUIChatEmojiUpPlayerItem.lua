local LWUIChatEmojiUpPlayerItem = BaseClass("LWUIChatEmojiUpPlayerItem", UIBaseContainer)
local base = UIBaseContainer
local UIChatHead = require("UI.UIChatNew.Component.ChatHead")

function LWUIChatEmojiUpPlayerItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWUIChatEmojiUpPlayerItem:ComponentDefine()
  base.OnCreate(self)
  self.head = self:AddComponent(UIChatHead, "ChatHead")
  self.nameText = self:AddComponent(UITextMeshProUGUIEx, "nameText")
end

function LWUIChatEmojiUpPlayerItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerMessageInfo, self.OnChatUserInfoUpdate)
end

function LWUIChatEmojiUpPlayerItem:OnRemoveListener()
  self:RemoveUIListener(EventId.PlayerMessageInfo, self.OnChatUserInfoUpdate)
  base.OnRemoveListener(self)
end

function LWUIChatEmojiUpPlayerItem:SetContentViewScript()
end

function LWUIChatEmojiUpPlayerItem:OnChatUserInfoUpdate(uid)
  if self.uid and self.uid == uid then
    local userInfo = ChatInterface.getUserData(uid)
    if userInfo then
      self.nameText:SetText(userInfo:GetUserName())
      self.head:UpdateHead(userInfo, {})
    end
  end
end

function LWUIChatEmojiUpPlayerItem:UpdateItem(data)
  self.uid = data.uid
  local userInfo = ChatInterface.getUserData(data.uid)
  self.head:UpdateHead(userInfo, {})
  self.nameText:SetText(userInfo:GetUserName())
end

function LWUIChatEmojiUpPlayerItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIChatEmojiUpPlayerItem:DataDestroy()
  self.uid = nil
end

function LWUIChatEmojiUpPlayerItem:ComponentDestroy()
  self.head = nil
  self.nameText = nil
end

return LWUIChatEmojiUpPlayerItem
