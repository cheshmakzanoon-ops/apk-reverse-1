local UIMainChatItem = BaseClass("UIMainChatItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIMainChatItemCell = require("UI.LWMainUI.Component.UIMainBottom.UIMainChatItemCell")
local UIAdaptReddot = require("UI.UICommon.Component.UIAdaptReddot")
local lastActiveRoomId = ""
local chat_go_path = "ChatBg"
local chat_unread_path = "ChatBg/AdaptReddot"
local btn_path = ""
local chat_npc_icon_path = "ChatBg/ChatNpcBg/ChatNpcIcon"
local radarAlarm_npc_icon_path = "AlarmBg/AlarmNpcBg/AlarmNpcIcon"
local red_packet_bg_path = "UIRedenvelope"
local red_packet_content1_txt_path = "UIRedenvelope/Bg2/Txt_Contente1"
local red_packet_content2_txt_path = "UIRedenvelope/Bg2/Txt_Contente2"
local red_packet_icon_path = "UIRedenvelope/RecPacketBg/RecPacketIcon"
local al_task_share_path = "AlTaskShare"
local al_task_share_txt_path = "AlTaskShare/Bg2/taskName"
local al_task_share_prog_path = "AlTaskShare/Progress"
local al_task_share_progTxt_path = "AlTaskShare/Progress/Txt_Progress"
local al_task_share_head_path = "AlTaskShare/AlarmNpcBg/sharePlayerIcon"
local alarm_go_path = "AlarmBg"
local alarm_text_path = "AlarmBg/Bg2/AlarmText"
local chatAnim_path = "ChatBg"
local chatShowEff_path = "ChatBg/VFX_ui_renwutishi_03"
local alarmAnim_path = "AlarmBg"
local page_path = "ChatBg/Bg1/Page"
local page_hint_path = "ChatBg/Bg1/Page/PageHint"
local switch_tip_path = "ChatBg/Bg1/Page/PageHint/switch_tip"
local switch_txt_path = "ChatBg/Bg1/Page/PageHint/switch_tip/content/txt"
local msg_tip_path = "ChatBg/Bg1/Page/msg_tip"
local msg_tip_txt_path = "ChatBg/Bg1/Page/msg_tip/content/msg_tip_txt"
local news_path = "ChatBg/Bg1/NewsLabel"
local news_vfx_path = "ChatBg/Bg1/PushNewsVFX"
local ChatTextIndex = {
  ChatTextIndex_1 = 1,
  ChatTextIndex_2 = 2,
  ChatTextIndex_3 = 3
}

function UIMainChatItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainChatItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMainChatItem:OnEnable()
  base.OnEnable(self)
  local ChatEventEnum = _ENV.ChatEventEnum
  self:AddUIListener(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, self.OnReceiveChatMessage)
  self:AddUIListener(ChatEventEnum.CHAT_INIT_PULL_DONE, self.RefreshChatSignal)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_SEL, self.RefreshChatSignal)
  self:AddUIListener(ChatEventEnum.CHAT_REFRESH_CHANNEL, self.onRoomQuit)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_DISMISS, self.onRoomQuit)
  self:AddUIListener(ChatEventEnum.QUIT_ROOM_COMMAND, self.onRoomQuit)
  self:AddUIListener(EventId.OnGetNewAllianceAutoInvite, self.RefreshChatSignal)
  self:AddUIListener(EventId.RefreshGuide, self.OnGuideShow)
  self:AddUIListener(EventId.CloseChatView, self.OnCloseChatView)
  self:AddUIListener(EventId.UPDATE_MSG_USERINFO, self.OnUserInfoUpdate)
  self:AddUIListener(EventId.LOAD_COMPLETE, self.OnEnterScene)
  self:AddUIListener(EventId.AllianceQuitOK, self.AllianceQuit)
  self:AddUIListener(EventId.OnNewsReadStateChanged, self.OnUpdateNewsMessage)
  self:AddUIListener(EventId.OnPushNewNews, self.OnReceiveNewsMessage)
  self:AddUIListener(EventId.ChatRoomActiveTimeUpdate, self.RefreshReddot)
  self:AddUIListener(EventId.APP_APPLICATION_PAUSE, self.OnApplicationPause)
  if DataCenter.GuideManager:InGuide() == true then
    self:RefreshState()
    self:RefreshShow()
  end
end

