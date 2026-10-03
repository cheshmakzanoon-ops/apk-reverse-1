local ChatItem = require("UI.UIChatNew.Component.ChatItem.ChatItem")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local ChatItemReplyNode = require("UI.UIChatNew.Component.ChatItem.ChatItemReplyNode")
local ChatItemNoticeRemark_Left = BaseClass("ChatItemNoticeRemark_Left", ChatItem)
local base = ChatItem
local Localization = CS.GameEntry.Localization
local _cp_anchorTransform = "ChatAnchor"
local _cp_chatShareNode = "ChatAnchor/ChatShareNode"
local _cp_bgImg = "ChatAnchor/Background"
local _cp_chatNormalBg = "ChatAnchor/Background/NormalBg"
local _cp_dlgText = "ChatAnchor/Background/DialogText"
local _cp_dividingLine = "ChatAnchor/Background/DialogText/Image"
local _cp_traText = "ChatAnchor/Background/TranslateText"
local _cp_chatUserName = "ChatNameLayout"
local _cp_chatShareTitle = "ChatAnchor/ChatShareNode/Image/ShareTitle"
local _cp_chatShareIcon = "ChatAnchor/ChatShareNode/Image/Icon"
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
local special_frame_path = "ChatAnchor/Background/specialFrame"
local translate_btn_path = "ChatAnchor/Background/NormalBg/TranslateBtn"
local translate_finish_path = "ChatAnchor/Background/NormalBg/TranslateFinishImg"
local translating_content_path = "ChatAnchor/Background/NormalBg/Translating"
local translating_text_path = "ChatAnchor/Background/NormalBg/Translating/TranslatingText"
local emojiImg_path = "ChatAnchor/Background/EmojiImg"
local bubble_default_path = "ChatAnchor/Background/bubbleDefault"
local bubble_special_path = "ChatAnchor/Background/bubbleSpecial"
local emoji_like_layout = "EmojiLikeLayout"
local emoji_like_item = "EmojiLikeLayout/EmojiLikeItem"

function ChatItemNoticeRemark_Left:ComponentDefine()
  base.ComponentDefine(self)
  self._rectTransform = self.rectTransform
  self._anchorTransform = self.transform:Find(_cp_anchorTransform):GetComponent(typeof(CS.UnityEngine.RectTransform))
  self._chatShareNode = self:AddComponent(UIButton, _cp_chatShareNode)
  self._chatShareTitle = self:AddComponent(UIText, _cp_chatShareTitle)
  self._chatShareSubTitle = self:AddComponent(UIText, _cp_chatShareSubTitle)
  self._chatShareIcon = self:AddComponent(UIImage, _cp_chatShareIcon)
  self._chatShareMsg = self:AddComponent(UITextMeshProUGUIEx, _cp_chatShareMsg)
  self._chatShareMsgNode = self:AddComponent(UIBaseContainer, _cp_chatShareMsgNode)
  self._bgImg = self:AddComponent(UIImage, _cp_bgImg)
  self._chatNormalBg = self:AddComponent(UIImage, _cp_chatNormalBg)
  local dlgComponent = ChatInterface.isTestingServer() and UITextMeshProUGUIEx or UIText
  self._dlgText = self:AddComponent(dlgComponent, _cp_dlgText)
  self._dividingLine = self:AddComponent(UIImage, _cp_dividingLine)
  local traComponent = ChatInterface.isTestingServer() and UITextMeshProUGUIEx or UIText
  self._traText = self:AddComponent(traComponent, _cp_traText)
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
  self.translateBtn = self:AddComponent(UIButton, translate_btn_path)
  self.translateFinishImg = self:AddComponent(UIBaseContainer, translate_finish_path)
  self.translating = self:AddComponent(UIBaseContainer, translating_content_path)
  self.translatingText = self:AddComponent(UIText, translating_text_path)
  self.translatingText:SetText(Localization:GetString("120039"))
  self.emoji_img = self:AddComponent(UIImage, emojiImg_path)
  self.btnNormalMsg = self:AddComponent(UIButton, "ChatAnchor/Background")
  self.emoji_like_layout = self:AddComponent(UIBaseContainer, emoji_like_layout)
  self.emoji_like_item = self:AddComponent(UIBaseContainer, emoji_like_item)
  self.emoji_like_item.gameObject:GameObjectCreatePool()
  self.translateBtn:SetOnClick(function()
    self:OnTranslationBtn()
  end)
  self._replyNode = self:AddComponent(ChatItemReplyNode, "ChatAnchor/Background/ReplyNode")
  if ChatInterface.isTestingServer() then
    ChatInterface.SetEmojiTextProperty(self._dlgText)
    ChatInterface.SetEmojiTextProperty(self._traText)
  end
  self.bubbleDefault = self:AddComponent(UIImage, bubble_default_path)
  self.bubbleSpecial = self:AddComponent(UIImage, bubble_special_path)
  self.remarkTimeText = self:AddComponent(UIText, "RemarkTimeText")
  self:ChangeBubble(nil, nil)
end

function ChatItemNoticeRemark_Left:ChangeBubble(bubbleId, bubbleET)
  local bubbleRes, msgColor, replyColor = DataCenter.DecorationDataManager:GetChatBubbleAndMsgColor(bubbleId, bubbleET)
  if bubbleRes then
    self.bubbleDefault:SetActive(false)
    self.bubbleSpecial:SetActive(true)
    self.bubbleSpecial:LoadSprite(bubbleRes)
    self._dlgText:SetColor(msgColor)
    self._traText:SetColor(msgColor)
    if self._replyNode and replyColor then
      self._replyNode:SetReplyTextColor(replyColor)
      self._replyNode:SetReplyTextAlpha(1)
    end
    self._dividingLine:SetColor(Color.New(replyColor.r, replyColor.g, replyColor.b, 1))
  else
    self.bubbleDefault:SetActive(true)
    self.bubbleSpecial:SetActive(false)
    self._dlgText:SetColor(DefaultChatMsgColor)
    self._traText:SetColor(DefaultChatMsgColor)
    self._dividingLine:SetColor(Color.New(DefaultChatMsgColor.r, DefaultChatMsgColor.g, DefaultChatMsgColor.b, 0.5))
  end
end

function ChatItemNoticeRemark_Left:UpdateUserInfoWithNew()
  base.UpdateUserInfoWithNew(self)
  if self._userInfo then
    self:ChangeBubble(self._userInfo.chatBubbleId, self._userInfo.chatBubbleET)
  end
end

function ChatItemNoticeRemark_Left:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:AddBtnClick()
end

function ChatItemNoticeRemark_Left:UpdateTranslateBtnState(isTranslating, hasTranslated)
  base.UpdateTranslateBtnState(self)
  if self.translateBtn == nil then
    return
  end
  self.translating:SetActive(isTranslating and not hasTranslated)
  self.translateBtn:SetActive(not isTranslating and not hasTranslated)
  self.translateFinishImg:SetActive(hasTranslated)
end

function ChatItemNoticeRemark_Left:ResetTranslatePart()
  base.ResetTranslatePart(self)
  if self.translateBtn == nil then
    return
  end
  self.translateBtn:SetActive(false)
  self.translateFinishImg:SetActive(false)
  self.translating:SetActive(false)
  self._traText:SetActive(false)
end

return ChatItemNoticeRemark_Left
