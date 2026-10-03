local base = require("UI.UIChatNew.Component.UniversalComponent.BaseLoopView")
local EasterEggChatItemFrame = require("UI.LWUIActEasterEgg.LWUIActEasterEggChat.Component.ChatItem.EasterEggChatItemFrame")
local EasterEggChatWithoutHeadFrame = require("UI.LWUIActEasterEgg.LWUIActEasterEggChat.Component.ChatItem.EasterEggChatWithoutHeadFrame")
local EasterEggLikeDescendOrder = require("UI.LWUIActEasterEgg.LWUIActEasterEggChat.Component.ChatItem.EasterEggLikeDescendOrder")
local EasterEggChatItemPost = require("UI.LWUIActEasterEgg.LWUIActEasterEggChat.Component.ChatItem.EasterEggChatItemPost")
local EasterEggEmptyNode = require("UI.LWUIActEasterEgg.LWUIActEasterEggChat.Component.ChatItem.EasterEggEmptyNode")
local EasterEggChatItemVote = require("UI.LWUIActEasterEgg.LWUIActEasterEggChat.Component.ChatItem.EasterEggChatItemVote")
local LWUIActEasterEggChatMessageArea = BaseClass("LWUIActEasterEggChatMessageArea", base)
local M = LWUIActEasterEggChatMessageArea
local Localization = CS.GameEntry.Localization
local hideToBottomBtnDis = 50

function M:OnCreate()
  base.OnCreate(self)
  self.isMovePanelToIndexWhenInit = false
  self.isJumpTop = false
  self.btnGoBottom:SetActive(false)
  self.btnGoTop:SetActive(false)
  self:HideLoading()
end

function M:OnDestroy()
  self.isMovePanelToIndexWhenInit = false
  self.isJumpTop = false
  self._scrollView:ClearAllItems()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  base.ComponentDefine(self)
  self.scrollRectMessage = self:AddComponent(UIScrollRect, "")
  self.scrollRectMessage:AddValueChangeListener(function(vec)
    self:CheckShowMoveTopOrBottomBtn()
  end)
  self.scrollViewPort = self:AddComponent(UIBaseContainer, "MainViewport")
  self.objLoading = self:AddComponent(UIBaseContainer, "MainViewport/objLoading")
  self.btnGoBottom = self:AddComponent(UIButton, "goBottomBtn")
  self.btnGoBottom:SetOnClick(function()
    self:ScrollToBottom()
  end)
  self.btnGoTop = self:AddComponent(UIButton, "goTopBtn")
  self.btnGoTop:SetOnClick(function()
    self:ScrollToTop()
  end)
end

function M:ComponentDestroy()
  base.ComponentDestroy(self)
  self.scrollRectMessage = nil
  self.scrollViewPort = nil
  self.objLoading = nil
  self.btnGoBottom = nil
  self.btnGoTop = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.EasterEggChatInitComment, self.OnRequestInitOnce)
  self:AddUIListener(EventId.EasterEggChatRefreshMsgsByTime, self.OnRequestHistoryByTimeResult)
  self:AddUIListener(EventId.EasterEggChatCommentLikeOrder, self.OnRefreshCommentLikeOrder)
  self:AddUIListener(ChatEventEnum.EasterEggChatRefreshGoToMsg, self.OnRequestGotoHistoryResult)
  self:AddUIListener(EventId.EasterEggChatReceiveOneData, self.OnRecieveChat)
  self:AddUIListener(ChatEventEnum.CHAT_REFRESH_SINGLE_CHAT_SHOW, self.OnRefreshSingleChatShow)
  self:AddUIListener(ChatEventEnum.CHAT_REFRESH_VIEW, self.OnRefreshScrollView)
  self:AddUIListener(ChatEventEnum.CHAT_MOVE_TO_SPECIAL_CHAT_DATA, self.OnRefreshViewDataAndMovePanelToItemIndex)
  self:AddUIListener(ChatEventEnum.EasterEggChatOnVoteUpdate, self.SetIsMovePanelToIndexWhenInit)
end

