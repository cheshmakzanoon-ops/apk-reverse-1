local base = UIBaseContainer
local UIChatViewMessageArea_v2 = BaseClass("UIChatViewMessageArea_v2", base)
local LoadingTipStatus = _ENV.LoadingTipStatus
local RectTransform = CS.UnityEngine.RectTransform
local ChatAISecretaryCell = require("UI.UIChatNew.Component.AIAssistant.ChatAISecretaryCell")
local ChatPushMsg = require("UI.UIChatNew.Component.ChatPushMsg.ChatPushMsg")
local UILWChatActDetectTreasureUseItemMsg = require("UI.UIChatNew.Component.ChatPushMsg.UILWChatActDetectTreasureUseItemMsg")
local ChatItem = require("UI.UIChatNew.Component.ChatItem.ChatItem")
local ChatAllianceCityUnderAttack = require("UI.UIChatNew.Component.ChatItem.ChatAllianceCityUnderAttack")
local ChatItemNeutralAttack = require("UI.UIChatNew.Component.ChatItem.ChatItemNeutralAttack")
local ChatItemMailReportShare = require("UI.UIChatNew.Component.ChatItem.ChatItemMailReportShare")
local ChatItemMailScoutShare = require("UI.UIChatNew.Component.ChatItem.ChatItemMailScoutShare")
local ChatItemAllianceTaskShare = require("UI.UIChatNew.Component.ChatItem.ChatItemAllianceTaskShare")
local ChatItemAllianceRecruitShare = require("UI.UIChatNew.Component.ChatItem.ChatItemAllianceRecruitShare")
local ChatItemTrain = require("UI.UIChatNew.Component.ChatItem.ChatItemTrain")
local ChatTrainRob = require("UI.UIChatNew.Component.ChatItem.ChatTrainRob")
local ChatItemTruckSendOrRob = require("UI.UIChatNew.Component.ChatItem.ChatItemTruckSendOrRob")
local ChatItemRedPacketItem = require("UI.UIChatNew.Component.ChatItem.ChatItemRedPacketItem")
local ChatItemPushRedPacketlMsg = require("UI.UIChatNew.Component.ChatItem.ChatItemPushRedPacketlMsg")
local ChatItemActivityMultipleParkour = require("UI.UIChatNew.Component.ChatItem.ChatItemActivityMultipleParkour")
local ChatTorchRelayCheer = require("UI.UIChatNew.Component.ChatTorchRelayCheer")
local ChatItemHelpStopFireAlliance = require("UI.UIChatNew.Component.ChatItem.ChatItemHelpStopFireAlliance")
local ChatItemAllianceCongratulation = require("UI.UIChatNew.Component.ChatItem.ChatItemAllianceCongratulation")
local UseChatItemFrame = true
local ChatItemFrame = require("UI.UIChatNewV2.Component.ChatItem.ChatItemFrame")
local ChatItemWithoutHeadFrame = require("UI.UIChatNewV2.Component.ChatItem.ChatItemWithoutHeadFrame")
local logger = require("Framework.Logger.Logger")
local _cp_scrollView = ""
local _cp_scrollViewContent = "MainViewport/MainContent"
local _cp_infoText = "InfoLabel"
local _cp_vScrollBar = "MainViewport/Scrollbar"
local _cp_objLoading = "objLoading"
local _cp_txt_loading = "objLoading/Image/txtLoading"
local _go_tail_btn_path = "GoTailBtn"
local DragDirectionType = {
  None = 1,
  Top = 2,
  Bottom = 3
}
local ChatFrameOffset = 16

function UIChatViewMessageArea_v2:setSlideNode(node)
  self._eventTriggerNode = node
end

function UIChatViewMessageArea_v2:getSlideNode()
  return self._eventTriggerNode
end

function UIChatViewMessageArea_v2:ComponentDefine()
  self._objLoading = self:AddComponent(UIBaseContainer, _cp_objLoading)
  self._txt_loading = self:AddComponent(UIText, _cp_txt_loading)
  self._scrollView = self:AddComponent(UILoopListView2, _cp_scrollView)
  self._scrollView_ScrollRect = self:AddComponent(UIScrollRect, _cp_scrollView)
  self._scrollView_ScrollRect:AddValueChangeListener(function(vec)
    self:OnScollValueChange()
    self:CheckShowMoveToTailBtn()
  end)
  self._scrollViewContent = self:AddComponent(UIBaseContainer, _cp_scrollViewContent)
  self._vScrollBar = self.transform:Find(_cp_vScrollBar):GetComponent(typeof(CS.UnityEngine.RectTransform))
  self._scrollBarImg = self._vScrollBar.transform:Find("SlidingArea/Handle"):GetComponent(typeof(CS.UnityEngine.UI.Image))
  
  function self._scrollView.unity_looplistview2.mOnListClickAction()
  end
  
  function self._scrollView.unity_looplistview2.mOnBeginDragAction()
    self:UpdateScrollbarVisible()
  end
  
  function self._scrollView.unity_looplistview2.mOnDragingAction()
    self:OnDragingAction()
  end
  
  function self._scrollView.unity_looplistview2.mOnEndDragAction()
    self:OnDragEndAction()
  end
  
  self.goTailBtn = self:AddComponent(UIButton, _go_tail_btn_path)
  self.goTailBtn:SetOnClick(function()
    self:ScrollToTail()
  end)
  self._inputTest = self.transform:Find("UIInputTest"):GetComponent(typeof(CS.UITestInputEvent))
  self._inputTest:SetEnable(false)
end

function UIChatViewMessageArea_v2:ComponentDestroy()
  self._scrollView_ScrollRect:RemoveAllListeners()
  self._scrollView.unity_looplistview2.mOnListClickAction = nil
  self._scrollView.unity_looplistview2.mOnBeginDragAction = nil
  self._scrollView.unity_looplistview2.mOnDragingAction = nil
  self._scrollView.unity_looplistview2.mOnEndDragAction = nil
  self:ClearScrollViewContent()
  self:ClearAllChatItems()
end

function UIChatViewMessageArea_v2:ClearAllChatItems()
  self:SetListItemCount_Mod(0, false, false)
end

function UIChatViewMessageArea_v2:RecycleAllChatItems()
end

function UIChatViewMessageArea_v2:ClearScrollViewContent()
  self._chatItemObjList = {}
  self._scrollViewContent:RemoveComponentsOnly(ChatItemAllianceRecruitShare)
  self._scrollViewContent:RemoveComponentsOnly(ChatItemNeutralAttack)
  self._scrollViewContent:RemoveComponentsOnly(ChatItem)
  self._scrollViewContent:RemoveComponentsOnly(ChatItemMailReportShare)
  self._scrollViewContent:RemoveComponentsOnly(ChatItemAllianceTaskShare)
  self._scrollViewContent:RemoveComponentsOnly(UILWChatActDetectTreasureUseItemMsg)
  self._scrollViewContent:RemoveComponentsOnly(ChatAISecretaryCell)
  self._scrollViewContent:RemoveComponentsOnly(ChatItemTrain)
  self._scrollViewContent:RemoveComponentsOnly(ChatTrainRob)
  self._scrollViewContent:RemoveComponentsOnly(ChatAllianceCityUnderAttack)
  self._scrollViewContent:RemoveComponentsOnly(ChatItemNeutralAttack)
  self._scrollViewContent:RemoveComponentsOnly(ChatItemMailScoutShare)
  self._scrollViewContent:RemoveComponentsOnly(ChatItemRedPacketItem)
  self._scrollViewContent:RemoveComponentsOnly(ChatItemPushRedPacketlMsg)
  self._scrollViewContent:RemoveComponentsOnly(ChatItemTruckSendOrRob)
  self._scrollViewContent:RemoveComponentsOnly(ChatItemActivityMultipleParkour)
  self._scrollViewContent:RemoveComponentsOnly(ChatTorchRelayCheer)
  self._scrollViewContent:RemoveComponentsOnly(ChatItemFrame)
  self._scrollViewContent:RemoveComponentsOnly(ChatItemHelpStopFireAlliance)
  self._scrollViewContent:RemoveComponentsOnly(ChatItemAllianceCongratulation)
  self._scrollView:RecycleAllItem()
