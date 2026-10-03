local UIMainChatItem = BaseClass("UIMainChatItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIMainChatItemCell = require("UI.LWMainUI.Component.UIMainBottom.UIMainChatItemCell")
local UIAdaptReddot = require("UI.UICommon.Component.UIAdaptReddot")
local UIChatHead = require("UI.UIChatNew.Component.ChatHead")
local rapidjson = require("rapidjson")
local GroupHead = require("UI/UIChatNewV2/Component/GroupHead")
local POST_TYPE_BLACK_LIST = {
  PostType.Text_MemberJoin,
  PostType.Text_MemberQuit,
  PostType.Text_ChatRoomSystemMsg,
  PostType.Text_AllianceMemberInOut,
  PostType.Text_AllianceRankChange,
  PostType.Text_AllianceOfficialChange,
  PostType.Text_AllianceOfficialSet,
  PostType.Text_AllianceOfficialCancel
}
local compBook = {
  {
    path = "AdaptReddot",
    name = "reddot",
    type = UIAdaptReddot,
    active = false
  },
  {
    path = "NewsLabel",
    name = "lblNews",
    type = UITextMeshProUGUIEx,
    text = ""
  },
  {
    path = "Page",
    name = "pageRoot",
    type = UIImage,
    active = false
  },
  {
    path = "Page/PageHint",
    name = "pageHint",
    type = UIImage
  },
  {
    path = "Page/PageHint/switch_tip",
    name = "pageSwitchTip",
    type = UICanvasGroup,
    active = false
  },
  {
    path = "Page/PageHint/switch_tip/content/txt",
    name = "pageSwitchTipTxt",
    type = UIText
  },
  {
    path = "ScrollView",
    name = "scroll",
    type = UIScrollPage
  },
  {
    path = "ScrollView/View",
    name = "scrollView",
    type = UIBaseContainer
  },
  {
    path = "ScrollView/View/Content",
    name = "scrollContent",
    type = UIBaseContainer
  },
  {
    path = "ScrollView/View/Content/Page_1",
    name = "page1",
    type = UIMainChatItemCell
  },
  {
    path = "ScrollView/View/Content/Page_2",
    name = "page2",
    type = UIMainChatItemCell
  },
  {
    path = "ScrollView/View/Content/Page_3",
    name = "page3",
    type = UIMainChatItemCell
  },
  {
    path = "PrivateBubble",
    name = "bubble",
    type = UIButton,
    active = false,
    onClick = function(self)
      self:OnChatBubbleClick()
    end
  },
  {
    path = "RedPacketBubble",
    name = "redPacketBubble",
    type = UIButton,
    active = false,
    onClick = function(self)
      self:OnClick(false, self.chatData.roomId)
    end
  },
  {
    path = "PrivateBubble/ChatHead",
    name = "bubbleHead",
    type = UIChatHead
  },
  {
    path = "PrivateBubble/groupHeadCom",
    name = "groupHead",
    type = GroupHead
  },
  {
    path = "PrivateBubble/icon",
    name = "bubbleIcon",
    type = UIImage
  }
}

function UIMainChatItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.curRoomId = nil
  self.roomIdArr = nil
  self.tipKeyArr = nil
  self.latestPrivateChat = nil
  self.chatData = nil
  self.curPageIndex = 1
end

function UIMainChatItem:OnDestroy()
  if self.showPrivateBubbleSequence ~= nil then
    self.showPrivateBubbleSequence:Kill()
    self.showPrivateBubbleSequence = nil
  end
  self:ComponentDestroy()
  self.curRoomId = nil
  self.roomIdArr = nil
  self.tipKeyArr = nil
  self.latestPrivateChat = nil
  if self.sizeChangeTimer then
    self.sizeChangeTimer:Stop()
    self.sizeChangeTimer = nil
  end
  base.OnDestroy(self)
end

function UIMainChatItem:OnEnable()
  base.OnEnable(self)
  self:AddUIListener(ChatEventEnum.CHAT_REFRESH_CHANNEL, self.UpdateRoomState)
  self:AddUIListener(ChatEventEnum.CHAT_INIT_PULL_DONE, self.OnInitPullDone)
  self:AddUIListener(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, self.OnReceiveChatMessage)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnChatMsgUpdate)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_SEL, self.SetCurRoomId)
  self:AddUIListener(ChatEventEnum.CHAT_UNREAD_UPDATE, self.OnChatUnReadUpdate)
  self:AddUIListener(EventId.UpdateAIHelpUnreadCount, self.CheckBubbleState)
  self:AddUIListener(EventId.OnNewsReadStateChanged, self.OnUpdateNews)
  self:AddUIListener(EventId.OnPushNewNews, self.OnReceiveNews)
  self:AddUIListener(EventId.APP_APPLICATION_PAUSE, self.OnApplicationPause)
  self:AddUIListener(EventId.GF_window_opened, self.OnWindowOpened)
  self:AddUIListener(EventId.RefreshBargainShopMessageSetting, self.RefreshEntries)
  self:AddUIListener(EventId.GF_window_closed, self.OnWindowClosed)
  self:AddUIListener(ChatEventEnum.CHAT_PRIVATE_ROOMLAST_UPDATE, self.RefreshPrivateList)
  self:AddUIListener(ChatEventEnum.CHAT_DEL_MSG, self.OnChatDelMsg)
  self:AddUIListener(EventId.SCREEN_SIZE_CHANGE, self.OnScreenSizeChange)
  self:AddUIListener(EventId.CHAT_REFRESH_VIEW, self.RefreshEntries)
  self:AddUIListener(EventId.ChatUserInfoUpdate, self.RefreshEntries)
  self:AddUIListener(EventId.CHAT_ROOM_REDDONT_UPDATE, self.RefreshReddot)
  self:AddUIListener(EventId.CHAT_MOMENT_NOTICE_REDDOT, self.UpdateMomentRed)
  self:AddUIListener(EventId.CHAT_RECEIVE_AT_SEQ_ID, self.CheckBubbleState)
  self:AddUIListener(EventId.ChatGetChatMsgReadOnlyMsg, self.RefreshEntries)
  self:AddUIListener(EventId.FireworkUpdateBubbleState, self.CheckBubbleState)
  self:AddUIListener(EventId.CHAT_BLOCK_ADD, self.OnBlockStateChange)
  self:AddUIListener(EventId.CHAT_BLOCK_REMOVE, self.OnBlockStateChange)
  self:AddUIListener(EventId.CHAT_REQUEST_HISTORY_MSG_RESULT, self.UpdateChatPageView)
  self:AddUIListener(EventId.CHAT_NEWSCENTER_INIT, self.OnNewsCenterUpdate)
  self:AddUIListener(EventId.CHAT_NEWSCENTER_ADDPUSH, self.OnNewsCenterUpdate)
  self:AddUIListener(EventId.CHAT_NEWSCENTER_BUBBLESTATE_UPDATA, self.OnNewsCenterUpdate)
  self:AddUIListener(EventId.AllianceCongratulationListNew, self.OnAllianceCongratulationUpdate)
  self:RefreshEntries()
  self:RefreshReddot()