function M:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.EasterEggChatInitComment, self.OnRequestInitOnce)
  self:RemoveUIListener(EventId.EasterEggChatRefreshMsgsByTime, self.OnRequestHistoryByTimeResult)
  self:RemoveUIListener(EventId.EasterEggChatCommentLikeOrder, self.OnRefreshCommentLikeOrder)
  self:RemoveUIListener(ChatEventEnum.EasterEggChatRefreshGoToMsg, self.OnRequestGotoHistoryResult)
  self:RemoveUIListener(EventId.EasterEggChatReceiveOneData, self.OnRecieveChat)
  self:RemoveUIListener(ChatEventEnum.CHAT_REFRESH_SINGLE_CHAT_SHOW, self.OnRefreshSingleChatShow)
  self:RemoveUIListener(ChatEventEnum.CHAT_REFRESH_VIEW, self.OnRefreshScrollView)
  self:RemoveUIListener(ChatEventEnum.CHAT_MOVE_TO_SPECIAL_CHAT_DATA, self.OnRefreshViewDataAndMovePanelToItemIndex)
  self:RemoveUIListener(ChatEventEnum.EasterEggChatOnVoteUpdate, self.SetIsMovePanelToIndexWhenInit)
  base.OnRemoveListener(self)
end

function M:OnChatNetErrorOrDisconnect()
  self:ShowLoading()
end

function M:OnChatLoginSuccess()
  self.isMovePanelToIndexWhenInit = false
  self.isJumpTop = false
  self:HideLoading()
end

function M:ShowLoading()
  self.objLoading:SetActive(true)
end

function M:HideLoading()
  self.objLoading:SetActive(false)
end

function M:ClearChatDatas()
  self._chatDatas = {}
end

function M:GetChatData(index)
  return self._chatDatas[index]
end

function M:AddChatData(chatData, index)
  self._chatDatas = self._chatDatas or {}
  if index == nil then
    table.insert(self._chatDatas, chatData)
  else
    table.insert(self._chatDatas, index, chatData)
  end
end

function M:SetChatData(chatData, index)
  self._chatDatas = self._chatDatas or {}
  if index == nil or index < 1 or index > #self._chatDatas then
    return
  end
  self._chatDatas[index] = chatData
end

function M:RemoveChatData(index)
  if self._chatDatas == nil then
    return
  end
  table.remove(self._chatDatas, index)
end

function M:IsExistInLikeChatDatas(chatData)
  for i, _chatData in ipairs(self._chatDatas) do
    if _chatData.seqId == chatData.seqId and _chatData.sendLocalTime == chatData.sendLocalTime and _chatData.senderUid == chatData.senderUid then
      return true, i
    end
  end
  return false, 0
end

function M:GetCurrentRoomId()
  local easterEggRoomId = ChatManager2:GetInstance().Room:GetEasterEggRoomId()
  return easterEggRoomId
end

function M:OnRequestInitOnce()
  self:UpdateMsgListInitOnce()
  local showChatDataNum = #self._chatDatas
  local isLikeDescendOrder = DataCenter.ActEasterEggManager:GetIsOnLikeDescendOrder()
  if isLikeDescendOrder then
    showChatDataNum = 20
  end
  self._scrollView:SetListItemCount(showChatDataNum, false, false)
  if self.isMovePanelToIndexWhenInit then
    self.isMovePanelToIndexWhenInit = false
    self._scrollView:RefreshAllShownItem()
  else
    self._scrollView:MovePanelToItemIndex(0, 0)
  end
  self:CheckShowMoveTopOrBottomBtn()
end

function M:UpdateMsgListInitOnce()
  self:ClearChatDatas()
  local isLikeDescendOrder = DataCenter.ActEasterEggManager:GetIsOnLikeDescendOrder()
  if isLikeDescendOrder then
    DataCenter.ActEasterEggManager:GetLikeDescendOrderData()
  else
    DataCenter.ActEasterEggManager:GetTimeOrderData()
  end
  local isShowTips = self:CheckShowTips()
  if isShowTips then
    self:CreateTopFakeChatData()
    return
  end
  local roomMsgs = self:GetEasterEggRoomMsgs()
  for k, chatData in ipairs(roomMsgs) do
    if chatData then
      chatData.chatScrollItemType = ActEasterEggChatScrollItemType.Comment
      self:AddChatData(DeepCopy(chatData))
    end
  end
  self:CreateTopFakeChatData()
end

function M:OnRefreshCommentLikeOrder()
  if not self:IsDataReceived() then
    return
  end
  self.isMovePanelToIndexWhenInit = true
  self.view:RequestCommentData()
end

