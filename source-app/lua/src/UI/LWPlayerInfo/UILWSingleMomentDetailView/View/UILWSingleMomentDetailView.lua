local UILWSingleMomentDetailView = BaseClass("UILWSingleMomentDetailView", UIBaseView)
local UISingleMomentMiddle = require("UI.LWPlayerInfo.UILWSingleMomentDetailView.Component.UISingleMomentMiddle")
local UIChatViewBottom = require("UI.UIChatNewV2.Component.UIChatViewBottom_v2")
local base = UIBaseView
local compBook = {
  {
    path = "Root/top/LayoutBtns/visibilityBtn",
    name = "visibilityBtn",
    type = UIButton,
    onClick = function(self)
      self:OnVisibilityClick()
    end
  },
  {
    path = "Root/top/LayoutBtns/visibilityBtn/visibilityIcon",
    name = "visibilityImg",
    type = UIImage
  },
  {
    path = "Root/top/LayoutBtns/BtnInfo",
    name = "btnInfo",
    type = UIButton,
    onClick = function(self)
      self:OnClickInfo()
    end
  },
  {
    path = "Root/top/LayoutBtns/BtnInfo/night",
    name = "btnInfoNight",
    type = UIBaseComponent
  },
  {
    path = "Root/middle",
    name = "middle",
    type = UISingleMomentMiddle
  },
  {
    path = "Root/bottom",
    name = "bottom",
    type = UIChatViewBottom
  },
  {
    path = "Root/bottom/areaInput/notInput",
    name = "notInput",
    type = UIBaseContainer
  },
  {
    path = "Root/bottom/areaInput/notInput/notInputText",
    name = "notInputText",
    type = UIText
  },
  {
    path = "Root/top/TxtTitle",
    name = "titleText",
    type = UITextMeshProUGUIEx
  },
  {
    path = "Root/middle/Scroll_View_mainView/MainViewport/objLoading",
    name = "loadingObj",
    type = UIBaseContainer
  }
}

function UILWSingleMomentDetailView:OnCreate()
  base.OnCreate(self)
  self:InitData()
  self.ctrl.view = self
  self:DefineCompsByBook(compBook)
  self.middle:ReInit(self.data)
  self:RefreshView()
end

function UILWSingleMomentDetailView:RefreshView()
  local isSelf = self.data.senderUid == LuaEntry.Player.uid
  self.loadingObj:SetActive(not ChatManager2:GetInstance().Net:IsRunning())
  local isNight = ChatInterface.GetChatTheme() == ChatUIThemeConfig.ChatMode.Night
  self.btnInfoNight:SetActive(isNight)
  local maskAlpha = isNight and 0.3 or 0
  self.mask = ChatInterface.GetUtil().CreateOrGetBlackMask(self.visibilityImg, maskAlpha)
  self.btnInfo:SetActive(not isSelf)
  self.visibilityBtn:SetActive(isSelf)
  local isCanComment = self:CanComment()
  local disableInput = false
  local tipText
  if self.userData.friendsCircleCommentIsOn and self.userData.uid ~= LuaEntry.Player.uid then
    disableInput = true
    tipText = "moment_comment_tip2"
  elseif not isCanComment then
    disableInput = true
    tipText = "moment_comment_tip1"
  end
  self.notInput:SetActive(disableInput)
  self.bottom:SetUMIFocus(false)
  local room = ChatInterface.getRoomData(self.circleCommentRoomId)
  if self:GetIsShowComment() and room and #room.msgs == 0 then
    local net = ChatManager2:GetInstance().Net
    net:SendMessage(ChatMsgDefines.RoomJoinMulti, ChatGroupType.GROUP_FRIENDS_CIRCLE_COMMENT_ROOM, self.circleCommentRoomId)
    net:SendMessage(ChatMsgDefines.HistoryRoomsV2, {
      self.circleCommentRoomId
    })
  end
  self.titleText:SetColorHex(ChatUIThemeConfig.MomentColor[ChatInterface.GetChatTheme()].titleText)
  self.bottom:ResetInputAndReply(self:GetSelectedRoom())
  if disableInput then
    self.notInputText:SetLocalText(tipText)
    self.bottom:SetKeyboardActive(false)
    self.bottom:SetEmojiBtnActive(false)
  elseif not self.bottom.hiddenKeyboard or self.bottom.forceHiddenKeyboard then
    self.bottom:SetKeyboardActive(true)
    self.bottom:SetEmojiBtnActive(true)
  end
end

function UILWSingleMomentDetailView:OnVisibilityClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMomentOperation, {anim = true}, self.data)
end

function UILWSingleMomentDetailView:GetIsNotFetchRecord()
  local isCanComment = self:CanComment()
  local friendsCircleCommentIsOn = self.userData.friendsCircleCommentIsOn and self.userData.uid ~= LuaEntry.Player.uid
  return not isCanComment or friendsCircleCommentIsOn
end

function UILWSingleMomentDetailView:GetIsShowComment()
  if not self.userData then
    return false
  end
  if self.userData.uid == LuaEntry.Player.uid then
    return true
  elseif self.userData.friendsCircleCommentIsOn then
    return false
  else
    return true
  end
end

function UILWSingleMomentDetailView:GetSelectedRoom()
  return ChatManager2:GetInstance().Room:GetRoomData(self.circleCommentRoomId)
