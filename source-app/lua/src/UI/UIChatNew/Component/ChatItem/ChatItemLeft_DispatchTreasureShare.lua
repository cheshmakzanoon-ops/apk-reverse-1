local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemLeft_DispatchTreasureShare = BaseClass("ChatItemLeft_DispatchTreasureShare", IChatItem)
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local UISplinterExchangeCell = require("UI.UISplinterExchange.Exchange.Component.UISplinterExchangeCell")
local base = IChatItem
local rapidjson = require("rapidjson")
local u_i_splinter_exchange_cell_path = "ChatAnchor/ChatShareNode/UISplinterExchangeCell"

function ChatItemLeft_DispatchTreasureShare:ComponentDefine()
  self._chatHead = self:AddComponent(ChatHead, "ChatHead")
  self._chatUserName = self:AddComponent(ChatUserName, "ChatNameLayout")
  self.u_i_splinter_exchange_cell = self:AddComponent(UISplinterExchangeCell, u_i_splinter_exchange_cell_path)
end

function ChatItemLeft_DispatchTreasureShare:ComponentDestroy()
  self._chatHead = nil
  self._chatUserName = nil
  self.u_i_splinter_exchange_cell = nil
end

function ChatItemLeft_DispatchTreasureShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.exchanged = false
  self._chatData = nil
  self.seqId = nil
  self.roomId = nil
end

function ChatItemLeft_DispatchTreasureShare:OnDestroy()
  self:ComponentDestroy()
  self.exchanged = nil
  self._chatData = nil
  self.seqId = nil
  self.roomId = nil
  base.OnDestroy(self)
end

function ChatItemLeft_DispatchTreasureShare:UpdateItem(chatData)
  self._chatData = chatData
  self.seqId = chatData:getSeqId()
  self.roomId = chatData.roomId
  self._userInfo = ChatManager2:GetInstance().User:getChatUserInfo(self._chatData.senderUid, true)
  self.data = rapidjson.decode(chatData.extra.customJsonParam).exchangeInfo
  self.exchanged = chatData.clientUpdateExtra == "exchanged"
  self:RefreshView()
end

function ChatItemLeft_DispatchTreasureShare:RefreshView()
  if self.data.type == nil then
    return
  end
  self._chatHead:UpdateHead(self._userInfo, self._chatData)
  self._chatUserName:UpdateName(self._userInfo, self._chatData)
  self.u_i_splinter_exchange_cell:SetData(self.data)
  self.u_i_splinter_exchange_cell:SetChatItemDataInit("Treasure_map_53")
  self.u_i_splinter_exchange_cell:RefreshChangeBtnChanged(self.exchanged)
end

function ChatItemLeft_DispatchTreasureShare:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_DEL_MSG, self.OnUpdateMsg)
  self:AddUIListener(EventId.RefreshItems, self.RefreshView)
end

function ChatItemLeft_DispatchTreasureShare:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_DEL_MSG, self.OnUpdateMsg)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshView)
  base.OnRemoveListener(self)
end

function ChatItemLeft_DispatchTreasureShare:OnUpdateMsg(chatData)
  if chatData and chatData.seqId == self.seqId and chatData.roomid == self.roomId then
    local roomData = ChatManager2:GetInstance().Room:GetRoomData(self.roomId)
    if roomData then
      local chatData = roomData:getChatDataBySeqId(self.seqId)
      if chatData and chatData.post == PostType.Dispatch_Treasure then
        self._chatData.clientUpdateExtra = "exchanged"
        self.exchanged = true
        self:RefreshView()
      end
    end
  end
end

return ChatItemLeft_DispatchTreasureShare