end

function UIChatViewMessageArea_v2:ResetLoadingTipState()
  self.dragDirectionForRefresh = DragDirectionType.None
  self.curLoadingTipState = LoadingTipStatus.None
  if self.showMessageTimer ~= nil then
    self.showMessageTimer:Stop()
    self.showMessageTimer = nil
  end
end

function UIChatViewMessageArea_v2:DataDefine()
  self._databaseOffset = -10
  self._isFetchingMore = false
  self.delayTimerTask = nil
  self._scrollViewPortSize = nil
  self._chatItemObjList = {}
  self.pinGoReq = {}
  self.lastVisibleHeight = 0
  self.timeInterval = 300
  self:InitChatDatas()
  self.chatItemSizeDelta = Vector2.zero
  self.curLoadingTipState = LoadingTipStatus.None
  self.loadingTipsAnchorPos = Vector2.New(0, 0)
  self.loadedMessageOffset = ChatLoadingTipHeight + ChatFrameOffset
  self.dragDirectionForRefresh = DragDirectionType.None
  self.curLoadingChatItem = nil
  ChatManager2:GetInstance().Room:ClearAllTimestampAnchor()
end

function UIChatViewMessageArea_v2:InitChatDatas()
  self._chatDatas = {}
  self._timeFlags = {}
  self._tipFlags = {}
end

function UIChatViewMessageArea_v2:GetChatData(key)
  return self._chatDatas[key]
end

function UIChatViewMessageArea_v2:GetChatDatas()
  return self._chatDatas
end

function UIChatViewMessageArea_v2:GetSeqIdIndex(seqId)
  if seqId == nil then
    return
  end
  for k, v in pairs(self._chatDatas) do
    if v.seqId == seqId and not self._timeFlags[k] then
      return k - 1
    end
  end
end

function UIChatViewMessageArea_v2:GetItemCount()
  return table.length(self._chatDatas)
end

function UIChatViewMessageArea_v2:InsertChatData(chatRoomData, timeFlag)
  self._chatDatas[#self._chatDatas + 1] = chatRoomData
  if type(timeFlag) == "number" then
    self._chatDatas[self:GetItemCount()].timeFlag = timeFlag
    self._timeFlags[self:GetItemCount()] = timeFlag
  elseif type(timeFlag) == "string" then
    self._chatDatas[self:GetItemCount()].tipFlag = timeFlag
    self._tipFlags[self:GetItemCount()] = timeFlag
  end
end

function UIChatViewMessageArea_v2:ClearChatDatas()
  self._chatDatas = {}
  self._timeFlags = {}
  self._tipFlags = {}
end

function UIChatViewMessageArea_v2:UpdateMsgList()
  self:ClearChatDatas()
  local roomMsgs = self:GetRoomMsgs()
  if roomMsgs == nil or #roomMsgs <= 0 then
    return
  end
  local roomId = self:GetCurrentRoomId()
  local curAnchorSeqId = ChatManager2:GetInstance().Room:GetTimestampAnchorSeqId(roomId)
  local anchorIndex = self:GetCurTimestampAnchorIndex(roomMsgs, curAnchorSeqId)
  if anchorIndex == -1 then
    anchorIndex = self:GetNewTimestampAnchorIndex(roomMsgs)
  end
  self:CalculateTimeFlagsByAnchor(roomMsgs, anchorIndex)
end

function UIChatViewMessageArea_v2:GetRoomMsgs()
  local roomId = self:GetCurrentRoomId()
  if not roomId then
    return nil
  end
  local roomMgr = ChatManager2:GetInstance().Room
  local jumpMsgRoom = roomMgr:GetJumpMsgRoom()
  if jumpMsgRoom and jumpMsgRoom.roomId ~= roomId then
    roomMgr:ClearJumpMsgRoom()
  end
  local roomData
  if roomMgr:IsShowingJumpMsg() then
    roomData = roomMgr:GetJumpMsgRoom()
  else
    roomData = ChatInterface.getRoomData(roomId)
  end
  if roomData then
    return roomData:GetUnblockedChatDatas()
  end
  return nil
end

function UIChatViewMessageArea_v2:GetCurrentRoomId()
  local room = self.view:GetSelectedRoom()
  return room and room.roomId or nil
end

function UIChatViewMessageArea_v2:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ERROR_OR_DISCONNECT, self.OnChatNetErrorOrDisconnect)
  self:AddUIListener(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, self.OnRecieveChat)
  self:AddUIListener(ChatEventEnum.CHAT_UPDATE_ROOM_HISTORY_MSG, self.OnUpdateHistoryMsg)
  self:AddUIListener(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_RESULT, self.OnRequestHistoryResult)
  self:AddUIListener(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_RESULT_BY_TIME, self.OnRequestHistoryByTimeResult)
  self:AddUIListener(ChatEventEnum.CHAT_REQUEST_HISTORY_GOTO_MSG_RESULT, self.OnRequestGotoHistoryResult)
  self:AddUIListener(ChatEventEnum.CHAT_ALLIANCE_NOTICELIST_ADD, self.OnRecieveNotice)
  self:AddUIListener(ChatEventEnum.CHAT_LOGIN_SUCCESS, self.OnChatLoginSuccess)
  self:AddUIListener(ChatEventEnum.CHAT_MAIN_VIEW_STOP_MOVEMENT, self.StopMovement)
  self:AddUIListener(ChatEventEnum.CHAT_MOVETOBOTTOM, self.OnMoveToBottom)
  self:AddUIListener(ChatEventEnum.CHAT_REFRESH_VIEW, self.RefreshScrollView)
  self:AddUIListener(ChatEventEnum.CHAT_TRANSLATE_All, self.TranslateAllShowingItems)
end

function UIChatViewMessageArea_v2:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ERROR_OR_DISCONNECT, self.OnChatNetErrorOrDisconnect)
  self:RemoveUIListener(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, self.OnRecieveChat)
  self:RemoveUIListener(ChatEventEnum.CHAT_UPDATE_ROOM_HISTORY_MSG, self.OnUpdateHistoryMsg)
  self:RemoveUIListener(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_RESULT, self.OnRequestHistoryResult)
  self:RemoveUIListener(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_RESULT_BY_TIME, self.OnRequestHistoryByTimeResult)
  self:RemoveUIListener(ChatEventEnum.CHAT_REQUEST_HISTORY_GOTO_MSG_RESULT, self.OnRequestGotoHistoryResult)
  self:RemoveUIListener(ChatEventEnum.CHAT_LOGIN_SUCCESS, self.OnChatLoginSuccess)
  self:RemoveUIListener(ChatEventEnum.CHAT_MAIN_VIEW_STOP_MOVEMENT, self.StopMovement)
  self:RemoveUIListener(ChatEventEnum.CHAT_ALLIANCE_NOTICELIST_ADD, self.OnRecieveNotice)
  self:RemoveUIListener(ChatEventEnum.CHAT_MOVETOBOTTOM, self.OnMoveToBottom)
  self:RemoveUIListener(ChatEventEnum.CHAT_REFRESH_VIEW, self.RefreshScrollView)
  self:RemoveUIListener(ChatEventEnum.CHAT_TRANSLATE_All, self.TranslateAllShowingItems)
  base.OnRemoveListener(self)
end

function UIChatViewMessageArea_v2:OnRecieveNotice()
  local currentRoomId = self:GetCurrentRoomId()
  if currentRoomId then
    local room = ChatInterface.getRoomData(currentRoomId)
    if room and room.group == ChatGroupType.GROUP_ALLIANCE_NOTICE then
      DataCenter.AllianceNoticeManager:SaveReadTime()
    end
  end
end

function UIChatViewMessageArea_v2:OnChatNetErrorOrDisconnect()
  self:ShowLoading()
  local roomMgr = ChatManager2:GetInstance().Room
  roomMgr:ClearJumpMsgRoom()
