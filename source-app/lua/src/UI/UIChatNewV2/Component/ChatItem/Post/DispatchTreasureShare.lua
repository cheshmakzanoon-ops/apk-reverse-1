local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_DispatchTreasureShare = BaseClass("DispatchTreasureShare", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")
local UISplinterExchangeCell = require("UI.UISplinterExchange.Exchange.Component.UISplinterExchangeCell")
local u_i_splinter_exchange_cell_path = "UISplinterExchangeCell"

function ChatItemPost_DispatchTreasureShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.exchanged = false
  self._chatData = nil
  self.seqId = nil
  self.roomId = nil
end

function ChatItemPost_DispatchTreasureShare:ComponentDefine()
  self.u_i_splinter_exchange_cell = self:AddComponent(UISplinterExchangeCell, u_i_splinter_exchange_cell_path)
end

function ChatItemPost_DispatchTreasureShare:OnLoaded()
  local chatData = self:ChatData()
  if chatData:isMyChat() then
    self.u_i_splinter_exchange_cell:SetChangeBtnUninteractable()
  else
    self.u_i_splinter_exchange_cell:SetChangeBtnInteractable()
  end
  self._chatData = chatData
  self.seqId = chatData:getSeqId()
  self.roomId = chatData.roomId
  self._userInfo = ChatManager2:GetInstance().User:getChatUserInfo(self._chatData.senderUid, true)
  self.data = rapidjson.decode(chatData.extra.customJsonParam).exchangeInfo
  self.exchanged = chatData.clientUpdateExtra == "exchanged"
  self:RefreshView()
end

function ChatItemPost_DispatchTreasureShare:RefreshView()
  if self.data.type == nil then
    return
  end
  self.u_i_splinter_exchange_cell:SetData(self.data)
  self.u_i_splinter_exchange_cell:SetChatItemDataInit("Treasure_map_53")
  self.u_i_splinter_exchange_cell:RefreshChangeBtnChanged(self.exchanged)
end

function ChatItemPost_DispatchTreasureShare:OnUpdateMsg(chatData)
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

function ChatItemPost_DispatchTreasureShare:OnRecycle()
  self.exchanged = nil
  self._chatData = nil
  self.seqId = nil
  self.roomId = nil
end

function ChatItemPost_DispatchTreasureShare:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_DEL_MSG, self.OnUpdateMsg)
  self:AddUIListener(EventId.RefreshItems, self.RefreshView)
end

function ChatItemPost_DispatchTreasureShare:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_DEL_MSG, self.OnUpdateMsg)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshView)
  base.OnRemoveListener(self)
end

return ChatItemPost_DispatchTreasureShare