end

function UILWSingleMomentDetailView:OnClickDelete()
end

function UILWSingleMomentDetailView:OnClickInfo()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatReport, {anim = true}, {
    type = ReportType.FriendCircle,
    chatData = self.data
  })
end

function UILWSingleMomentDetailView:OnClickBack()
  if self.initCommentNum ~= self.commentNum and self.source then
    local param = {
      roomId = self.data.roomId,
      seqId = self.data.seqId,
      commentNum = self.commentNum,
      self_comment = self.self_comment,
      source = self.source
    }
    ChatInterface.getMoment():UpdateCommentCount(param)
  end
  self.ctrl:CloseSelf()
end

function UILWSingleMomentDetailView:OnDestroy()
  self:ClearData()
  self:ClearCompsByBook(compBook)
  base.OnDestroy(self)
end

function UILWSingleMomentDetailView:UpdateCommentNum(commentNum, self_comment)
  self.commentNum = commentNum
  self.self_comment = self_comment
end

function UILWSingleMomentDetailView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.OnPlayerDataCallBack)
  self:AddUIListener(EventId.ChatRoomClear, self.OnChatNetErrorOrDisconnect)
  self:AddUIListener(EventId.CHAT_LOGIN_SUCCESS, self.OnChatLoginSuccess)
  self:AddUIListener(ChatEventEnum.CHAT_ERROR_OR_DISCONNECT, self.OnChatNetErrorOrDisconnect)
end

function UILWSingleMomentDetailView:OnRemoveListener()
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.OnPlayerDataCallBack)
  self:RemoveUIListener(EventId.ChatRoomClear, self.OnChatNetErrorOrDisconnect)
  self:RemoveUIListener(EventId.CHAT_LOGIN_SUCCESS, self.OnChatLoginSuccess)
  self:RemoveUIListener(ChatEventEnum.CHAT_ERROR_OR_DISCONNECT, self.OnChatNetErrorOrDisconnect)
  base.OnRemoveListener(self)
end

function UILWSingleMomentDetailView:OnChatNetErrorOrDisconnect()
  self.loadingObj:SetActive(true)
end

function UILWSingleMomentDetailView:OnChatLoginSuccess()
  self:InitData()
  self:RefreshView()
end

function UILWSingleMomentDetailView:OnPlayerDataCallBack(uid)
  if uid ~= self.data.senderUid then
    return
  end
  self.userData = UIUtil.GetPlayerInfoShowByUid(self.data.senderUid, nil, true)
  self:RefreshView()
end

function UILWSingleMomentDetailView:CanComment()
  if self.userData.friendsCircleAllianceMomentIsOn then
    if self.userData.uid == LuaEntry.Player.uid then
      return true
    end
    if not string.IsNullOrEmpty(LuaEntry.Player.allianceId) then
      return self.userData.allianceId == LuaEntry.Player.allianceId
    end
    return false
  end
  return true
end

function UILWSingleMomentDetailView:InitData()
  local viewUserData = self:GetUserData()
  if viewUserData then
    self.data = viewUserData.chatData
    self.source = viewUserData.source
  end
  self.userData = UIUtil.GetPlayerInfoShowByUid(self.data.senderUid, nil, true)
  self.circleCommentRoomId = ChatManager2:GetInstance().Room:GetFriendsCircleCommentRoomId(self.data.senderUid, self.data.seqId)
  self.initCommentNum = self.data.commentNum
  self.commentNum = self.data.commentNum
  self.self_comment = self.data.self_comment
  ChatInterface.getMoment():SendClickExposure(self.data.msgId)
  ChatManager2:GetInstance().Room:CreateChatRoom(self.circleCommentRoomId, ChatGroupType.GROUP_FRIENDS_CIRCLE_COMMENT_ROOM)
end

function UILWSingleMomentDetailView:UpdateFriendCircleRoomMsg()
  local room = ChatManager2:GetInstance().Room:GetRoomData(self.data.roomId)
  local comRoom = ChatManager2:GetInstance().Room:GetRoomData(self.circleCommentRoomId)
  local chatData
  if room and comRoom then
    chatData = room:getChatDataBySeqId(self.data.seqId)
    if chatData then
      local likeData = chatData:GetEmojiLikeData()
      if likeData and likeData.count then
        local roomLikeCount = comRoom.friendsCircleLikeUids and table.count(comRoom.friendsCircleLikeUids) or 0
        if table.count(roomLikeCount) > likeData.count then
          chatData.count = roomLikeCount
        end
      end
      chatData.commentNum = comRoom.commentNum
      self.data.commentNum = comRoom.commentNum
      EventManager:GetInstance():Broadcast(ChatEventEnum.UPDATE_USER_MSG, chatData)
    end
  end
end

function UILWSingleMomentDetailView:ClearData()
  self:UpdateFriendCircleRoomMsg()
  if self.circleCommentRoomId then
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RoomLeave, self.circleCommentRoomId, ChatGroupType.GROUP_FRIENDS_CIRCLE_COMMENT_ROOM)
    ChatManager2:GetInstance().Room:RemoveRoomData(self.circleCommentRoomId)
  end
  self.data = nil
  self.userData = nil
  self.circleCommentRoomId = nil
end

function UILWSingleMomentDetailView:GetDetailsData()
  return self.data
end

return UILWSingleMomentDetailView