end

function UIChatViewMessageArea_v2:ScrollToTail()
  ChatManager2:GetInstance().Room:ClearJumpMsgRoom()
  self.curLoadingTipState = LoadingTipStatus.None
  self:UpdateLoadingTip(self.curLoadingChatItem)
  self:UpdateMsgList()
  self:SetListItemCount_Mod(self:GetItemCount() + 2, false, true)
  if self.goTailBtn then
    self.goTailBtn:SetActive(false)
  end
end

function UIChatViewMessageArea_v2:OnGetItemByIndex(listView, index)
  if index < 0 or index > self:GetItemCount() + 1 then
    return nil
  end
  local item
  if index == 0 or index == self:GetItemCount() + 1 then
    item = listView:NewListViewItem("ChatPullToLoad")
    self:UpdateLoadingTip(item)
    return item
  end
  self.prefabIndex = self.prefabIndex or 0
  index = index - 1
  local prefabName = self:GetChatItemPrefabName(index)
  if prefabName == "ChatItemFrame" then
    local postItemConfig = ChatInterface.GetPostConfig_Player(self:GetChatData(index + 1))
    prefabName = prefabName .. "_" .. postItemConfig.postClass.__cname
  elseif prefabName == "ChatItemWithoutHeadFrame" then
    local postItemConfig = self:GetPostConfig_System(self:GetChatData(index + 1), index + 1)
    prefabName = prefabName .. "_" .. postItemConfig.postClass.__cname
  end
  item = listView:NewListViewItem(prefabName)
  if item == nil then
    return nil
  end
  local chataData = self:GetChatData(index + 1)
  if chataData then
    self.view.ctrl:OnCreateChatItem(chataData)
  end
  if self._chatItemObjList[item] ~= nil then
    self:SetChatItemSizeDelta(item)
    self._chatItemObjList[item]:SetContentViewScript(self)
    self._chatItemObjList[item]:UpdateItem(self:GetChatData(index + 1), index + 1)
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
      self:SetChatItemSizeDelta(item)
    end
    local temp = self._scrollViewContent:AddComponent(chatItemScript, item.gameObject)
    temp:SetContentViewScript(self)
    temp:UpdateItem(self:GetChatData(index + 1), index + 1)
    self._chatItemObjList[item] = temp
  end
  return item
end

function UIChatViewMessageArea_v2:LogChatItemUse(index, scriptName, prefabName)
  index = index + 1
  if self._timeFlags[index] ~= nil or self._tipFlags[index] ~= nil then
    return
  end
  local chatData = self:GetChatData(index)
  if chatData == nil then
    return
  end
  local postType = chatData.post
  if ChatInterface.IsSharePoint(postType) then
    postType = PostType.Text_PointShare
  end
  if postType == PostType.Text_ChatRoomSystemMsg or postType == PostType.Text_AllianceRankChange or postType == PostType.Abandon_AllianceCity or postType == PostType.Text_MemberJoin or postType == PostType.Text_MemberQuit or postType == PostType.Alliance_OfficialChange or postType == PostType.Alliance_LeaderChange or postType == PostType.Alliance_CityUnderAttack or postType == PostType.Train_Rob or postType == PostType.Train_Driver or postType == PostType.Train_Departure or postType == PostType.Alliance_Notice or postType == PostType.BestReward or postType == PostType.RedPacket_MSG or postType == PostType.DetectEventGetDoubleTreasure or postType == PostType.ZombieRush or postType == PostType.HELP_STOP_FIRE_ALLIANCEE or postType == PostType.ActDetectTreasureItemUse or postType == PostType.MONSTER_INVASION_BIG_BOSS or postType == PostType.Detect_Treasure_Fin_Info or postType == PostType.NewAllianceRallyPoint or postType == PostType.DiggingGameShareAlliance or postType == PostType.OffSeasonDiggingGameShareAlliance or postType == PostType.SeasonTradeShopRefresh or postType == PostType.CaptureHugeSandWorm or postType == PostType.TradeOpenLevel or postType == PostType.OccupyTradePlayer or postType == PostType.ALLIANCE_MONSTER_CHALLENGE_NEW_BATTLE or ChatInterface.IsAssistantChatMessage(postType) then
    return
  end
  if ChatItemPosts[postType] == nil then
    Logger.LogInfo(string.format("[LogChatItemUse] post: %s, script: %s, prefab: %s", tostring(chatData.post), scriptName.__cname, prefabName))
  end
end

function UIChatViewMessageArea_v2:SetChatItemSizeDelta(item)
  if item.CachedRectTransform.sizeDelta.x == self._scrollView:GetViewPortWidth() - 50 then
    return
  end
  self.chatItemSizeDelta = self.chatItemSizeDelta or Vector2.zero
  self.chatItemSizeDelta.x = self._scrollView:GetViewPortWidth() - 50
  self.chatItemSizeDelta.y = item.CachedRectTransform.sizeDelta.y
  item.CachedRectTransform.sizeDelta = self.chatItemSizeDelta
end

local TimeInterval = 3000

function UIChatViewMessageArea_v2:TranslateAllShowingItems()
  if self.lastTranslateTime ~= nil and UITimeManager:GetInstance():GetServerTime() - self.lastTranslateTime < TimeInterval then
    return
  end
  self.lastTranslateTime = UITimeManager:GetInstance():GetServerTime()
  local count = self:GetItemCount()
  for i = 0, count - 1 do
    if self._scrollView:GetShownItemByItemIndex(i + 1) then
      local chatData = self:GetChatData(i + 1)
      local _translationMsg = chatData:getTranslationMsg()
      local isSkipTranslate = self:IsSkipTranslate(chatData)
      if not isSkipTranslate then
        if chatData.translatedLang ~= ChatInterface.GetChatTranslateLanguageAbbr() then
          chatData:setTranslateState(1)
          chatData:SetCanRefreshTranslate(1)
          EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_TRANSLATE, chatData)
        elseif string.IsNullOrEmpty(_translationMsg) and (chatData:GetTranslateState() == 0 or chatData:GetTranslateState() == -1) then
          chatData:setTranslateState(1)
          chatData:SetCanRefreshTranslate(1)
        end
      end
    end
  end
  self:RefreshScrollView()
end

function UIChatViewMessageArea_v2:IsSkipTranslate(chatData)
  return chatData:getPost() == PostType.Chat_Stickers
end

function UIChatViewMessageArea_v2:OnRecycleItemFunc(loopListViewItem)
  if loopListViewItem == nil then
    return
  end
  local script = self._chatItemObjList[loopListViewItem]
  if script ~= nil and script.OnRecycleItem then
    script:OnRecycleItem()
  end
end

function UIChatViewMessageArea_v2:RefreshScrollView()
  self:SetListItemCount_Mod(self:GetItemCount() + 2, false, false, true)
end

function UIChatViewMessageArea_v2:ReloadAfterTranslateRecv(index)
  self:RefreshScrollView()
end

function UIChatViewMessageArea_v2:ClearChatDatas()
  self._chatDatas = {}
  self._timeFlags = {}
  self._tipFlags = {}
  CS.UIChatSendPhoto.ClearAssetLoadingSet()
end

function UIChatViewMessageArea_v2:GetItemCount()
  return table.length(self._chatDatas)
end

function UIChatViewMessageArea_v2:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self._scrollView.unity_looplistview2:SetItemUseCanvas(true)
  self._scrollView:InitListViewParam2(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end, nil, nil, function(loopListViewItem)
    self:OnRecycleItemFunc(loopListViewItem)
  end)
  SFSNetwork.SendMessage(MsgDefines.ChatAskAllianceGatherMessage)
end

function UIChatViewMessageArea_v2:CheckAbstractRoom()
  local roomId = self:GetCurrentRoomId()
  if roomId == E_CHAT_COUNTRY_ROOMID or roomId == E_CHAT_ALLIANCE_ROOMID then
    self:ShowLoading()
  else
    self:HideLoading()
  end
end

