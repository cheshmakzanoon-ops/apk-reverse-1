local base = UIBaseContainer
local UIChatViewNoticeRemark = BaseClass("UIChatViewNoticeRemark", base)
local ChatItemLeft_Normal = require("UI.UIChatNew.Component.ChatItem.ChatItemNoticeRemark_Left")
local ChatItemRight_Normal = require("UI.UIChatNew.Component.ChatItem.ChatItemNoticeRemark_Right")
local ChatItemNoticeDetail = require("UI.UIChatNew.Component.ChatItem.ChatItemNoticeDetail")
local ChatItemFrame = require("UI.UIChatNewV2.Component.ChatItem.ChatItemFrame")
local ChatCancelMsg = require("UI.UIChatNew.Component.ChatItem.ChatCancelMsg")
local _cp_scrollView = ""
local _cp_scrollViewContent = "MainViewport/MainContent"
local _cp_vScrollBar = "MainViewport/Scrollbar"
local _cp_objLoading = "objLoading"
local _cp_txt_loading = "objLoading/Image/txtLoading"
local _go_tail_btn_path = "GoTailBtn"

function UIChatViewNoticeRemark:setSlideNode(node)
  self._eventTriggerNode = node
end

function UIChatViewNoticeRemark:getSlideNode()
  return self._eventTriggerNode
end

function UIChatViewNoticeRemark:ComponentDefine()
  self._objLoading = self:AddComponent(UIBaseContainer, _cp_objLoading)
  self._txt_loading = self:AddComponent(UIText, _cp_txt_loading)
  self.notRemarkTip = self:AddComponent(UIBaseContainer, "notRemarkTip")
  self._scrollView = self:AddComponent(UILoopListView2, _cp_scrollView)
  self._scrollView_ScrollRect = self:AddComponent(UIScrollRect, _cp_scrollView)
  self._scrollView_ScrollRect:AddValueChangeListener(function(vec)
    self:OnScollValueChange()
    self:CheckShowMoveToTailBtn()
  end)
  self._scrollViewContent = self:AddComponent(UIBaseContainer, _cp_scrollViewContent)
  self._vScrollBar = self.transform:Find(_cp_vScrollBar):GetComponent(typeof(CS.UnityEngine.RectTransform))
  
  function self._scrollView.unity_looplistview2.mOnListClickAction()
  end
  
  function self._scrollView.unity_looplistview2.mOnBeginDragAction()
    self:UpdateScrollbarVisible()
  end
  
  function self._scrollView.unity_looplistview2.mOnEndDragAction()
    self:OnEndDrag()
  end
  
  self.goTailBtn = self:AddComponent(UIButton, _go_tail_btn_path)
  self.goTailBtn:SetOnClick(function()
    self:ScrollToTail()
  end)
end

function UIChatViewNoticeRemark:ComponentDestroy()
  self._scrollView.unity_looplistview2.mOnListClickAction = nil
  self._scrollView.unity_looplistview2.mOnBeginDragAction = nil
  self._scrollView.unity_looplistview2.mOnEndDragAction = nil
  self._scrollViewContent:RemoveComponents(ChatItemLeft_Normal)
  self._scrollViewContent:RemoveComponents(ChatItemRight_Normal)
  self._scrollViewContent:RemoveComponents(ChatItemFrame)
  self._scrollView:ClearAllItems()
end

function UIChatViewNoticeRemark:DataDefine()
  self._databaseOffset = -10
  self._chatDatas = {}
  self._chatDatasCnt = 0
  self._timeFlags = {}
  self._isFetchingMore = false
  self.delayTimerTask = nil
  self._scrollViewPortSize = nil
  self._chatItemObjList = {}
  self.pinGoReq = {}
  self.isNotFrist = nil
  self.lastVisibleHeight = 0
end