end

function UIMainChatItem:OnBlockStateChange()
  self:RefreshEntries()
end

function UIMainChatItem:UpdateMomentRed(redType)
  if redType ~= MomentPushType.NoticeComment then
    return
  end
  self:RefreshReddot()
end

function UIMainChatItem:OnNewsCenterUpdate()
  if self.lastBubble and self.lastBubble.type == BubbleType.NewsCenter then
    self:HideBubble()
  end
  if not self.lastBubble then
    local bubbleInfo = self.view.ctrl:GetNonChatBubble()
    if bubbleInfo then
      self.lastBubble = bubbleInfo
      self:ShowBubble(bubbleInfo)
    end
  end
end

function UIMainChatItem:OnAllianceCongratulationUpdate()
  if self.lastBubble and self.lastBubble.type == BubbleType.NewThumpsUp then
    self:HideBubble()
  end
  if not self.lastBubble then
    local bubbleInfo = self.view.ctrl:GetNonChatBubble()
    if bubbleInfo then
      self.lastBubble = bubbleInfo
      self:ShowBubble(bubbleInfo)
    end
  end
end

function UIMainChatItem:OnChatDelMsg(serverData)
  local index, page
  local delSeqIdDict = {}
  if serverData.seqId then
    delSeqIdDict[serverData.seqId] = true
  elseif serverData.seqIds then
    local delSeqIdsStr = serverData.seqIds
    local delSeqIds = rapidjson.decode(delSeqIdsStr)
    for i, seqId in ipairs(delSeqIds) do
      delSeqIdDict[seqId] = true
    end
  end
  for i = 1, 3 do
    page = self["page" .. i]
    if page and page.GetDataById and page:GetDataByIdDict(serverData.roomid, delSeqIdDict) then
      index = i
    end
  end
  if index then
    self:RefreshEntries()
  end
end

