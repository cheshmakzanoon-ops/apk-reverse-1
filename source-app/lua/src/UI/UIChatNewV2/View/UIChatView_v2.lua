local base = UIBaseView
local UIChatView_v2 = BaseClass("UIChatView_v2", base)
local Localization = CS.GameEntry.Localization
local ChatRoomData = require("Chat.Model.ChatRoomData")
local UIChatViewTop = require("UI.UIChatNewV2.Component.UIChatViewTop_v2")
local UIChatViewMiddle = require("UI.UIChatNewV2.Component.UIChatViewMiddle_v2")
local UIChatViewBottom = require("UI.UIChatNewV2.Component.UIChatViewBottom_v2")
local ChatFullScreenEffect = require("UI.UIChatNewV2.Component.ChatFullScreenEffect")
local compBook = {
  {
    path = "webView",
    name = "webView",
    type = UIBaseContainer
  },
  {
    path = "root/top",
    name = "top",
    type = UIChatViewTop
  },
  {
    path = "root/middle",
    name = "middle",
    type = UIChatViewMiddle
  },
  {
    path = "root/bottom",
    name = "bottom",
    type = UIChatViewBottom
  },
  {
    path = "root",
    name = "rootEffect",
    type = ChatFullScreenEffect
  }
}

function UIChatView_v2:OnCreate()
  base.OnCreate(self)
  self.ctrl.view = self
  self:ComponentDefine()
  self:DataInit()
  __ChatPostBI(ChatBIEnum.IM_ENTER_CHAT_PAGE)
  CommonUtil.InitRandomSeedWithUID(LuaEntry.Player.uid)
end

function UIChatView_v2:OnDestroy()
  DataCenter.SeasonDataManager:CleanShareDesertStatus()
  DataCenter.ChatPrivateDataManager:OnExitChatView()
  DataCenter.ChatVieweDataManager:OnExitChatView()
  ChatInterface.getMoment():SendExposure()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChatView_v2:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIChatView_v2:ComponentDestroy()
end

function UIChatView_v2:OnOpenURL(data)
  if CS.SDKManager.IS_UNITY_EDITOR() or Config.IsPC() then
    CS.SDKManager.OpenURL(data.openUrl)
  else
    self.webView:SetActive(true)
    DataCenter.LWNewsCenterManager:ShowWebViewURl({
      obj = self.webView.gameObject,
      url = data.openUrl,
      startJson = data.eventJson,
      openType = NewsCenterOpenType.Chat
    })
    self.bottom:SetInputCompsActive(false)
  end
end

function UIChatView_v2:DataInit()
  self.chatRoomMgr = ChatInterface.getRoomMgr()
  DataCenter.AllianceNoticeManager:GetNoticeList()
  DataCenter.ChatCacheMsgManager:RemoveMsgByCache()
  self.roomSets, self.roomSetMap = self.ctrl:GetRoomGroup()
  self.bottom:SetInputMsgText()
  self.rootEffect:InitData()
  self:UpdateSetRooms()
  local userdata = self:GetUserData() or {}
  local roomId = string.IsNullOrEmpty(userdata.roomId) and self.chatRoomMgr:GetCountryRoomId() or userdata.roomId
  self.jumpSeqId = userdata.seqId
  local scrollToActive = userdata.scrollToActive
  self.jumpSeqIdType = nil
  local privateUserInfo = userdata.privateUserInfo
  if not privateUserInfo and userdata.userId then
    privateUserInfo = {
      uid = userdata.userId,
      userName = userdata.username or ""
    }
  end
  if privateUserInfo then
    self:OnTalkToSomebody(privateUserInfo)
  else
    local roomData = self.chatRoomMgr:GetRoomData(roomId)
    self:SelectRoom(roomData, scrollToActive)
  end
end

function UIChatView_v2:DataDestroy()
  CS.UIChatSendPhoto.ClearAssetLoadingSet()
  self.jumpSeqId = nil
  self.jumpSeqIdType = nil
  self.chatRoomMgr = nil
