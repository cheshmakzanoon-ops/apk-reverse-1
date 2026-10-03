local base = require("UI.UIChatNew.Component.UniversalComponent.BaseLoopView")
local UISingleMonmentMessageArea = BaseClass("UISingleMonmentMessageArea", base)
local FriendCircleFrame = require("UI.LWPlayerInfo.FriendCirclePost.FriendCircleFrame")
local FriendsCirleComment = require("UI.LWPlayerInfo.FriendCirclePost.post.FriendsCirleComment")
local MomentLikePlayersItem = require("UI.LWPlayerInfo.UILWSingleMomentDetailView.Component.MomentLikePlayersItem")

function UISingleMonmentMessageArea:OnCreate()
  base.OnCreate(self)
  self.darkModeSupport = true
  self._scrollView:MovePanelToItemIndex(0, 0)
end

function UISingleMonmentMessageArea:SetChatItemSizeDelta(item, index)
  local posx = self._scrollView:GetViewPortWidth() - 50
  if item.CachedRectTransform.sizeDelta.x == posx then
    return
  end
  self.chatItemSizeDelta = self.chatItemSizeDelta or Vector2.zero
  self.chatItemSizeDelta.x = self._scrollView:GetViewPortWidth() - 50
  self.chatItemSizeDelta.y = item.CachedRectTransform.sizeDelta.y
  item.CachedRectTransform.sizeDelta = self.chatItemSizeDelta
end

function UISingleMonmentMessageArea:ScrollToTail()
end

function UISingleMonmentMessageArea:SetTitleData(data)
  self.titleData = data
end

local TimeInterval = 3000

function UISingleMonmentMessageArea:TranslateAllShowingItems()
  if self.lastTranslateTime ~= nil and UITimeManager:GetInstance():GetServerTime() - self.lastTranslateTime < TimeInterval then
    return
  end
  self.lastTranslateTime = UITimeManager:GetInstance():GetServerTime()
  local count = self:GetItemCount()
  for i = 0, count - 1 do
    if self._scrollView:GetShownItemByItemIndex(i) then
      local chatData = self._chatDatas[i + 1]
      local _translationMsg = ""
      if not chatData.isPlayerList and chatData.getTranslationMsg then
        _translationMsg = chatData:getTranslationMsg()
      end
      local isSkipTranslate = self:IsSkipTranslate(chatData)
      if (string.IsNullOrEmpty(_translationMsg) or chatData.translatedLang ~= ChatInterface.GetChatTranslateLanguageAbbr()) and not isSkipTranslate and not chatData.isPlayerList and (chatData:GetTranslateState() == 0 or chatData:GetTranslateState() == -1) then
        chatData:setTranslateState(1)
        chatData:SetCanRefreshTranslate(1)
        EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_TRANSLATE, chatData)
      end
    end
  end
end

function UISingleMonmentMessageArea:IsSkipTranslate(chatData)
  if chatData.getPost then
    return chatData:getPost() == PostType.Chat_Stickers
  end
end