function UIChatViewMessageArea_v2:ShowLoading()
  self._objLoading:SetActive(true)
  self._txt_loading:SetLocalText(290047)
end

function UIChatViewMessageArea_v2:HideLoading()
  self._objLoading:SetActive(false)
end

function UIChatViewMessageArea_v2:OnDestroy()
  self:ComponentDestroy()
  self.lastVisibleHeight = nil
  self.chatItemSizeDelta = nil
  self.loadingTipsAnchorPos = nil
  self:ResetLoadingTipState()
  self.curLoadingChatItem = nil
  ChatManager2:GetInstance().Room:ClearAllTimestampAnchor()
  base.OnDestroy(self)
end

function UIChatViewMessageArea_v2:OnEnable()
  base.OnEnable(self)
  self._scrollView_ScrollRect:AddValueChangeListener(function(vec)
    self:OnScollValueChange()
    self:CheckShowMoveToTailBtn()
  end)
end

function UIChatViewMessageArea_v2:OnDisable()
  self._scrollView_ScrollRect:RemoveAllListeners()
  self._isFetchingMore = false
  base.OnDisable(self)
end

function UIChatViewMessageArea_v2:OnChatLoginSuccess()
  self._isFetchingMore = false
  self:HideLoading()
end

function UIChatViewMessageArea_v2:OnRecieveChat(chatRoomData)
  if chatRoomData == nil then
    return
  end
  local beforeInsert = self:GetItemCount()
  local roomId = self:GetCurrentRoomId()
  local luaRoomId = chatRoomData.roomId
  if roomId ~= luaRoomId then
    return
  end
  local roomData = ChatInterface.getRoomData(roomId)
  if not roomData then
    Logger.LogError(">>>> OnRecieveChat can't find room by roomId: " .. tostring(luaRoomId) .. "|" .. tostring(roomId))
    return
  end
  roomData:readMsg(roomData.lastSeqId)
  if chatRoomData:getSeqId() == (roomData:GetOriginalFirstSeqId() or 1) then
    roomData:SetIsReachFirstMessage(true)
  end
  if not ChatManager2:GetInstance().Restrict:GetMsgIsCanShow(chatRoomData) or ChatManager2:GetInstance().Room:IsShowingJumpMsg() then
    return
  end
  local roomMsgs = self:GetRoomMsgs()
  roomMsgs = roomMsgs or {}
  local isBottom = self:CheckLastChatItemToBottom()
  local curAnchorSeqId = ChatManager2:GetInstance().Room:GetTimestampAnchorSeqId(roomId)
  local anchorIndex = self:GetCurTimestampAnchorIndex(roomMsgs, curAnchorSeqId)
  if anchorIndex == -1 then
    anchorIndex = self:GetNewTimestampAnchorIndex(roomMsgs)
  end
  local tmpHeadTimeFlag, _ = self:GetTimeFlagByTargetTime(roomMsgs, anchorIndex, chatRoomData:getCreateTime())
  if self:IsTimestampExist(tmpHeadTimeFlag) then
    self:InsertChatData(chatRoomData)
  else
    self:InsertChatData(chatRoomData, tmpHeadTimeFlag)
    self:InsertChatData(chatRoomData)
  end
  self:SetListItemCount_Mod(self:GetItemCount() + 2, false, beforeInsert == 0)
  if isBottom and not self._scrollView.unity_looplistview2.IsDraging then
    self:ScrollToTail()
  else
    self._scrollView:RefreshAllShownItem()
  end
end

function UIChatViewMessageArea_v2:CheckLastChatItemToBottom()
  local isBottom = false
  local lastMaxCount = self:GetItemCount()
  local lastChatItem = self._scrollView:GetShownItemByItemIndex(lastMaxCount)
  if lastChatItem == nil then
    return isBottom
  end
  local pos = self._scrollView:GetItemCornerPosInViewPort(lastChatItem)
  isBottom = Mathf.Abs(pos.y) - lastChatItem.ItemSizeWithPadding <= self._scrollView.unity_looplistview2.ViewPortSize
  return isBottom
end

function UIChatViewMessageArea_v2:OnMoveToBottom()
  self._isFetchingMore = false
  local chatCount = self:GetItemCount()
  self._scrollView:MovePanelToItemIndex(chatCount, 0)
end

function UIChatViewMessageArea_v2:OnUpdateHistoryMsg()
  self._isFetchingMore = false
  local roomId = self:GetCurrentRoomId()
  if not roomId then
    return nil
  end
  local roomData = ChatInterface.getRoomData(roomId)
  if roomData then
    roomData:readMsg(roomData.lastSeqId)
  end
end

function UIChatViewMessageArea_v2:OnRequestHistoryResult(ret)
  if ret and ret.rooms and table.count(ret.rooms) == 1 and ret.rooms[1].group == ChatGroupType.GROUP_FRIENDS_CIRCLE_ROOM then
    return
  end
  self._isFetchingMore = false
  self:UpdateMsgList()
  self:HideLoadingTips()
  self:SetListItemCount_Mod(self:GetItemCount() + 2, false, true)
  self:CheckShowMoveToTailBtn()
end

function UIChatViewMessageArea_v2:IsUpdateMsgs(ret)
  if not (ret and ret.msg) or table.count(ret.msg) == 0 then
    return
  end
  local roomId = self:GetCurrentRoomId()
  for i = 1, #ret.msg do
    if ret.msg[i].roomId == roomId then
      return true
    end
  end
end

function UIChatViewMessageArea_v2:OnRequestHistoryByTimeResult(ret)
  if not self:IsUpdateMsgs(ret) then
    return
  end
  self._isFetchingMore = false
  local oldChatCount = self:GetItemCount()
  local oldFirstMsgSeqId = self:GetOldFirstChatDataSeqId()
  local lastChatCount = self:GetItemCount()
  self:UpdateMsgList()
  self:SetListItemCount_Mod(self:GetItemCount() + 2, false, false)
  local newChatCount = self:GetItemCount()
  local moveToIndex = newChatCount - oldChatCount + 1
  if oldFirstMsgSeqId ~= -1 then
    local index = self:GetOriginalFirstPosIndex(oldFirstMsgSeqId)
    if index ~= -1 then
      moveToIndex = index
    end
  end
  local loadedMessageOffset = 0
  if lastChatCount ~= newChatCount then
    loadedMessageOffset = self.loadedMessageOffset
  end
  self:HideLoadingTips()
  self._scrollView:MovePanelToItemIndex(moveToIndex, loadedMessageOffset)
  self:CheckShowMoveToTailBtn()
end

function UIChatViewMessageArea_v2:OnRequestGotoHistoryResult(ret)
  self._isFetchingMore = false
  local oldChatCount = self:GetItemCount()
  local oldFirstMsgSeqId = self:GetOldFirstChatDataSeqId()
  self:UpdateMsgList()
  self:HideLoadingTips()
  self:SetListItemCount_Mod(self:GetItemCount() + 2, false, false)
  local newChatCount = self:GetItemCount()
  local moveToIndex = newChatCount - oldChatCount + 1
  if oldFirstMsgSeqId ~= -1 then
    local index = self:GetOriginalFirstPosIndex(oldFirstMsgSeqId)
    if index ~= -1 then
      moveToIndex = index
    end
  end
  if ret.refreshType == 1 then
    local index = (self:GetSeqIdIndex(ret.seqId) or 0) + 1
    self._scrollView:MovePanelToItemIndex_Mod(index, ChatFrameOffset)
    local item = self._scrollView:GetShownItemByItemIndex(index)
    local scripts = self._chatItemObjList[item]
    if scripts and scripts.ShowBlackFlash then
      scripts:ShowBlackFlash()
    end
  elseif ret.refreshType == 3 then
    self._scrollView:MovePanelToItemIndex_Mod(oldChatCount, 0, true)
  else
    self._scrollView:MovePanelToItemIndex_Mod(moveToIndex, self.loadedMessageOffset)
  end
end