end

function UIChatView_v2:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_BLOCK_ADD, self.OnBlockStateChange)
  self:AddUIListener(ChatEventEnum.CHAT_BLOCK_REMOVE, self.OnBlockStateChange)
  self:AddUIListener(ChatEventEnum.CHAT_REFRESH_CHANNEL, self.OnRefreshRooms)
  self:AddUIListener(ChatEventEnum.CHAT_TALK_TO_PRIVATE, self.OnTalkToSomebody)
  self:AddUIListener(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, self.OnReceiveChatMessage)
  self:AddUIListener(ChatEventEnum.CHAT_UNREAD_UPDATE, self.OnUnreadUpdate)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_REDDONT_UPDATE, self.OnUnreadUpdate)
  self:AddUIListener(ChatEventEnum.LF_CloseChatView, self.CloseSelf)
  self:AddUIListener(ChatEventEnum.Chat_QuitRoom, self.OnQuitRoom)
  self:AddUIListener(ChatEventEnum.CHAT_ALLIANCE_NOTICELIST_UPDATE, self.UpdateNoticeList)
  self:AddUIListener(ChatEventEnum.CHAT_PRIVATE_ROOMLAST_UPDATE, self.UpdatePrivateSetRooms)
  self:AddUIListener(ChatEventEnum.CHAT_INIT_PULL_DONE, self.OnRefreshRooms)
  self:AddUIListener(EventId.DetectEventGetTreasureClaimInfo, self.OnDetectEventGetTreasureClaimInfo)
  self:AddUIListener(EventId.ChatDeleteChatDataByPicVer, self.OnDeleteChatDataByPicVer)
  self:AddUIListener(EventId.Chat_GetFriendList, self.OnGetFriendList)
  self:AddUIListener(EventId.CLEAR_CHAT_DYNAMIC_STICKER_GO, self.ClearChatDynamicStickerGo)
  self:AddUIListener(EventId.CHAT_REQUEST_HISTORY_MSG_RESULT, self.RefreshFriendList)
  self:AddUIListener(EventId.CHAT_CHANGE_ROOM_ATVIEW, self.ChangeSelectRoom)
  self:AddUIListener(EventId.UIHideViewShown, self.OnHideViewShown)
  self:AddUIListener(EventId.CHAT_NEWSCENTER_CHATVIEW_OPENURL, self.OnOpenURL)
  self:AddUIListener(EventId.ChatViewJumpToMsg, self.GetJumpMsgRoomEventId)
  self:AddUIListener(EventId.CHAT_NEWSCENTER_SHARE, self.OnCloseNewsCenterURL)
end