function UIMainChatItem:OnDisable()
  self:RemoveUIListener(ChatEventEnum.CHAT_REFRESH_CHANNEL, self.UpdateRoomState)
  self:RemoveUIListener(ChatEventEnum.CHAT_INIT_PULL_DONE, self.OnInitPullDone)
  self:RemoveUIListener(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, self.OnReceiveChatMessage)
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_SEL, self.SetCurRoomId)
  self:RemoveUIListener(ChatEventEnum.CHAT_UNREAD_UPDATE, self.OnChatUnReadUpdate)
  self:RemoveUIListener(EventId.OnNewsReadStateChanged, self.OnUpdateNews)
  self:RemoveUIListener(EventId.OnPushNewNews, self.OnReceiveNews)
  self:RemoveUIListener(EventId.APP_APPLICATION_PAUSE, self.OnApplicationPause)
  self:RemoveUIListener(EventId.GF_window_opened, self.OnWindowOpened)
  self:RemoveUIListener(EventId.GF_window_closed, self.OnWindowClosed)
  self:RemoveUIListener(EventId.RefreshBargainShopMessageSetting, self.RefreshEntries)
  self:RemoveUIListener(ChatEventEnum.CHAT_PRIVATE_ROOMLAST_UPDATE, self.RefreshPrivateList)
  self:RemoveUIListener(ChatEventEnum.CHAT_DEL_MSG, self.OnChatDelMsg)
  self:RemoveUIListener(EventId.SCREEN_SIZE_CHANGE, self.OnScreenSizeChange)
  self:RemoveUIListener(EventId.CHAT_REFRESH_VIEW, self.RefreshEntries)
  self:RemoveUIListener(EventId.ChatUserInfoUpdate, self.RefreshEntries)
  self:RemoveUIListener(EventId.CHAT_ROOM_REDDONT_UPDATE, self.RefreshReddot)
  self:RemoveUIListener(EventId.CHAT_RECEIVE_AT_SEQ_ID, self.CheckBubbleState)
  self:RemoveUIListener(EventId.ChatGetChatMsgReadOnlyMsg, self.RefreshEntries)
  self:RemoveUIListener(EventId.FireworkUpdateBubbleState, self.CheckBubbleState)
  self:RemoveUIListener(EventId.CHAT_BLOCK_ADD, self.OnBlockStateChange)
  self:RemoveUIListener(EventId.CHAT_BLOCK_REMOVE, self.OnBlockStateChange)
  self:RemoveUIListener(EventId.CHAT_REQUEST_HISTORY_MSG_RESULT, self.UpdateChatPageView)
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnChatMsgUpdate)
  self:RemoveUIListener(EventId.UpdateAIHelpUnreadCount, self.CheckBubbleState)
  self:RemoveUIListener(EventId.CHAT_NEWSCENTER_INIT, self.OnNewsCenterUpdate)
  self:RemoveUIListener(EventId.CHAT_NEWSCENTER_ADDPUSH, self.OnNewsCenterUpdate)
  self:RemoveUIListener(EventId.CHAT_NEWSCENTER_BUBBLESTATE_UPDATA, self.OnNewsCenterUpdate)
  self:RemoveUIListener(EventId.AllianceCongratulationListNew, self.OnAllianceCongratulationUpdate)
  base.OnDisable(self)
end

function UIMainChatItem:RefreshPrivateList()
  self:RefreshReddot(true)
end

function UIMainChatItem:UpdateRoomState()
  self:UpdateChatPageView()
  self:RefreshReddot()
  self:CheckBubbleState()
end

function UIMainChatItem:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.scroll:SetPageChangedCallback(BindCallback(self, self.OnUpdateScroll))
  local effect = self.transform:Find("PushNewsVFX")
  if effect then
    self.vfxNews = effect:GetComponent(typeof(CS.UnityEngine.ParticleSystem))
  end
  self.scroll:SetOnClick(function()
    self:OnClick()
  end)
end

function UIMainChatItem:ComponentDestroy()
  self:ClearCompsByBook(compBook)
  self.vfxNews = nil
end

function UIMainChatItem:ReInit(isSkipPrivateBubble)
  if ChatInterface.getRoomMgr():IsInitRoomDone() then
    self:UpdateChatPageView()
  end
  if DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_Chat) then
    ChatInterface.SetEmojiTextProperty(self.lblNews)
    self.page1:InitEmojiText()
    self.page2:InitEmojiText()
    self.page3:InitEmojiText()
  end
  self:RefreshReddot(not isSkipPrivateBubble)
  self:OnUpdateNews()
end

function UIMainChatItem:ReInit_Desert()
  self.disablePrivateBubble = true
  local desertRoomId = ChatInterface.getRoomMgr():GetDragonServerSelfRoomId()
  if ChatInterface.getRoomMgr():IsExistRoomId(desertRoomId) then
    self.curRoomId = desertRoomId
    self:UpdateChatPageView()
  end
  self:RefreshReddot(true)
end

local function __GetTextColor(textColorSelfAlliance)
  if textColorSelfAlliance == true then
    return ChatColorAlliance
  end
  return ChatColorNormal
end

local function __CreateEntry_GMEmpty()
  local param = {}
  param.uid = ChatGMUserId
  param.name = Localization:GetString("290046", Localization:GetString("100619"))
  param.head = ChatGMUserIcon
  param.headPicVer = 0
  param.sign = ""
  return param
end

