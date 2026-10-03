local base = UIBaseContainer
local MainUIVoiceRoomComponent = BaseClass("MainUIVoiceRoomComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local TypeParticleSystem = typeof(CS.UnityEngine.ParticleSystem)

function MainUIVoiceRoomComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MainUIVoiceRoomComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MainUIVoiceRoomComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.circleImgPlayerHead = self.viewSkin:AddComponent(self, CircleImage, 2)
  self.textMemberCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnRoot = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnRoot:SetOnClick(function()
    self:OnBtnRootClick()
  end)
  self.compEffUiVoiceRoomJiaruGlow = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.compIn = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self._headImg = self.circleImgPlayerHead.gameObject:GetComponent(typeof(CS.UIPlayerHead))
  self._audioFlagEffect = self.compEffUiVoiceRoomJiaruGlow.gameObject:GetComponent(TypeParticleSystem)
end

function MainUIVoiceRoomComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textName = nil
  self.circleImgPlayerHead = nil
  self.textMemberCount = nil
  self.btnRoot = nil
  self.compEffUiVoiceRoomJiaruGlow = nil
  self.compIn = nil
  self._audioFlagEffect = nil
end

function MainUIVoiceRoomComponent:DataDefine()
  self.targetChatRoomId = nil
  self.targetRoomName = ""
  self:RefreshTargetVoiceRoomInfo()
end

function MainUIVoiceRoomComponent:DataDestroy()
  self.targetChatRoomId = nil
  self.targetRoomName = nil
end

function MainUIVoiceRoomComponent:GetTargetVoiceRoomInfo()
  local voiceRoomMgr = ChatManager2:GetInstance().Voice
  local targetChatRoomId
  local currentChatRoomId = voiceRoomMgr:GetCurrentChatRoomId()
  if not string.IsNullOrEmpty(currentChatRoomId) and voiceRoomMgr:HasVoiceRoomID(currentChatRoomId) then
    targetChatRoomId = currentChatRoomId
  end
  if string.IsNullOrEmpty(targetChatRoomId) then
    local roomList = voiceRoomMgr:GetVoiceRoomList()
    targetChatRoomId = roomList[1]
  end
  if string.IsNullOrEmpty(targetChatRoomId) then
    return nil, ""
  end
  local roomMgr = ChatManager2:GetInstance().Room
  local roomData = roomMgr:GetRoomData(targetChatRoomId)
  local roomName = roomData:getRoomName() or targetChatRoomId
  return targetChatRoomId, roomName
end

function MainUIVoiceRoomComponent:GetVoiceRoomMemberCount(chatRoomId)
  if string.IsNullOrEmpty(chatRoomId) then
    return 0
  end
  local voiceRoomMgr = ChatManager2:GetInstance().Voice
  local voiceRoomData = voiceRoomMgr and voiceRoomMgr.GetVoiceRoomData and voiceRoomMgr:GetVoiceRoomData(chatRoomId) or nil
  if not voiceRoomData then
    return 0
  end
  return voiceRoomData:GetOnlinePlayerCount()
end

function MainUIVoiceRoomComponent:RefreshJoinStateDisplay()
  local voiceRoomMgr = ChatManager2:GetInstance().Voice
  local currentChatRoomId = voiceRoomMgr:GetCurrentChatRoomId()
  local isInTargetRoom = not string.IsNullOrEmpty(self.targetChatRoomId) and currentChatRoomId == self.targetChatRoomId
  self.circleImgPlayerHead:SetActive(isInTargetRoom)
  self:RefreshPlayerHead()
  if isInTargetRoom then
    local memberCount = self:GetVoiceRoomMemberCount(self.targetChatRoomId)
    self.textMemberCount:SetText(tostring(memberCount))
  else
    self.textMemberCount:SetText("")
  end
end

function MainUIVoiceRoomComponent:RefreshPlayerHead()
  local voiceRoomMgr = ChatManager2:GetInstance().Voice
  local uid, isSpeaking = voiceRoomMgr:GetLastAudioOn()
  if isSpeaking then
    self._audioFlagEffect:Play()
    self.compIn:SetActive(true)
  else
    self._audioFlagEffect:Stop()
    self.compIn:SetActive(false)
  end
  if uid ~= nil then
    local _userInfo = ChatInterface.getUserData(uid)
    if _userInfo ~= nil then
      local userId = _userInfo.uid or ""
      local userPic = _userInfo.headPic or ""
      if _userInfo:IsGmUser() then
        userPic = _userInfo:GetGMIcon()
      end
      local userPicVer = _userInfo.headPicVer or 0
      self._headImg:SetData(userId, userPic, userPicVer)
      return
    end
  end
  self._headImg:UseSystemHead()
end

function MainUIVoiceRoomComponent:RefreshTargetVoiceRoomInfo()
  local targetChatRoomId, roomName = self:GetTargetVoiceRoomInfo()
  self.targetChatRoomId = targetChatRoomId
  self.targetRoomName = roomName or ""
  self.textName:SetText(self.targetRoomName)
  self:RefreshJoinStateDisplay()
end

function MainUIVoiceRoomComponent:OnShowBFVoiceRoom()
  self:RefreshTargetVoiceRoomInfo()
end

function MainUIVoiceRoomComponent:OnVoiceRoomMemberUpdate(roomId)
  self:RefreshJoinStateDisplay()
end

function MainUIVoiceRoomComponent:OnVoiceRoomAudioChange()
  self:RefreshPlayerHead()
end

function MainUIVoiceRoomComponent:OnEnterVoiceRoom(roomId)
  self:RefreshTargetVoiceRoomInfo()
end

function MainUIVoiceRoomComponent:OnExitVoiceRoom(roomId)
  self:RefreshTargetVoiceRoomInfo()
end

function MainUIVoiceRoomComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ShowBFVoiceRoom, self.OnShowBFVoiceRoom)
  self:AddUIListener(EventId.VoiceRoomMemberUpdate, self.OnVoiceRoomMemberUpdate)
  self:AddUIListener(EventId.VoiceRoomAudioChange, self.OnVoiceRoomAudioChange)
  self:AddUIListener(EventId.EnterVoiceRoom, self.OnEnterVoiceRoom)
  self:AddUIListener(EventId.ExitVoiceRoom, self.OnExitVoiceRoom)