function UIChatView_v2:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_BLOCK_ADD, self.OnBlockStateChange)
  self:RemoveUIListener(ChatEventEnum.CHAT_BLOCK_REMOVE, self.OnBlockStateChange)
  self:RemoveUIListener(ChatEventEnum.CHAT_REFRESH_CHANNEL, self.OnRefreshRooms)
  self:RemoveUIListener(ChatEventEnum.CHAT_TALK_TO_PRIVATE, self.OnTalkToSomebody)
  self:RemoveUIListener(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, self.OnReceiveChatMessage)
  self:RemoveUIListener(ChatEventEnum.CHAT_UNREAD_UPDATE, self.OnUnreadUpdate)
  self:RemoveUIListener(ChatEventEnum.LF_CloseChatView, self.CloseSelf)
  self:RemoveUIListener(ChatEventEnum.CHAT_ALLIANCE_NOTICELIST_UPDATE, self.UpdateNoticeList)
  self:RemoveUIListener(ChatEventEnum.CHAT_PRIVATE_ROOMLAST_UPDATE, self.UpdatePrivateSetRooms)
  self:RemoveUIListener(ChatEventEnum.CHAT_INIT_PULL_DONE, self.OnRefreshRooms)
  self:RemoveUIListener(EventId.DetectEventGetTreasureClaimInfo, self.OnDetectEventGetTreasureClaimInfo)
  self:RemoveUIListener(EventId.ChatDeleteChatDataByPicVer, self.OnDeleteChatDataByPicVer)
  self:RemoveUIListener(EventId.Chat_GetFriendList, self.OnGetFriendList)
  self:RemoveUIListener(ChatEventEnum.Chat_QuitRoom, self.OnQuitRoom)
  self:RemoveUIListener(EventId.CLEAR_CHAT_DYNAMIC_STICKER_GO, self.ClearChatDynamicStickerGo)
  self:RemoveUIListener(EventId.CHAT_REQUEST_HISTORY_MSG_RESULT, self.RefreshFriendList)
  self:RemoveUIListener(EventId.CHAT_ROOM_REDDONT_UPDATE, self.OnUnreadUpdate)
  self:RemoveUIListener(EventId.ChatViewJumpToMsg, self.GetJumpMsgRoomEventId)
  self:RemoveUIListener(EventId.CHAT_CHANGE_ROOM_ATVIEW, self.ChangeSelectRoom)
  self:RemoveUIListener(EventId.UIHideViewShown, self.OnHideViewShown)
  self:RemoveUIListener(EventId.CHAT_NEWSCENTER_CHATVIEW_OPENURL, self.OnOpenURL)
  self:RemoveUIListener(EventId.CHAT_NEWSCENTER_SHARE, self.OnCloseNewsCenterURL)
  base.OnRemoveListener(self)
end

function UIChatView_v2:CloseSelf()
  self:AskForPushPermission()
  self.ctrl:CloseSelf()
end

function UIChatView_v2:OnCloseNewsCenterURL()
  if self.webView and self.webView:GetActive() then
    CS.ZendeskSupportView.Close()
    self.webView:SetActive(false)
    self.bottom:SetInputCompsActive(true)
    return
  end
end

function UIChatView_v2:GetSelectedRoomSet()
  if not self.roomSets then
    return nil
  end
  for _, roomSet in pairs(self.roomSets) do
    if roomSet.selected then
      return roomSet
    end
  end
  return nil
end

function UIChatView_v2:OnQuitRoom(data)
  if data.category and data.category == ChatRoomCategory.PRIVATE then
    local curRoom = self:GetSelectedRoom()
    if data.roomId and curRoom and data.roomId == curRoom.roomId then
      self:OnClickBack()
    end
    self:UpdatePrivateSetRooms(true)
    self.top:UpdateTabsReddot()
  end
end

function UIChatView_v2:GetSelectedRoom()
  local roomSet = self:GetSelectedRoomSet()
  if roomSet then
    return roomSet.currRoom
  end
  return nil
end

function UIChatView_v2:UpdateSetRooms()
  if not self.chatRoomMgr then
    self.chatRoomMgr = ChatInterface.getRoomMgr()
  end
  local room
  for _, roomSet in ipairs(self.roomSets) do
    if roomSet.category == ChatRoomCategory.PRIVATE then
      self:UpdatePrivateSetRooms()
    elseif roomSet.category == ChatRoomCategory.MOMENT then
      roomSet.rooms = {}
      if roomSet.groups and table.count(roomSet.groups) > 0 then
        self:UpdateMomentRoomSet(roomSet)
      end
    else
      roomSet.rooms = {}
      for _, group in ipairs(roomSet.groups) do
        local room = self.chatRoomMgr:GetRoomDataByGroup(group)
        if room then
          table.insert(roomSet.rooms, room)
          if not roomSet.currRoom then
            roomSet.currRoom = room
          end
        end
      end
    end
  end
  self.top:UpdateTabs(self.roomSets)
end

function UIChatView_v2:UpdateMomentRoomSet(roomSet)
  local defMomentGroup = ChatInterface.getMoment():GetSelectMomentGroup()
  local defRoom, firstRoom, room
  for _, groupList in ipairs(roomSet.groups) do
    for i, group in ipairs(groupList.secondGroups) do
      room = nil
      room = ChatInterface.getMoment():GetMomentData(group)
      if room then
        table.insert(roomSet.rooms, room)
        firstRoom = firstRoom or room
        if group == defMomentGroup then
          defRoom = room
        end
      end
    end
  end
  if defRoom then
    roomSet.currRoom = defRoom
  elseif firstRoom then
    roomSet.currRoom = firstRoom
  end