local function __CreateEntry_Empty(channelName, roomId)
  local param = {}
  param.uid = LuaEntry.Player:GetUid()
  param.name = Localization:GetString("290046", channelName)
  param.head = LuaEntry.Player:GetPic()
  param.headPicVer = LuaEntry.Player.picVer
  param.sign = ""
  param.isEmpty = true
  if roomId == ChatGMRoomId then
    param.uid = ChatGMUserId
    param.head = ChatGMUserIcon
    param.headPicVer = 0
  end
  return param
end

local function __CreateEntry_Chat(roomId, chatData)
  local _senderUid = chatData.senderUid
  local _userinfo = ChatInterface.getUserData(_senderUid)
  local name = _userinfo:GetUserName()
  if name == _userinfo.uid then
    name = " "
  end
  if chatData:isFromAI() then
    name = chatData:getSenderName()
  end
  local param = {}
  param.uid = _userinfo.uid
  param.textColorSelfAlliance = false
  param.name = name
  param.des = chatData:getMessageWithExtra(false)
  if chatData.post == PostType.Text_AllianceNotice and string.IsNullOrEmpty(param.des) then
    local isHavePicVer = chatData:IsNoticeHavePicListData()
    if isHavePicVer then
      param.des = Localization:GetString("picture_msg_preview")
    else
      param.des = ""
    end
  end
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if allianceData ~= nil and _userinfo.allianceSimpleName == allianceData.abbr and allianceData.abbr ~= "" then
    param.textColorSelfAlliance = true
  end
  param.shareData = chatData:getMessageParam(false)
  param.roomId = chatData.roomId
  param.seqId = chatData.seqId
  local head = _userinfo.headPic or ""
  if _userinfo:IsGmUser() then
    head = _userinfo:GetGMIcon()
  end
  param.head = head
  param.headPicVer = _userinfo.headPicVer or 0
  param.time = chatData.serverTime
  param.sign = chatData.senderUid .. chatData.msg .. math.ceil(param.time / 10000)
  return param
end

local function __CreateThreeEntries(roomId)
  local data1, data2, data3
  if roomId == nil or roomId == "" then
    return data1, data2, data3
  end
  local lastThreeMsg = ChatInterface.getRoomMgr():GetLastChatMsgs(roomId, 3)
  if not lastThreeMsg or #lastThreeMsg <= 0 then
    if roomId == ChatGMRoomId then
      data1 = __CreateEntry_GMEmpty()
    else
      local roomData = ChatInterface.getRoomData(roomId)
      data1 = __CreateEntry_Empty(roomData and roomData:getRoomName() or "")
    end
    return data1, data2, data3
  else
    if lastThreeMsg[1] then
      data1 = __CreateEntry_Chat(roomId, lastThreeMsg[1])
    end
    if lastThreeMsg[2] then
      data2 = __CreateEntry_Chat(roomId, lastThreeMsg[2])
    end
    if lastThreeMsg[3] then
      data3 = __CreateEntry_Chat(roomId, lastThreeMsg[3])
    end
  end
  return data1, data2, data3
end

function UIMainChatItem:SetCurRoomId(roomId)
  if self.roomIdArr and table.indexof(self.roomIdArr, roomId) then
    self.curRoomId = roomId
    self:SyncPageByCurRoomId()
  end
end

local __PAGE_GROUP_ID_GETTERS = {
  {
    "GetCountryRoomId"
  },
  {
    "GetAllianceRoomId"
  }
}
local __PAGE_GROUP_ID_GETTERS_BATTLEFIELD = {
  {
    "GetBattlefieldRoomId",
    "GetCountryRoomId"
  },
  {
    "GetAllianceRoomId"
  }
}
local OLD__PAGE_GROUP_ID_GETTERS = {
  {
    "GetCountryRoomId"
  },
  {
    "GetAllianceRoomId"
  },
  {
    "GetDragonServerSelfRoomId",
    "GetCrossServerRoomId"
  }
}
local __PAGE_GROUP_TIP_KEY = {
  100171,
  393081,
  2010117
}

