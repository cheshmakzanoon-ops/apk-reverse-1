local UIVoiceRoomView = BaseClass("UIVoiceRoomView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local VoiceRoomPlayer = require("UI.UIChatVoice.UIVoiceRoom.Component.VoiceRoomPlayer")
local VoiceChatManager = CS.VoiceChatManager
local SDKManager = CS.SDKManager

function UIVoiceRoomView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIVoiceRoomView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIVoiceRoomView:OnEnable()
  base.OnEnable(self)
  Logger.LogInfo(string.format("[VoiceRoomUI][Lua] OnEnable, chatRoomId=%s, voiceRoomId=%s", tostring(self.chatRoomId or ""), tostring(self.voiceRoomId or "")))
  self:RefreshLocalVoiceState()
  self:RefreshPlayerList()
end

function UIVoiceRoomView:OnDisable()
  base.OnDisable(self)
end

function UIVoiceRoomView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.gridInfinityScrollViewContent = self.viewSkin:AddComponent(self, GridInfinityScrollView, 3)
  self.btnMic = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnMic:SetOnClick(function()
    self:OnBtnMicClick()
  end)
  self.btnSpeak = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnSpeak:SetOnClick(function()
    self:OnBtnSpeakClick()
  end)
  self.imgMicBtnOn = self.viewSkin:AddComponent(self, UIImage, 6)
  self.imgSpeakBtnOn = self.viewSkin:AddComponent(self, UIImage, 7)
  self.imgSpeakBtnOff = self.viewSkin:AddComponent(self, UIImage, 8)
  self.imgMicBtnOff = self.viewSkin:AddComponent(self, UIImage, 9)
  self.compScrollView = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.textRoomName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.itemContent = self.compScrollView
  self.itemContentScroll = self.gridInfinityScrollViewContent
end

function UIVoiceRoomView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.btnBack = nil
  self.gridInfinityScrollViewContent = nil
  self.btnMic = nil
  self.btnSpeak = nil
  self.imgMicBtnOn = nil
  self.imgSpeakBtnOn = nil
  self.imgSpeakBtnOff = nil
  self.imgMicBtnOff = nil
  self.compScrollView = nil
  self.textRoomName = nil
  self:ClearPlayerItems()
  self.itemContent = nil
  self.itemContentScroll = nil
end

function UIVoiceRoomView:DataDefine()
  self.chatRoomId = nil
  self.voiceRoomId = nil
  self.isMicOn = false
  self.isSpeakerOn = true
  self.playerDataList = {}
  self.playerListGO = {}
  self.isPlayerListInited = false
  self.cellItems = {}
end

function UIVoiceRoomView:DataDestroy()
  self.chatRoomId = nil
  self.voiceRoomId = nil
  self.isMicOn = nil
  self.isSpeakerOn = nil
  self.playerDataList = nil
  self.playerListGO = nil
  self.isPlayerListInited = nil
  self.cellItems = nil
end

function UIVoiceRoomView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EnterVoiceRoomVoiceService, self.OnEnterVoiceRoomVoiceService)
  self:AddUIListener(EventId.VoiceRoomMemberUpdate, self.OnVoiceRoomMemberUpdate)
  self:AddUIListener(EventId.VoiceRoomSelfDeviceStatusUpdate, self.OnVoiceRoomSelfDeviceStatusUpdate)
end

function UIVoiceRoomView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.EnterVoiceRoomVoiceService, self.OnEnterVoiceRoomVoiceService)
  self:RemoveUIListener(EventId.VoiceRoomMemberUpdate, self.OnVoiceRoomMemberUpdate)
  self:RemoveUIListener(EventId.VoiceRoomSelfDeviceStatusUpdate, self.OnVoiceRoomSelfDeviceStatusUpdate)
end

function UIVoiceRoomView:OnEnterVoiceRoomVoiceService()
  self:RefreshLocalVoiceState()
end

function UIVoiceRoomView:OnVoiceRoomMemberUpdate(roomId)
  if string.IsNullOrEmpty(self.chatRoomId) then
    return
  end
  if string.IsNullOrEmpty(roomId) or roomId ~= self.chatRoomId then
    return
  end
  self:RefreshPlayerList()
end

function UIVoiceRoomView:OnVoiceRoomSelfDeviceStatusUpdate(roomId)
  if string.IsNullOrEmpty(self.chatRoomId) then
    return
  end
  if string.IsNullOrEmpty(roomId) or roomId ~= self.chatRoomId then
    return
  end
  self:RefreshLocalVoiceState()
end

