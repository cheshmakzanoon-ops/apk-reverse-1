local ChatItem = require("UI.UIChatNew.Component.ChatItem.ChatItem")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local ChatItemRight_AllianceNotice = BaseClass("ChatItemRight_AllianceNotice", ChatItem)
local base = ChatItem
local Localization = CS.GameEntry.Localization
local _cp_anchorTransform = "ChatAnchor"
local _cp_chatShareNode = "ChatAnchor/ChatShareNode"
local _cp_bgImg = "ChatAnchor/Background"
local _cp_chatNormalBg = "ChatAnchor/Background/NormalBg"
local _cp_dlgText = "ChatAnchor/Background/DialogText"
local _cp_chatUserName = "ChatNameLayout"
local _cp_chatShareTitle = "ChatAnchor/ChatShareNode/Image/ShareTitle"
local _cp_chatShareMsg = "ChatAnchor/ChatShareNode/ShareIconNode/ShareMsg/ShareMsg"
local _cp_chatShareMsgNode = "ChatAnchor/ChatShareNode/ShareIconNode/ShareMsg"
local _notice_title_path = "ChatAnchor/Background/NormalBg/bar/txtTitle"
local emoji_like_layout = "EmojiLikeLayout"
local emoji_like_item = "EmojiLikeLayout/EmojiLikeItem"

function ChatItemRight_AllianceNotice:ComponentDefine()
  base.ComponentDefine(self)
  self._rectTransform = self.rectTransform
  self._anchorTransform = self.transform:Find(_cp_anchorTransform):GetComponent(typeof(CS.UnityEngine.RectTransform))
  self._chatShareNode = self:AddComponent(UIButton, _cp_chatShareNode)
  self.titleBg = self:AddComponent(UIImage, "ChatAnchor/Background/NormalBg/bar")
  self.titleText = self:AddComponent(UIText, "ChatAnchor/Background/NormalBg/bar/txtTitle")
  self._bgImg = self:AddComponent(UIImage, _cp_bgImg)
  self._chatNormalBg = self:AddComponent(UIImage, _cp_chatNormalBg)
  self._dlgText = self:AddComponent(UITextMeshProUGUIEx, _cp_dlgText)
  self._chatShareTitle = self:AddComponent(UIText, _cp_chatShareTitle)
  self._chatShareMsg = self:AddComponent(UITextMeshProUGUIEx, _cp_chatShareMsg)
  self._chatShareMsgNode = self:AddComponent(UIBaseContainer, _cp_chatShareMsgNode)
  self._dividingLine = nil
  self._traText = nil
  self._translation = nil
  self._translationButton = nil
  self._chatUserName = self:AddComponent(ChatUserName, _cp_chatUserName)
  self._noticeTitle = self:AddComponent(UITextMeshProUGUIEx, _notice_title_path)
  self._noticeTitle:SetText(Localization:GetString(2900001))
  self.btnNormalMsg = self:AddComponent(UIButton, "ChatAnchor/Background")
  self.emoji_like_layout = self:AddComponent(UIBaseContainer, emoji_like_layout)
  self.emoji_like_item = self:AddComponent(UIBaseContainer, emoji_like_item)
  self.emoji_like_item.gameObject:GameObjectCreatePool()
  self._chat_item_width_fix = 510
  self._chat_item_height_add = 50
end

function ChatItemRight_AllianceNotice:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:AddBtnClick()
end

function ChatItemRight_AllianceNotice:UpdateItem(chatData, index)
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

return ChatItemRight_AllianceNotice
