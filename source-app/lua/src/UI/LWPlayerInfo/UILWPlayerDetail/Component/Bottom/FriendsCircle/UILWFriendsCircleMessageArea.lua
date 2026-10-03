local UILWFriendsCircleMessageArea = BaseClass("UILWFriendsCircleMessageArea", UIBaseContainer)
local FriendCircleFrame = require("UI.LWPlayerInfo.FriendCirclePost.FriendCircleFrame")
local base = UIBaseContainer

function UILWFriendsCircleMessageArea:OnCreate()
  base.OnCreate(self)
  self._chatItemObjList = {}
  self._chatItemObjList = {}
  self._chatDatas = {}
  self:ComponentDefine()
end

function UILWFriendsCircleMessageArea:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_RESULT_BY_TIME, self.OnRequestHistoryByTimeResult)
  self:AddUIListener(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, self.OnChatRecieveRoomMsg)
  self:AddUIListener(ChatEventEnum.ChatDeleteMessage, self.OnChatDeleteMessage)
  self:AddUIListener(ChatEventEnum.CHAT_ERROR_OR_DISCONNECT, self.OnChatNetErrorOrDisconnect)
  self:AddUIListener(ChatEventEnum.CHAT_LOGIN_SUCCESS, self.OnChatLoginSuccess)
end

function UILWFriendsCircleMessageArea:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_RESULT_BY_TIME, self.OnRequestHistoryByTimeResult)
  self:RemoveUIListener(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, self.OnChatRecieveRoomMsg)
  self:RemoveUIListener(ChatEventEnum.ChatDeleteMessage, self.OnChatDeleteMessage)
  self:RemoveUIListener(ChatEventEnum.CHAT_ERROR_OR_DISCONNECT, self.OnChatNetErrorOrDisconnect)
  self:RemoveUIListener(ChatEventEnum.CHAT_LOGIN_SUCCESS, self.OnChatLoginSuccess)
  base.OnRemoveListener(self)
end

function UILWFriendsCircleMessageArea:OnChatNetErrorOrDisconnect()
  self:ShowLoading(true)
end

function UILWFriendsCircleMessageArea:OnChatLoginSuccess()
  self:ShowLoading(false)
end

function UILWFriendsCircleMessageArea:OnChatRecieveRoomMsg(chatData)
  if chatData.roomId == self.roomId then
    self:RefreshRoomData(self.roomId)
    self._scrollView:MovePanelToItemIndex(0, 0)
  end
end

function UILWFriendsCircleMessageArea:OnChatDeleteMessage(roomId)
  if roomId == self.roomId then
    self:RefreshRoomData(self.roomId)
  end
end

function UILWFriendsCircleMessageArea:ShowLoading(isOn)
  self.loadingObj:SetActive(isOn)
end

function UILWFriendsCircleMessageArea:OnRequestHistoryByTimeResult(msg)
  self:RefreshRoomData(self.roomId)
end

function UILWFriendsCircleMessageArea:ComponentDefine()
  self._scrollView = self:AddComponent(UILoopListView2, "")
  self._scrollView:InitListViewParam2(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end, nil, nil, function(loopListViewItem)
    self:OnRecycleItemFunc(loopListViewItem)
  end)
  
  function self._scrollView.unity_looplistview2.mOnEndDragAction()
    self:OnDragEnd()
  end
  
  self.loadingObj = self:AddComponent(UIBaseContainer, "objLoading")
  self.itemContent = self:AddComponent(UIBaseContainer, "MainViewport/MainContent")
end

function UILWFriendsCircleMessageArea:SetChatItemSizeDelta(item)
  if item.CachedRectTransform.sizeDelta.x == self._scrollView:GetViewPortWidth() - 50 then
    return
  end
  self.chatItemSizeDelta = self.chatItemSizeDelta or Vector2.zero
  self.chatItemSizeDelta.x = self._scrollView:GetViewPortWidth() - 50
  self.chatItemSizeDelta.y = item.CachedRectTransform.sizeDelta.y
  item.CachedRectTransform.sizeDelta = self.chatItemSizeDelta
end

function UILWFriendsCircleMessageArea:SetOnDragEndCallBack(On)
end