function UIMainChatItem:UpdateChatPageView()
  self.roomIdArr = {}
  self.tipKeyArr = {}
  local page = __PAGE_GROUP_ID_GETTERS
  if BattleFieldUtil.InBattleField() then
    page = __PAGE_GROUP_ID_GETTERS_BATTLEFIELD
  end
  for i, group in ipairs(page) do
    for _, getter in ipairs(group) do
      local roomId = ChatInterface.getRoomMgr()[getter](ChatInterface.getRoomMgr())
      if ChatInterface.getRoomMgr():IsExistRoomId(roomId) then
        table.insert(self.roomIdArr, roomId)
        table.insert(self.tipKeyArr, __PAGE_GROUP_TIP_KEY[i])
        break
      end
    end
  end
  if not self.curRoomId or not table.indexof(self.roomIdArr, self.curRoomId) then
    self.curRoomId = self.roomIdArr[1]
  end
  local ScreenSize = self.view.rectTransform.rect
  local pageCnt = math.min(3, #self.roomIdArr)
  local pageWidth = ScreenSize.width - 350
  self.pageRoot:SetActive(1 < pageCnt)
  self.pageRoot:SetSizeDelta(Vector2.New(4 + 32 * pageCnt, 12))
  self.scrollContent:SetSizeDelta(Vector2.New(pageWidth * pageCnt, 130))
  self.page1:SetSizeDeltaXY(pageWidth, 130)
  self.page2:SetSizeDeltaXY(pageWidth, 130)
  self.page3:SetSizeDeltaXY(pageWidth, 130)
  self.page1:SetActive(1 <= pageCnt)
  self.page2:SetActive(2 <= pageCnt)
  self.page3:SetActive(3 <= pageCnt)
  self.scroll:SetPageCount(pageCnt)
  self:SyncPageByCurRoomId()
  self:RefreshEntries()
end

function UIMainChatItem:SyncPageByCurRoomId()
  if not self.roomIdArr or not self.curRoomId then
    return
  end
  self.atInitChatChannel = true
  for i, roomId in ipairs(self.roomIdArr) do
    if self.curRoomId == roomId then
      local offset = #self.roomIdArr == 3 and -50 or -34
      self.pageHint:SetLocalPositionXYZ(2 + offset + 32 * (i - 1), 0, 0)
      self.scroll:PageTo(i)
    end
  end
  self.atInitChatChannel = false
end

function UIMainChatItem:ShowBubbleAnimation(common)
  local sequence = CS.DG.Tweening.DOTween.Sequence()
  sequence:Append(common.transform:DORotate(Vector3.New(0, 0, -6), 0.04):SetEase(CS.DG.Tweening.Ease.InQuad))
  sequence:Append(common.transform:DORotate(Vector3.New(0, 0, 6), 0.08):SetEase(CS.DG.Tweening.Ease.Linear))
  sequence:Append(common.transform:DORotate(Vector3.New(0, 0, -3), 0.08):SetEase(CS.DG.Tweening.Ease.Linear))
  sequence:Append(common.transform:DORotate(Vector3.New(0, 0, 3), 0.08):SetEase(CS.DG.Tweening.Ease.Linear))
  sequence:Append(common.transform:DORotate(Vector3.New(0, 0, 0), 0.04):SetEase(CS.DG.Tweening.Ease.OutQuad))
  sequence:AppendInterval(3)
  sequence:SetLoops(-1)
end

function UIMainChatItem:RefreshEntriesByRoomId(targetRoomId)
  if not self.roomIdArr then
    return
  end
  for idx, roomId in ipairs(self.roomIdArr) do
    if targetRoomId == nil or targetRoomId == roomId then
      self:RefreshEntry(idx, roomId)
    end
  end
end

function UIMainChatItem:RefreshEntries()
  if not self.roomIdArr then
    return
  end
  for idx, roomId in ipairs(self.roomIdArr) do
    self:RefreshEntry(idx, roomId)
  end
end

function UIMainChatItem:RefreshEntry(idx, roomId)
  local chat1, chat2, chat3 = __CreateThreeEntries(roomId)
  if roomId == ChatInterface.getRoomMgr():GetAllianceRoomId() and not ChatInterface.getRoomMgr():IsExistRoomId(roomId) then
    chat1 = {
      name = Localization:GetString("2700020"),
      des = "",
      uid = nil
    }
  end
  local page = self["page" .. idx]
  if page then
    if chat1 then
      local showName1 = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(chat1.uid, chat1.name)
      page:SetChatTextAndColor(3, showName1, chat1.des, __GetTextColor(chat1.textColorSelfAlliance), chat1)
    else
      page:SetChatTextAndColor(3, "", "")
    end
    if chat2 then
      local showName2 = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(chat2.uid, chat2.name)
      page:SetChatTextAndColor(2, showName2, chat2.des, __GetTextColor(chat2.textColorSelfAlliance), chat2)
    else
      page:SetChatTextAndColor(2, "", "")
    end
    if chat3 then
      local showName3 = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(chat3.uid, chat3.name)
      page:SetChatTextAndColor(1, showName3, chat3.des, __GetTextColor(chat3.textColorSelfAlliance), chat3)
    else
      page:SetChatTextAndColor(1, "", "")
    end
  end
end

function UIMainChatItem:InitBubble()
  local result = self.view.ctrl.GetShowBubbleInfo()
  if result.bubbleInfo then
    self.lastBubble = result.bubbleInfo
    self:ShowBubble(result.bubbleInfo)
  end
end

function UIMainChatItem:OnChatUnReadUpdate(chatRoomData)
  self:RefreshReddot()
  if not chatRoomData or not self.lastBubble then
    return
  end
  if self.lastBubble.chatData then
    local roomId = self.lastBubble.chatData.roomId
    if roomId == chatRoomData.roomId then
      self:CheckBubbleState()
    end
  end
end

function UIMainChatItem:RefreshReddot(showPrivateBubble)
  local result = ChatInterface.getRoomMgr():GetAllRoomNewMsgCount()
  local commentCount = ChatInterface.getMoment():GetRedDot(MomentPushType.NoticeComment) or 0
  if 0 < commentCount and ChatInterface.getMoment():GetMomentIsOpen() then
    result.redType = UnreadNotificationType.ShowUnreadCount
    result.showNumber = (result.showNumber or 0) + commentCount
  end
  self.reddot:SetRedDotType(result.redType)
  self.reddot:SetNumber(result.showNumber, 99, 0 >= result.total)
  self.reddot:SetRussianPosition()
  if 0 < result.showNumber then
    self.reddot:SetLocalScaleXYZ(1, 1, 1)
  else
    self.reddot:SetLocalScaleXYZ(0.75, 0.75, 1)
  end
  if showPrivateBubble == true then
    if result.latestPrivateMsg then
      self.latestPrivateChat = result.latestPrivateMsg
    elseif result.lastPrivateRoom and not result.lastPrivateRoom:GetMsgSuccess() then
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.Roomlast, {
        result.lastPrivateRoom.roomId
      })
    end
  end