end

function UIChatView_v2:OnGetFriendList()
  self:UpdatePrivateSetRooms(true)
end

function UIChatView_v2:RefreshFriendList()
  self:UpdatePrivateSetRooms(true)
  self.top:UpdateTabsReddot()
end

function UIChatView_v2:GetJumpMsgRoomEventId(param)
  if param == nil then
    return
  end
  local roomId = param.roomId
  local seqId = param.seqId
  local jumpType = param.jumpType
  if roomId == nil then
    return
  end
  self.jumpSeqId = seqId
  self.jumpSeqIdType = jumpType
  local roomData = self.chatRoomMgr:GetRoomData(roomId)
  self:SelectRoom(roomData)
end

function UIChatView_v2:UpdatePrivateSetRooms(result)
  local roomSet = self.roomSetMap[ChatRoomCategory.PRIVATE]
  roomSet.rooms = self.chatRoomMgr:GetAllUnblockedPrivateRoomDatas(true)
  if result ~= nil then
    self.middle:UpdatePrivateList(roomSet)
  end
end

function UIChatView_v2:UpdateNoticeList()
  self.middle.noticeList:ReInit()
end

function UIChatView_v2:SwitchType(room)
  self.middle:SetPrivateListActive(false)
  if room.group == ChatGroupType.GROUP_ALLIANCE_NOTICE then
    self.middle:SetScrollMsgsActive(false)
    self.middle:SetNoticeActive(true)
    self.middle:SetMomentActive(false)
    self.bottom:SetInputCompsActive(false)
    self.bottom:SetBatchBtnShow(false)
    self.bottom:SetNoticeBatchBtnShow(true)
    return false
  elseif ChatInterface.GetIsMomentGroup(room.group) then
    self.middle:SetScrollMsgsActive(false)
    self.middle:SetNoticeActive(false)
    self.middle:SetMomentActive(true)
    self.bottom:SetInputCompsActive(false)
    self.bottom:SetBatchBtnShow(false)
    self.bottom:SetNoticeBatchBtnShow(false)
    return false
  else
    self.middle:SetMomentActive(false)
    self.middle:SetNoticeActive(false)
    self.middle:SetScrollMsgsActive(true)
    if not self.webView:GetActive() then
      self.bottom:SetInputCompsActive(true)
    end
    self.bottom:SetBatchBtnShow(false)
    self.bottom:SetNoticeBatchBtnShow(false)
    return true
  end
end

function UIChatView_v2:ChangeSelectRoom(roomId)
  local roomData = ChatInterface.getRoomMgr():GetRoomData(roomId)
  if roomData then
    self:SelectRoom(roomData)
  end
end

function UIChatView_v2:OnHideViewShown(viewName)
  if self.view.__name == viewName then
    local currRoom = self:GetSelectedRoom()
    if currRoom then
      if ChatInterface.GetIsMomentGroup(currRoom.group) then
        self.middle:UpdateMomentMessage()
      else
        currRoom:readMsg(currRoom.lastSeqId)
        self:OnRefreshRooms(nil, true)
        self.middle.scrollMsgs:GetHistoricalChat(RequestType.LoadRecentMessages)
      end
    end
  end
end