function UILWFriendsCircleMessageArea:ReloadAfterTranslateRecv()
  local room = ChatInterface.getRoomData(self.roomId)
  if room then
    self._chatDatas = DeepCopy(room.msgs)
    table.sort(self._chatDatas, function(a, b)
      return a.serverTime > b.serverTime
    end)
  end
  self._scrollView:SetListItemCount(self:GetItemCount(), false, false)
  self._scrollView:RefreshAllShownItem()
end

function UILWFriendsCircleMessageArea:OnDragEnd()
  if ChatManager2:GetInstance().Room:GetIsNewPrivateList() then
    local containerTrans = self._scrollView.unity_looplistview2.ContainerTrans
    if containerTrans.localPosition.y <= 0 then
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_COMMAND, self.roomId)
    elseif containerTrans.localPosition.y > containerTrans.rect.size.y - self._scrollView.rectTransform.rect.size.y then
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_COMMAND, self.roomId)
    end
  end
end

function UILWFriendsCircleMessageArea:GetItemNameSequence()
  NameCount = NameCount + 1
  return tostring(NameCount)
end

function UILWFriendsCircleMessageArea:OnRecycleItemFunc(loopListViewItem)
  if loopListViewItem == nil then
    return
  end
  local script = self._chatItemObjList[loopListViewItem]
  if script ~= nil then
    script:OnRecycleItem()
    script:SetActive(false)
  end
end

function UILWFriendsCircleMessageArea:GetItemCount()
  return table.length(self._chatDatas)
end

function UILWFriendsCircleMessageArea:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if not self._chatDatas or index < 1 or index > #self._chatDatas then
    return nil
  end
  local item = loopScroll:NewListViewItem("FriendCircleFrame")
  if not item then
    return
  end
  local temp = self._chatItemObjList[item]
  if temp then
    temp:SetActive(true)
    temp:UpdateItem(self._chatDatas[index], index - 1, nil, ChatPhotoSource.PlayerDetailFriendsCircle)
    self:SetChatItemSizeDelta(item)
  else
    temp = self.itemContent:GetComponent(item.gameObject.name, FriendCircleFrame)
    if temp == nil then
      local objectName = self:GetItemNameSequence()
      item.gameObject.name = objectName
      temp = self.itemContent:AddComponent(FriendCircleFrame, item.gameObject)
    end
    temp:SetActive(true)
    self:SetChatItemSizeDelta(item)
    temp:SetContentViewScript(self)
    temp:UpdateItem(self._chatDatas[index], index - 1, nil, ChatPhotoSource.PlayerDetailFriendsCircle)
    self._chatItemObjList[item] = temp
  end
  ChatInterface.getMoment():AddExposure(self._chatDatas[index], self._chatDatas[index].group)
  return item
end

function UILWFriendsCircleMessageArea:RefreshRoomData(roomId)
  if not roomId then
    self._scrollView:RecycleAllItem()
    self.itemContent:RemoveComponents(FriendCircleFrame)
    self:DataDestroy()
    return
  end
  if not ChatManager2:GetInstance().Net:IsRunning() then
    self:ShowLoading(true)
  else
    self:ShowLoading(false)
  end
  self.roomId = roomId
  local room = ChatInterface.getRoomData(roomId)
  if room then
    self._chatDatas = DeepCopy(room.msgs)
    table.sort(self._chatDatas, function(a, b)
      return a.serverTime > b.serverTime
    end)
    if self.circle then
      self.circle:ShowFriendsCircle(#self._chatDatas > 0)
    end
    self._scrollView:SetListItemCount(#self._chatDatas, false, false)
    self._scrollView.unity_looplistview2:RefreshAllShownItem()
  end
end

function UILWFriendsCircleMessageArea:SetCircle(circle)
  self.circle = circle
end

function UILWFriendsCircleMessageArea:ComponentDestroy()
  self.itemContent:RemoveComponents(FriendCircleFrame)
  self._scrollView:RecycleAllItem()
  self._scrollView.unity_looplistview2.mOnEndDragAction = nil
  self.itemContent = nil
  self._scrollView = nil
end

function UILWFriendsCircleMessageArea:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWFriendsCircleMessageArea:DataDestroy()
  self.roomId = nil
  self._chatItemObjList = {}
  self._chatDatas = nil
end

return UILWFriendsCircleMessageArea