function M:OnRequestHistoryByTimeResult(param)
  local isLikeDescendOrder = DataCenter.ActEasterEggManager:GetIsOnLikeDescendOrder()
  if isLikeDescendOrder then
    return
  end
  local refreshType = param.refreshType
  if refreshType == ActEasterEggChatRefreshType.OnlyOrderByTime then
    self:UpdateMsgListByTimeResult()
    self._scrollView:SetListItemCount(self:GetItemCount(), false, false)
    self._scrollView:RefreshAllShownItem()
    return
  end
  local oldItemCount = self:GetItemCount()
  self:UpdateMsgListByTimeResult()
  local newItemCount = self:GetItemCount()
  self._scrollView:SetListItemCount(newItemCount, false, false)
  if refreshType == ActEasterEggChatRefreshType.NewMessage then
    if oldItemCount == newItemCount then
      self._scrollView.unity_looplistview2:MovePanelToItemIndexToBottom(oldItemCount - 1)
    else
      self._scrollView.unity_looplistview2:MovePanelToItemIndexToBottom(oldItemCount)
    end
  elseif refreshType == ActEasterEggChatRefreshType.HistoryMessage then
    self._scrollView:MovePanelToItemIndex(newItemCount - oldItemCount, 0)
  else
    self._scrollView:RefreshAllShownItem()
  end
  self:CheckShowMoveTopOrBottomBtn()
end

function M:UpdateMsgListByTimeResult()
  self:ClearChatDatas()
  local isShowTips = self:CheckShowTips()
  if isShowTips then
    self:CreateTopFakeChatData()
    return
  end
  DataCenter.ActEasterEggManager:GetTimeOrderDataByTimeRes()
  local roomMsgs = self:GetEasterEggRoomMsgs()
  for k, chatData in ipairs(roomMsgs) do
    if chatData then
      chatData.chatScrollItemType = ActEasterEggChatScrollItemType.Comment
      self:AddChatData(DeepCopy(chatData))
    end
  end
  local isReachTop = DataCenter.ActEasterEggManager:IsReachTopChatData()
  if isReachTop then
    self:CreateTopFakeChatData()
  end
  self:CheckShowMoveTopOrBottomBtn()
end

function M:OnRequestGotoHistoryResult(param)
  local refreshType = param.refreshType
  local isShowTips = self:CheckShowTips()
  if isShowTips then
    return
  end
  self:UpdateMsgListByGotoHistoryResult()
  self._scrollView:SetListItemCount(self:GetItemCount(), false, false)
  local isReachTop = DataCenter.ActEasterEggManager:IsReachTopChatData()
  if isReachTop then
    local isJumpTopLikeChatData = DataCenter.ActEasterEggManager:GetIsJumpTopLikeChatData()
    if isJumpTopLikeChatData then
      DataCenter.ActEasterEggManager:SetIsJumpTopLikeChatData(false)
      self._scrollView:MovePanelToItemIndex(2, 0)
    elseif refreshType == ActEasterEggChatRefreshType.NewMessage then
      if self.isJumpTop then
        self.isJumpTop = false
        self._scrollView:MovePanelToItemIndex(0, 0)
      else
        local topLikeChatData = DataCenter.ActEasterEggManager:GetTopLikeChatData()
        if topLikeChatData then
          self._scrollView:MovePanelToItemIndex(3, 0)
        else
          self._scrollView:MovePanelToItemIndex(2, 0)
        end
      end
    else
      self._scrollView:MovePanelToItemIndex(self:GetItemCount() - 1, 0)
    end
  elseif refreshType == ActEasterEggChatRefreshType.NewMessage then
    self._scrollView:MovePanelToItemIndex(0, 0)
  else
    self._scrollView:MovePanelToItemIndex(self:GetItemCount() - 1, 0)
  end
  self:CheckShowMoveTopOrBottomBtn()
end

function M:UpdateMsgListByGotoHistoryResult()
  self:ClearChatDatas()
  DataCenter.ActEasterEggManager:GetJumpTimeOrderData()
  local roomMsgs = self:GetEasterEggRoomMsgs()
  for k, chatData in ipairs(roomMsgs) do
    if chatData then
      chatData.chatScrollItemType = ActEasterEggChatScrollItemType.Comment
      self:AddChatData(DeepCopy(chatData))
    end
  end
  local isReachTop = DataCenter.ActEasterEggManager:IsReachTopChatData()
  if isReachTop then
    self:CreateTopFakeChatData()
  end
  return
end