function UIVoiceRoomView:ReInit()
  self.textTitle:SetLocalText("chat_voice_room_name")
  local chatRoomId, voiceRoomId
  local voiceRoomMgr = ChatManager2 and ChatManager2:GetInstance() and ChatManager2:GetInstance().Voice or nil
  if voiceRoomMgr and voiceRoomMgr.GetCurrentRoomContext then
    chatRoomId, voiceRoomId = voiceRoomMgr:GetCurrentRoomContext()
  end
  self.chatRoomId = chatRoomId
  self.voiceRoomId = voiceRoomId
  local roomMgr = ChatManager2:GetInstance().Room
  local roomData = roomMgr:GetRoomData(chatRoomId)
  if roomData == nil then
    self.textRoomName:SetText("room data is null.")
    return
  end
  local roomName = roomData:getRoomName() or chatRoomId
  self.textRoomName:SetText(roomName)
  Logger.LogInfo(string.format("[VoiceRoomUI][Lua] ReInit, chatRoomId=%s, voiceRoomId=%s", tostring(self.chatRoomId or ""), tostring(self.voiceRoomId or "")))
  self:InitPlayerListScroll()
  self:RefreshLocalVoiceState()
  self:RefreshPlayerList()
end

function UIVoiceRoomView:GetRoomData()
  local chatMgr = ChatManager2 and ChatManager2:GetInstance() or nil
  if not chatMgr then
    return nil
  end
  local voiceRoomMgr = chatMgr.Voice
  local chatRoomId
  if voiceRoomMgr and voiceRoomMgr.GetCurrentChatRoomId then
    chatRoomId = voiceRoomMgr:GetCurrentChatRoomId()
  end
  self.chatRoomId = chatRoomId
  local roomMgr = chatMgr.Room
  if not roomMgr or string.IsNullOrEmpty(chatRoomId) then
    return nil
  end
  return roomMgr:GetRoomData(chatRoomId)
end

function UIVoiceRoomView:RefreshLocalVoiceState()
  self.isMicOn = false
  self.isSpeakerOn = false
  if not self:EnsureInVoiceRoomVoiceService(false) then
    return
  end
  local voiceMgr = self:GetVoiceManager()
  if voiceMgr then
    local sdkMicEnabled, sdkSpeakerEnabled
    if voiceMgr.IsMicEnabled then
      sdkMicEnabled = voiceMgr:IsMicEnabled() and true or false
      self.isMicOn = sdkMicEnabled
    end
    if voiceMgr.IsSpeakerEnabled then
      sdkSpeakerEnabled = voiceMgr:IsSpeakerEnabled() and true or false
      self.isSpeakerOn = sdkSpeakerEnabled
    end
  end
  self:RefreshVoiceBtnState()
end

function UIVoiceRoomView:RefreshVoiceBtnState()
  if self.imgMicBtnOn then
    self.imgMicBtnOn:SetActive(self.isMicOn)
  end
  if self.imgMicBtnOff then
    self.imgMicBtnOff:SetActive(not self.isMicOn)
  end
  if self.imgSpeakBtnOn then
    self.imgSpeakBtnOn:SetActive(self.isSpeakerOn)
  end
  if self.imgSpeakBtnOff then
    self.imgSpeakBtnOff:SetActive(not self.isSpeakerOn)
  end
end

function UIVoiceRoomView:GetVoiceManager()
  return VoiceChatManager and VoiceChatManager.Instance or nil
end

function UIVoiceRoomView:IsInVoiceRoomVoiceService()
  local voiceRoomMgr = ChatManager2 and ChatManager2:GetInstance() and ChatManager2:GetInstance().Voice or nil
  if not voiceRoomMgr or not voiceRoomMgr.IsInVoiceRoomVoiceService then
    return false
  end
  return voiceRoomMgr:IsInVoiceRoomVoiceService(self.chatRoomId)
end

function UIVoiceRoomView:EnsureInVoiceRoomVoiceService(showTip)
  local inService = self:IsInVoiceRoomVoiceService()
  if not inService and showTip then
    UIUtil.ShowTipsId("voice_room_tips9")
  end
  return inService
end

function UIVoiceRoomView:SetMicEnabled(enabled)
  if not self:EnsureInVoiceRoomVoiceService(true) then
    return false
  end
  local voiceRoomMgr = ChatManager2 and ChatManager2:GetInstance() and ChatManager2:GetInstance().Voice or nil
  if voiceRoomMgr and voiceRoomMgr.SetMicEnabled then
    local chatRoomId = voiceRoomMgr.GetCurrentChatRoomId and voiceRoomMgr:GetCurrentChatRoomId() or nil
    self.chatRoomId = chatRoomId
    if string.IsNullOrEmpty(chatRoomId) then
      return false
    end
    local ret = voiceRoomMgr:SetMicEnabled(chatRoomId, enabled and true or false)
    return ret == 0
  end
end

function UIVoiceRoomView:SetSpeakerEnabled(enabled)
  if not self:EnsureInVoiceRoomVoiceService(true) then
    return false
  end
  local voiceMgr = self:GetVoiceManager()
  if not voiceMgr then
    return false
  end
  if enabled == false then
    UIUtil.ShowTipsId("voice_room_tips6")
  else
    UIUtil.ShowTipsId("voice_room_tips7")
  end
  local ret = voiceMgr:SetSpeakerEnabled(enabled and true or false)
  return ret == 0
