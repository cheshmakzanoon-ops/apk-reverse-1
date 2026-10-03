local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemRight_DispatchTreasureShare = BaseClass("ChatItemRight_DispatchTreasureShare", IChatItem)
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local UISplinterExchangeCell = require("UI.UISplinterExchange.Exchange.Component.UISplinterExchangeCell")
local rapidjson = require("rapidjson")
local base = IChatItem
local u_i_splinter_exchange_cell_path = "ChatAnchor/ChatShareNode/UISplinterExchangeCell"

function ChatItemRight_DispatchTreasureShare:ComponentDefine()
  self._chatHead = self:AddComponent(ChatHead, "ChatHead")
  self._chatUserName = self:AddComponent(ChatUserName, "ChatNameLayout")
  self.u_i_splinter_exchange_cell = self:AddComponent(UISplinterExchangeCell, u_i_splinter_exchange_cell_path)
  self.u_i_splinter_exchange_cell:SetChangeBtnUninteractable()
end

function ChatItemRight_DispatchTreasureShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemRight_DispatchTreasureShare:UpdateItem(chatData)
  self._chatData = chatData
  self.seqId = chatData:getSeqId()
  self._userInfo = ChatManager2:GetInstance().User:getChatUserInfo(self._chatData.senderUid, true)
  self.data = rapidjson.decode(chatData.extra.customJsonParam).exchangeInfo
  self:RefreshView(chatData)
end

function ChatItemRight_DispatchTreasureShare:RefreshView(chatData)
  self._chatHead:UpdateHead(self._userInfo, self._chatData)
  self._chatUserName:UpdateName(self._userInfo, self._chatData)
  self.u_i_splinter_exchange_cell:SetData(self.data)
  self.u_i_splinter_exchange_cell:SetChatItemDataInit("Treasure_map_56")
end

return ChatItemRight_DispatchTreasureShare