function M:OnRecieveChat(chatData)
  local isShowTips = self:CheckShowTips()
  if isShowTips then
    return
  end
  local isLikeDescendOrder = DataCenter.ActEasterEggManager:GetIsOnLikeDescendOrder()
  if isLikeDescendOrder and #self._chatDatas >= 20 then
    return
  end
  self:UpdateMsgListByRecieveChat()
  self._scrollView:SetListItemCount(#self._chatDatas, false, false)
  local lastChatData = self:GetChatData(self:GetItemCount())
  if lastChatData:getSenderUid() == LuaEntry.Player.uid then
    self._scrollView:MovePanelToItemIndex(self:GetItemCount() - 1, 0)
  else
    self._scrollView:RefreshAllShownItem()
  end
  self:CheckShowMoveTopOrBottomBtn()
end

function M:UpdateMsgListByRecieveChat()
  local roomMsgs = self:GetEasterEggRoomMsgs()
  if #roomMsgs == 1 then
    self:ClearChatDatas()
    local chatData = roomMsgs[1]
    chatData.chatScrollItemType = ActEasterEggChatScrollItemType.Comment
    self:AddChatData(DeepCopy(chatData))
    self:CreateTopFakeChatData()
  else
    local lastSeqId = self:GetLastChatDataSeqId()
    local roomLastChatData = roomMsgs[#roomMsgs]
    local roomLastSeqId = roomLastChatData:getSeqId()
    if lastSeqId ~= roomLastSeqId then
      roomLastChatData.chatScrollItemType = ActEasterEggChatScrollItemType.Comment
      self:AddChatData(DeepCopy(roomLastChatData))
    end
  end
end

function M:OnRefreshSingleChatShow(chatData)
  for k, v in pairs(self._chatDatas) do
    local _chatData = v
    if _chatData.getSeqId and _chatData:getSeqId() == chatData:getSeqId() then
      local isExist, index = self:IsExistInLikeChatDatas(chatData)
      if isExist then
        self:SetChatData(DeepCopy(chatData), index)
      end
      self._scrollView:RefreshItemByItemIndex(index - 1)
    end
  end
end

function M:OnRefreshScrollView()
  self._scrollView:RefreshAllShownItem()
end

function M:OnRefreshViewDataAndMovePanelToItemIndex(seqId)
  self:UpdateMsgListByTimeResult()
  for i, _chatData in ipairs(self._chatDatas) do
    if _chatData.seqId == seqId then
      self._scrollView:MovePanelToItemIndex(i - 1, 0)
      return
    end
  end
end

function M:GetLastChatDataSeqId()
  local lastChatData = self:GetChatData(self:GetItemCount())
  if lastChatData == nil then
    return -1
  end
  return lastChatData:getSeqId() or -1
end

function M:CreateTopFakeChatData()
  local eggInfo = self.view:GetEggInfo()
  if eggInfo == nil then
    Logger.LogError("\229\164\141\230\180\187\232\138\130\226\128\148\226\128\148\226\128\148\226\128\148\231\130\185\229\135\187\229\143\145\233\128\129\232\175\132\232\174\186\230\151\182\239\188\140\228\184\187\231\149\140\233\157\162eggInfo\228\184\186\231\169\186\239\188\129")
    return
  end
  local roomMsgs = self:GetEasterEggRoomMsgs()
  local chatData = {}
  if eggInfo:GetEggType() == ActEasterEggType.Gathering then
    if #roomMsgs == 0 then
      chatData.chatScrollItemType = ActEasterEggChatScrollItemType.NoCommentNode
      self:AddChatData(DeepCopy(chatData), 1)
    else
      chatData.chatScrollItemType = ActEasterEggChatScrollItemType.LikeDescendOrder
      self:AddChatData(DeepCopy(chatData), 1)
    end
  elseif eggInfo:GetEggType() == ActEasterEggType.Vote then
    if eggInfo:GetMyVoteRes() ~= 0 and 0 < #roomMsgs then
      chatData.chatScrollItemType = ActEasterEggChatScrollItemType.LikeDescendOrder
      self:AddChatData(DeepCopy(chatData), 1)
    else
      chatData.chatScrollItemType = ActEasterEggChatScrollItemType.NoCommentNode
      self:AddChatData(DeepCopy(chatData), 1)
    end
  end
  chatData = {}
  if eggInfo:GetEggType() == ActEasterEggType.Gathering then
    chatData.chatScrollItemType = ActEasterEggChatScrollItemType.Post
    self:AddChatData(DeepCopy(chatData), 1)
  elseif eggInfo:GetEggType() == ActEasterEggType.Vote then
    chatData.chatScrollItemType = ActEasterEggChatScrollItemType.Vote
    self:AddChatData(DeepCopy(chatData), 1)
  else
    Logger.LogError("\229\189\147\229\137\141\232\155\139\230\178\161\230\156\137\228\184\187\233\162\152\239\188\129 ")
  end
end

function M:DeleteTopFakeChatData()
  local chatData = self._chatDatas[1]
  if chatData and (chatData.chatScrollItemType == ActEasterEggChatScrollItemType.Post or chatData.chatScrollItemType == ActEasterEggChatScrollItemType.Vote) then
    self:RemoveChatData(1)
  end
  chatData = self._chatDatas[1]
  if chatData and chatData.chatScrollItemType == ActEasterEggChatScrollItemType.NoCommentNode then
    self:RemoveChatData(1)
  end
  chatData = self._chatDatas[1]
  if chatData and chatData.chatScrollItemType == ActEasterEggChatScrollItemType.LikeDescendOrder then
    self:RemoveChatData(1)
  end
end

function M:CheckShowTips()
  local eggInfo = self.view:GetEggInfo()
  if eggInfo == nil then
    Logger.LogError("\229\164\141\230\180\187\232\138\130\226\128\148\226\128\148\226\128\148\226\128\148\231\130\185\229\135\187\229\143\145\233\128\129\232\175\132\232\174\186\230\151\182\239\188\140\228\184\187\231\149\140\233\157\162eggInfo\228\184\186\231\169\186\239\188\129")
    return true
  end
  local roomMsgs = self:GetEasterEggRoomMsgs()
  if #roomMsgs == 0 then
    return true
  end
  return eggInfo:GetEggType() == ActEasterEggType.Vote and eggInfo:GetMyVoteRes() == 0
end

function M:GetEasterEggRoomMsgs()
  local roomData = ChatManager2:GetInstance().Room:GetEasterEggRoom()
  return roomData:GetMsgs()
end

function M:CheckFirstChatItemToTop()
  local isLikeDescendOrder = DataCenter.ActEasterEggManager:GetIsOnLikeDescendOrder()
  if isLikeDescendOrder then
    return self.itemContent.transform.localPosition.y < hideToBottomBtnDis
  else
    local isReachTop = DataCenter.ActEasterEggManager:IsReachTopChatData()
    return isReachTop and self.itemContent.transform.localPosition.y < hideToBottomBtnDis
  end
end

function M:IsDataReceived()
  local isReadyForFirstPart = DataCenter.ActEasterEggManager:GetReadyForFirstPart()
  local isReadyForLikeDescendMsg = DataCenter.ActEasterEggManager:GetReadyForLikeDescendMsg()
  return isReadyForFirstPart and isReadyForLikeDescendMsg
end

function M:ScrollToTop()
  if not self:IsDataReceived() then
    return
  end
  local isReachTop = DataCenter.ActEasterEggManager:IsReachTopChatData()
  if isReachTop then
    self._scrollView:MovePanelToItemIndex(0, 0)
  else
    self.isJumpTop = true
    local roomId = self:GetCurrentRoomId()
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomGoto, roomId, 1, 1)
  end
end

function M:ScrollToBottom()
  if not self:IsDataReceived() then
    return
  end
  local isLikeDescendOrder = DataCenter.ActEasterEggManager:GetIsOnLikeDescendOrder()
  if isLikeDescendOrder then
    self._scrollView:MovePanelToItemIndex(self:GetItemCount() - 1, 0)
  else
    local isReachBottom = DataCenter.ActEasterEggManager:IsReachBottomChatData()
    if isReachBottom then
      self._scrollView:MovePanelToItemIndex(self:GetItemCount() - 1, 0)
    else
      local roomId = self:GetCurrentRoomId()
      local roomData = ChatManager2:GetInstance().Room:GetEasterEggRoom()
      local roomLastSeqId = roomData:getRoomLastSeqId()
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomGoto, roomId, roomLastSeqId, 2)
    end
  end