function UIChatView_v2:SelectRoom(room, scrollToActive)
  if not room then
    return
  end
  DataCenter.SeasonDataManager:CleanShareDesertStatus()
  if room.group ~= ChatGroupType.GROUP_TMPRoom then
    local tempRoom = ChatInterface.getRoomData(room.roomId)
    if tempRoom then
      room = tempRoom
    elseif room.roomId then
    end
  end
  DataCenter.ChatVieweDataManager:OnSelectRoom(room)
  self:SwitchType(room)
  self.top:SetLayouTabState(room.category ~= ChatRoomCategory.PRIVATE)
  for _, roomSet in ipairs(self.roomSets) do
    if roomSet.category == room.category then
      roomSet.selected = true
      roomSet.currRoom = room
      self.ctrl:CacheUnreadCountAndJumpSeqId(room)
      if room.category ~= ChatRoomCategory.MOMENT then
        room:readMsg(room.lastSeqId)
      end
      self.middle:UpdateBar(roomSet, scrollToActive)
      self.middle:UpdatePins(roomSet.currRoom)
      if room:GetAtSeqId() == self.jumpSeqId then
        room:ClearAtSeqId()
      end
      self.middle:UpdateMessages(roomSet.currRoom, self.jumpSeqId, self.jumpSeqIdType)
      self.bottom:ResetInputAndReply(roomSet.currRoom)
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_SEL, room.roomId)
      self.jumpSeqId = nil
      self.jumpSeqIdType = nil
    else
      roomSet.selected = false
    end
  end
  self.top:UpdateTabs(self.roomSets)
  self.top:UpdateTopBtns()
  local tempRoom = self:GetSelectedRoom()
  if not tempRoom then
  end
end

function UIChatView_v2:ShowPrivateRoomList()
  local privateRoomSet
  for _, roomSet in ipairs(self.roomSets) do
    if roomSet.category == ChatRoomCategory.PRIVATE then
      roomSet.selected = true
      roomSet.currRoom = nil
      privateRoomSet = roomSet
    else
      roomSet.selected = false
    end
  end
  DataCenter.ChatVieweDataManager:OnShowPrivateList()
  self.top:UpdateTabs(self.roomSets)
  self.top:UpdateAllianceNoticeBtnState()
  self.middle:SetPrivateListActive(true)
  self.middle:UpdatePrivateList(privateRoomSet)
  self.middle:SetMomentActive(false)
  self.middle:SetNoticeActive(false)
  self.middle:SetScrollMsgsActive(false)
  self.bottom:ResetInputAndReply(nil)
  self.bottom:SetInputCompsActive(false)
  self.bottom:SetBatchBtnShow(true)
  self.bottom:SetNoticeBatchBtnShow(false)
end

function UIChatView_v2:ShowRoomMsgs(room)
  if not room then
    return
  end
  self.bottom:EnterRoom(room)
end

function UIChatView_v2:ShowAllianceNoticePopup()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIPostPublishing, {anim = true})
end

function UIChatView_v2:OnRefreshRooms(tempRoomData, isSelectRoom)
  if tempRoomData and (tempRoomData.group == ChatGroupType.GROUP_FRIENDS_CIRCLE_ROOM or tempRoomData.group == ChatGroupType.GROUP_FRIENDS_CIRCLE_COMMENT_ROOM or tempRoomData.group == ChatGroupType.GROUP_ALLIANCE_NOTICE_COMMENTS or ChatInterface.GetIsMomentGroup(tempRoomData.group)) then
    return
  end
  self:UpdateSetRooms()
  local currRoom = self:GetSelectedRoom()
  local inAlliance = ChatInterface.isInAlliance()
  if not currRoom then
    return
  end
  if ChatInterface.GetIsMomentGroup(currRoom.group) then
    return
  end
  if currRoom.group == ChatGroupType.GROUP_ALLIANCE_FRIEND_ROOM and (not inAlliance or not DataCenter.SeasonAllyFriendManager:HasFriend()) then
    local roomData = self.chatRoomMgr:GetRoomDataByGroup(ChatGroupType.GROUP_COUNTRY)
    self:SelectRoom(roomData)
    return
  end
  if currRoom.group == ChatGroupType.GROUP_ALLIANCE_MANAGER or currRoom.group == ChatGroupType.GROUP_ALLIANCE or currRoom.group == ChatGroupType.GROUP_ALLIANCE_NOTICE then
    if not inAlliance then
      local roomData = self.chatRoomMgr:GetRoomDataByGroup(ChatGroupType.GROUP_COUNTRY)
      self:SelectRoom(roomData)
      return
    elseif currRoom.group == ChatGroupType.GROUP_ALLIANCE_MANAGER then
      local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
      if not isR4orR5 then
        local roomData = self.chatRoomMgr:GetRoomDataByGroup(ChatGroupType.GROUP_ALLIANCE)
        self:SelectRoom(roomData)
        return
      end
    end
  end
  if currRoom and currRoom.group == ChatGroupType.GROUP_TMPRoom then
    local userInfo = currRoom:getPrivateOtherMember()
    if userInfo then
      local privateRoom = self.chatRoomMgr:getPrivateRoomData(userInfo.uid)
      if privateRoom then
        self:SelectRoom(privateRoom)
        return
      end
    end
  end
  if not isSelectRoom then
    self:SelectRoom(currRoom)
  end