function UIChatViewNoticeRemark:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ERROR_OR_DISCONNECT, self.OnChatNetErrorOrDisconnect)
  self:AddUIListener(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, self.OnRecieveChat)
  self:AddUIListener(ChatEventEnum.CHAT_UPDATE_ROOM_HISTORY_MSG, self.OnUpdateHistoryMsg)
  self:AddUIListener(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_RESULT, self.OnRequestHistoryResult)
  self:AddUIListener(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_RESULT_BY_TIME, self.OnRequestHistoryResultByTime)
  self:AddUIListener(ChatEventEnum.CHAT_LOGIN_SUCCESS, self.OnChatLoginSuccess)
  self:AddUIListener(ChatEventEnum.UPDATE_USER_MSG, self.UpdateMsgList)
  self:AddUIListener(ChatEventEnum.CHAT_MAIN_VIEW_STOP_MOVEMENT, self.StopMovement)
  self:AddUIListener(ChatEventEnum.CHAT_REFRESH_VIEW, self.RefreshScrollView)
  self:AddUIListener(EventId.CHAT_ITEM_NEWSCENTER_DATA_GET, self.RefreshScrollView)
  SFSNetwork.SendMessage(MsgDefines.ChatAskAllianceGatherMessage)
end

function UIChatViewNoticeRemark:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ERROR_OR_DISCONNECT, self.OnChatNetErrorOrDisconnect)
  self:RemoveUIListener(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, self.OnRecieveChat)
  self:RemoveUIListener(ChatEventEnum.CHAT_UPDATE_ROOM_HISTORY_MSG, self.OnUpdateHistoryMsg)
  self:RemoveUIListener(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_RESULT, self.OnRequestHistoryResult)
  self:RemoveUIListener(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_RESULT_BY_TIME, self.OnRequestHistoryResultByTime)
  self:RemoveUIListener(ChatEventEnum.CHAT_LOGIN_SUCCESS, self.OnChatLoginSuccess)
  self:RemoveUIListener(ChatEventEnum.UPDATE_USER_MSG, self.UpdateMsgList)
  self:RemoveUIListener(ChatEventEnum.CHAT_MAIN_VIEW_STOP_MOVEMENT, self.StopMovement)
  self:RemoveUIListener(ChatEventEnum.CHAT_REFRESH_VIEW, self.RefreshScrollView)
  self:RemoveUIListener(EventId.CHAT_ITEM_NEWSCENTER_DATA_GET, self.RefreshScrollView)
  base.OnRemoveListener(self)
end

function UIChatViewNoticeRemark:OnChatNetErrorOrDisconnect()
  self:ShowLoading()
end

function UIChatViewNoticeRemark:MoveToTop()
  if table.length(self._chatDatas) > 1 then
    self._scrollView:MovePanelToItemIndex(0, 0)
  end
end

function UIChatViewNoticeRemark:ScrollToTail()
  if table.length(self._chatDatas) > 1 then
    self._scrollView:MovePanelToItemIndex(table.length(self._chatDatas) - 1, 0)
  end
  if self.goTailBtn then
    self.goTailBtn:SetActive(false)
  end
end

function UIChatViewNoticeRemark:OnGetItemByIndex(listView, index)
  if index < 0 or index >= table.length(self._chatDatas) then
    return nil
  end
  self.prefabIndex = self.prefabIndex or 0
  local prefabName = self:GetChatItemPrefabName(index)
  if prefabName == "ChatItemFrame" then
    local postItemConfig = ChatInterface.GetPostConfig_Player(self._chatDatas[index + 1])
    prefabName = prefabName .. "_" .. postItemConfig.postClass.__cname
  end
  local item = listView:NewListViewItem(prefabName)
  if item == nil then
    return nil
  end
  if self._chatItemObjList[item] ~= nil then
    self._chatItemObjList[item]:SetContentViewScript(self)
    self._chatItemObjList[item]:UpdateItem(self._chatDatas[index + 1], index + 1)
  else
    local chatItemScript = self:GetChatItemScriptName(index)
    if chatItemScript == nil then
      Logger.LogError(">>>> chatitemscript prefab - " .. tostring(prefabName))
      return
    end
    local objectName = prefabName .. "_" .. tostring(self.prefabIndex) .. "_" .. tostring(index)
    item.gameObject.name = tostring(objectName)
    self.prefabIndex = self.prefabIndex + 1
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
      item.CachedRectTransform:SetInsetAndSizeFromParentEdge(CS.UnityEngine.RectTransform.Edge.Left, 10, self._scrollView:GetViewPortWidth() - 50)
    end
    local temp = self._scrollViewContent:AddComponent(chatItemScript, item.gameObject)
    temp:SetContentViewScript(self)
    temp:UpdateItem(self._chatDatas[index + 1], index + 1)
    if chatItemScript == ChatItemNoticeDetail then
      temp:SetLoopScrollData(self._scrollView, index)
    end
    self._chatItemObjList[item] = temp
  end
  return item