function UISingleMonmentMessageArea:RefreshRoomData(roomId)
  self.roomId = roomId
  local room = ChatInterface.getRoomData(roomId)
  if room then
    self._chatDatas = room:GetUnblockedChatDatas()
    table.sort(self._chatDatas, function(a, b)
      a.isFrist = false
      a.commentNum = 0
      b.isFrist = false
      b.commentNum = 0
      return a.serverTime > b.serverTime
    end)
    local count = table.count(self._chatDatas)
    if self._chatDatas[1] then
      self._chatDatas[1].isFrist = true
      self._chatDatas[1].commentNum = room.commentNum
      self._chatDatas[1].self_comment = self.titleData.self_comment
    end
    if room then
      if room.friendsCircleLikeUids and table.count(room.friendsCircleLikeUids) > 0 then
        local playerListData = {}
        playerListData.players = room.friendsCircleLikeUids
        playerListData.isPlayerList = true
        local likeData = self.titleData:GetEmojiLikeData()
        if likeData then
          playerListData.likeCount = likeData.count
          table.insert(self._chatDatas, 1, playerListData)
        end
      else
      end
      self.titleData.commentNum = count
      self.titleData.notClick = true
      self.titleData.isSingle = true
      table.insert(self._chatDatas, 1, self.titleData)
    end
    self._scrollView:SetListItemCount(#self._chatDatas, false, false)
    self._scrollView.unity_looplistview2:RefreshAllShownItem()
  end
end

function UISingleMonmentMessageArea:ReLoadChat()
  self._scrollView:SetListItemCount(#self._chatDatas, false, false)
  self._scrollView.unity_looplistview2:RefreshAllShownItem()
end

function UISingleMonmentMessageArea:GetChatItemScriptName(index)
  if self._chatDatas[index].isPlayerList then
    return MomentLikePlayersItem
  elseif self._chatDatas[index].post == PostType.Chat_Moment then
    return FriendsCirleComment
  end
  return FriendCircleFrame
end

function UISingleMonmentMessageArea:GetItemPrefabName(index)
  if self._chatDatas[index].isPlayerList then
    return "MomentLikePlayersItem"
  elseif self._chatDatas[index].post == PostType.Chat_Moment then
    return "FriendsCirleComment"
  end
  return "FriendCircleFrame"
end

function UISingleMonmentMessageArea:OnTopPull()
  self:RefreshRoomData(self.roomId)
end

function UISingleMonmentMessageArea:OnBottomPull()
  if self.view and not self.view:GetIsNotFetchRecord() then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_COMMAND, self.roomId)
  end
end

function UISingleMonmentMessageArea:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_RESULT_BY_TIME, self.OnRequestHistoryByTimeResult)
  self:AddUIListener(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, self.OnChatRecieveRoomMsg)
  self:AddUIListener(ChatEventEnum.ChatDeleteMessage, self.OnChatDeleteMessage)
  self:AddUIListener(ChatEventEnum.CHAT_TRANSLATE_All, self.TranslateAllShowingItems)
  self:AddUIListener(ChatEventEnum.FriendsCircleSelfCommentUpdate, self.OnSelfCommentUpdate)
end

function UISingleMonmentMessageArea:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_RESULT_BY_TIME, self.OnRequestHistoryByTimeResult)
  self:RemoveUIListener(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, self.OnChatRecieveRoomMsg)
  self:RemoveUIListener(ChatEventEnum.ChatDeleteMessage, self.OnChatDeleteMessage)
  self:RemoveUIListener(ChatEventEnum.CHAT_TRANSLATE_All, self.TranslateAllShowingItems)
  self:RemoveUIListener(ChatEventEnum.FriendsCircleSelfCommentUpdate, self.OnSelfCommentUpdate)
  base.OnRemoveListener(self)
end

function UISingleMonmentMessageArea:OnChatDeleteMessage(roomId)
  if roomId == self.roomId then
    local room = ChatInterface.getRoomData(roomId)
    room.commentNum = room.commentNum - 1
    self:RefreshRoomData(self.roomId)
  end
end

function UISingleMonmentMessageArea:OnChatRecieveRoomMsg(chatData)
  if chatData.roomId == self.roomId then
    local room = ChatInterface.getRoomData(self.roomId)
    room.commentNum = room.commentNum + 1
    if chatData.senderUid == LuaEntry.Player:GetUid() and self.titleData then
      self.titleData.self_comment = true
    end
    self.view:UpdateCommentNum(room.commentNum, self.titleData.self_comment)
    self:RefreshRoomData(self.roomId)
    self._scrollView:MovePanelToItemIndex(0, 0)
  end
end

function UISingleMonmentMessageArea:OnSelfCommentUpdate(data)
  if data.roomId == self.roomId then
    local updateSelfComment = false
    if data.self_comment then
      updateSelfComment = true
    else
      updateSelfComment = false
    end
    self.titleData.self_comment = updateSelfComment
    self:RefreshRoomData(self.roomId)
    self._scrollView:MovePanelToItemIndex(0, 0)
  end
end

function UISingleMonmentMessageArea:OnRequestHistoryByTimeResult(msg)
  self:RefreshRoomData(self.roomId)
end

function UISingleMonmentMessageArea:GetItemCount()
  return table.length(self._chatDatas)
end

function UISingleMonmentMessageArea:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISingleMonmentMessageArea:ComponentDestroy()
  self.itemContent:RemoveComponents(FriendCircleFrame)
  self.itemContent:RemoveComponents(MomentLikePlayersItem)
  self.itemContent:RemoveComponents(FriendsCirleComment)
end

function UISingleMonmentMessageArea:ReloadAfterTranslateRecv()
  self._scrollView:SetListItemCount(self:GetItemCount(), false, false)
  self._scrollView:RefreshAllShownItem()
end

return UISingleMonmentMessageArea