function UIMainChatItem:OnDisable()
  local ChatEventEnum = _ENV.ChatEventEnum
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_SEL, self.RefreshChatSignal)
  self:RemoveUIListener(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, self.OnReceiveChatMessage)
  self:RemoveUIListener(ChatEventEnum.CHAT_INIT_PULL_DONE, self.RefreshChatSignal)
  self:RemoveUIListener(ChatEventEnum.CHAT_REFRESH_CHANNEL, self.onRoomQuit)
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_DISMISS, self.onRoomQuit)
  self:RemoveUIListener(ChatEventEnum.QUIT_ROOM_COMMAND, self.onRoomQuit)
  self:RemoveUIListener(EventId.OnGetNewAllianceAutoInvite, self.RefreshChatSignal)
  self:RemoveUIListener(EventId.RefreshGuide, self.OnGuideShow)
  self:RemoveUIListener(EventId.CloseChatView, self.OnCloseChatView)
  self:RemoveUIListener(EventId.UPDATE_MSG_USERINFO, self.OnUserInfoUpdate)
  self:RemoveUIListener(EventId.LOAD_COMPLETE, self.OnEnterScene)
  self:RemoveUIListener(EventId.AllianceQuitOK, self.AllianceQuit)
  self:RemoveUIListener(EventId.OnNewsReadStateChanged, self.OnUpdateNewsMessage)
  self:RemoveUIListener(EventId.OnPushNewNews, self.OnReceiveNewsMessage)
  self:RemoveUIListener(EventId.ChatRoomActiveTimeUpdate, self.RefreshReddot)
  self:RemoveUIListener(EventId.APP_APPLICATION_PAUSE, self.OnApplicationPause)
  base.OnDisable(self)
end