end

function UIChatViewNoticeRemark:OnRecycleItemFunc(loopListViewItem)
  if loopListViewItem == nil then
    return
  end
  local script = self._chatItemObjList[loopListViewItem]
  if script ~= nil and script.OnRecycleItem then
    script:OnRecycleItem()
  end
end

function UIChatViewNoticeRemark:GetViewWidth()
  if self._scrollView then
    return self._scrollView:GetViewPortWidth()
  end
end

function UIChatViewNoticeRemark:RefreshScrollView()
  self._scrollView:RefreshAllShownItem()
end

function UIChatViewNoticeRemark:ReloadAfterTranslateRecv(index)
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWUIAllianceNoticeDetail) then
    return
  end
  if index == 0 then
    self:ReloadData()
  else
    self:RefreshScrollView()
  end
  if index == table.count(self._chatDatas) then
    self:OnMoveToBottom()
  end
end

function UIChatViewNoticeRemark:GetRoomMsgs()
  local roomId = self:GetCurrentRoomId()
  local roomData = ChatInterface.getRoomData(roomId)
  if roomData then
    local msgs = roomData:GetUnblockedChatDatas()
    if self.noticeData then
      local data = DataCenter.AllianceNoticeManager:GetNoticeDataById(self.noticeData.uid)
      if data then
        self.noticeData = data
      elseif self.noticeData.uid then
        Logger.LogError("noticeData is nil id : " .. self.noticeData.uid)
      elseif self.noticeData.content then
        Logger.LogError("noticeData is nil content : " .. self.noticeData.content)
      else
        Logger.LogError("noticeData is nil")
      end
      self.noticeData.isNotice = true
      
      function self.noticeData.getSeqId()
        return -1
      end
      
      self.noticeData.scrollViewWidth = self._scrollView:GetViewPortWidth()
      table.insert(msgs, 1, self.noticeData)
    end
    return msgs
  end
  return nil
end

function UIChatViewNoticeRemark:ClearChatDatas()
  self._chatDatas = {}
  self._timeFlags = {}
end

function UIChatViewNoticeRemark:GetItemCount()
  return table.length(self._chatDatas)
end

function UIChatViewNoticeRemark:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self._scrollView.unity_looplistview2:SetItemUseCanvas(true)
  self._scrollView:InitListViewParam2(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end, nil, nil, function(loopListViewItem)
    self:OnRecycleItemFunc(loopListViewItem)
  end)
end

function UIChatViewNoticeRemark:OnEnable()
  base.OnEnable(self)
  self._scrollBarImg = self._vScrollBar.transform:Find("SlidingArea/Handle"):GetComponent(typeof(CS.UnityEngine.UI.Image))
end

function UIChatViewNoticeRemark:CheckAbstractRoom()
  local roomId = self:GetCurrentRoomId()
  if roomId == E_CHAT_COUNTRY_ROOMID or roomId == E_CHAT_ALLIANCE_ROOMID then
    self:ShowLoading()
  else
    self:HideLoading()
  end
end

function UIChatViewNoticeRemark:ShowLoading()
  self._objLoading:SetActive(true)
  self._txt_loading:SetLocalText(290047)
end

function UIChatViewNoticeRemark:HideLoading()
  self._objLoading:SetActive(false)
end

function UIChatViewNoticeRemark:OnDestroy()
  self:ComponentDestroy()
  self.lastVisibleHeight = nil
  base.OnDestroy(self)
end

function UIChatViewNoticeRemark:OnDisable()
  self._scrollView_ScrollRect:RemoveAllListeners()
  self._isFetchingMore = false
  base.OnDisable(self)
end

function UIChatViewNoticeRemark:OnChatLoginSuccess()
  self._isFetchingMore = false
  self:HideLoading()
end

