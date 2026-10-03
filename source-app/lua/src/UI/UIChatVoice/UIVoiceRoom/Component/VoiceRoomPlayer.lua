local base = UIBaseContainer
local VoiceRoomPlayer = BaseClass("VoiceRoomPlayer", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local TypeParticleSystem = typeof(CS.UnityEngine.ParticleSystem)

function VoiceRoomPlayer:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function VoiceRoomPlayer:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function VoiceRoomPlayer:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgListeningToggleDisable = self.viewSkin:AddComponent(self, UIImage, 1)
  self.btnListeningToggle = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnListeningToggle:SetOnClick(function()
    self:OnBtnListeningToggleClick()
  end)
  self.imgMicToggleDisable = self.viewSkin:AddComponent(self, UIImage, 3)
  self.compVoiceCtrl = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.btnCloseReport = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnCloseReport:SetOnClick(function()
    self:OnBtnCloseReportClick()
  end)
  self.textReport = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.compPlayerCtrl = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.imgCommanderFlag = self.viewSkin:AddComponent(self, UIImage, 8)
  self.compHead = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.btnMicToggle = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnMicToggle:SetOnClick(function()
    self:OnBtnMicToggleClick()
  end)
  self.compAudioFlag = self.viewSkin:AddComponent(self, UIBaseContainer, 11)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.imgSelfConnetionFlag = self.viewSkin:AddComponent(self, UIImage, 13)
  self.imgVoiceConnetionFlag = self.viewSkin:AddComponent(self, UIImage, 14)
  self.btnRoot = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnRoot:SetOnClick(function()
    self:OnBtnRootClick()
  end)
  self.imgCommanderFlagBG = self.viewSkin:AddComponent(self, UIImage, 16)
  self.imgListeningToggleEnable = self.viewSkin:AddComponent(self, UIImage, 17)
  self.imgMicToggleEnable = self.viewSkin:AddComponent(self, UIImage, 18)
  self.btnReport = self.viewSkin:AddComponent(self, UIButton, 19)
  self.btnReport:SetOnClick(function()
    self:OnBtnReportClick()
  end)
  self.sliderAudioFlag = self.viewSkin:AddComponent(self, UISlider, 20)
  self.compEffUiVoiceRoomAudioGlow = self.viewSkin:AddComponent(self, UIBaseContainer, 21)
  self._headImg = self.compHead.gameObject:GetComponent(typeof(CS.UIPlayerHead))
  self._audioFlagEffect = self.compEffUiVoiceRoomAudioGlow.gameObject:GetComponent(TypeParticleSystem)
end

function VoiceRoomPlayer:ComponentDestroy()
  self.viewSkin = nil
  self.imgListeningToggleDisable = nil
  self.btnListeningToggle = nil
  self.imgMicToggleDisable = nil
  self.compVoiceCtrl = nil
  self.btnCloseReport = nil
  self.textReport = nil
  self.compPlayerCtrl = nil
  self.imgCommanderFlag = nil
  self.compHead = nil
  self.btnMicToggle = nil
  self.compAudioFlag = nil
  self.textName = nil
  self.imgSelfConnetionFlag = nil
  self.imgVoiceConnetionFlag = nil
  self.btnRoot = nil
  self.imgCommanderFlagBG = nil
  self.imgListeningToggleEnable = nil
  self.imgMicToggleEnable = nil
  self.btnReport = nil
  self.sliderAudioFlag = nil
  self.compEffUiVoiceRoomAudioGlow = nil
  self._headImg = nil
  self._audioFlagEffect = nil
end

function VoiceRoomPlayer:DataDefine()
  self.roomId = nil
  self.playerId = nil
  self.memberData = nil
  self.showVoiceCtrl = true
  self.isMicOn = false
  self.isListening = true
  self.isSpeaking = false
  self.isChatConnected = false
  self.isVoiceConnected = false
  self.isCommander = false
  self.isSelf = false
end

function VoiceRoomPlayer:DataDestroy()
  self.roomId = nil
  self.playerId = nil
  self.memberData = nil
  self.showVoiceCtrl = nil
  self.isMicOn = nil
  self.isListening = nil
  self.isSpeaking = nil
  self.isChatConnected = nil
  self.isVoiceConnected = nil
  self.isCommander = nil
  self.isSelf = nil
end

function VoiceRoomPlayer:GetRoomData()
  local voiceRoomMgr = ChatManager2 and ChatManager2:GetInstance() and ChatManager2:GetInstance().Voice or nil
  if not voiceRoomMgr or not voiceRoomMgr.GetRoomData then
    return nil
  end
  local chatRoomId
  if voiceRoomMgr.GetCurrentChatRoomId then
    chatRoomId = voiceRoomMgr:GetCurrentChatRoomId()
  end
  self.roomId = chatRoomId
  return voiceRoomMgr:GetRoomData(chatRoomId)
end

function VoiceRoomPlayer:RefreshCtrlVisible()
  if self.isSelf then
    self.compVoiceCtrl:SetActive(true)
    self.compPlayerCtrl:SetActive(false)
  else
    if self.compVoiceCtrl then
      self.compVoiceCtrl:SetActive(self.showVoiceCtrl)
    end
    if self.compPlayerCtrl then
      self.compPlayerCtrl:SetActive(not self.showVoiceCtrl)
    end
  end
end

function VoiceRoomPlayer:RefreshStatusFromMemberData()
  self.isMicOn = false
  self.isListening = true
  self.isSpeaking = false
  self.isChatConnected = false
  self.isVoiceConnected = false
  self.isCommander = false
  self.isSelf = false
  local selfUid
  if ChatInterface and ChatInterface.getPlayerUid then
    selfUid = ChatInterface.getPlayerUid()
  end
  if string.IsNullOrEmpty(selfUid) and LuaEntry and LuaEntry.Player and LuaEntry.Player.uid then
    selfUid = tostring(LuaEntry.Player.uid)
  end
  if not string.IsNullOrEmpty(selfUid) and not string.IsNullOrEmpty(self.playerId) then
    self.isSelf = tostring(self.playerId) == tostring(selfUid)
  end
  local memberInfo = self.memberData
  if type(memberInfo) ~= "table" then
    return
  end
  local chatService = memberInfo.chatService
  if type(chatService) == "table" then
    self.isChatConnected = chatService.inVoiceRoom
    self.isCommander = chatService.isCommander and true or false
  end
  local voiceService = memberInfo.voiceService
  if type(voiceService) == "table" then
    self.isVoiceConnected = true
    if voiceService.isMicOn ~= nil then
      self.isMicOn = voiceService.isMicOn and true or false
    end
    if voiceService.isListening ~= nil then
      self.isListening = voiceService.isListening and true or false
    end
    if voiceService.isSpeaking ~= nil then
      self.isSpeaking = voiceService.isSpeaking and true or false
    end
  end
end

function VoiceRoomPlayer:RefreshVoiceStateUI()
  self.imgMicToggleDisable:SetActive(not self.isMicOn)
  self.imgMicToggleEnable:SetActive(self.isMicOn)
  if not self.isSelf then
    self.imgListeningToggleEnable:SetActive(self.isListening)
    self.imgListeningToggleDisable:SetActive(not self.isListening)
  else
    self.imgListeningToggleEnable:SetActive(false)
    self.imgListeningToggleDisable:SetActive(false)
  end
  self.compAudioFlag:SetActive(self.isSpeaking)
  if self.isSpeaking then
    self._audioFlagEffect:Play()
  else
    self._audioFlagEffect:Stop()
  end
  if self.isChatConnected and self.isVoiceConnected then
    self.imgSelfConnetionFlag:SetActive(false)
    self.imgVoiceConnetionFlag:SetActive(false)
  else
    if self.imgSelfConnetionFlag then
      self.imgSelfConnetionFlag:SetActive(self.isChatConnected)
    end
    if self.imgVoiceConnetionFlag then
      self.imgVoiceConnetionFlag:SetActive(self.isVoiceConnected)
    end
  end
  if self.imgCommanderFlag then
    self.imgCommanderFlag:SetActive(self.isCommander)
    self.imgCommanderFlagBG:SetActive(self.isCommander)
  end
end

function VoiceRoomPlayer:RefreshAllState()
  self:RefreshStatusFromMemberData()
  local _userInfo = ChatInterface.getUserData(self.playerId)
  if _userInfo ~= nil then
    local userId = _userInfo.uid or ""
    local userName = _userInfo.userName or ""
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(userId, userName)
    local abbr = ""
    if not string.IsNullOrEmpty(_userInfo.allianceSimpleName) then
      abbr = "[" .. _userInfo.allianceSimpleName .. "]"
    end
    self.textName:SetText(abbr .. showName)
    if self.isSelf then
      self.textName:SetColorRGBA(0.37254901960784315, 0.9372549019607843, 0.5294117647058824, 1)
    else
      self.textName:SetColorRGBA(1, 1, 1, 1)
    end
  end
  self.textReport:SetLocalText("208251")
  self:RefreshCtrlVisible()
  self:RefreshVoiceStateUI()
  if _userInfo ~= nil then
    local userId = _userInfo.uid or ""
    local userPic = _userInfo.headPic or ""
    if _userInfo:IsGmUser() then
      userPic = _userInfo:GetGMIcon()
    end
    local userPicVer = _userInfo.headPicVer or 0
    self._headImg:SetData(userId, userPic, userPicVer)
  else
    self._headImg:UseSystemHead()
  end
end

function VoiceRoomPlayer:SetData(member)
  self.memberData = member
  self.playerId = member and member.uid or nil
  local voiceRoomMgr = ChatManager2 and ChatManager2:GetInstance() and ChatManager2:GetInstance().Voice or nil
  if voiceRoomMgr and voiceRoomMgr.GetCurrentChatRoomId then
    self.roomId = voiceRoomMgr:GetCurrentChatRoomId()
  end
  self.showVoiceCtrl = true
  self:RefreshAllState()
end

function VoiceRoomPlayer:OnBtnRootClick()
  if self.isSelf then
    return
  end
  self.showVoiceCtrl = not self.showVoiceCtrl
  self:RefreshCtrlVisible()
end

function VoiceRoomPlayer:OnBtnCloseReportClick()
  if self.isSelf then
    return
  end
  self.showVoiceCtrl = true
  self:RefreshCtrlVisible()
end

function VoiceRoomPlayer:OnBtnReportClick()
  local roomMgr = ChatManager2:GetInstance().Room
  local chatData = roomMgr:CreateChatMessage()
  if chatData then
    chatData.senderUid = self.playerId
    chatData.roomId = self.roomId
    chatData.msg = ""
    chatData.post = PostType.Text_Normal
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatReport, {anim = true}, {
    type = ReportType.voiceRoom,
    chatData = chatData
  })
  self.showVoiceCtrl = true
  self:RefreshCtrlVisible()