end

function UIMainChatItem:OnClick()
  if LuaEntry.Player.renameTime < 1 then
    local isOpen = Setting:GetPrivateInt(SettingKeys.IS_RENAME_OPEN_IN_CHAT, 0)
    if isOpen < 1 then
      Setting:SetPrivateInt(SettingKeys.IS_RENAME_OPEN_IN_CHAT, 1)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFirstChangeInfo, {anim = true}, {
        window = "mainchat",
        callback = {
          caller = self,
          func = self.OnClick
        }
      })
      return
    end
  end
  if self.curRoomId == "temp_alliance_room_id" and not LuaEntry.Player:IsInAlliance() then
    if LuaEntry.Player:IsFirstJoinAlliance() == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
    end
    return
  end
  if self.curRoomId then
    GoToUtil.OpenChatView(true, {anim = false, immediately = true}, {
      roomId = self.curRoomId,
      scrollToActive = true
    })
  else
    Logger.LogInfo("Chat server not connected yet. No default room ID available.")
  end
end

function UIMainChatItem:OnChatBubbleClick()
  if not self.lastBubble then
    return
  end
  local gotoRoomId
  if self.lastBubble.chatData then
    gotoRoomId = self.lastBubble.chatData.roomId
  end
  if self.lastBubble.type == BubbleType.Private then
    if self.lastBubble.chatData then
      local param = {
        roomId = gotoRoomId,
        userId = self.lastBubble.chatData.senderUid,
        username = self.lastBubble.chatData.senderName
      }
      GoToUtil.OpenChatView(true, {anim = false, immediately = true}, param)
      return
    end
  elseif self.lastBubble.jumpRoom then
    if self.lastBubble.type == BubbleType.At then
      local exist = ChatInterface.getRoomMgr():IsExistRoomId(gotoRoomId)
      if not exist then
        self:CheckBubbleState()
        return
      end
    end
    if self.lastBubble.chatData then
      local param = {
        roomId = gotoRoomId,
        seqId = self.lastBubble.chatData.seqId
      }
      GoToUtil.OpenChatView(true, {anim = false, immediately = true}, param)
      return
    end
  elseif self.lastBubble.type == BubbleType.CustomerService then
    DataCenter.LWCustomerServiceManager:OpenCustomerServiceByVipLevel("2700006", true)
    DataCenter.LWCustomerServiceManager:DoCloseCustomerServiceRedPointData()
  elseif self.lastBubble.type == BubbleType.NewsCenter then
    local guid = DataCenter.LWNewsCenterManager:GetRedNew(ChatNewsCenterTabType.StrategyGuide)
    local cement = DataCenter.LWNewsCenterManager:GetRedNew(ChatNewsCenterTabType.Announcement)
    local openTabType
    if guid and cement or cement then
      openTabType = ChatNewsCenterTabType.Announcement
    elseif guid then
      openTabType = ChatNewsCenterTabType.StrategyGuide
    end
    local param
    if openTabType then
      param = {tabType = openTabType}
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWNewsCenter, {anim = false}, param)
  elseif self.lastBubble.type == BubbleType.NewThumpsUp then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWAllianceCongratulationPopView)
  elseif self.lastBubble.type == BubbleType.FireworkGiftBox or self.lastBubble.type == BubbleType.S0AllianceBoss then
    if self.lastBubble.chatData then
      local chatData = self.lastBubble.chatData
      local extraJson = rapidjson.decode(chatData.extra.customJsonParam)
      local boxUuid = extraJson.uuid
      local ownerUid = extraJson.ownerUid
      local data = {uuid = boxUuid, ownerUid = ownerUid}
      local uids = {}
      if chatData.clientUpdateExtra then
        local tempList = string.split(chatData.clientUpdateExtra, "|")
        for k, v in ipairs(tempList) do
          table.insert(uids, v)
        end
      end
      local fireworkBoxMaxNum = 0
      local fireworkLineData = LocalController:instance():getLine(TableName.Firework, extraJson.configId)
      if fireworkLineData then
        local rewardListStr = fireworkLineData.reward
        local rewardList = string.split(rewardListStr, "|")
        extraJson.index = extraJson.index or 0
        local boxDataStr = rewardList[extraJson.index + 1]
        if boxDataStr then
          local boxDataList = string.split(boxDataStr, ";")
          if 3 <= #boxDataList then
            fireworkBoxMaxNum = tonumber(boxDataList[3])
          end
        end
        local isAllTaken = fireworkBoxMaxNum <= #uids
        if not isAllTaken then
          SFSNetwork.SendMessage(MsgDefines.FindFireworksGiftWorldPoint, data)
        else
          UIUtil.ShowTipsId("firework_tips_1015")
        end
      end
      DataCenter.LWFireworkGiftManager:SetBubbleTipViewedPrefs(ownerUid)
      EventManager:GetInstance():Broadcast(EventId.FireworkUpdateBubbleState)
    end
  elseif gotoRoomId then
    GoToUtil.OpenChatView(true, {anim = false, immediately = true}, {roomId = gotoRoomId})
  end