function UIChatViewNoticeRemark:OnRecieveChat(chatRoomData)
  if chatRoomData == nil then
    return
  end
  local currentRoomId = self:GetCurrentRoomId()
  local luaRoomId = chatRoomData.roomId
  if currentRoomId ~= luaRoomId then
    return
  end
  local room = ChatInterface.getRoomData(currentRoomId)
  if not room then
    Logger.LogError(">>>> OnRecieveChat can't find room by roomId: " .. tostring(luaRoomId) .. "|" .. tostring(currentRoomId))
    return
  end
  room:readMsg(room.lastSeqId)
  local total = room:getToTalNum()
  local roomMsgs = room.msgs
  local preSendTime = 0
  local lastMaxCount = self:GetItemCount()
  if 1 < total then
    local prevChatData = roomMsgs[#roomMsgs - 1]
    preSendTime = prevChatData:getCreateTime()
  end
  self._chatDatas[#self._chatDatas + 1] = chatRoomData
  local isBottom = false
  local lastChatItem = self._scrollView:GetShownItemByItemIndex(lastMaxCount - 1)
  if lastChatItem ~= nil then
    local pos = self._scrollView:GetItemCornerPosInViewPort(lastChatItem)
    isBottom = Mathf.Abs(pos.y) - self._scrollView.unity_looplistview2.ViewPortSize < lastChatItem.ItemSize
  end
  self._scrollView:SetListItemCount(self:GetItemCount(), false, false)
  self._scrollView:RefreshAllShownItem()
  if isBottom and not self._scrollView.unity_looplistview2.IsDraging then
    self:ScrollToTail()
  end
  self.notRemarkTip:SetActive(self._chatDatas and #self._chatDatas == 0)
end

function UIChatViewNoticeRemark:OnMoveToBottom()
  self._isFetchingMore = false
  local chatCount = self:GetItemCount()
  self:ReloadData()
  self._scrollView.unity_looplistview2:ForceUpdate()
  if chatCount and 0 < chatCount then
    self._scrollView:MovePanelToItemIndex(chatCount, 0)
  end
end

function UIChatViewNoticeRemark:SetNoticeData(noticeData)
  self.noticeData = noticeData
end

function UIChatViewNoticeRemark:OnUpdateHistoryMsg()
  self._isFetchingMore = false
  self:ReloadData()
  self._scrollView.unity_looplistview2:ForceUpdate()
end

function UIChatViewNoticeRemark:OnRequestHistoryResult(ret)
  self._isFetchingMore = false
  local oldChatCount = self:GetItemCount()
  self:ReloadData()
  local newChatCount = self:GetItemCount()
  self._scrollView.unity_looplistview2:ForceUpdate()
  if not self.isNotFrist then
    self.isNotFrist = true
    self:MoveToTop()
    return
  end
  if newChatCount - oldChatCount - 1 > 0 and self.isNotFrist then
    self._scrollView:MovePanelToItemIndex(newChatCount - oldChatCount - 1, 0)
  else
    self._scrollView:MovePanelToItemIndex(oldChatCount - 1, 0)
  end
end

function UIChatViewNoticeRemark:OnRequestHistoryResultByTime(ret)
  self._isFetchingMore = false
  local isRoomIdPass = false
  if ret and ret.roomId then
    local roomId = self:GetCurrentRoomId()
    local retRoomId = ret.roomId
    if retRoomId == roomId then
      isRoomIdPass = true
    end
  end
  if not isRoomIdPass then
    return
  end
  self:OnRequestHistoryResult(ret)
end

function UIChatViewNoticeRemark:GetChatItemPrefabName(index)
  index = index + 1
  if index > table.length(self._chatDatas) then
    return "ChatItemNoticeRemark_Left"
  end
  if self._chatDatas[index].isNotice then
    return "ChatItemNoticeDetail"
  end
  local chatData = self._chatDatas[index]
  if chatData == nil then
    return "ChatItemNoticeDetail"
  end
  if chatData.post == PostType.MessageRecall then
    return "ChatCancelMsg"
  end
  if chatData.post == PostType.Text_Normal and ChatInterface.isTestingServer() then
    return "ChatItemFrame"
  end
  local isMyChat = chatData:isMyChat()
  if chatData.post == PostType.ChatGPT_Assistant_Private then
    return "ChatItemNoticeRemark_Left"
  end
  if chatData.post == PostType.Text_StorageShopShare then
    local attachInfo = chatData:getMessageParam(false)
    if not attachInfo.slots then
      return isMyChat and "ChatItemNoticeRemark_Right" or "ChatItemNoticeRemark_Left"
    end
  elseif ChatInterface.isTestingServer() then
    return isMyChat and "ChatItemNoticeRemark_Right_TMP" or "ChatItemNoticeRemark_Left_TMP"
  else
    return isMyChat and "ChatItemNoticeRemark_Right" or "ChatItemNoticeRemark_Left"
  end
end

function UIChatViewNoticeRemark:GetChatItemScriptName(index)
  index = index + 1
  local chatData = self._chatDatas[index]
  if chatData.post == PostType.Text_Normal and ChatInterface.isTestingServer() then
    return ChatItemFrame
  end
  if chatData.post == PostType.MessageRecall then
    return ChatCancelMsg
  end
  if chatData.isNotice then
    return ChatItemNoticeDetail
  end
  local isMyChat = chatData:isMyChat()
  if chatData.post == PostType.ChatGPT_Assistant_Private then
    return ChatItemLeft_Normal
  end
  if chatData.post == PostType.Text_StorageShopShare then
    local attachInfo = chatData:getMessageParam(false)
    if attachInfo.slots then
    else
      return isMyChat and ChatItemRight_Normal or ChatItemLeft_Normal
    end
  else
    return isMyChat and ChatItemRight_Normal or ChatItemLeft_Normal
  end
end

function UIChatViewNoticeRemark:ReLoadChat()
  self:InitChatMsg()
  self._isFetchingMore = false
  self:CheckAbstractRoom()
  self:CheckNetIsFine()
end

function UIChatViewNoticeRemark:CheckNetIsFine()
  if not ChatManager2:GetInstance().Net:IsRunning() then
    self:ShowLoading()
  end
end

function UIChatViewNoticeRemark:InitChatMsg()
  self._vScrollBar:Set_anchoredPosition(100, 0)
  self:ReloadData()
  self._scrollView:MovePanelToItemIndex(table.length(self._chatDatas) - 1, 0)
end

function UIChatViewNoticeRemark:UpdateScrollbarVisible()
  if self:IsNeedShowScrollBar() then
    self._scrollBarImg.color = Color32.New(183, 163, 163, 255)
    self._scrollBarImg:DOPause()
    self._vScrollBar.anchoredPosition = Vector2.New(-7, 0)
  else
    self._vScrollBar.anchoredPosition = Vector2.New(100, 0)
  end
end

function UIChatViewNoticeRemark:IsNeedShowScrollBar()
  return self._scrollView.unity_looplistview2.ContainerTrans.sizeDelta.y > self._scrollView.unity_looplistview2.ViewPortHeight
end

function UIChatViewNoticeRemark:OnScollValueChange()
  if not self._scrollView.unity_looplistview2.IsDraging and Mathf.Abs(self._scrollView.unity_looplistview2.ScrollRect.velocity.y) < 40 and self.delayTimerTask == nil and self._scrollBarImg.color.a > 200 and self:IsNeedShowScrollBar() then
    self.delayTimerTask = TimerManager:GetInstance():GetTimer(0.3, function()
      if self._scrollBarImg ~= nil then
        self._scrollBarImg:DOFade(0, 0.2)
      end
      if self.delayTimerTask ~= nil then
        self.delayTimerTask:Stop()
        self.delayTimerTask = nil
      end
    end, self, true, false, false)
    self.delayTimerTask:Start()
  end
end

function UIChatViewNoticeRemark:ReloadData()
  self:ClearChatDatas()
  local roomMsgs = self:GetRoomMsgs()
  if roomMsgs ~= nil then
    for k, chatData in ipairs(roomMsgs) do
      if chatData.isNotice or chatData ~= nil and not chatData:canSkip() then
        self._chatDatas[#self._chatDatas + 1] = chatData
      end
    end
  end
  self.notRemarkTip:SetActive(self._chatDatas and #self._chatDatas == 0)
  self._scrollView:SetListItemCount(self:GetItemCount(), false, false)
  self._scrollView:RefreshAllShownItem()
  if #self._chatDatas == 1 then
    TimerManager:GetInstance():DelayInvoke(function()
      if self._scrollView and self._scrollView.RefreshAllShownItem then
        self._scrollView:RefreshAllShownItem()
      end
    end, 0.1)
  end
  if self._chatDatasCnt == 0 and table.count(self._chatDatas) ~= 0 then
    self._chatDatasCnt = table.count(self._chatDatas)
    self:MoveToTop()
  end
end

function UIChatViewNoticeRemark:UpdateMsgList()
  self:ClearChatDatas()
  local roomMsgs = self:GetRoomMsgs()
  if roomMsgs ~= nil then
    for k, chatData in ipairs(roomMsgs) do
      if chatData.isNotice or chatData ~= nil and not chatData:canSkip() then
        self._chatDatas[#self._chatDatas + 1] = chatData
      end
    end
  end
end

function UIChatViewNoticeRemark:OnEndDrag()
  if not self._isFetchingMore then
    local max = self._scrollView.transform.rect.height - 20
    local difference = self._scrollView.unity_looplistview2.ContainerTrans.rect.height - self._scrollView.unity_looplistview2.ContainerTrans.localPosition.y
    if max > difference then
      local roomId = self:GetCurrentRoomId()
      local roomData = ChatInterface.getRoomData(roomId)
      if roomData:getToTalNum() > 0 then
        self:GetHistoricalChat()
      end
    elseif Mathf.Abs(self._scrollView.unity_looplistview2.ScrollRect.velocity.y) < 40 and self:IsNeedShowScrollBar() then
      self._scrollBarImg:DOFade(0, 0.2)
    end
  end
end

function UIChatViewNoticeRemark:GetHistoricalChat()
  self._isFetchingMore = true
  local roomId = self:GetCurrentRoomId()
  local room = ChatInterface.getRoomData(roomId)
  if room == nil then
    return
  end
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomV2, room.roomId, 1)
end

function UIChatViewNoticeRemark:StopMovement()
  if self._scrollView_ScrollRect then
    self._scrollView_ScrollRect:StopMovement()
  end
end

function UIChatViewNoticeRemark:CheckShowMoveToTailBtn()
  local isBottom = false
  local lastMaxCount = self:GetItemCount()
  local lastChatItem = self._scrollView:GetShownItemByItemIndex(lastMaxCount - 1)
  if lastChatItem ~= nil then
    local pos = self._scrollView:GetItemCornerPosInViewPort(lastChatItem)
    isBottom = Mathf.Abs(pos.y) - self._scrollView.unity_looplistview2.ViewPortSize < lastChatItem.ItemSize
  end
  if 0 < lastMaxCount then
    self.goTailBtn:SetActive(not isBottom)
  else
    self.goTailBtn:SetActive(false)
  end
end

function UIChatViewNoticeRemark:GetCurrentRoomId()
  local room = self.view:GetSelectedRoom()
  return room and room.roomId or nil
end

function UIChatViewNoticeRemark:TranslateAllShowingItems()
  if self.lastTranslateTime ~= nil and UITimeManager:GetInstance():GetServerTime() - self.lastTranslateTime < 300 then
    return
  end
  self.lastTranslateTime = UITimeManager:GetInstance():GetServerTime()
  local count = self:GetItemCount()
  for i = 0, count - 1 do
    if self._scrollView:GetShownItemByItemIndex(i) then
      local chatData = self._chatDatas[i + 1]
      if chatData and chatData.getTranslationMsg then
        local _translationMsg = chatData:getTranslationMsg()
        if (string.IsNullOrEmpty(_translationMsg) or chatData.translatedLang ~= ChatInterface.GetChatTranslateLanguageAbbr()) and (chatData:GetTranslateState() == 0 or chatData:GetTranslateState() == -1) then
          chatData:setTranslateState(1)
          chatData:SetCanRefreshTranslate(1)
          EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_TRANSLATE, chatData)
        end
      end
    end
  end
  self:RefreshScrollView()
end

return UIChatViewNoticeRemark
