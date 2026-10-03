local base = UIBaseContainer
local UIChatViewMessageArea_v3 = BaseClass("UIChatViewMessageArea_v3", base)
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
local _cp_scrollView = ""
local _cp_scrollViewContent = "MainViewport/MainContent"
local _cp_vScrollBar = "MainViewport/Scrollbar"
local _cp_objLoading = "objLoading"
local _cp_txt_loading = "objLoading/Image/txtLoading"
local _go_tail_btn_path = "GoTailBtn"
local up_msg_loading_path = "MainViewport/MainContent/upMsgLoading"
local down_msg_loading_path = "MainViewport/MainContent/downMsgLoading"
local ChatFrameOffset = 16

function UIChatViewMessageArea_v3:ComponentDefine()
  self._objLoading = self:AddComponent(UIBaseContainer, _cp_objLoading)
  self._txt_loading = self:AddComponent(UIText, _cp_txt_loading)
  self.up_msg_loading = self:AddComponent(UIImage, up_msg_loading_path)
  self.down_msg_loading = self:AddComponent(UIImage, down_msg_loading_path)
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

function UIChatViewMessageArea_v3:ComponentDestroy()
  self._scrollView_ScrollRect:RemoveAllListeners()
  self._scrollView.unity_looplistview2.mOnListClickAction = nil
  self._scrollView.unity_looplistview2.mOnBeginDragAction = nil
  self._scrollView.unity_looplistview2.mOnDragingAction = nil
  self._scrollView.unity_looplistview2.mOnEndDragAction = nil
  self:ClearScrollViewContent()
  self:ClearAllChatItems()
end

function UIChatViewMessageArea_v3:ClearAllChatItems()
  self:SetListItemCount_Mod(0, false, false)
end

function UIChatViewMessageArea_v3:RecycleAllChatItems()
end

function UIChatViewMessageArea_v3:ClearScrollViewContent()
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

function UIChatViewMessageArea_v3:DataDefine()
  self.delayTimerTask = nil
  self._chatItemObjList = {}
  self:InitChatDatas()
  self.chatItemSizeDelta = Vector2.zero
end

function UIChatViewMessageArea_v3:InitChatDatas()
  self._chatDatas = {}
  self._tipFlags = {}
  self._timeFlags = {}
  self._timeFlagHead = 0
  self._timeFlagTail = 0
  self.chatDic = {}
  self._checkAutoLoad = false
  self._lastCreateIndex = -1
end

function UIChatViewMessageArea_v3:GetChatData(key)
  return self._chatDatas[key]
end

function UIChatViewMessageArea_v3:GetChatDatas()
  return self._chatDatas
end

function UIChatViewMessageArea_v3:GetSeqIdIndex(seqId)
  if seqId == nil then
    return
  end
  for k, v in pairs(self._chatDatas) do
    if v.seqId == seqId and self._timeFlags[k] == false then
      return k - 1
    end
  end
end

function UIChatViewMessageArea_v3:GetItemCount()
  return table.length(self._chatDatas)
end

function UIChatViewMessageArea_v3:GetCurrentRoomId()
  local room = self.view:GetSelectedRoom()
  return room and room.roomId or nil
end

function UIChatViewMessageArea_v3:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ERROR_OR_DISCONNECT, self.OnChatNetErrorOrDisconnect)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_HISTORYMSG_UPDATA, self.RequestRoomMsg)
  self:AddUIListener(ChatEventEnum.CHAT_ALLIANCE_NOTICELIST_ADD, self.OnRecieveNotice)
  self:AddUIListener(ChatEventEnum.CHAT_LOGIN_SUCCESS, self.OnChatLoginSuccess)
  self:AddUIListener(ChatEventEnum.CHAT_MAIN_VIEW_STOP_MOVEMENT, self.StopMovement)
  self:AddUIListener(ChatEventEnum.CHAT_MOVETOBOTTOM, self.OnMoveToBottom)
  self:AddUIListener(ChatEventEnum.CHAT_REFRESH_VIEW, self.RefreshScrollView)
  self:AddUIListener(ChatEventEnum.CHAT_TRANSLATE_All, self.TranslateAllShowingItems)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_FETCH_HISTORY_STATE_UPDATA, self.UpdateLoadingState)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_SEL, self.SelectRoom)
  self:AddUIListener(EventId.CHAT_ITEM_NEWSCENTER_DATA_GET, self.RefreshScrollView)