function UIMainChatItem:ComponentDefine()
  self.chat_go = self:AddComponent(UIBaseContainer, chat_go_path)
  self.chat_scroll_view = self:AddComponent(UIScrollPage, "ChatBg/Bg1/ScrollView")
  self.chat_scroll_viewport = self:AddComponent(UIBaseContainer, "ChatBg/Bg1/ScrollView/View")
  self.chat_scroll_content = self:AddComponent(UIBaseContainer, "ChatBg/Bg1/ScrollView/View/Content")
  self.chat_World = self:AddComponent(UIMainChatItemCell, "ChatBg/Bg1/ScrollView/View/Content/World")
  self.chat_AL = self:AddComponent(UIMainChatItemCell, "ChatBg/Bg1/ScrollView/View/Content/AL")
  self.chat_Private = self:AddComponent(UIMainChatItemCell, "ChatBg/Bg1/ScrollView/View/Content/Private")
  self.chat_npc_icon = self:AddComponent(UIPlayerHead, chat_npc_icon_path)
  self.radarAlarm_npc = self:AddComponent(UIImage, radarAlarm_npc_icon_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.alarm_go = self:AddComponent(UIBaseContainer, alarm_go_path)
  self.alarm_text = self:AddComponent(UIText, alarm_text_path)
  self.alarmAnimN = self:AddComponent(UIAnimator, alarmAnim_path)
  self.chatAnimN = self:AddComponent(UIAnimator, chatAnim_path)
  self.chatShowEffN = self:AddComponent(UIBaseContainer, chatShowEff_path)
  self.chatShowParticle = self.chatShowEffN.transform:GetComponent(typeof(CS.UnityEngine.ParticleSystem))
  self.chat_unread = self:AddComponent(UIAdaptReddot, chat_unread_path)
  self.chat_unread:SetActive(false)
  self.redPacket_go = self:AddComponent(UIBaseContainer, red_packet_bg_path)
  self.redPacketContent1 = self:AddComponent(UIText, red_packet_content1_txt_path)
  self.redPacketContent2 = self:AddComponent(UIText, red_packet_content2_txt_path)
  self.redPacketHead = self:AddComponent(UIPlayerHead, red_packet_icon_path)
  self.alTaskShare_go = self:AddComponent(UIBaseContainer, al_task_share_path)
  self.alTaskShareTxt = self:AddComponent(UIText, al_task_share_txt_path)
  self.alTaskShareProg = self:AddComponent(UISlider, al_task_share_prog_path)
  self.alTaskShareProgTxt = self:AddComponent(UIText, al_task_share_progTxt_path)
  self.alTaskShareHead = self:AddComponent(UIPlayerHead, al_task_share_head_path)
  self.page_hint_root = self:AddComponent(UIImage, page_path)
  self.page_hint_spr = self:AddComponent(UIImage, page_hint_path)
  self.switch_tip = self:AddComponent(UICanvasGroup, switch_tip_path)
  self.switch_txt = self:AddComponent(UIText, switch_txt_path)
  self.msg_tip = self:AddComponent(UICanvasGroup, msg_tip_path)
  self.msg_tip_txt = self:AddComponent(UIText, msg_tip_txt_path)
  self.news_label = self:AddComponent(UIText, news_path)
  self.news_label:SetText("")
  self.news_vfx = self:AddComponent(UIBaseContainer, news_vfx_path)
  self.news_vfx:SetActive(false)
  self:OnUpdateNewsMessage()
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.chat_scroll_view:SetPageChangedCallback(BindCallback(self, self.OnUpdateScroll))
  self.chat_scroll_view:SetOnClick(function()
    self:OnClick()
  end)
end

function UIMainChatItem:ComponentDestroy()
  self.chat_go = nil
  self.alarm_go = nil
  self.alarm_text = nil
  self.btn = nil
  self.chat_npc_icon = nil
  self.radarAlarm_npc = nil
  self.alTaskShare_go = nil
  self.alTaskShareTxt = nil
  self.alTaskShareProg = nil
  self.alTaskShareProgTxt = nil
  self.alTaskShareHead = nil
end

function UIMainChatItem:DataDefine()
  self.curRoomId = ""
  self.state = nil
  self.ballData = nil
  self.showTextList = {}
  self.firstShow = true
  self.rankChangeLevel2 = LuaEntry.DataConfig:TryGetNum("quest_chat", "k6")
  self.oneChatShowMaxTime = LuaEntry.DataConfig:TryGetNum("quest_chat", "k4") * 1000
  self.initShowAllianceChatTime = LuaEntry.DataConfig:TryGetNum("quest_chat", "k5") * 1000
  self.k7 = LuaEntry.DataConfig:TryGetNum("quest_chat", "k7") * 1000
  self.currentChatSign = ""
  self.quest_early = LuaEntry.DataConfig:CheckSwitch("quest_early")
  self.lastState = nil
end

function UIMainChatItem:DataDestroy()
  self.curRoomId = nil
  self.state = nil
  self.ballData = nil
  self.showTextList = nil
  self.firstShow = nil
  self.currentChatSign = nil
  self.oneChatShowMaxTime = nil
end

function UIMainChatItem:onRoomQuit(roomId)
  if roomId == nil or roomId == "" then
    return
  end
  local room = ChatInterface.getRoomData(roomId)
  if room == nil or room.group == ChatGroupType.GROUP_TMPRoom or room:isCustomRoom() then
    lastActiveRoomId = ""
  end
  if roomId == self.curRoomId then
    self:SetCurRoomId(ChatInterface.getRoomMgr():GetCountryRoomId())
  else
    self:UpdateChatPageView()
  end
end

function UIMainChatItem:GetOneChatShowMaxTime()
  local lv = DataCenter.BuildManager.MainLv
  if lv >= self.rankChangeLevel2 then
    return LongMaxValue
  end
  return self.oneChatShowMaxTime
end

function UIMainChatItem:GetEmptyChatData(channelName, roomId)
  local param = {}
  param.uid = LuaEntry.Player:GetUid()
  param.name = Localization:GetString("290046", channelName)
  param.head = LuaEntry.Player:GetPic()
  param.headPicVer = LuaEntry.Player.picVer
  param.sign = ""
  if roomId == ChatGMRoomId then
    param.uid = ChatGMUserId
    param.head = ChatGMUserIcon
    param.headPicVer = 0
  end
  return param
end

local function _getChatMessage(curRoomId, chatdata)
  local _senderUid = chatdata.senderUid
  local _userinfo = ChatInterface.getUserData(_senderUid)
  local name = _userinfo:GetUserName()
  if chatdata:isFromAI() then
    name = chatdata:getSenderName()
  end
  local param = {}
  param.uid = _userinfo.uid
  param.textColorSelfAlliance = false
  if curRoomId == ChatInterface.getRoomMgr():GetCountryRoomId() and _userinfo.allianceSimpleName ~= nil and _userinfo.allianceSimpleName ~= "" then
    param.name = "[" .. _userinfo.allianceSimpleName .. "] " .. name .. ": "
  else
    param.name = name .. ": "
  end
  local tempDes, msgTb = chatdata:getMessageWithExtra(false)
  param.des = tempDes
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if allianceData ~= nil and _userinfo.allianceSimpleName == allianceData.abbr and allianceData.abbr ~= "" then
    param.textColorSelfAlliance = true
  end
  param.shareData = chatdata:getMessageParam(false)
  local head = _userinfo.headPic or ""
  if _userinfo:IsGmUser() then
    head = _userinfo:GetGMIcon()
  end
  param.head = head
  param.headPicVer = _userinfo.headPicVer or 0
  param.time = chatdata.serverTime
  param.sign = chatdata.senderUid .. chatdata.msg .. math.ceil(param.time / 10000)
  local isRedPcake = false
  if chatdata.extra and chatdata.extra.post and chatdata.extra.post == PostType.RedPackge then
    local redData = DataCenter.AllianceRedPacketManager:GetRedPacketByUUid(chatdata.extra.redPackets)
    if redData and redData.status == RedPacketState.VALID then
      isRedPcake = true
      param.extra = chatdata.extra
    end
  end
  if not chatdata.extra or chatdata.extra.post then
  end
  param.isRedPcaket = isRedPcake
  return param
end

function UIMainChatItem:GetChatDes(theRoomId)
  local data1, data2, data3
  if theRoomId == nil or theRoomId == "" then
    return data1, data2, data3
  end
  local chatmsglist = ChatInterface.getRoomMgr():GetLastChatMsgs(theRoomId, 3)
  if chatmsglist == nil or #chatmsglist == 0 then
    if theRoomId == ChatGMRoomId then
      data1 = self:GetEmptyChatData(Localization:GetString("100619"), ChatGMRoomId)
    else
      local roomData = ChatInterface.getRoomData(theRoomId)
      if roomData then
        local channelName = roomData:getRoomName()
        data1 = self:GetEmptyChatData(channelName)
      else
        data1 = self:GetEmptyChatData("")
      end
    end
    return data1, data2, data3
  else
    if chatmsglist[1] then
      data1 = _getChatMessage(theRoomId, chatmsglist[1])
    end
    if chatmsglist[2] then
      data2 = _getChatMessage(theRoomId, chatmsglist[2])
    end
    if chatmsglist[3] then
      data3 = _getChatMessage(theRoomId, chatmsglist[3])
    end
  end
  if data1 and data1.isRedPcaket then
    self.chatRedData = data1
  end
  return data1, data2, data3
end

function UIMainChatItem:OnClick()
  if self.state == UIMainLeftBottomState.WarningBall then
    self.lastState = UIMainLeftBottomState.WarningBall
  elseif self.state == UIMainLeftBottomState.OnlyChat or self.state == UIMainLeftBottomState.AllianceTaskShare then
    if self.chat_Active == self.chat_AL and not LuaEntry.Player:IsInAlliance() then
      if LuaEntry.Player:IsFirstJoinAlliance() == true then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
      end
      return
    end
    if self:CheckOpenRenameView() then
    else
      GoToUtil.OpenChatView(true, {anim = false, immediately = true}, {
        roomId = self.curRoomId
      })
    end
  elseif self.state == UIMainLeftBottomState.RedPacket then
    self.view.ctrl:OnFunctionClick(UIMainFunctionInfo.Chat, self.curRoomId)
  end
end

function UIMainChatItem:CheckOpenRenameView()
  if LuaEntry.Player.renameTime < 1 then
    local isOpen = Setting:GetPrivateInt(SettingKeys.IS_RENAME_OPEN_IN_CHAT, 0)
    if isOpen < 1 then
      Setting:SetPrivateInt(SettingKeys.IS_RENAME_OPEN_IN_CHAT, 1)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFirstChangeInfo, {anim = true}, {window = "chat"})
      return true
    end
  end