end

function UIChatView_v2:OnTalkToSomebody(userInfo)
  if not userInfo then
    return
  end
  local privateRoom = self.chatRoomMgr:getPrivateRoomData(userInfo.uid)
  if privateRoom then
    self:SelectRoom(privateRoom)
  else
    local room = self.chatRoomMgr:CreateTempPrivateRooom(userInfo.uid)
    if room then
      self:UpdateSetRooms()
      self:SelectRoom(room)
    end
  end
end

function UIChatView_v2:OnBlockStateChange(blockInfo)
  self:UpdatePrivateSetRooms(true)
  local currRoom = self:GetSelectedRoom()
  if currRoom then
    self.middle:UpdateMessages(currRoom)
  end
  self:OnUnreadUpdate()
end

function UIChatView_v2:OnRefreshPrivatePin()
  local currRoom = self:GetSelectedRoom()
  if currRoom and currRoom:isPrivateChat() and not DataCenter.LWChatPinManager:GetIsOpenPush(currRoom) then
    self.middle:UpdatePins(currRoom)
  end
end

function UIChatView_v2:OnReceiveChatMessage(chatMsg)
  local room = self.chatRoomMgr:GetRoomData(chatMsg.roomId)
  if room and (room:isPrivateChat() or room.group == ChatGroupType.GROUP_CUSTOM_GROUP) then
    self:UpdatePrivateSetRooms(true)
    self:OnRefreshPrivatePin()
  end
end

function UIChatView_v2:OnUnreadUpdate()
  self.top:UpdateTabsReddot()
  self.middle.barRooms:UpdateTabsReddot()
end

function UIChatView_v2:BlackWebView()
  if self.webView and self.webView:GetActive() then
    local isCanCloseView = not CS.ZendeskSupportView.WebViewBack()
    if isCanCloseView then
      CS.ZendeskSupportView.Close()
      self.webView:SetActive(false)
      self.bottom:SetInputCompsActive(true)
    end
  else
    self.ctrl:CloseSelf()
  end
end

function UIChatView_v2:OnClickBack()
  if self.webView and self.webView:GetActive() then
    local isCanCloseView = not CS.ZendeskSupportView.WebViewBack()
    if isCanCloseView then
      CS.ZendeskSupportView.Close()
      self.webView:SetActive(false)
      self.bottom:SetInputCompsActive(true)
    end
    return
  end
  local roomMgr = ChatManager2:GetInstance().Room
  roomMgr:ClearJumpMsgRoom()
  local roomSet = self:GetSelectedRoomSet()
  local privateViewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  local noticeViewShowType = DataCenter.ChatVieweDataManager:GetAlNoticeShowType()
  if roomSet and roomSet.category == ChatRoomCategory.PRIVATE and roomSet.currRoom and roomSet.currRoom.group ~= ChatGroupType.GROUP_TMPRoom and not self.middle.listPrivate:GetActive() then
    self:ShowPrivateRoomList()
    self.top:SetLayouTabState(true)
  elseif roomSet and roomSet.category == ChatRoomCategory.PRIVATE and roomSet.currRoom == nil and privateViewShowType == ChatPrivateListShowType.BatchDel then
    DataCenter.ChatPrivateDataManager:OnToNormalType()
    EventManager:GetInstance():Broadcast(EventId.ChatPrivateShowTypeChange)
  elseif roomSet and roomSet.category == ChatRoomCategory.ALLIANCE and roomSet.currRoom and roomSet.currRoom.group == ChatGroupType.GROUP_ALLIANCE_NOTICE and noticeViewShowType == ChatAlNoticeShowType.BatchDel then
    DataCenter.ChatVieweDataManager:SetAlNoticeNormalData()
    EventManager:GetInstance():Broadcast(EventId.ChatAlNoticeShowTypeChange)
  else
    self:CloseSelf()
  end