function UIChatViewMessageArea_v2:GetChatItemPrefabName(index)
  index = index + 1
  if index > self:GetItemCount() then
    return "ChatItemFrame"
  end
  if self._timeFlags[index] ~= nil or self._tipFlags[index] ~= nil then
    return "ChatItemWithoutHeadFrame"
  end
  local chatData = self:GetChatData(index)
  if chatData == nil then
    return "ChatItemFrame"
  end
  local isMyChat = chatData:isMyChat()
  if chatData.post == PostType.ChatGPT_Assistant_Private then
    return "ChatItemFrame"
  end
  if chatData.post == PostType.Text_ChatRoomSystemMsg or chatData.post == PostType.Text_AllianceRankChange or chatData.post == PostType.Abandon_AllianceCity or chatData.post == PostType.MessageRecall or chatData.post == PostType.Text_MemberJoin or chatData.post == PostType.Text_MemberQuit then
    return "ChatItemWithoutHeadFrame"
  elseif UseChatItemFrame and ChatInterface.IsSharePoint(chatData.post) then
    return "ChatItemFrame"
  elseif UseChatItemFrame and chatData.post == PostType.GiftGiving then
    if chatData.group == ChatGroupType.GROUP_CUSTOM then
      return "ChatItemFrame"
    else
      return "ChatItemWithoutHeadFrame"
    end
  elseif UseChatItemFrame and chatData.post == PostType.TrainVipInvite then
    return "ChatItemFrame"
  elseif UseChatItemFrame and ChatItemPosts[chatData.post] then
    return "ChatItemFrame"
  elseif UseChatItemFrame and ChatItemPostsType2[chatData.post] then
    return "ChatItemWithoutHeadFrame"
  elseif UseChatItemFrame and ChatInterface.IsAssistantChatMessage(chatData.post) then
    return "ChatItemWithoutHeadFrame"
  elseif chatData.post == PostType.ActDetectTreasureItemUse then
    return "UILWChatActDetectTreasureUseItemMsg"
  elseif chatData.post == PostType.Alliance_CityUnderAttack then
    return "ChatAllianceCityUnderAttack"
  elseif chatData.post == PostType.Train_Rob then
    return "ChatTrainRob"
  elseif chatData.post == PostType.RedPacket_MSG then
    return "ChatItemPushRedPacketlMsg"
  elseif chatData.post == PostType.TorchRelayCheer then
    return isMyChat and "ChatItemRight_TorchRelayCheer" or "ChatItemLeft_TorchRelayCheer"
  elseif chatData.post == PostType.HELP_STOP_FIRE_ALLIANCEE then
    return "ChatItemHelpStopFireAlliance"
  elseif chatData.post == PostType.MONSTER_INVASION_BIG_BOSS then
    return "ChatPushMsg"
  elseif chatData.post == PostType.STAGE_FEATURE_CHAPTER then
    return isMyChat and "ChatItemRight_StageFeatureChapter" or "ChatItemLeft_StageFeatureChapter"
  elseif chatData.post == PostType.ALLIANCE_MONSTER_CHALLENGE_NEW_BATTLE then
    return "ChatPushMsg"
  elseif chatData.post == PostType.ALLIANCE_CONGRATULATION then
    return "ChatItemAllianceCongratulation"
  else
    return "ChatItemFrame"
  end
end

function UIChatViewMessageArea_v2:GetChatItemScriptName(index)
  index = index + 1
  if index > self:GetItemCount() then
    return ChatItem
  end
  if self._timeFlags[index] ~= nil or self._tipFlags[index] ~= nil then
    return ChatItemWithoutHeadFrame
  end
  local chatData = self:GetChatData(index)
  local isMyChat = chatData:isMyChat()
  if chatData.post == PostType.ChatGPT_Assistant then
    return ChatAISecretaryCell
  end
  if chatData.post == PostType.ChatGPT_Assistant_Private then
    return ChatItemFrame
  end
  if chatData.post == PostType.Text_ChatRoomSystemMsg or chatData.post == PostType.Text_AllianceRankChange or chatData.post == PostType.Text_MemberJoin or chatData.post == PostType.Abandon_AllianceCity or chatData.post == PostType.MessageRecall or chatData.post == PostType.Text_MemberQuit then
    return ChatItemWithoutHeadFrame
  elseif UseChatItemFrame and ChatInterface.IsSharePoint(chatData.post) then
    return ChatItemFrame
  elseif UseChatItemFrame and chatData.post == PostType.GiftGiving then
    if chatData.group == ChatGroupType.GROUP_CUSTOM then
      return ChatItemFrame
    else
      return ChatItemWithoutHeadFrame
    end
  elseif UseChatItemFrame and chatData.post == PostType.TrainVipInvite then
    return ChatItemFrame
  elseif UseChatItemFrame and ChatItemPosts[chatData.post] then
    return ChatItemFrame
  elseif UseChatItemFrame and ChatItemPostsType2[chatData.post] then
    return ChatItemWithoutHeadFrame
  elseif UseChatItemFrame and ChatInterface.IsAssistantChatMessage(chatData.post) then
    return ChatItemWithoutHeadFrame
  elseif chatData.post == PostType.ActDetectTreasureItemUse then
    return UILWChatActDetectTreasureUseItemMsg
  elseif chatData.post == PostType.RedPacket_MSG then
    return ChatItemPushRedPacketlMsg
  elseif chatData.post == PostType.Alliance_CityUnderAttack then
    return ChatAllianceCityUnderAttack
  elseif chatData.post == PostType.Train_Rob then
    return ChatTrainRob
  elseif chatData.post == PostType.TorchRelayCheer then
    return ChatTorchRelayCheer
  elseif chatData.post == PostType.HELP_STOP_FIRE_ALLIANCEE then
    return ChatItemHelpStopFireAlliance
  elseif chatData.post == PostType.MONSTER_INVASION_BIG_BOSS then
    return ChatPushMsg
  elseif chatData.post == PostType.ALLIANCE_MONSTER_CHALLENGE_NEW_BATTLE then
    return ChatPushMsg
  elseif chatData.post == PostType.ALLIANCE_CONGRATULATION then
    return ChatItemAllianceCongratulation
  else
    return ChatItemFrame
  end
end

function UIChatViewMessageArea_v2:ReLoadChat()
  self:InitChatMsg()
  self._isFetchingMore = false
  self:CheckAbstractRoom()
  self:CheckNetIsFine()
end

function UIChatViewMessageArea_v2:CheckNetIsFine()
  if not ChatManager2:GetInstance().Net:IsRunning() then
    self:ShowLoading()
  end
end

function UIChatViewMessageArea_v2:InitChatMsg()
  self._vScrollBar:Set_anchoredPosition(CommonUtil.IsArabicAutoMirrorOpen() and -100 or 100, 0)
  if self.goTailBtn then
    self.goTailBtn:SetActive(false)
  end
  self:UpdateMsgList()
  self:SetListItemCount_Mod(self:GetItemCount() + 2, false, true)
  self:ResetLoadingTipState()
  self._inputTest:SetEnable(true)
  if self.waitingJumpSeqId then
    local seqIndex = self:GetSeqIdIndex(self.waitingJumpSeqId)
    local index = (seqIndex or 0) + 1
    if seqIndex then
      self._scrollView.unity_looplistview2:EnableLoadingGoTail(true, index, -ChatFrameOffset)
    else
      self._scrollView.unity_looplistview2:EnableLoadingGoTail(false)
    end
    if self.waitingJumpSeqIdType and self.waitingJumpSeqIdType == ChatJumpSeqIdType.TargetGotoCenterAndEffect then
      local jumpIndex = index
      self._scrollView:MovePanelToItemIndex_Mod(jumpIndex, ChatFrameOffset)
      local item = self._scrollView:GetShownItemByItemIndex(index)
      local scripts = self._chatItemObjList[item]
      if scripts and scripts.ShowBlackFlash then
        scripts:ShowBlackFlash()
      end
    elseif not seqIndex then
      local room = self.view:GetSelectedRoom()
      ChatManager2:GetInstance().Room:ClearJumpMsgRoom()
      ChatManager2:GetInstance().Room:JumpMsgPullLast(room.roomId, self.waitingJumpSeqId)
    else
      self._scrollView:MovePanelToItemIndex_Mod(index, ChatFrameOffset)
    end
    self.waitingJumpSeqId = nil
    self.waitingJumpSeqIdType = nil
  else
    self._scrollView.unity_looplistview2:EnableLoadingGoTail(true)
  end