end

function UIMainChatItem:OnUpdateScroll(index)
  self.curPageIndex = index
  if #self.roomIdArr == 3 then
    self.pageHint.transform:DOLocalMoveX((2 + index * 32 - 50 - 32) * CommonUtil.ArabicAutoMirrorFactor(), 0.1):SetEase(CS.DG.Tweening.Ease.InOutCubic)
  elseif #self.roomIdArr == 2 then
    self.pageHint.transform:DOLocalMoveX((2 + index * 32 - 34 - 32) * CommonUtil.ArabicAutoMirrorFactor(), 0.1):SetEase(CS.DG.Tweening.Ease.InOutCubic)
  end
  if self.atInitChatChannel == true then
    return
  end
  local activeRoomId = self.roomIdArr[index]
  self.pageSwitchTipTxt:SetLocalText(self.tipKeyArr[index])
  if self.showPrivateBubbleSequence ~= nil then
    self.showPrivateBubbleSequence:Kill()
  end
  self.pageSwitchTip:SetLocalScaleXYZ(0, 0, 0)
  self.pageSwitchTip:SetAlpha(0)
  self.pageSwitchTip:SetActive(true)
  local sequence = CS.DG.Tweening.DOTween.Sequence()
  sequence:Join(self.pageSwitchTip.transform:DOScale(Vector3.New(1, 1, 1), 0.5))
  sequence:Join(self.pageSwitchTip:FadeIn(0, 0.2))
  sequence:AppendInterval(1)
  sequence:AppendCallback(function()
    self.pageSwitchTip:FadeOut(0, 0.2)
  end)
  self.showPrivateBubbleSequence = sequence
  self:SetCurRoomId(activeRoomId)
end

function UIMainChatItem:OnApplicationPause(isPaused)
  if not isPaused and self.scroll then
    self.scroll.isInDrag = false
    self.scroll:PageToAndCallback(self.curPageIndex or 1)
  end
end

function UIMainChatItem:OnInitPullDone()
  self:RefreshEntries()
  self:InitBubble()
  self:RefreshReddot(true)
end

function UIMainChatItem:ShowBubble(bubbleInfo)
  self.bubble:SetActive(true)
  if bubbleInfo.type == BubbleType.Private then
    local senderInfo = ChatInterface.getUserMgr():getChatUserInfo(bubbleInfo.chatData.senderUid, false)
    self.bubbleHead:UpdateHead(senderInfo, bubbleInfo.chatData)
    self.bubbleIcon:SetActive(false)
    self.groupHead:SetActive(false)
    self.bubbleHead:SetActive(true)
  elseif bubbleInfo.type == BubbleType.GroupChat then
    self.bubbleIcon:SetActive(false)
    self.bubbleHead:SetActive(false)
    self.groupHead:SetActive(true)
    local room = ChatInterface.getRoomData(bubbleInfo.chatData.roomId)
    if room then
      self.groupHead:UpdateGroupHeadList(room.memberList)
    end
  else
    self.bubbleHead:SetActive(false)
    self.groupHead:SetActive(false)
    self.bubbleIcon:SetActive(true)
    self.bubbleIcon:LoadSpriteAsyncWithCallback(bubbleInfo.iconPath, function()
      if bubbleInfo.size then
        self.bubbleIcon:SetSizeDelta(bubbleInfo.size)
      else
        self.bubbleIcon:SetNativeSize()
      end
    end)
  end
  if self.showPrivateBubbleSequence ~= nil then
    self.showPrivateBubbleSequence:Kill()
  end
  self.bubble:SetEulerAnglesXYZ(0, 0, 0)
  self.showPrivateBubbleSequence = self:ShowBubbleAnimation(self.bubble)