end

function VoiceRoomPlayer:IsInVoiceRoomVoiceService()
  local voiceRoomMgr = ChatManager2 and ChatManager2:GetInstance() and ChatManager2:GetInstance().Voice or nil
  if not voiceRoomMgr or not voiceRoomMgr.IsInVoiceRoomVoiceService then
    return false
  end
  return voiceRoomMgr:IsInVoiceRoomVoiceService(self.roomId)
end

function VoiceRoomPlayer:OnBtnListeningToggleClick()
  if not self:IsInVoiceRoomVoiceService() then
    UIUtil.ShowMessage(Localization:GetString("not_in_voice_room_voice_service"))
    return
  end
  local uid = tostring(self.playerId or "")
  if string.IsNullOrEmpty(uid) then
    return
  end
  local targetListening = (not self.isListening or not true) and true
  local volume = targetListening and 100 or 0
  local voiceMgr = CS.VoiceChatManager and CS.VoiceChatManager.Instance or nil
  if voiceMgr == nil then
    return
  end
  local ret = voiceMgr:SetSpeakerVolumeByUserId(uid, volume)
  if ret ~= 0 then
    return
  end
  self.isListening = targetListening
  if type(self.memberData) == "table" then
    self.memberData.voiceService = self.memberData.voiceService or {}
    self.memberData.voiceService.isListening = targetListening
  end
  self:RefreshVoiceStateUI()
end

function VoiceRoomPlayer:OnBtnMicToggleClick()
end

function VoiceRoomPlayer:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChatUserInfoUpdate, self.OnChatUserInfoUpdate)
  self:AddUIListener(EventId.PlayerMessageInfo, self.OnChatUserInfoUpdate)
end

function VoiceRoomPlayer:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ChatUserInfoUpdate, self.OnChatUserInfoUpdate)
  self:RemoveUIListener(EventId.PlayerMessageInfo, self.OnChatUserInfoUpdate)
end

function VoiceRoomPlayer:OnChatUserInfoUpdate(uid)
  if self.playerId and self.playerId == uid then
    local userInfo = ChatInterface.getUserData(uid)
    if userInfo then
      self:RefreshAllState()
    end
  end
end

return VoiceRoomPlayer