end

function UIChatViewMessageArea_v3:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ERROR_OR_DISCONNECT, self.OnChatNetErrorOrDisconnect)
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_HISTORYMSG_UPDATA, self.RequestRoomMsg)
  self:RemoveUIListener(ChatEventEnum.CHAT_LOGIN_SUCCESS, self.OnChatLoginSuccess)
  self:RemoveUIListener(ChatEventEnum.CHAT_MAIN_VIEW_STOP_MOVEMENT, self.StopMovement)
  self:RemoveUIListener(ChatEventEnum.CHAT_ALLIANCE_NOTICELIST_ADD, self.OnRecieveNotice)
  self:RemoveUIListener(ChatEventEnum.CHAT_MOVETOBOTTOM, self.OnMoveToBottom)
  self:RemoveUIListener(ChatEventEnum.CHAT_REFRESH_VIEW, self.RefreshScrollView)
  self:RemoveUIListener(ChatEventEnum.CHAT_TRANSLATE_All, self.TranslateAllShowingItems)
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_FETCH_HISTORY_STATE_UPDATA, self.UpdateLoadingState)
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_SEL, self.SelectRoom)
  self:RemoveUIListener(EventId.CHAT_ITEM_NEWSCENTER_DATA_GET, self.RefreshScrollView)
  base.OnRemoveListener(self)
end

function UIChatViewMessageArea_v3:OnRecieveNotice()
  local currentRoomId = self:GetCurrentRoomId()
  if currentRoomId then
    local room = ChatInterface.getRoomData(currentRoomId)
    if room and room.group == ChatGroupType.GROUP_ALLIANCE_NOTICE then
      DataCenter.AllianceNoticeManager:SaveReadTime()
    end
  end
end

function UIChatViewMessageArea_v3:OnChatNetErrorOrDisconnect()
  self:ShowLoading()
  local roomMgr = ChatManager2:GetInstance().Room
  roomMgr:ClearJumpMsgRoom()
end

function UIChatViewMessageArea_v3:SelectRoom()
  self:TryReqChatSpeakUid()
end

function UIChatViewMessageArea_v3:TryReqChatSpeakUid()
  local room = self:GetRoom()
  if not room then
    return
  end
  local roomMgr = ChatManager2:GetInstance().Room
  if roomMgr:CheckNeedUpdateChatSpeakUid(room.group) then
    roomMgr:TryReqChatSpeakUid(room.roomId)
  end
end