end

function UIMainChatItem:OnUpdateRedPot()
end

function UIMainChatItem:OnReceiveChatMessage(data)
  if data == 0 or self:CanShowInItem(data.post) == false then
    return
  end
  local roomId = data.roomId
  if data.group == ChatGroupType.GROUP_CUSTOM and LuaEntry.Player.uid ~= data.senderUid then
    local roomData = ChatInterface.getRoomMgr():GetRoomData(roomId)
    if roomData ~= nil and roomData:isPrivateChat() then
      if lastActiveRoomId == nil or lastActiveRoomId == "" then
        self.page_hint_root:SetSizeDelta(Vector2.New(100, 12))
        self.chat_scroll_content:SetSizeDelta(Vector2.New(1380, 130))
        self.chat_Private:SetActive(true)
        self.chat_scroll_view:SetPageCount(3)
        lastActiveRoomId = roomId
      end
      self:ShowMessageTipAnim(Localization:GetString("290038"))
    end
  elseif data.group == ChatGroupType.GROUP_ALLIANCE and LuaEntry.Player.uid ~= data.senderUid then
    self:ShowMessageTipAnim(Localization:GetString("129046"))
  end
  self:RefreshShow()
end

function UIMainChatItem:ShowMessageTipAnim(str)
  if string.IsNullOrEmpty(str) then
    return
  end
  if self.showPrivateChatTipSequence ~= nil then
    self.showPrivateChatTipSequence:Pause()
    self.showPrivateChatTipSequence:Kill()
    self.showPrivateChatTipSequence = nil
  end
  self.msg_tip:SetLocalScaleXYZ(0, 0, 0)
  self.msg_tip:SetAlpha(0)
  self.msg_tip_txt:SetText(str)
  local sequence = CS.DG.Tweening.DOTween.Sequence()
  sequence:Join(self.msg_tip.transform:DOScale(Vector3.New(1, 1, 1), 0.5))
  sequence:Join(self.msg_tip:FadeIn(0, 0.2))
  sequence:AppendInterval(0.2)
  sequence:Append(self.msg_tip.transform:DORotate(Vector3.New(0, 0, -5), 0.1))
  sequence:Append(self.msg_tip.transform:DORotate(Vector3.New(0, 0, 5), 0.2))
  sequence:Append(self.msg_tip.transform:DORotate(Vector3.New(0, 0, -5), 0.2))
  sequence:Append(self.msg_tip.transform:DORotate(Vector3.New(0, 0, 5), 0.2))
  sequence:Append(self.msg_tip.transform:DORotate(Vector3.New(0, 0, -5), 0.2))
  sequence:Append(self.msg_tip.transform:DORotate(Vector3.New(0, 0, 5), 0.2))
  sequence:Append(self.msg_tip.transform:DORotate(Vector3.New(0, 0, 0), 0.1))
  sequence:AppendInterval(0.5)
  sequence:AppendCallback(function()
    self.msg_tip:FadeOut(0, 0.2)
  end)
  self.showPrivateChatTipSequence = sequence
