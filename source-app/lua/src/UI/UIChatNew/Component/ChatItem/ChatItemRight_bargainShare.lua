local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemRight_bargainShare = BaseClass("ChatItemRight_bargainShare", IChatItem)
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local base = IChatItem

function ChatItemRight_bargainShare:ComponentDefine()
  self._chatHead = self:AddComponent(ChatHead, "ChatHead")
  self._chatUserName = self:AddComponent(ChatUserName, "ChatNameLayout")
  self.resItem = self:AddComponent(UICommonResItem, "ChatAnchor/ChatShareNode/UICommonResItem")
end

function ChatItemRight_bargainShare:OnHelpBtnClick()
end

function ChatItemRight_bargainShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemRight_bargainShare:UpdateItem(chatData)
  self._chatData = chatData
  self.seqId = chatData:getSeqId()
  self._userInfo = ChatManager2:GetInstance().User:getChatUserInfo(self._chatData.senderUid, true)
  self.data = chatData:getMessageParam()
  self.itemTemp = DataCenter.ActBargainShopTemplateManagaer:GetActBaragainShopPropTemplate(self.data.itemId)
  self:RefreshView(chatData)
end

function ChatItemRight_bargainShare:RefreshView(chatData)
  self._chatHead:UpdateHead(self._userInfo, self._chatData)
  self._chatUserName:UpdateName(self._userInfo, self._chatData)
  if self.itemTemp then
    self.resItem:ReInit(self.itemTemp)
  end
end

return ChatItemRight_bargainShare