end

function UIChatViewMessageArea_v2:UpdateScrollbarVisible()
  if self:IsNeedShowScrollBar() then
    self._scrollBarImg.color = Color32.New(183, 163, 163, 255)
    self._scrollBarImg:DOPause()
    self._vScrollBar.anchoredPosition = Vector2.New(CommonUtil.IsArabicAutoMirrorOpen() and 7 or -7, 0)
  else
    self._vScrollBar.anchoredPosition = Vector2.New(CommonUtil.IsArabicAutoMirrorOpen() and -100 or 100, 0)
  end
end

function UIChatViewMessageArea_v2:IsNeedShowScrollBar()
  return self._scrollView.unity_looplistview2.ContainerTrans.sizeDelta.y > self._scrollView.unity_looplistview2.ViewPortHeight
end

function UIChatViewMessageArea_v2:OnScollValueChange()
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

function UIChatViewMessageArea_v2:ReloadData(isRefreshScrollViewImmediately)
  self:UpdateMsgList()
  if isRefreshScrollViewImmediately then
    self:RefreshScrollView()
  else
    self:SetListItemCount_Mod(self:GetItemCount() + 2, false, true)
  end
end

function UIChatViewMessageArea_v2:OnDragingAction()
  if self._scrollView.unity_looplistview2.ShownItemCount == 0 then
    return
  end
  if self.curLoadingTipState == LoadingTipStatus.WaitLoad or self.curLoadingTipState == LoadingTipStatus.Loaded then
    return
  end
  local containerTrans = self._scrollView.unity_looplistview2.ContainerTrans
  self.dragDirectionForRefresh = DragDirectionType.None
  if containerTrans.localPosition.y <= -ChatLoadingTipHeight then
    self.dragDirectionForRefresh = DragDirectionType.Top
    self.curLoadingChatItem = self._scrollView:GetShownItemByItemIndex(0)
    if self.curLoadingChatItem == nil then
      return
    end
    local chatItem = self._scrollView:GetShownItemByItemIndex(1)
    if chatItem == nil then
      return
    end
    if self.curLoadingTipState == LoadingTipStatus.None then
      self.curLoadingTipState = LoadingTipStatus.WaitRelease
      self:UpdateLoadingTip(self.curLoadingChatItem)
    end
  elseif ChatManager2:GetInstance().Room:IsShowingJumpMsg() and containerTrans.localPosition.y > containerTrans.rect.size.y - self._scrollView.rectTransform.rect.size.y + ChatLoadingTipHeight then
    self.dragDirectionForRefresh = DragDirectionType.Bottom
    local lastItemIndex = self:GetItemCount()
    self.curLoadingChatItem = self._scrollView:GetShownItemByItemIndex(lastItemIndex + 1)
    if self.curLoadingChatItem == nil then
      return
    end
    local chatItem = self._scrollView:GetShownItemByItemIndex(lastItemIndex)
    if chatItem == nil then
      return
    end
    if self.curLoadingTipState == LoadingTipStatus.None then
      self.curLoadingTipState = LoadingTipStatus.WaitRelease
      self:UpdateLoadingTip(self.curLoadingChatItem)
    end
  elseif self.curLoadingTipState == LoadingTipStatus.WaitRelease then
    self.curLoadingTipState = LoadingTipStatus.None
    self:UpdateLoadingTip(self.curLoadingChatItem)
  end
end

function UIChatViewMessageArea_v2:OnDragEndAction()
  if not self._isFetchingMore then
    local roomMgr = ChatManager2:GetInstance().Room
    local containerTrans = self._scrollView.unity_looplistview2.ContainerTrans
    if containerTrans.localPosition.y <= 0 then
      self:PullToLoadMessage()
    elseif roomMgr:IsShowingJumpMsg() and containerTrans.localPosition.y > containerTrans.rect.size.y - self._scrollView.rectTransform.rect.size.y then
      roomMgr:JumpMsgPullLast()
    elseif Mathf.Abs(self._scrollView.unity_looplistview2.ScrollRect.velocity.y) < 40 and self:IsNeedShowScrollBar() then
      self._scrollBarImg:DOFade(0, 0.2)
    end
  end
end

function UIChatViewMessageArea_v2:GetOldFirstChatDataSeqId()
  local oldFirstChatData = self:GetChatData(1)
  if oldFirstChatData == nil then
    return -1
  end
  return oldFirstChatData:getSeqId() or -1
end

function UIChatViewMessageArea_v2:GetOriginalFirstPosIndex(oldFirstMsgSeqId)
  if self._chatDatas == nil then
    return -1
  end
  for i = 1, #self._chatDatas do
    local chatData = self._chatDatas[i]
    if chatData and chatData:getSeqId() == oldFirstMsgSeqId then
      if i == 1 and self._timeFlags[1] ~= nil then
        return 1
      end
      if self._timeFlags[i] == nil then
        return i
      end
    end
  end
  return -1
end

function UIChatViewMessageArea_v2:GetHistoricalChat()
  self._isFetchingMore = true
  local roomId = self:GetCurrentRoomId()
  local room
  if roomId then
    room = ChatInterface.getRoomData(roomId)
  end
  if room == nil then
    return
  end
  local roomMgr = ChatManager2:GetInstance().Room
  if roomMgr:IsShowingJumpMsg() then
    roomMgr:JumpMsgPullPrevious()
  else
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_COMMAND, room.roomId)
  end
end

function UIChatViewMessageArea_v2:StopMovement()
  if self._scrollView_ScrollRect then
    self._scrollView_ScrollRect:StopMovement()
  end
end

function UIChatViewMessageArea_v2:CheckShowMoveToTailBtn()
  local isBottom = self:CheckLastChatItemToBottom()
  local lastMaxCount = self:GetItemCount()
  if 0 < lastMaxCount then
    self.goTailBtn:SetActive(not isBottom)
  else
    self.goTailBtn:SetActive(false)
  end
end

function UIChatViewMessageArea_v2:GetCurrentRoomId()
  local room = self.view:GetSelectedRoom()
  return room and room.roomId or nil
end

function UIChatViewMessageArea_v2:PullToLoadMessage()
  if self._scrollView.unity_looplistview2.ShownItemCount == 0 then
    return
  end
  if self.curLoadingTipState ~= LoadingTipStatus.None and self.curLoadingTipState ~= LoadingTipStatus.WaitRelease then
    return
  end
  local chatItem1
  if self.dragDirectionForRefresh == DragDirectionType.Top then
    chatItem1 = self._scrollView:GetShownItemByItemIndex(0)
  elseif self.dragDirectionForRefresh == DragDirectionType.Bottom then
    local lastMaxCount = self:GetItemCount()
    chatItem1 = self._scrollView:GetShownItemByItemIndex(lastMaxCount)
  end
  if chatItem1 == nil then
    return
  end
  self._scrollView.unity_looplistview2:OnItemSizeChanged(chatItem1.ItemIndex)
  if self.curLoadingTipState ~= LoadingTipStatus.WaitRelease then
    return
  end
  self.curLoadingTipState = LoadingTipStatus.WaitLoad
  self:UpdateLoadingTip(chatItem1)
  if self.dragDirectionForRefresh == DragDirectionType.Top then
    self:ShowLoadedMessageTop()
  elseif self.dragDirectionForRefresh == DragDirectionType.Bottom then
    local lastMaxCount = self:GetItemCount()
    chatItem1 = self._scrollView:GetShownItemByItemIndex(lastMaxCount)
  end
end