end

function UIChatView_v2:NeedAskForPushPermission(prefKey)
  if not self._needAskForPushPermissionKeys then
    self._needAskForPushPermissionKeys = {}
  end
  if self._needAskForPushPermissionKeys[prefKey] then
    return
  end
  if CS.GameEntry.Sdk:GetIsNotifyOpen() then
    return
  end
  local lastAskTime = CommonUtil.PlayerPrefsGetLong(prefKey, 0)
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local gapTime = serverTime - lastAskTime
  if gapTime < 86400000 then
    return
  end
  self._needAskForPushPermissionKeys[prefKey] = true
end

function UIChatView_v2:AskForPushPermission()
  if not self._needAskForPushPermissionKeys then
    return
  end
  local needAsk = false
  for prefKey, isTrue in pairs(self._needAskForPushPermissionKeys) do
    if isTrue then
      CommonUtil.PlayerPrefsSetLong(prefKey, UITimeManager:GetInstance():GetServerTime())
      needAsk = true
    end
  end
  self._needAskForPushPermissionKeys = nil
  if needAsk then
    UIUtil.ShowMessage(Localization:GetString("2900008"), 2, "2900009", "110106", function()
      CS.GameEntry.Sdk:AskForNotifyPermission()
    end)
  end
end

function UIChatView_v2:OnDetectEventGetTreasureClaimInfo(data)
  local currRoom = self:GetSelectedRoom()
  local inAlliance = ChatInterface.isInAlliance()
  if not currRoom or not inAlliance then
    return
  end
  if currRoom.group == ChatGroupType.GROUP_ALLIANCE_MANAGER or currRoom.group == ChatGroupType.GROUP_ALLIANCE or currRoom.group == ChatGroupType.GROUP_ALLIANCE_NOTICE then
    if data.pointId > 0 then
      local serverId = data.targetServer
      if serverId <= 0 then
        serverId = LuaEntry.Player:GetSourceServerId()
      end
      EventManager:GetInstance():Broadcast(ChatEventEnum.LF_CloseChatView, true)
      GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(data.pointId, ForceChangeScene.World), nil, nil, nil, serverId)
    else
      UIUtil.OpenDetectEventTreasureClaimInfoView(data)
    end
  end
end

function UIChatView_v2:OnDeleteChatDataByPicVer(data)
  self.middle.scrollMsgs:DeleteChatDataByPicVer(data.roomId, data.picVer)
  if data.isRefreshScroll then
    self.middle.scrollMsgs:RefreshScrollView()
  end
end

function UIChatView_v2:ClearChatDynamicStickerGo()
  self.middle:ClearChatDynamicStickerGo()
end

function UIChatView_v2:MomentChangeSelect(room)
  for i = 1, #self.roomSets do
    if self.roomSets[i].category == room.category then
      self.roomSets[i].currRoom = room
      ChatInterface.getMoment():SetSelectMomentGroup(room.group)
      self.middle:UpdateMessages(room)
    end
  end
end

function UIChatView_v2:GetRoomSet(category)
  return self.roomSetMap[category]
end

function UIChatView_v2:OnWindowReopenWithoutCreate()
  local room = self:GetSelectedRoom()
  if ChatInterface.GetIsMomentGroup(room.group) then
    self.middle:UpdateMomentMessage()
  end
end

return UIChatView_v2