end

function UIVoiceRoomView:CloseAsMinimize()
  self.ctrl:CloseSelf()
end

function UIVoiceRoomView:CloseAndLeaveVoiceRoom()
  local voiceRoomMgr = ChatManager2 and ChatManager2:GetInstance() and ChatManager2:GetInstance().Voice or nil
  local chatRoomId = self.chatRoomId
  if voiceRoomMgr and voiceRoomMgr.GetCurrentChatRoomId then
    chatRoomId = voiceRoomMgr:GetCurrentChatRoomId()
  end
  if voiceRoomMgr and voiceRoomMgr.ExitVoiceRoom and not string.IsNullOrEmpty(chatRoomId) then
    voiceRoomMgr:RequestLeaveRoom(chatRoomId)
  end
  self.ctrl:CloseSelf()
end

function UIVoiceRoomView:OnBtnBackClick()
  UIUtil.ShowMessage(Localization:GetString("voice_room_tips3"), 2, "btn_minimize", "btn_leave", function()
    self:CloseAsMinimize()
  end, function()
    self:CloseAndLeaveVoiceRoom()
  end)
end

function UIVoiceRoomView:OnBtnMicClick()
  local target = not self.isMicOn
  local success = self:SetMicEnabled(target)
  if success then
    self:RefreshLocalVoiceState()
  end
end

function UIVoiceRoomView:OnBtnSpeakClick()
  local target = not self.isSpeakerOn
  local success = self:SetSpeakerEnabled(target)
  if success then
    self:RefreshLocalVoiceState()
  end
end

function UIVoiceRoomView:CollectPlayerData()
  local list = {}
  local voiceRoomMgr = ChatManager2 and ChatManager2:GetInstance() and ChatManager2:GetInstance().Voice or nil
  if not voiceRoomMgr then
    return list
  end
  local chatRoomId = self.chatRoomId
  if string.IsNullOrEmpty(chatRoomId) and voiceRoomMgr.GetCurrentChatRoomId then
    chatRoomId = voiceRoomMgr:GetCurrentChatRoomId()
    self.chatRoomId = chatRoomId
  end
  if string.IsNullOrEmpty(chatRoomId) then
    return list
  end
  local voiceRoomData = voiceRoomMgr.GetVoiceRoomData and voiceRoomMgr:GetVoiceRoomData(chatRoomId) or nil
  if not voiceRoomData then
    return list
  end
  if type(voiceRoomData.membersList) ~= "table" or type(voiceRoomData.members) ~= "table" then
    return list
  end
  local members = voiceRoomData.members
  for _, uid in ipairs(voiceRoomData.membersList) do
    local member = members[uid]
    if member ~= nil then
      local inVoiceRoom = member.chatService ~= nil and member.chatService.inVoiceRoom == true
      local hasVoiceService = member.voiceService ~= nil
      if inVoiceRoom or hasVoiceService then
        table.insert(list, member)
      end
    end
  end
  return list
end

function UIVoiceRoomView:InitPlayerListScroll()
  if self.isPlayerListInited or not self.itemContentScroll then
    return
  end
  local bindFunc1 = BindCallback(self, self.OnInitPlayerScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdatePlayerScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyPlayerScrollItem)
  self.itemContentScroll:Init(bindFunc1, bindFunc2, bindFunc3)
  self.isPlayerListInited = true
end

function UIVoiceRoomView:OnInitPlayerScroll(go, index)
  local item = self.itemContent:AddComponent(VoiceRoomPlayer, go)
  self.playerListGO[go] = item
end

function UIVoiceRoomView:OnUpdatePlayerScroll(go, index)
  local item = self.playerListGO[go]
  if not item then
    return
  end
  local data = self.playerDataList[index + 1]
  if not data then
    item:SetActive(false)
    self.cellItems[index + 1] = nil
    return
  end
  item:SetData(data)
  item:SetActive(true)
  self.cellItems[index + 1] = item
end

function UIVoiceRoomView:OnDestroyPlayerScrollItem(go, index)
  local oneBasedIndex = index + 1
  self.cellItems[oneBasedIndex] = nil
end

function UIVoiceRoomView:ClearPlayerItems()
  self.playerListGO = {}
  self.cellItems = {}
  self.itemContent:RemoveComponents(VoiceRoomPlayer)
  self.itemContentScroll:DestroyChildNode()
end

function UIVoiceRoomView:RefreshPlayerList()
  self.playerDataList = self:CollectPlayerData()
  self:InitPlayerListScroll()
  if not (self.isPlayerListInited and self.itemContent) or not self.itemContentScroll then
    return
  end
  local itemCount = #self.playerDataList
  self.itemContent:SetActive(0 < itemCount)
  self.itemContentScroll:SetItemCount(itemCount)
end

return UIVoiceRoomView