function UIChatViewMessageArea_v2:UpdateLoadingTip(chatItem)
  if chatItem == nil then
    return
  end
  if self.curLoadingTipState == LoadingTipStatus.None then
    chatItem.gameObject:SetActive(false)
    chatItem.CachedRectTransform:SetSizeWithCurrentAnchors(RectTransform.Axis.Vertical, 0)
  elseif self.curLoadingTipState == LoadingTipStatus.WaitRelease then
    chatItem.gameObject:SetActive(true)
    chatItem.CachedRectTransform:SetSizeWithCurrentAnchors(RectTransform.Axis.Vertical, ChatLoadingTipHeight)
    if self.dragDirectionForRefresh == DragDirectionType.Top then
      self:RefreshLoadingTipsPos(chatItem, ChatLoadingTipHeight)
    elseif self.dragDirectionForRefresh == DragDirectionType.Bottom then
      local containerTrans = self._scrollView.unity_looplistview2.ContainerTrans
      self:RefreshLoadingTipsPos(chatItem, -containerTrans.sizeDelta.y)
    end
  elseif self.curLoadingTipState == LoadingTipStatus.WaitLoad then
    chatItem.gameObject:SetActive(true)
    chatItem.CachedRectTransform:SetSizeWithCurrentAnchors(RectTransform.Axis.Vertical, ChatLoadingTipHeight)
    self:RefreshLoadingTipsPos(chatItem, 0)
  end
end

function UIChatViewMessageArea_v2:SetLoadingTipPos(chatItem)
  if self.dragDirectionForRefresh == DragDirectionType.Top then
    self:RefreshLoadingTipsPos(chatItem, ChatLoadingTipHeight)
  elseif self.dragDirectionForRefresh == DragDirectionType.Bottom then
    local containerTrans = self._scrollView.unity_looplistview2.ContainerTrans
    self:RefreshLoadingTipsPos(chatItem, -containerTrans.sizeDelta.y)
  end
end

function UIChatViewMessageArea_v2:RefreshLoadingTipsPos(chatItem, posY)
  if chatItem == nil then
    return
  end
  self.loadingTipsAnchorPos.x = chatItem.CachedRectTransform.anchoredPosition.x
  self.loadingTipsAnchorPos.y = posY
  chatItem.CachedRectTransform.anchoredPosition = self.loadingTipsAnchorPos
end

function UIChatViewMessageArea_v2:ShowLoadedMessageTop()
  if self.showMessageTimer ~= nil then
    self.showMessageTimer:Stop()
    self.showMessageTimer = nil
  end
  
  local function showMessageTimerAction()
    if self._scrollView.unity_looplistview2.ContainerTrans.anchoredPosition.y > -70 then
      if self.showMessageTimer ~= nil then
        self.showMessageTimer:Stop()
        self.showMessageTimer = nil
      end
      local roomMsgs = self:GetRoomMsgs()
      if roomMsgs == nil or #roomMsgs == 0 then
        self.curLoadingTipState = LoadingTipStatus.None
        self:UpdateLoadingTip(self.curLoadingChatItem)
        return
      end
      self:GetHistoricalChat()
    end
  end
  
  if self.showMessageTimer == nil then
    self.showMessageTimer = TimerManager:GetInstance():GetTimer(0, showMessageTimerAction, self, false, true, false)
    self.showMessageTimer:Start()
  end
end

function UIChatViewMessageArea_v2:AfterLoadedMessage()
  if self._scrollView.unity_looplistview2.ShownItemCount == 0 then
    return
  end
  if self.curLoadingTipState == LoadingTipStatus.WaitLoad then
    self.curLoadingTipState = LoadingTipStatus.None
    self:SetListItemCount_Mod(self:GetItemCount() + 2, false, false, true)
  end
end

function UIChatViewMessageArea_v2:HideLoadingTips()
  if self._scrollView.unity_looplistview2.ShownItemCount == 0 then
    return
  end
  if self.curLoadingTipState == LoadingTipStatus.WaitLoad then
    self.curLoadingTipState = LoadingTipStatus.None
    local lastLoadingChatItem = self._scrollView:GetShownItemByItemIndex(self:GetItemCount() + 1)
    if lastLoadingChatItem then
      self:UpdateLoadingTip(lastLoadingChatItem)
    end
    local firstLoadingChatItem = self._scrollView:GetShownItemByItemIndex(0)
    if firstLoadingChatItem then
      self:UpdateLoadingTip(firstLoadingChatItem)
    end
  end
end

function UIChatViewMessageArea_v2:SetListItemCount_Mod(itemTotalCount, moveToMinPos, moveToMaxPos, refresh)
  if itemTotalCount ~= 0 then
    for i = 2, #self._chatDatas - 1 do
      if self._chatDatas[i].timeFlag == true or self._chatDatas[i].tipFlag == true then
      else
        local curStartSeqId = self._chatDatas[i]:getSeqId()
        if curStartSeqId ~= self.lastStartSeqId then
          self.lastStartSeqId = curStartSeqId
          self._scrollView:ClearItemPosCache()
        end
        break
      end
    end
  end
  self._scrollView:SetListItemCount_Mod(itemTotalCount, moveToMinPos, moveToMaxPos, refresh)
end

function UIChatViewMessageArea_v2:DeleteChatDataByPicVer(roomId, picVer)
  if self:GetCurrentRoomId() == roomId then
    for i = #self._chatDatas, 1, -1 do
      local chatData = self._chatDatas[i]
      if chatData and chatData:IsFakePhotoChatData() and chatData:getExtra().picVer == picVer then
        table.remove(self._chatDatas, i)
        self:UpdateMsgList()
        return
      end
    end
  end
end

function UIChatViewMessageArea_v2:GetCurTimestampAnchorIndex(roomMsgs, curAnchorSeqId)
  if roomMsgs == nil or #roomMsgs == 0 or curAnchorSeqId == nil then
    return -1
  end
  local anchorIndex = -1
  for i = #roomMsgs, 1, -1 do
    if roomMsgs[i] then
      if curAnchorSeqId <= 0 and roomMsgs[i]:GetClientNoSeqIDIndex() == curAnchorSeqId then
        return i
      end
      if 0 < curAnchorSeqId and roomMsgs[i]:getSeqId() == curAnchorSeqId then
        return i
      end
    end
  end
  return anchorIndex
end