end

function UIMainChatItem:OnUpdateNewsMessage()
  local firstUnreadNews = DataCenter.LWNewsCenterManager:GetFirstUnreadNews()
  if firstUnreadNews then
    self:OnReceiveNewsMessage(firstUnreadNews)
  else
    self.news_label:SetText("")
    self.chat_scroll_viewport.transform.offsetMax = Vector2.New(0, 0)
  end
end

function UIMainChatItem:OnReceiveNewsMessage(newsInfo)
  if newsInfo then
    if newsInfo.smallType == NewsSubType.PERSONAL_BATTLE then
      self.news_label:SetText(Localization:GetString(801041) .. Localization:GetString("800903"))
    elseif newsInfo.smallType == NewsSubType.ALLIANCE_BATTLE then
      self.news_label:SetText(Localization:GetString(801041) .. Localization:GetString("800904"))
    elseif newsInfo.smallType == NewsSubType.ALLIANCE_ATK_ALLIANCE_CITY then
      self.news_label:SetText(Localization:GetString(801041) .. Localization:GetString("800905"))
    elseif newsInfo.smallType == NewsSubType.APPOINT_OFFICAL then
      self.news_label:SetText(Localization:GetString(801041) .. Localization:GetString("800906"))
    elseif newsInfo.smallType == NewsSubType.CROSS_SERVER_BATTLE then
    elseif newsInfo.smallType == NewsSubType.CROSS_PLUNDER_KINGDOM then
    elseif newsInfo.smallType == NewsSubType.CROSS_AREA_BATTLE then
    elseif newsInfo.smallType == NewsSubType.TRAIN_ROB then
      self.news_label:SetText(Localization:GetString(801041) .. Localization:GetString("800938"))
    end
    self.news_vfx:SetActive(false)
    self.news_vfx:SetActive(true)
    self.chat_scroll_viewport.transform.offsetMax = Vector2.New(0, -38)
  end
end

function UIMainChatItem:OnUserInfoUpdate()
  self:RefreshChatSignal()
end

function UIMainChatItem:SetCurRoomId(chatroomid)
  if chatroomid == ChatInterface.getRoomMgr():GenLanguageRoomId() or chatroomid == ChatInterface.getRoomMgr():GenCrossServerRoomId() then
    return
  end
  if self.curRoomId ~= chatroomid then
    self.curRoomId = chatroomid
    local roomData = ChatInterface.getRoomMgr():GetRoomData(chatroomid)
    if roomData and roomData:isCustomRoom() then
      lastActiveRoomId = chatroomid
    end
    self:UpdateChatPageView()
    self:RefreshSignal()
  end
end

function UIMainChatItem:RefreshState()
  local chat = self:GetChatDes(self.curRoomId)
  if chat ~= nil and chat ~= "" then
    if chat.isRedPcaket then
      self.state = UIMainLeftBottomState.RedPacket
    elseif chat.blState then
      self.state = chat.blState
    else
      self.state = UIMainLeftBottomState.OnlyChat
    end
  end
end

function UIMainChatItem:ReInit()
  self.showIndex = 0
  self:InitChatChannel()
  self:RefreshState()
  self:RefreshShow()