end

function UIMainChatItem:OnChatMsgUpdate(chatData)
  if chatData.post == PostType.Text_PointShare_Alliance then
    self:CheckBubbleState()
  end
end

function UIMainChatItem:CheckBubbleState()
  local result = self.view.ctrl.GetShowBubbleInfo()
  if result.bubbleInfo then
    self.lastBubble = result.bubbleInfo
    self:ShowBubble(result.bubbleInfo)
  else
    self:HideBubble()
  end
end

function UIMainChatItem:HideBubble()
  if self.showPrivateBubbleSequence ~= nil then
    self.showPrivateBubbleSequence:Kill()
    self.showPrivateBubbleSequence = nil
  end
  if self.checkTimer ~= nil then
    self.checkTimer:Stop()
    self.checkTimer = nil
  end
  self.latestPrivateChat = nil
  self.bubble:SetActive(false)
  self.lastBubble = nil
  self.pageSwitchTip:SetAlpha(0)
end

function UIMainChatItem:OnReceiveChatMessage(chatData)
  if not chatData then
    return
  end
  if table.indexof(POST_TYPE_BLACK_LIST, chatData.post) then
    return
  end
  if not ChatManager2:GetInstance().Restrict:GetMsgIsCanShow(chatData) then
    return
  end
  self.chatData = chatData
  local bubble = self.view.ctrl.GetChatBubble(chatData)
  if bubble and self.lastBubble and self.lastBubble.sort and bubble.sort and self.lastBubble.sort > bubble.sort then
    return
  end
  if bubble then
    bubble.chatData = chatData
    self.lastBubble = bubble
    self:ShowBubble(bubble)
  end
  self:RefreshEntriesByRoomId(chatData.roomId)
  self:RefreshReddot()
end

function UIMainChatItem:OnUpdateNews()
  local firstUnreadNews = DataCenter.LWNewsCenterManager:GetFirstUnreadNews()
  if firstUnreadNews then
    self:OnReceiveNews(firstUnreadNews)
  else
    self.lblNews:SetText("")
    self.scrollView.transform.offsetMax = Vector2.New(0, 0)
  end
end

function UIMainChatItem:OnReceiveNews(newsInfo)
  if newsInfo then
    if newsInfo.smallType == NewsSubType.PERSONAL_BATTLE then
      self.lblNews:SetText(Localization:GetString(801041) .. Localization:GetString("800903"))
    elseif newsInfo.smallType == NewsSubType.ALLIANCE_BATTLE then
      self.lblNews:SetText(Localization:GetString(801041) .. Localization:GetString("800904"))
    elseif newsInfo.smallType == NewsSubType.ALLIANCE_ATK_ALLIANCE_CITY then
      self.lblNews:SetText(Localization:GetString(801041) .. Localization:GetString("800905"))
    elseif newsInfo.smallType == NewsSubType.APPOINT_OFFICAL then
      self.lblNews:SetText(Localization:GetString(801041) .. Localization:GetString("800906"))
    elseif newsInfo.smallType == NewsSubType.CROSS_SERVER_BATTLE then
    elseif newsInfo.smallType == NewsSubType.CROSS_PLUNDER_KINGDOM then
    elseif newsInfo.smallType == NewsSubType.CROSS_AREA_BATTLE then
    elseif newsInfo.smallType == NewsSubType.TRAIN_ROB then
    elseif newsInfo.smallType == NewsSubType.ARENA_CHAMPION then
      self.lblNews:SetText(Localization:GetString(801041) .. Localization:GetString("800938"))
    end
    if self.vfxNews then
      self.vfxNews:Play()
    end
    self.scrollView.transform.offsetMax = Vector2.New(0, -68)
  end
end

function UIMainChatItem:OnWindowOpened(windowName)
  if windowName == UIWindowNames.UIChatNew_v2 then
    self:HideBubble()
  end
end

function UIMainChatItem:OnWindowClosed(windowName)
  if windowName == UIWindowNames.UIChatNew_v2 then
    local bubbleInfo = self.view.ctrl:GetNonChatBubble()
    if bubbleInfo then
      self.lastBubble = bubbleInfo
      self:ShowBubble(bubbleInfo)
    else
      self:HideBubble()
    end
  end
end

function UIMainChatItem:OnScreenSizeChange()
  if self.sizeChangeTimer then
    self.sizeChangeTimer:Stop()
    self.sizeChangeTimer = nil
  end
  self.sizeChangeTimer = TimerManager:GetInstance():DelayFrameInvoke(function()
    self:UpdateChatPageView()
  end, 0.2)
end

return UIMainChatItem