function UIChatViewMessageArea_v2:GetNewTimestampAnchorIndex(roomMsgs)
  if roomMsgs == nil or #roomMsgs == 0 then
    return -1
  end
  local lastChatDataServerTime = roomMsgs[#roomMsgs]:getCreateTime()
  for i = #roomMsgs - 1, 1, -1 do
    if lastChatDataServerTime - roomMsgs[i]:getCreateTime() >= self.timeInterval then
      local timestampAnchorIndex = i + 1
      self:SetTimestampAnchorSeqId(roomMsgs[timestampAnchorIndex])
      return timestampAnchorIndex
    end
  end
  local timestampAnchorIndex = 1
  self:SetTimestampAnchorSeqId(roomMsgs[timestampAnchorIndex])
  return timestampAnchorIndex
end

function UIChatViewMessageArea_v2:SetTimestampAnchorSeqId(chatData)
  local finalSeqId = chatData:getSeqId()
  if finalSeqId <= 0 then
    finalSeqId = chatData:GetClientNoSeqIDIndex()
  end
  ChatManager2:GetInstance().Room:SetTimestampAnchorSeqId(chatData:getRoomId(), finalSeqId)
end

function UIChatViewMessageArea_v2:CalculateTimeFlagsByAnchor(roomMsgs, anchorIndex)
  if anchorIndex == nil or anchorIndex == -1 then
    logger.LogError("\233\148\154\229\174\154\230\151\182\233\151\180\230\136\179\228\188\160\229\133\165\228\184\141\229\175\185\239\188\154CalculateTimeFlagsByAnchor")
    return
  end
  self:SetTimestampAtTopsOfAllChat(roomMsgs)
  local _, tailTimeFlag = self:GetTimeFlagByRoomMsgsIndex(roomMsgs, anchorIndex, 1)
  for i = 1, #roomMsgs do
    local chatData = roomMsgs[i]
    if chatData then
      local sendTime = chatData:getCreateTime()
      if tailTimeFlag <= sendTime then
        local tmpHeadTimeFlag, tmpTailTimeFlag = self:GetTimeFlagByRoomMsgsIndex(roomMsgs, anchorIndex, i)
        if i ~= 1 then
          self:InsertChatData(chatData, tmpHeadTimeFlag)
        end
        if i == anchorIndex then
          tailTimeFlag = self:GetTimeFlagByRoomMsgsIndex(roomMsgs, anchorIndex, anchorIndex) + self.timeInterval
        else
          tailTimeFlag = tmpTailTimeFlag
        end
      end
      self:InsertChatData(chatData)
    end
  end
end

function UIChatViewMessageArea_v2:GetTimeFlagByRoomMsgsIndex(roomMsgs, anchorIndex, roomMsgsIndex)
  if anchorIndex <= 0 then
    Logger.LogError("\233\148\154\229\174\154\230\151\182\233\151\180\230\136\179anchorIndex\228\184\141\230\173\163\231\161\174\239\188\140\230\163\128\230\159\165")
    return 0, 0
  end
  if roomMsgs[anchorIndex] == nil then
    Logger.LogError("roomMsgs\228\184\173\228\184\141\229\140\133\229\144\171\233\148\154\229\174\154\230\151\182\233\151\180\230\136\179\231\154\132Index\239\188\140\230\163\128\230\159\165")
    return 0, 0
  end
  local anchorTimeFlag = roomMsgs[anchorIndex]:getCreateTime()
  if anchorIndex == roomMsgsIndex then
    return anchorTimeFlag, anchorTimeFlag
  elseif roomMsgsIndex < anchorIndex then
    local intervalTailCount = math.floor((anchorTimeFlag - roomMsgs[roomMsgsIndex]:getCreateTime()) / self.timeInterval)
    local intervalHeadCount = intervalTailCount + 1
    local tailTimeFlag = anchorTimeFlag - intervalTailCount * self.timeInterval
    local headTimeFlag = anchorTimeFlag - intervalHeadCount * self.timeInterval
    return headTimeFlag, tailTimeFlag
  elseif anchorIndex < roomMsgsIndex then
    local intervalTailCount = math.ceil((roomMsgs[roomMsgsIndex]:getCreateTime() - anchorTimeFlag) / self.timeInterval)
    local intervalHeadCount = intervalTailCount - 1
    local tailTimeFlag = anchorTimeFlag + intervalTailCount * self.timeInterval
    local headTimeFlag = anchorTimeFlag + intervalHeadCount * self.timeInterval
    return headTimeFlag, tailTimeFlag
  end
  Logger.LogError("\230\151\182\233\151\180\230\136\179\232\174\161\231\174\151\233\148\153\232\175\175\239\188\154GetTimeFlagByRoomMsgsIndex     \233\152\159\229\136\151\230\142\146\229\186\143\231\144\134\229\186\148\230\160\185\230\141\174\230\156\141\229\138\161\229\153\168\230\151\182\233\151\180\230\157\165\229\141\135\229\186\143\230\142\146\229\136\151\239\188\129")
  return 0, 0
end

function UIChatViewMessageArea_v2:GetTimeFlagByTargetTime(roomMsgs, anchorIndex, targetTime)
  if anchorIndex <= 0 then
    Logger.LogError("\233\148\154\229\174\154\230\151\182\233\151\180\230\136\179anchorIndex\228\184\141\230\173\163\231\161\174\239\188\140\230\163\128\230\159\165")
    return 0, 0
  end
  if roomMsgs[anchorIndex] == nil then
    Logger.LogError("roomMsgs\228\184\173\228\184\141\229\140\133\229\144\171\233\148\154\229\174\154\230\151\182\233\151\180\230\136\179\231\154\132Index\239\188\140\230\163\128\230\159\165")
    return 0, 0
  end
  local anchorTimeFlag = roomMsgs[anchorIndex]:getCreateTime()
  if anchorTimeFlag == targetTime then
    return anchorTimeFlag, anchorTimeFlag
  elseif targetTime < anchorTimeFlag then
    local intervalTailCount = math.floor((anchorTimeFlag - targetTime) / self.timeInterval)
    local intervalHeadCount = intervalTailCount + 1
    local tailTimeFlag = anchorTimeFlag - intervalTailCount * self.timeInterval
    local headTimeFlag = anchorTimeFlag - intervalHeadCount * self.timeInterval
    return headTimeFlag, tailTimeFlag
  elseif targetTime > anchorTimeFlag then
    local intervalTailCount = math.ceil((targetTime - anchorTimeFlag) / self.timeInterval)
    local intervalHeadCount = intervalTailCount - 1
    local tailTimeFlag = anchorTimeFlag + intervalTailCount * self.timeInterval
    local headTimeFlag = anchorTimeFlag + intervalHeadCount * self.timeInterval
    return headTimeFlag, tailTimeFlag
  end
  Logger.LogError("\230\151\182\233\151\180\230\136\179\232\174\161\231\174\151\233\148\153\232\175\175\239\188\154GetTimeFlagByTargetTime     \233\152\159\229\136\151\230\142\146\229\186\143\231\144\134\229\186\148\230\160\185\230\141\174\230\156\141\229\138\161\229\153\168\230\151\182\233\151\180\230\157\165\229\141\135\229\186\143\230\142\146\229\136\151\239\188\129")
  return 0, 0
end

function UIChatViewMessageArea_v2:IsTimestampExist(timestamp)
  if self._timeFlags == nil then
    logger.LogError("_timeFlags\230\151\182\233\151\180\230\136\179\230\149\176\230\141\174\231\188\147\229\173\152\228\184\186\231\169\186\227\128\130")
    return false
  end
  for k, v in pairs(self._timeFlags) do
    if v == timestamp then
      return true
    end
  end
  return false
end

function UIChatViewMessageArea_v2:SetTimestampAtTopsOfAllChat(roomMsgs)
  local roomId = self:GetCurrentRoomId()
  if roomId == nil then
    logger.LogError("\229\189\147\229\137\141\230\136\191\233\151\180ID\228\184\186\231\169\186\239\188\129")
    return
  end
  local roomData = ChatInterface.getRoomData(roomId)
  if roomData == nil then
    logger.LogError("\229\189\147\229\137\141\230\136\191\233\151\180\230\149\176\230\141\174\228\184\186\231\169\186\239\188\129")
    return
  end
  if roomData:GetIsReachFirstMessage() then
    self:AddNewPlayerSafeTip(roomData, roomMsgs)
    self:InsertChatData(roomMsgs[1], roomMsgs[1]:getCreateTime())
  end
end

function UIChatViewMessageArea_v2:AddNewPlayerSafeTip(roomData, roomMsgs)
  if roomData.category ~= ChatRoomCategory.PRIVATE then
    return
  end
  if not roomData:GetIsReachFirstMessage() then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if now - LuaEntry.Player.regTime > 259200000 then
    return
  end
  local newTip = DeepCopy(roomMsgs[1])
  self:InsertChatData(newTip, "new_user_chat_alarm_tips")
end

function UIChatViewMessageArea_v2:GetPostKey_System(chatData, index)
  if self._timeFlags[index] then
    return "Time"
  elseif self._tipFlags[index] then
    return "Tip"
  end
  if ChatInterface.IsAssistantChatMessage(chatData.post) then
    return "ChatAIAssistant"
  end
  return chatData.post
end

function UIChatViewMessageArea_v2:GetPostConfig_System(chatData, index)
  local postConfig = ChatItemPostsType2[self:GetPostKey_System(chatData, index)]
  if postConfig == nil then
    postConfig = ChatItemPostsType2.Time
  end
  return postConfig
end

function UIChatViewMessageArea_v2:SetJumpSeqId(seqId, jumpType)
  self.waitingJumpSeqId = seqId
  self.waitingJumpSeqIdType = jumpType
end

return UIChatViewMessageArea_v2