end

function UIMainChatItem:OnEnterScene()
  self.curRoomId = ""
  self:InitChatChannel()
end

function UIMainChatItem:LastShowAllianceChatIsInK5Time()
  local allianceRoomId = ChatInterface.getRoomMgr():GetAllianceRoomId()
  local roomData = ChatInterface.getRoomData(allianceRoomId)
  if roomData ~= nil then
    local lists = roomData.msgs
    local index = #lists
    local now = UITimeManager:GetInstance():GetServerTime()
    while 0 < index do
      local tmpData = lists[index]
      if tmpData ~= nil and self:CanShowInItem(tmpData.post) == true then
        local dataTime = tmpData.serverTime
        local diff = now - dataTime
        if diff > self.initShowAllianceChatTime then
          do return false end
          break
        end
        do return true end
        break
      end
      index = index - 1
    end
  end
  return false
end

function UIMainChatItem:OnUpdateScroll(index)
  CS.GameEntry.Setting:SetInt("default_chat_" .. LuaEntry.Player.uid, index)
  if lastActiveRoomId == "" then
    self.page_hint_spr.transform:DOLocalMoveX(2 + index * 32 - 34 - 32, 0.1):SetEase(CS.DG.Tweening.Ease.InOutCubic)
  else
    self.page_hint_spr.transform:DOLocalMoveX(2 + index * 32 - 50 - 32, 0.1):SetEase(CS.DG.Tweening.Ease.InOutCubic)
  end
  if self.atInitChatChannel == true then
    return
  end
  local activeRoomId
  if index == 1 then
    activeRoomId = ChatInterface.getRoomMgr():GetCountryRoomId()
    self.switch_txt:SetLocalText(100171)
  elseif index == 2 then
    activeRoomId = ChatInterface.getRoomMgr():GetAllianceRoomId()
    self.switch_txt:SetLocalText(393081)
  elseif lastActiveRoomId ~= "" then
    activeRoomId = lastActiveRoomId
    self.switch_txt:SetLocalText(290038)
  else
    activeRoomId = ChatInterface.getRoomMgr():GenLanguageRoomId()
  end
  if self.showChatChannelTipSequence ~= nil then
    self.showChatChannelTipSequence:Pause()
    self.showChatChannelTipSequence:Kill()
    self.showChatChannelTipSequence = nil
  end
  self.switch_tip:SetLocalScaleXYZ(0, 0, 0)
  self.switch_tip:SetAlpha(0)
  local sequence = CS.DG.Tweening.DOTween.Sequence()
  sequence:Join(self.switch_tip.transform:DOScale(Vector3.New(1, 1, 1), 0.5))
  sequence:Join(self.switch_tip:FadeIn(0, 0.2))
  sequence:AppendInterval(1)
  sequence:AppendCallback(function()
    self.switch_tip:FadeOut(0, 0.2)
  end)
  self.showChatChannelTipSequence = sequence
  self:SetCurRoomId(activeRoomId)
end

function UIMainChatItem:InitChatChannel()
  self.atInitChatChannel = true
  if self.curRoomId == nil or self.curRoomId == "" then
    local default_chat_tab = CS.GameEntry.Setting:GetInt("default_chat_" .. LuaEntry.Player.uid, 1)
    if default_chat_tab == 1 then
      self.curRoomId = ChatInterface.getRoomMgr():GetCountryRoomId()
    else
      self.curRoomId = ChatInterface.getRoomMgr():GetAllianceRoomId()
    end
    self:RefreshSpecialText(1, ChatInterface.getRoomMgr():GetCountryRoomId(), self.chat_World)
    self:RefreshSpecialText(2, ChatInterface.getRoomMgr():GetAllianceRoomId(), self.chat_AL)
  end
  self:UpdateChatPageView()
  self.atInitChatChannel = false
end

function UIMainChatItem:UpdateChatPageView()
  local offset = -32
  self.atInitChatChannel = true
  if lastActiveRoomId == "" then
    self.page_hint_root:SetSizeDelta(Vector2.New(68, 12))
    self.chat_scroll_content:SetSizeDelta(Vector2.New(920, 130))
    self.chat_Private:SetActive(false)
    offset = -34
    self.chat_scroll_view:SetPageCount(2)
  else
    self.page_hint_root:SetSizeDelta(Vector2.New(100, 12))
    self.chat_scroll_content:SetSizeDelta(Vector2.New(1380, 130))
    self.chat_Private:SetActive(true)
    offset = -50
    self.chat_scroll_view:SetPageCount(3)
  end
  if self.curRoomId == ChatInterface.getRoomMgr():GetCountryRoomId() then
    self.page_hint_spr:SetLocalPositionXYZ(2 + offset, 0, 0)
    self.chat_scroll_view:PageTo(1)
    self.chat_Active = self.chat_World
  elseif self.curRoomId == ChatInterface.getRoomMgr():GetAllianceRoomId() then
    self.page_hint_spr:SetLocalPositionXYZ(34 + offset, 0, 0)
    self.chat_scroll_view:PageTo(2)
    self.chat_Active = self.chat_AL
  elseif lastActiveRoomId == self.curRoomId then
    self.page_hint_spr:SetLocalPositionXYZ(66 + offset, 0, 0)
    self.chat_scroll_view:PageTo(3)
    self.chat_Active = self.chat_Private
  end
  self.atInitChatChannel = false
