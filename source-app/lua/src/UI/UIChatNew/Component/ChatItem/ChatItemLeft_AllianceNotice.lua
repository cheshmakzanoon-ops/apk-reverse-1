local ChatItem = require("UI.UIChatNew.Component.ChatItem.ChatItem")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local ChatItemLeft_AllianceNotice = BaseClass("ChatItemLeft_AllianceNotice", ChatItem)
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
local _cp_chatShareMsg = "ChatAnchor/ChatShareNode/ShareIconNode/ShareMsg/ShareMsg"
local _cp_chatShareMsgNode = "ChatAnchor/ChatShareNode/ShareIconNode/ShareMsg"
local translate_btn_path = "ChatAnchor/Background/NormalBg/TranslateBtn"
local translate_finish_path = "ChatAnchor/Background/NormalBg/TranslateFinishImg"
local translating_content_path = "ChatAnchor/Background/NormalBg/Translating"
local translating_text_path = "ChatAnchor/Background/NormalBg/Translating/TranslatingText"
local emoji_like_layout = "EmojiLikeLayout"
local emoji_like_item = "EmojiLikeLayout/EmojiLikeItem"
local _notice_title_path = "ChatAnchor/Background/NormalBg/bar/txtTitle"

function ChatItemLeft_AllianceNotice:ComponentDefine()
  base.ComponentDefine(self)
  self._rectTransform = self.rectTransform
  self._anchorTransform = self.transform:Find(_cp_anchorTransform):GetComponent(typeof(CS.UnityEngine.RectTransform))
  self._chatShareNode = self:AddComponent(UIButton, _cp_chatShareNode)
  self._chatShareTitle = self:AddComponent(UIText, _cp_chatShareTitle)
  self._chatShareMsg = self:AddComponent(UITextMeshProUGUIEx, _cp_chatShareMsg)
  self._chatShareMsgNode = self:AddComponent(UIBaseContainer, _cp_chatShareMsgNode)
  self._bgImg = self:AddComponent(UIImage, _cp_bgImg)
  self._chatNormalBg = self:AddComponent(UIImage, _cp_chatNormalBg)
  self._dlgText = self:AddComponent(UITextMeshProUGUIEx, _cp_dlgText)
  self._dividingLine = self:AddComponent(UIImage, _cp_dividingLine)
  self._traText = self:AddComponent(UIText, _cp_traText)
  self._chatUserName = self:AddComponent(ChatUserName, _cp_chatUserName)
  self.titleBg = self:AddComponent(UIImage, "ChatAnchor/Background/NormalBg/bar")
  self.titleText = self:AddComponent(UIText, "ChatAnchor/Background/NormalBg/bar/txtTitle")
  self.translateBtn = self:AddComponent(UIButton, translate_btn_path)
  self.translateFinishImg = self:AddComponent(UIBaseContainer, translate_finish_path)
  self.translating = self:AddComponent(UIBaseContainer, translating_content_path)
  self.translatingText = self:AddComponent(UITextMeshProUGUIEx, translating_text_path)
  self.translatingText:SetText(Localization:GetString("120039"))
  self.btnNormalMsg = self:AddComponent(UIButton, "ChatAnchor/Background")
  self.emoji_like_layout = self:AddComponent(UIBaseContainer, emoji_like_layout)
  self.emoji_like_item = self:AddComponent(UIBaseContainer, emoji_like_item)
  self.emoji_like_item.gameObject:GameObjectCreatePool()
  self.translateBtn:SetOnClick(function()
    self:OnTranslationBtn()
  end)
  self._noticeTitle = self:AddComponent(UITextMeshProUGUIEx, _notice_title_path)
  self._noticeTitle:SetText(Localization:GetString(2900001))
  self._chat_item_width_fix = 510
  self._chat_item_height_add = 50
end

function ChatItemLeft_AllianceNotice:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:AddBtnClick()
end

function ChatItemLeft_AllianceNotice:UpdateItem(chatData, index)
  base.UpdateItem(self, chatData, index)
  local path, key
  if chatData.extra.noticeType == ChatNoticeType.ALLIANCE_VOTE then
    path = ChatInterface.GetChatUIPath("ChatNotice/zyf_tongmenggonggao_gonggaokuang_biaoti.png")
    key = "alliance_post_poll"
  else
    path = ChatInterface.GetChatUIPath("ChatNotice/sj_liaotian_gonggaobg.png")
    key = "2900001"
  end
  self.titleBg:LoadSprite(path)
  self.titleText:SetLocalText(key)
end

function ChatItemLeft_AllianceNotice:UpdateTranslateBtnState(isTranslating, hasTranslated)
  base.UpdateTranslateBtnState(self)
  if self.translateBtn == nil then
    return
  end
  self.translating:SetActive(isTranslating and not hasTranslated)
  self.translateBtn:SetActive(not isTranslating and not hasTranslated)
  self.translateFinishImg:SetActive(hasTranslated)
end

function ChatItemLeft_AllianceNotice:ResetTranslatePart()
  base.ResetTranslatePart(self)
  if self.translateBtn == nil then
    return
  end
  self.translateBtn:SetActive(false)
  self.translateFinishImg:SetActive(false)
  self.translating:SetActive(false)
  self._traText:SetActive(false)
end

return ChatItemLeft_AllianceNotice