end

function M:SetIsMovePanelToIndexWhenInit(state)
  self.isMovePanelToIndexWhenInit = state
end

function M:GetChatItemScriptName(index)
  local chataData = self._chatDatas[index]
  if chataData == nil then
    Logger.LogError("\229\164\141\230\180\187\232\138\130\226\128\148\226\128\148\226\128\148\226\128\148\226\128\148GetChatItemScriptName \232\142\183\229\143\150\228\184\141\229\136\176chatData\230\149\176\230\141\174")
    return ""
  end
  if chataData.chatScrollItemType == ActEasterEggChatScrollItemType.LikeDescendOrder then
    return EasterEggLikeDescendOrder
  elseif chataData.chatScrollItemType == ActEasterEggChatScrollItemType.Post then
    return EasterEggChatItemPost
  elseif chataData.chatScrollItemType == ActEasterEggChatScrollItemType.Vote then
    return EasterEggChatItemVote
  end
  if chataData.getPost and chataData:getPost() == PostType.MessageRecall then
    return EasterEggChatWithoutHeadFrame
  end
  if chataData.chatScrollItemType == ActEasterEggChatScrollItemType.NoCommentNode then
    return EasterEggEmptyNode
  end
  return EasterEggChatItemFrame
end

function M:GetItemPrefabName(index)
  local chataData = self._chatDatas[index]
  if chataData == nil then
    Logger.LogError("\229\164\141\230\180\187\232\138\130\226\128\148\226\128\148\226\128\148\226\128\148\226\128\148GetItemPrefabName \232\142\183\229\143\150\228\184\141\229\136\176chatData\230\149\176\230\141\174")
    return ""
  end
  if chataData.chatScrollItemType == ActEasterEggChatScrollItemType.LikeDescendOrder then
    return "EasterEggLikeDescendOrder"
  elseif chataData.chatScrollItemType == ActEasterEggChatScrollItemType.Post then
    return "EasterEggChatItemPost"
  elseif chataData.chatScrollItemType == ActEasterEggChatScrollItemType.Vote then
    return "EasterEggChatItemVote"
  end
  if chataData.chatScrollItemType == ActEasterEggChatScrollItemType.NoCommentNode then
    return "EasterEggEmptyNode"
  end
  if chataData.getPost and chataData:getPost() == PostType.MessageRecall then
    return "EasterEggChatWithoutHeadFrame"
  end
  return "EasterEggChatItemFrame"
