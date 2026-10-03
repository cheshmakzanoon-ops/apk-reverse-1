local ChatItem = require("UI.UIChatNew.Component.ChatItem.ChatItem")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local ChatItemRight_Normal = BaseClass("ChatItemRight_Normal", ChatItem)
local ChatItemReplyNode = require("UI.UIChatNew.Component.ChatItem.ChatItemReplyNode")
local base = ChatItem
local Localization = CS.GameEntry.Localization
local _cp_anchorTransform = "ChatAnchor"
local _cp_chatShareNode = "ChatAnchor/ChatShareNode"
local _cp_bgImg = "ChatAnchor/Background"
local _cp_chatNormalBg = "ChatAnchor/Background/NormalBg"
local _cp_dlgText = "ChatAnchor/Background/DialogText"
local _cp_chatUserName = "ChatNameLayout"
local _cp_chatShareTitle = "ChatAnchor/ChatShareNode/Image/ShareTitle"
local _cp_chatShareIcon = "ChatAnchor/ChatShareNode/Image/Icon"
local _cp_chatShareSpecialIcon = "ChatAnchor/ChatShareNode/Image/SpecialIcon"
local _cp_chatShareSubTitle = "ChatAnchor/ChatShareNode/Image/SubTitle"
local _cp_chatShareMsg = "ChatAnchor/ChatShareNode/ShareIconNode/ShareMsg/ShareMsg"
local _cp_chatShareMsgNode = "ChatAnchor/ChatShareNode/ShareIconNode/ShareMsg"
local click_obj_path = "ChatAnchor/Background/clickObj"
local up_btn_path = "ChatAnchor/Background/clickObj/good"
local down_btn_path = "ChatAnchor/Background/clickObj/bad"
local up_img_path = "ChatAnchor/Background/clickObj/good/goodIcon"
local up_num_path = "ChatAnchor/Background/clickObj/good/goodNum"
local down_img_path = "ChatAnchor/Background/clickObj/bad/badIcon"
local down_num_path = "ChatAnchor/Background/clickObj/bad/badNum"
local emojiImg_path = "ChatAnchor/Background/EmojiImg"
local emoji_like_layout = "EmojiLikeLayout"
local emoji_like_item = "EmojiLikeLayout/EmojiLikeItem"
local bubble_default_path = "ChatAnchor/Background/bubbleDefault"
local bubble_special_path = "ChatAnchor/Background/bubbleSpecial"

function ChatItemRight_Normal:ComponentDefine()
  base.ComponentDefine(self)
  self._rectTransform = self.rectTransform
  self._anchorTransform = self.transform:Find(_cp_anchorTransform):GetComponent(typeof(CS.UnityEngine.RectTransform))
  self._chatShareNode = self:AddComponent(UIButton, _cp_chatShareNode)
  self._bgImg = self:AddComponent(UIImage, _cp_bgImg)
  self._chatNormalBg = self:AddComponent(UIImage, _cp_chatNormalBg)
  local component = ChatInterface.isTestingServer() and UITextMeshProUGUIEx or UIText
  self._dlgText = self:AddComponent(component, _cp_dlgText)
  self._chatShareTitle = self:AddComponent(UIText, _cp_chatShareTitle)
  self._chatShareSubTitle = self:AddComponent(UIText, _cp_chatShareSubTitle)
  self._chatShareIcon = self:AddComponent(UIImage, _cp_chatShareIcon)
  self._chatShareMsg = self:AddComponent(UITextMeshProUGUIEx, _cp_chatShareMsg)
  self._chatShareMsgNode = self:AddComponent(UIBaseContainer, _cp_chatShareMsgNode)
  self._chatUserName = self:AddComponent(ChatUserName, _cp_chatUserName)
  self.upObj = self:AddComponent(UIBaseContainer, click_obj_path)
  self.upNode = self:AddComponent(UIButton, up_btn_path)
  self.upNode:SetOnClick(BindCallback(self, self.OnUp))
  self.up_anim = self:AddComponent(UIAnimator, up_img_path)
  self.down_anim = self:AddComponent(UIAnimator, down_img_path)
  self.downNode = self:AddComponent(UIButton, down_btn_path)
  self.downNode:SetOnClick(BindCallback(self, self.OnDown))
  self.up_num = self:AddComponent(UIText, up_num_path)
  self.down_num = self:AddComponent(UIText, down_num_path)
  self.emoji_img = self:AddComponent(UIImage, emojiImg_path)
  self.emoji_like_layout = self:AddComponent(UIBaseContainer, emoji_like_layout)
  self.emoji_like_item = self:AddComponent(UIBaseContainer, emoji_like_item)
  self.emoji_like_item.gameObject:GameObjectCreatePool()
  self.btnNormalMsg = self:AddComponent(UIButton, "ChatAnchor/Background")
  self._replyNode = self:AddComponent(ChatItemReplyNode, "ChatAnchor/Background/ReplyNode")
  self.bubbleDefault = self:AddComponent(UIImage, bubble_default_path)
  self.bubbleSpecial = self:AddComponent(UIImage, bubble_special_path)
  if not IsNull(self.transform:Find(_cp_chatShareSpecialIcon)) then
    self._chatShareSpecialIcon = self:AddComponent(UIImage, _cp_chatShareSpecialIcon)
    self._chatShareSpecialIcon:SetActive(false)
  end
  local bubbleRes, msgColor, replyColor = DataCenter.DecorationDataManager:GetSelfChatBubbleAndMsgColor()
  if bubbleRes then
    self.bubbleDefault:SetActive(false)
    self.bubbleSpecial:SetActive(true)
    self.bubbleSpecial:LoadSprite(bubbleRes)
    if self._replyNode and replyColor then
      self._replyNode:SetReplyTextColor(replyColor)
      self._replyNode:SetReplyTextAlpha(1)
    end
    self._dlgText:SetColor(msgColor)
  else
    self.bubbleDefault:SetActive(true)
    self.bubbleSpecial:SetActive(false)
    self._dlgText:SetColor(DefaultChatMsgColor)
    if self._replyNode then
      self._replyNode:SetReplyTextColor(DefaultChatRePlyMsgColor)
      self._replyNode:SetReplyTextAlpha(1)
    end
  end
  if ChatInterface.isTestingServer() then
    ChatInterface.SetEmojiTextProperty(self._dlgText)
  end
end

function ChatItemRight_Normal:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:AddBtnClick()
end

return ChatItemRight_Normal