end

function MainUIVoiceRoomComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.ShowBFVoiceRoom, self.OnShowBFVoiceRoom)
  self:RemoveUIListener(EventId.VoiceRoomMemberUpdate, self.OnVoiceRoomMemberUpdate)
  self:RemoveUIListener(EventId.VoiceRoomAudioChange, self.OnVoiceRoomAudioChange)
  self:RemoveUIListener(EventId.EnterVoiceRoom, self.OnEnterVoiceRoom)
  self:RemoveUIListener(EventId.ExitVoiceRoom, self.OnExitVoiceRoom)
  base.OnRemoveListener(self)
end

function MainUIVoiceRoomComponent:JoinTargetVoiceRoom()
  local voiceRoomMgr = ChatManager2:GetInstance().Voice
  if voiceRoomMgr:IsJoinRoomCmdPending(self.targetChatRoomId) then
    Logger.LogInfo(string.format("[VoiceChat][Lua] JoinTargetVoiceRoom is pending %s", tostring(self.targetChatRoomId)))
    return
  end
  voiceRoomMgr:RequestJoinRoom(self.targetChatRoomId)
end

function MainUIVoiceRoomComponent:OnBtnRootClick()
  self:RefreshTargetVoiceRoomInfo()
  if string.IsNullOrEmpty(self.targetChatRoomId) then
    return
  end
  local voiceRoomMgr = ChatManager2:GetInstance().Voice
  local currentChatRoomId = voiceRoomMgr:GetCurrentChatRoomId()
  if currentChatRoomId == self.targetChatRoomId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVoiceRoom, {anim = true})
    return
  end
  UIUtil.ShowMessage(Localization:GetString("voice_room_tips2"), 2, "btn_join", "btn_cancel", function()
    self:JoinTargetVoiceRoom()
  end, function()
  end)
end

return MainUIVoiceRoomComponent