end

function M:ChatItemPostsType2(chatData, index)
  if chatData:getPost() == PostType.MessageRecall then
    return ChatItemPostsType2[PostType.MessageRecall]
  end
end

function M:OnTopPull()
  local eggInfo = self.view:GetEggInfo()
  if eggInfo == nil then
    return
  end
  local isLikeDescendOrder = DataCenter.ActEasterEggManager:GetIsOnLikeDescendOrder()
  if eggInfo:GetEggType() == ActEasterEggType.Vote and eggInfo:GetMyVoteRes() == 0 or isLikeDescendOrder then
    return
  end
  local roomData = ChatManager2:GetInstance().Room:GetEasterEggRoom()
  local topLikeChatData = DataCenter.ActEasterEggManager:GetTopLikeChatData()
  if topLikeChatData and topLikeChatData:getSeqId() ~= roomData:getFirstSeqId() then
    roomData:RemoveChatDataBySeqId(topLikeChatData:getSeqId())
  end
  local roomId = self:GetCurrentRoomId()
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomV2, roomId, 0)
end

function M:OnBottomPull()
  local eggInfo = self.view:GetEggInfo()
  if eggInfo == nil then
    return
  end
  local isLikeDescendOrder = DataCenter.ActEasterEggManager:GetIsOnLikeDescendOrder()
  if eggInfo:GetEggType() == ActEasterEggType.Vote and eggInfo:GetMyVoteRes() == 0 or isLikeDescendOrder then
    return
  end
  local roomData = ChatManager2:GetInstance().Room:GetEasterEggRoom()
  local topLikeChatData = DataCenter.ActEasterEggManager:GetTopLikeChatData()
  if topLikeChatData and topLikeChatData:getSeqId() == roomData:GetLastMsgSeqId() + 1 then
    roomData:RemoveChatDataBySeqId(topLikeChatData:getSeqId())
    roomData:AddChatDataOnly(topLikeChatData)
  end
  local roomId = self:GetCurrentRoomId()
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomV2, roomId, 1)
end

function M:CheckShowMoveTopOrBottomBtn()
  if not self:IsDataReceived() then
    return
  end
  local isInShowBtnRange = self.scrollViewPort.transform.rect.height < self.itemContent.transform.rect.height
  local isFirstChatItemToTop = self:CheckFirstChatItemToTop()
  self.btnGoBottom:SetActive(isInShowBtnRange and isFirstChatItemToTop)
  self.btnGoTop:SetActive(isInShowBtnRange and not isFirstChatItemToTop)
end

function M:SetChatItemSizeDelta(item)
end

function M:GetViewPortHeight()
  return self.scrollViewPort.transform.rect.height
end

return M