function UIChatViewMessageArea_v3:ScrollToTail()
  local room = self:GetRoom()
  if not room then
    return
  end
  if room.isJump or #self._chatDatas > 0 and self._chatDatas[#self._chatDatas].seqId ~= room:GetCurLsatSeqId() then
    self:GetHistoricalChat(RequestType.InitFetch)
  end
  self._scrollView:MovePanelToItemIndex_Mod(#self._chatDatas - 1, 0)
  if self.goTailBtn then
    self.goTailBtn:SetActive(false)
  end
end

function UIChatViewMessageArea_v3:UpdateImgAnimation(roomStateInfo, img, action)
  if roomStateInfo.isOn then
    img:SetActive(true)
    self[action] = img.transform:DOLocalRotate(Vector3(0, 0, -360), 1, CS.DG.Tweening.RotateMode.LocalAxisAdd):SetLoops(-1, CS.DG.Tweening.LoopType.Restart)
    img.transform:SetSiblingIndex(img.transform.parent.childCount - 1)
  else
    img:SetActive(false)
    self:ClearTween("action")
  end
end

function UIChatViewMessageArea_v3:UpdateLoadingState(roomStateInfo)
  local room = self:GetRoom()
  if not room then
    return
  end
  if room.roomId == roomStateInfo.roomId then
    if roomStateInfo.state == RequestType.PullPrev then
      self:UpdateImgAnimation(roomStateInfo, self.up_msg_loading, "up_tween")
    elseif roomStateInfo.state == RequestType.PullLast then
      self:UpdateImgAnimation(roomStateInfo, self.down_msg_loading, "down_tween")
    end
  end
end

function UIChatViewMessageArea_v3:OnUpdate()
  if self._checkAutoLoad and self._lastCreateIndex ~= -1 then
    self._checkAutoLoad = false
    local autoLoadCount = ChatItemAutoLoadCount
    local room = self:GetRoom()
    if autoLoadCount > self._lastCreateIndex then
      if self._chatDatas[1] and room and self._chatDatas[1].seqId > room.firstSeqId then
        self:GetHistoricalChat(RequestType.PullPrev)
      end
    elseif self._lastCreateIndex + autoLoadCount >= self:GetItemCount() then
      local endChatData = self._chatDatas[#self._chatDatas]
      if endChatData and room and endChatData.seqId < room.lastSeqId then
        self:GetHistoricalChat(RequestType.PullLast)
      end
    end
  end
end

function UIChatViewMessageArea_v3:OnGetItemByIndex(listView, index)
  if index < 0 or index >= self:GetItemCount() then
    return nil
  end
  self._checkAutoLoad = true
  self._lastCreateIndex = index
  local item
  self.prefabIndex = self.prefabIndex or 0
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
  local chatItemUIType = ChatItemUIType.Normal
  if self._timeFlags and self._timeFlags[index + 1] then
    chatItemUIType = ChatItemUIType.Time
  elseif self._tipFlags and self._tipFlags[index + 1] then
    chatItemUIType = ChatItemUIType.Tip
  end
  if self._chatItemObjList[item] ~= nil then
    self:SetChatItemSizeDelta(item)
    self._chatItemObjList[item]:SetContentViewScript(self)
    self._chatItemObjList[item]:UpdateItem(self:GetChatData(index + 1), index + 1, {chatItemUIType = chatItemUIType})
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
    temp:UpdateItem(self:GetChatData(index + 1), index + 1, {chatItemUIType = chatItemUIType})
    self._chatItemObjList[item] = temp
  end
  return item
end

function UIChatViewMessageArea_v3:LogChatItemUse(index, scriptName, prefabName)
  index = index + 1
  local chatData = self:GetChatData(index)
  if chatData == nil then
    return
  end
  local postType = chatData.post
  if ChatInterface.IsSharePoint(postType) then
    postType = PostType.Text_PointShare
  end
  if postType == PostType.Text_ChatRoomSystemMsg or postType == PostType.Text_AllianceRankChange or postType == PostType.Abandon_AllianceCity or postType == PostType.Text_MemberJoin or postType == PostType.Text_MemberQuit or postType == PostType.Alliance_OfficialChange or postType == PostType.Alliance_LeaderChange or postType == PostType.Alliance_CityUnderAttack or postType == PostType.Train_Rob or postType == PostType.Train_Driver or postType == PostType.Train_Departure or postType == PostType.Alliance_Notice or postType == PostType.BestReward or postType == PostType.RedPacket_MSG or postType == PostType.DetectEventGetDoubleTreasure or postType == PostType.ZombieRush or postType == PostType.HELP_STOP_FIRE_ALLIANCEE or postType == PostType.ActDetectTreasureItemUse or postType == PostType.MONSTER_INVASION_BIG_BOSS or postType == PostType.Detect_Treasure_Fin_Info or postType == PostType.DiggingGameShareAlliance or postType == PostType.OffSeasonDiggingGameShareAlliance or postType == PostType.SeasonTradeShopRefresh or postType == PostType.CaptureHugeSandWorm or postType == PostType.TradeOpenLevel or postType == PostType.OccupyTradePlayer or postType == PostType.ALLIANCE_MONSTER_CHALLENGE_NEW_BATTLE or postType == PostType.ALLIANCE_CONGRATULATION or ChatInterface.IsAssistantChatMessage(postType) then
    return
  end
  if ChatItemPosts[postType] == nil then
    Logger.LogInfo(string.format("[LogChatItemUse] post: %s, script: %s, prefab: %s", tostring(chatData.post), scriptName.__cname, prefabName))
  end
end

function UIChatViewMessageArea_v3:SetChatItemSizeDelta(item)
  if item.CachedRectTransform.sizeDelta.x == self._scrollView:GetViewPortWidth() - 50 then
    return
  end
  self.chatItemSizeDelta = self.chatItemSizeDelta or Vector2.zero
  self.chatItemSizeDelta.x = self._scrollView:GetViewPortWidth() - 50
  self.chatItemSizeDelta.y = item.CachedRectTransform.sizeDelta.y
  item.CachedRectTransform.sizeDelta = self.chatItemSizeDelta
end

local TimeInterval = 3000

function UIChatViewMessageArea_v3:TranslateAllShowingItems()
  if self.lastTranslateTime ~= nil and UITimeManager:GetInstance():GetServerTime() - self.lastTranslateTime < TimeInterval then
    return
  end
  self.lastTranslateTime = UITimeManager:GetInstance():GetServerTime()
  local count = self:GetItemCount()
  for i = 0, count - 1 do
    if self._scrollView:GetShownItemByItemIndex(i) then
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

function UIChatViewMessageArea_v3:IsSkipTranslate(chatData)
  return chatData:getPost() == PostType.Chat_Stickers
end

function UIChatViewMessageArea_v3:OnRecycleItemFunc(loopListViewItem)
  if loopListViewItem == nil then
    return
  end
  local script = self._chatItemObjList[loopListViewItem]
  if script ~= nil and script.OnRecycleItem then
    script:OnRecycleItem()
  end
end

function UIChatViewMessageArea_v3:RefreshScrollView()
  self:SetListItemCount_Mod(self:GetItemCount(), false, false, true)
end

function UIChatViewMessageArea_v3:ReloadAfterTranslateRecv(index)
  self:RefreshScrollView()
end

function UIChatViewMessageArea_v3:ClearChatDatas()
  self:InitChatDatas()
  CS.UIChatSendPhoto.ClearAssetLoadingSet()
end

function UIChatViewMessageArea_v3:GetItemCount()
  return table.length(self._chatDatas)
end

function UIChatViewMessageArea_v3:GetRoom()
  local room = self.view:GetSelectedRoom()
  room = room and ChatManager2:GetInstance().Room:GetEffectiveRoomData(room.roomId)
  return room
end

function UIChatViewMessageArea_v3:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self._scrollView.unity_looplistview2:SetItemUseCanvas(true)
  self._scrollView.unity_looplistview2:SetStopAdjustVelocity(true)
  self._scrollView:InitListViewParam2(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end, nil, nil, function(loopListViewItem)
    self:OnRecycleItemFunc(loopListViewItem)
  end)
  self._scrollView.unity_looplistview2:SetSmoothDraggingInertia(true)
  SFSNetwork.SendMessage(MsgDefines.ChatAskAllianceGatherMessage)
  if not self.updateTimer then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

function UIChatViewMessageArea_v3:CheckAbstractRoom()
  local roomId = self:GetCurrentRoomId()
  if roomId == E_CHAT_COUNTRY_ROOMID or roomId == E_CHAT_ALLIANCE_ROOMID then
    self:ShowLoading()
  else
    self:HideLoading()
  end
end

function UIChatViewMessageArea_v3:ShowLoading()
  self._objLoading:SetActive(true)
  self._txt_loading:SetLocalText(290047)
end

function UIChatViewMessageArea_v3:HideLoading()
  self._objLoading:SetActive(false)
end

function UIChatViewMessageArea_v3:ClearTween(tweenName)
  if self[tweenName] ~= nil then
    self[tweenName]:Kill()
    self[tweenName] = nil
  end
end

function UIChatViewMessageArea_v3:OnDestroy()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  self:ComponentDestroy()
  self:ClearTween("up_tween")
  self:ClearTween("down_tween")
  self.chatItemSizeDelta = nil
  ChatManager2:GetInstance().Room:ClearAllTimestampAnchor()
  base.OnDestroy(self)
end

function UIChatViewMessageArea_v3:OnEnable()
  base.OnEnable(self)
  self._scrollView_ScrollRect:AddValueChangeListener(function(vec)
    self:OnScollValueChange()
    self:CheckShowMoveToTailBtn()
  end)
end

function UIChatViewMessageArea_v3:OnDisable()
  self._scrollView_ScrollRect:RemoveAllListeners()
  base.OnDisable(self)
end

function UIChatViewMessageArea_v3:OnChatLoginSuccess()
  self:HideLoading()
end

function UIChatViewMessageArea_v3:CheckLastChatItemToBottom()
  local isBottom = false
  local lastMaxCount = self:GetItemCount()
  local lastChatItem = self._scrollView:GetShownItemByItemIndex(lastMaxCount - 1)
  if lastChatItem == nil then
    return isBottom
  end
  local pos = self._scrollView:GetItemCornerPosInViewPort(lastChatItem)
  isBottom = Mathf.Abs(pos.y) - lastChatItem.ItemSizeWithPadding <= self._scrollView.unity_looplistview2.ViewPortSize
  return isBottom
end

function UIChatViewMessageArea_v3:OnMoveToBottom()
  local chatCount = self:GetItemCount()
  self._scrollView:MovePanelToItemIndex(chatCount, 0)
end

function UIChatViewMessageArea_v3:IsUpdateMsgs(ret)
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

function UIChatViewMessageArea_v3:GetChatItemPrefabName(index)
  index = index + 1
  if index > self:GetItemCount() then
    return "ChatItemFrame"
  end
  if self._timeFlags[index] == true or self._tipFlags[index] == true then
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
  elseif chatData.post == PostType.SeasonCampDestroyCity then
    return "ChatItemWithoutHeadFrame"
  elseif chatData.post == PostType.SeasonOccupyAltar then
    return "ChatItemWithoutHeadFrame"
  else
    return "ChatItemFrame"
  end
end

function UIChatViewMessageArea_v3:GetChatItemScriptName(index)
  index = index + 1
  if index > self:GetItemCount() then
    return ChatItem
  end
  if self._timeFlags[index] == true or self._tipFlags[index] == true then
    return ChatItemWithoutHeadFrame
  end
  local chatData = self:GetChatData(index)
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
  elseif chatData.post == PostType.SeasonCampDestroyCity then
    return ChatItemWithoutHeadFrame
  elseif chatData.post == PostType.SeasonOccupyAltar then
    return ChatItemWithoutHeadFrame
  else
    return ChatItemFrame
  end
end

function UIChatViewMessageArea_v3:ReLoadChat()
  self:InitChatMsg()
  self:CheckAbstractRoom()
  self:CheckNetIsFine()
end

function UIChatViewMessageArea_v3:CheckNetIsFine()
  if not ChatManager2:GetInstance().Net:IsRunning() then
    self:ShowLoading()
  end
end

function UIChatViewMessageArea_v3:InitChatMsg()
  self._vScrollBar:Set_anchoredPosition(CommonUtil.IsArabicAutoMirrorOpen() and -100 or 100, 0)
  if self.goTailBtn then
    self.goTailBtn:SetActive(false)
  end
  if self.waitingJumpSeqId then
    ChatManager2:GetInstance().Room:ClearJumpMsgRoom()
    self.serverTime = UITimeManager:GetInstance():GetServerTime()
    self:GetHistoricalChat(RequestType.JumpTo, self.waitingJumpSeqId)
    self.waitingJumpSeqId = nil
    self.waitingJumpSeqIdType = nil
  else
    self:GetHistoricalChat(RequestType.InitFetch)
    self:SetEnableLoading(true)
  end
  self.up_msg_loading:SetActive(false)
  self.down_msg_loading:SetActive(false)
end

function UIChatViewMessageArea_v3:SetEnableLoading(isOn, index, off)
  self._inputTest:SetEnable(isOn)
  if index and off then
    self._scrollView.unity_looplistview2:EnableLoadingGoTail(isOn, index, off)
  else
    self._scrollView.unity_looplistview2:EnableLoadingGoTail(isOn)
  end
end

function UIChatViewMessageArea_v3:UpdateScrollbarVisible()
  if self:IsNeedShowScrollBar() then
    self._scrollBarImg.color = Color32.New(183, 163, 163, 255)
    self._scrollBarImg:DOPause()
    self._vScrollBar.anchoredPosition = Vector2.New(CommonUtil.IsArabicAutoMirrorOpen() and 7 or -7, 0)
  else
    self._vScrollBar.anchoredPosition = Vector2.New(CommonUtil.IsArabicAutoMirrorOpen() and -100 or 100, 0)
  end
end

function UIChatViewMessageArea_v3:IsNeedShowScrollBar()
  return self._scrollView.unity_looplistview2.ContainerTrans.sizeDelta.y > self._scrollView.unity_looplistview2.ViewPortHeight
end

function UIChatViewMessageArea_v3:OnScollValueChange()
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

function UIChatViewMessageArea_v3:OnDragEndAction()
  local containerTrans = self._scrollView.unity_looplistview2.ContainerTrans
  if containerTrans.localPosition.y <= 0 then
    local room = self:GetRoom()
    local firstSeqId = self._chatDatas[1] and self._chatDatas[1].seqId
    if room and room:CanFetchMoreMessagesBySeqId(RequestType.PullPrev, firstSeqId) then
      self:GetHistoricalChat(RequestType.PullPrev)
    end
  elseif containerTrans.localPosition.y > containerTrans.rect.size.y - self._scrollView.rectTransform.rect.size.y then
    local room = self:GetRoom()
    local lastSeqId = self._chatDatas[#self._chatDatas] and self._chatDatas[#self._chatDatas].seqId
    if room and room:CanFetchMoreMessagesBySeqId(RequestType.PullLast, lastSeqId) then
      self:GetHistoricalChat(RequestType.PullLast)
    end
  elseif Mathf.Abs(self._scrollView.unity_looplistview2.ScrollRect.velocity.y) < 40 and self:IsNeedShowScrollBar() then
    self._scrollBarImg:DOFade(0, 0.2)
  end
end

function UIChatViewMessageArea_v3:GetOldFirstChatDataSeqId()
  if #self._chatDatas == 0 then
    return -1
  end
  return self._chatDatas[1].seqId
end

function UIChatViewMessageArea_v3:GetOriginalFirstPosIndex(oldFirstMsgSeqId)
  if self._chatDatas == nil then
    return -1
  end
  for i = 1, #self._chatDatas do
    local chatData = self._chatDatas[i]
    if chatData and chatData:getSeqId() == oldFirstMsgSeqId then
      return i
    end
  end
  return -1
end

function UIChatViewMessageArea_v3:GetNewMsg(requestType, seqId)
  if requestType == RequestType.InitFetch then
    ChatManager2:GetInstance().Room:ClearJumpMsgRoom()
    self:InitChatDatas()
  elseif requestType == RequestType.JumpTo then
    self:InitChatDatas()
  end
  local roomId = self:GetCurrentRoomId()
  if not roomId then
    if self._chatDatas and #self._chatDatas > 0 then
      Logger.LogWarning("Selected room is empty. Current retained room id: " .. tostring(self._chatDatas[1].roomId))
    end
    return
  end
  local roomMsgs, anchorSeqId
  local startSeqId = seqId
  if requestType == RequestType.ReceivePush then
    local roomData = ChatManager2:GetInstance().Room:GetRoomData(roomId)
    if roomData then
      roomMsgs = {
        roomData:getLastChatData()
      }
    end
  elseif requestType == RequestType.LoadRecentMessages then
    roomMsgs = ChatManager2:GetInstance().Room:GetRoomMsg(roomId, requestType, startSeqId)
  else
    roomMsgs, anchorSeqId = ChatManager2:GetInstance().Room:GetRoomMsgByServer(roomId, requestType, startSeqId)
  end
  if not roomMsgs or #roomMsgs == 0 then
    return
  end
  if requestType == RequestType.PullPrev then
    for i = #roomMsgs, 1, -1 do
      self:InsertChatData(true, roomMsgs[i])
    end
  else
    for i = 1, #roomMsgs do
      self:InsertChatData(false, roomMsgs[i])
    end
  end
  local room = self:GetRoom()
  if (room:GetIsChatHistoryEnd(RequestType.PullPrev) or room:GetFirstIdLocalEnd()) and #self._chatDatas >= 1 then
    local firstData = room:GetUnblockedFirstChatData()
    if firstData and self._chatDatas[1].seqId == firstData.seqId and not self._timeFlags[1] then
      table.insert(self._chatDatas, 1, self._chatDatas[1])
      table.insert(self._timeFlags, 1, true)
      self._timeFlagHead = self._chatDatas[1]:getCreateTime()
    end
  end
  return true, anchorSeqId
end

function UIChatViewMessageArea_v3:InsertChatData(front, chatData)
  local isEmpty = #self._chatDatas == 0
  if not self.chatDic then
    self.chatDic = {}
  end
  if self.chatDic[chatData.seqId] then
    return
  end
  self.chatDic[chatData.seqId] = chatData
  local chatTime = chatData:getCreateTime()
  if isEmpty then
    table.insert(self._chatDatas, chatData)
    table.insert(self._timeFlags, false)
    self._timeFlagHead = chatTime
    self._timeFlagTail = chatTime
    return
  end
  if front then
    local headTime = self._timeFlagHead
    if 300 <= headTime - chatTime or not UITimeManager:GetInstance():IsSameDayForLocal(headTime, chatTime) then
      table.insert(self._chatDatas, 1, self._chatDatas[1])
      table.insert(self._timeFlags, 1, true)
      self._timeFlagHead = chatTime
    end
    table.insert(self._chatDatas, 1, chatData)
    table.insert(self._timeFlags, 1, false)
  else
    local tailTime = self._timeFlagTail
    if 300 <= chatTime - tailTime or not UITimeManager:GetInstance():IsSameDayForLocal(tailTime, chatTime) then
      table.insert(self._chatDatas, chatData)
      table.insert(self._timeFlags, true)
      self._timeFlagTail = chatTime
    end
    table.insert(self._chatDatas, chatData)
    table.insert(self._timeFlags, false)
  end
end

function UIChatViewMessageArea_v3:UpdateMsgList(requestType, seqId)
  local oldItemCout = self:GetItemCount()
  local isUpdate, anchorSeqId = self:GetNewMsg(requestType, seqId)
  if #self._chatDatas == 0 and not isUpdate then
    self:ClearAllChatItems()
  end
  local offset = 0
  if isUpdate then
    if requestType == RequestType.InitFetch then
      self:SetListItemCount_Mod(self:GetItemCount(), false, true, false)
    elseif requestType == RequestType.JumpTo then
      self:SetListItemCount_Mod(self:GetItemCount(), false, false, false)
      local jumpToSeqId = anchorSeqId or seqId
      local index = self:GetSeqIdIndex(jumpToSeqId)
      self:ShowJumpToMsg(index)
      self:SetEnableLoading(true, index, -ChatFrameOffset)
    elseif requestType == RequestType.PullPrev then
      offset = self:GetItemCount() - oldItemCout
      for i, temp in pairs(self._chatItemObjList) do
        temp._chatIndex = temp._chatIndex + offset
      end
      self._scrollView.unity_looplistview2:InsertFront_Mod(self:GetItemCount())
    elseif requestType == RequestType.PullLast then
      self._scrollView.unity_looplistview2:AppendTail_Mod(self:GetItemCount())
    elseif requestType == RequestType.ReceivePush then
      self._scrollView.unity_looplistview2:AppendTail_Mod(self:GetItemCount())
    elseif requestType == RequestType.LoadRecentMessages then
      self._scrollView.unity_looplistview2:AppendTail_Mod(self:GetItemCount())
    end
  end
  return isUpdate
end

function UIChatViewMessageArea_v3:ShowJumpToMsg(index)
  self._scrollView:MovePanelToItemIndex_Mod(index, 0)
  local item = self._scrollView:GetShownItemByItemIndex(index or 0)
  local scripts = self._chatItemObjList[item]
  if scripts and scripts.ShowBlackFlash then
    scripts:ShowBlackFlash()
  end
end

function UIChatViewMessageArea_v3:FetchRoomData(requestType, seqId)
  self:UpdateMsgList(requestType, seqId)
end

function UIChatViewMessageArea_v3:GetHistoricalChat(requestType, seqId)
  if requestType == RequestType.InitFetch then
    self:FetchRoomData(requestType)
  elseif requestType == RequestType.JumpTo then
    local index = self:GetSeqIdIndex(seqId)
    if index ~= nil then
      self:ShowJumpToMsg(index)
    else
      self:FetchRoomData(requestType, seqId)
    end
  elseif requestType == RequestType.PullPrev then
    if #self._chatDatas == 0 then
      seqId = nil
    else
      seqId = self._chatDatas[1].seqId
    end
    self:FetchRoomData(requestType, seqId)
  elseif requestType == RequestType.PullLast then
    if #self._chatDatas ~= 0 then
      seqId = self._chatDatas[#self._chatDatas].seqId
    end
    self:FetchRoomData(requestType, seqId)
  elseif requestType == RequestType.LoadRecentMessages then
    if #self._chatDatas ~= 0 then
      seqId = self._chatDatas[#self._chatDatas].seqId
    end
    self:FetchRoomData(RequestType.LoadRecentMessages, seqId)
  elseif requestType == RequestType.ReceivePush then
    local room = self:GetRoom()
    if not room.isJump then
      local lastSeqId = room:FindPrevId(seqId)
      local uiLastMsg = self._chatDatas[#self._chatDatas]
      local canInsert = false
      if not lastSeqId then
        canInsert = true
      elseif not uiLastMsg or uiLastMsg.seqId == lastSeqId then
        canInsert = true
      end
      if canInsert then
        local isBottom = self:CheckLastChatItemToBottom()
        self:FetchRoomData(requestType)
        if isBottom and not self._scrollView.unity_looplistview2.IsDraging then
          self:ScrollToTail()
        end
      end
    end
    local roomData = self.view:GetSelectedRoom()
    if roomData then
      roomData:readMsg(roomData.lastSeqId)
    end
  end
end

function UIChatViewMessageArea_v3:RequestRoomMsg(roomTempData)
  if roomTempData.roomId ~= self:GetCurrentRoomId() then
    return
  end
  if roomTempData.requestType == RequestType.JumpTo or roomTempData.requestType == RequestType.ReceivePush then
    self:GetHistoricalChat(roomTempData.requestType, roomTempData.seqId)
  else
    self:GetHistoricalChat(roomTempData.requestType)
  end
end

function UIChatViewMessageArea_v3:StopMovement()
  if self._scrollView_ScrollRect then
    self._scrollView_ScrollRect:StopMovement()
  end
end

function UIChatViewMessageArea_v3:CheckShowMoveToTailBtn()
  local isBottom = self:CheckLastChatItemToBottom()
  local lastMaxCount = self:GetItemCount()
  if 0 < lastMaxCount then
    self.goTailBtn:SetActive(not isBottom)
  else
    self.goTailBtn:SetActive(false)
  end
end

function UIChatViewMessageArea_v3:GetCurrentRoomId()
  local room = self.view:GetSelectedRoom()
  return room and room.roomId or nil
end

function UIChatViewMessageArea_v3:SetListItemCount_Mod(itemTotalCount, moveToMinPos, moveToMaxPos, refresh)
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

function UIChatViewMessageArea_v3:DeleteChatDataByPicVer(roomId, picVer)
  if self:GetCurrentRoomId() ~= roomId then
    return
  end
  local curData, prevData
  for i = #self._chatDatas, 1, -1 do
    curData = self._chatDatas[i]
    if curData and curData:IsFakePhotoChatData() and curData:getExtra().picVer == picVer then
      local nextDataIndexAfterDel = i
      table.remove(self._chatDatas, i)
      table.remove(self._timeFlags, i)
      prevData = self._chatDatas[i - 1]
      if prevData and prevData.seqId == curData.seqId then
        table.remove(self._chatDatas, i - 1)
        table.remove(self._timeFlags, i - 1)
        nextDataIndexAfterDel = i - 1
      end
      local curDataTime = curData:getCreateTime()
      if curDataTime == self._timeFlagTail then
        local preIndex = nextDataIndexAfterDel - 1
        for i = preIndex, 1, -1 do
          if self._timeFlags[i] ~= nil and self._timeFlags[i] == true then
            local preTimeData = self._chatDatas[i]
            self._timeFlagTail = preTimeData:getCreateTime()
            break
          end
        end
      end
      local curChangeIndex = nextDataIndexAfterDel
      local curChangeData = self._chatDatas[curChangeIndex]
      if not curChangeData or self._timeFlags[curChangeIndex] then
      else
        local curPreChangeIndex = curChangeIndex - 1
        local curPreChangeData = self._chatDatas[curPreChangeIndex]
        local needAddTimeItem = false
        local curTime = curChangeData:getCreateTime()
        if curPreChangeData then
          local preTime = curPreChangeData:getCreateTime()
          if 300 <= curTime - preTime or not UITimeManager:GetInstance():IsSameDayForLocal(curTime, preTime) then
            needAddTimeItem = true
          end
        else
          needAddTimeItem = true
        end
        if needAddTimeItem then
          table.insert(self._chatDatas, curChangeIndex, curChangeData)
          table.insert(self._timeFlags, curChangeIndex, true)
        end
      end
      self:SetListItemCount_Mod(self:GetItemCount(), false, false, true)
      return
    end
  end
end

function UIChatViewMessageArea_v3:GetPostKey_System(chatData, index)
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

function UIChatViewMessageArea_v3:GetPostConfig_System(chatData, index)
  local postConfig = ChatItemPostsType2[self:GetPostKey_System(chatData, index)]
  if postConfig == nil then
    postConfig = ChatItemPostsType2.Time
  end
  return postConfig
end

function UIChatViewMessageArea_v3:SetJumpSeqId(seqId, jumpType)
  self.waitingJumpSeqId = seqId
  self.waitingJumpSeqIdType = jumpType
end

return UIChatViewMessageArea_v3