end

function UIMainChatItem:CheckRoom()
  if self.curRoomId == nil or self.curRoomId == "" then
    self:InitChatChannel()
    self:RefreshState()
  end
end

function UIMainChatItem:RefreshShow()
  self.showTextList = {}
  self.alTaskShare_go:SetActive(false)
  if self.state == UIMainLeftBottomState.OnlyChat then
    self.alarm_go:SetActive(false)
    self.redPacket_go:SetActive(false)
    if self.firstShow or not self.chat_go:GetActive() then
      self.chat_go:SetActive(true)
      self.chatShowParticle:Play()
      self.firstShow = false
    end
    local param = {}
    param.state = UIMainShowTextType.Chat
    if self.curRoomId == "" and self.curRoomId == ChatInterface.getRoomMgr():GetAllianceRoomId() then
      param.chats = {
        {
          name = Localization:GetString("2700020"),
          des = ""
        }
      }
      self:RefreshText(param)
      return
    end
    local chat1, chat2, chat3 = self:GetChatDes(self.curRoomId)
    param.chats = {
      chat1,
      chat2,
      chat3
    }
    if not chat1 then
      return
    end
    self.chat_npc_icon:SetData(chat1.uid, chat1.head, chat1.headPicVer)
    local showHead = chat1.uid .. "_" .. (chat1.head or "")
    if chat1.headPicVer then
      showHead = chat1.uid .. "_" .. (chat1.head or "") .. "_" .. (chat1.headPicVer or "")
    end
    DOTween.Rewind(self.chat_npc_icon.gameObject)
    if showHead ~= self.currenShowHead then
      DOTween.Play(self.chat_npc_icon.gameObject)
    end
    self.currenShowHead = showHead
    self:RefreshText(param)
    if self.quest_early then
      return
    end
  elseif self.state == UIMainLeftBottomState.RedPacket then
    self.alarm_go:SetActive(false)
    self.chat_go:SetActive(false)
    self.redPacket_go:SetActive(true)
    local param = {}
    param.state = UIMainShowTextType.RedPacket
    local chat1 = self.chatRedData
    param.name = chat1.name
    param.extra = chat1.extra
    self.redPacketHead:SetData(chat1.uid, chat1.head, chat1.headPicVer)
    self:RefreshText(param)
  elseif self.state == UIMainLeftBottomState.AllianceTaskShare then
    self.alarm_go:SetActive(false)
    self.chat_go:SetActive(false)
    self.redPacket_go:SetActive(false)
    self.alTaskShare_go:SetActive(true)
    local chat1 = self:GetChatDes(self.curRoomId)
    self.alTaskShareHead:SetData(chat1.uid, chat1.head, chat1.headPicVer)
    self.alTaskShareProg:SetValue(chat1.shareData.curProg / chat1.shareData.maxProg)
    self.alTaskShareProgTxt:SetText(chat1.shareData.curProg .. "/" .. chat1.shareData.maxProg)
    self.alTaskShareTxt:SetText(Localization:GetString("391003") .. Localization:GetString(chat1.shareData.taskName))
  end
end

local function GetTextColor(textColorSelfAlliance)
  if textColorSelfAlliance == true then
    return ChatColorAlliance
  end
  return ChatColorNormal
end

function UIMainChatItem:RefreshSpecialText(index, roomId, chat_active)
  local chat1, chat2, chat3
  if index == 2 and not LuaEntry.Player:IsInAlliance() then
    chat1 = {
      name = Localization:GetString("2700020"),
      desc = ""
    }
    chat2 = nil
    chat3 = nil
  else
    chat1, chat2, chat3 = self:GetChatDes(roomId)
  end
  chat_active:StopChatAnim()
  if chat3 then
    chat_active:SetChatTextAndColor(ChatTextIndex.ChatTextIndex_1, chat3.name, chat3.des, GetTextColor(chat3.textColorSelfAlliance))
  else
    chat_active:SetChatTextAndColor(ChatTextIndex.ChatTextIndex_3, "", "")
  end
  if chat2 then
    chat_active:SetChatTextAndColor(ChatTextIndex.ChatTextIndex_2, chat2.name, chat2.des, GetTextColor(chat2.textColorSelfAlliance))
  else
    chat_active:SetChatTextAndColor(ChatTextIndex.ChatTextIndex_2, "", "")
  end
  if chat1 then
    chat_active:SetChatTextAndColor(ChatTextIndex.ChatTextIndex_3, chat1.name, chat1.des, GetTextColor(chat1.textColorSelfAlliance))
  else
    chat_active:SetChatTextAndColor(ChatTextIndex.ChatTextIndex_1, "", "")
  end
end

function UIMainChatItem:RefreshText(param)
  self.chat_unread:SetActive(false)
  self.alTaskShare_go:SetActive(false)
  if param.state == UIMainShowTextType.Chat then
    self.chat_go:SetActive(true)
    self.alarm_go:SetActive(false)
    self:RefreshReddot()
    local chat_active = self.chat_Active
    if param.chats then
      for i = 1, 3 do
        local idx = 3 - i + 1
        local chat = param.chats[i]
        if chat then
          chat_active:SetChatTextAndColor(ChatTextIndex["ChatTextIndex_" .. idx], chat.name, chat.des, GetTextColor(chat.textColorSelfAlliance))
        else
          chat_active:SetChatTextAndColor(ChatTextIndex["ChatTextIndex_" .. idx], "", "")
        end
      end
    end
  elseif param.state == UIMainShowTextType.RedPacket then
    self.chat_go:SetActive(false)
    self.alarm_go:SetActive(false)
    self.redPacketContent1:SetLocalText(104201)
    local buildId = GetTableData(TableName.SysRedPacket, param.extra.reasonId, "building")
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    local lvConfig = GetTableData(TableName.SysRedPacket, param.extra.reasonId, "level")
    self.redPacketContent2:SetText(param.name .. Localization:GetString("390922", Localization:GetString(buildTemplate.name), lvConfig))
  end
end

function UIMainChatItem:RefreshSignal()
  self:RefreshState()
  self:RefreshShow()
end

function UIMainChatItem:RefreshChatSignal(roomId)
  roomId = roomId or ChatInterface.getRoomMgr():GetCountryRoomId()
  self:SetCurRoomId(roomId)
end

function UIMainChatItem:OnCloseChatView(roomId)
end

function UIMainChatItem:OnGuideShow()
end

function UIMainChatItem:CanShowInItem(type)
  if type == PostType.Text_MemberJoin or type == PostType.Text_MemberQuit or type == PostType.Text_ChatRoomSystemMsg or type == PostType.Text_AllianceMemberInOut or type == PostType.Text_AllianceRankChange or type == PostType.Text_AllianceOfficialChange or type == PostType.Text_AllianceOfficialSet or type == PostType.Text_AllianceOfficialCancel then
    return false
  end
  return true
end

function UIMainChatItem:AllianceQuit()
  self:RefreshSpecialText(2, ChatInterface.getRoomMgr():GetAllianceRoomId(), self.chat_AL)
end

function UIMainChatItem:RefreshReddot()
  local unreadNum = 0
  if self.quest_early then
    local countryRoom = ChatInterface.getRoomMgr():CheckGroupCountry()
    if countryRoom then
      if ChatManager2:GetInstance().Room ~= nil then
        unreadNum = ChatManager2:GetInstance().Room:GetAllRoomNewMsgCount()
      end
    else
      local allianceRoomId = ChatInterface.getRoomMgr():GetAllianceRoomId()
      local roomData = ChatInterface.getRoomData(allianceRoomId)
      if roomData ~= nil then
        local num = roomData:getNewMsgNum()
        unreadNum = num
      end
    end
  elseif ChatManager2:GetInstance().Room ~= nil then
    unreadNum = ChatManager2:GetInstance().Room:GetAllRoomNewMsgCount()
  end
  local redPacketNum = DataCenter.AllianceRedPacketManager:GetValidRedPacketNum()
  unreadNum = unreadNum + redPacketNum
  local unreadAlAutoInvite = DataCenter.AllianceAutoInviteManager:GetUnreadCount()
  unreadNum = unreadNum + unreadAlAutoInvite
  self.chat_unread:SetNumber(unreadNum)
end

function UIMainChatItem:OnApplicationPause(isPaused)
  if not isPaused and self.chat_scroll_view then
    self.chat_scroll_view.isInDrag = false
  end
end

return UIMainChatItem
