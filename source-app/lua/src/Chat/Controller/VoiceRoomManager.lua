local VoiceRoomManager = BaseClass("VoiceRoomManager")
local VoiceChatManager = CS.VoiceChatManager
local VoiceChatRoomType = CS.VoiceChatRoomType
local VoiceChatAppScene = CS.VoiceChatAppScene
local VoiceChatUserEventType = CS.VoiceChatUserEventType
local VoiceRoomData = require("Chat.Model.VoiceRoomData")

function VoiceRoomManager:__init()
  self.voiceManager = VoiceChatManager and VoiceChatManager.Instance or nil
  self.isBoundCallbacks = false
  self.onEnterRoomCompletedHandler = nil
  self.onExitRoomCompletedHandler = nil
  self.onRoomDisconnectedHandler = nil
  self.onUserUpdatedHandler = nil
  self.onCustomEventReceivedHandler = nil
  self.lastEnterRoomResult = nil
  self.lastDisconnectResult = nil
  self.lastUserUpdate = nil
  self.lastCustomEvent = nil
  self.currentChatRoomId = nil
  self.currentVoiceRoomId = nil
  self.inVoiceServiceRoom = false
  self.voiceRoomList = {}
  self.voiceRoomDataMap = {}
  self.joinRoomCmdPending = false
  self.joinRoomCmdPendingChatRoomId = nil
  self.pendingPrivacyAgreementRoomId = nil
  self.audioOnList = {}
  self:BindCallbacks()
  self:AddListener()
end

function VoiceRoomManager:__delete()
  self:RemoveListener()
  self:UnbindCallbacks()
end

function VoiceRoomManager:BindCallbacks()
  local voiceMgr = self.voiceManager
  if not voiceMgr or self.isBoundCallbacks then
    return
  end
  
  function self.onEnterRoomCompletedHandler(result)
    self:OnEnterRoomCompleted(result)
  end
  
  function self.onExitRoomCompletedHandler(result)
    self:OnExitRoomCompleted(result)
  end
  
  function self.onRoomDisconnectedHandler(result)
    self:OnRoomDisconnected(result)
  end
  
  function self.onUserUpdatedHandler(update)
    self:OnUserUpdated(update)
  end
  
  function self.onCustomEventReceivedHandler(evt)
    self:OnCustomEventReceived(evt)
  end
  
  voiceMgr:AddEnterRoomCompletedListener(self.onEnterRoomCompletedHandler)
  voiceMgr:AddExitRoomCompletedListener(self.onExitRoomCompletedHandler)
  voiceMgr:AddRoomDisconnectedListener(self.onRoomDisconnectedHandler)
  voiceMgr:AddUserUpdatedListener(self.onUserUpdatedHandler)
  voiceMgr:AddCustomEventReceivedListener(self.onCustomEventReceivedHandler)
  self.isBoundCallbacks = true
end

function VoiceRoomManager:AddListener()
  EventManager:GetInstance():AddListenerWithSelf(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_RESULT, self.OnRequestHistoryMsgResult, self)
end

function VoiceRoomManager:RemoveListener()
  EventManager:GetInstance():RemoveListener2(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_RESULT, self.OnRequestHistoryMsgResult, self)
end

function VoiceRoomManager:UnbindCallbacks()
  local voiceMgr = self.voiceManager
  if not voiceMgr or not self.isBoundCallbacks then
    return
  end
  if self.onEnterRoomCompletedHandler then
    voiceMgr:RemoveEnterRoomCompletedListener(self.onEnterRoomCompletedHandler)
  end
  if self.onExitRoomCompletedHandler then
    voiceMgr:RemoveExitRoomCompletedListener(self.onExitRoomCompletedHandler)
  end
  if self.onRoomDisconnectedHandler then
    voiceMgr:RemoveRoomDisconnectedListener(self.onRoomDisconnectedHandler)
  end
  if self.onUserUpdatedHandler then
    voiceMgr:RemoveUserUpdatedListener(self.onUserUpdatedHandler)
  end
  if self.onCustomEventReceivedHandler then
    voiceMgr:RemoveCustomEventReceivedListener(self.onCustomEventReceivedHandler)
  end
  self.onEnterRoomCompletedHandler = nil
  self.onExitRoomCompletedHandler = nil
  self.onRoomDisconnectedHandler = nil
  self.onUserUpdatedHandler = nil
  self.onCustomEventReceivedHandler = nil
  self.isBoundCallbacks = false
end

function VoiceRoomManager:ClearCurrentRoomContext()
  Logger.Log(string.format("[VoiceChat][Lua] ClearCurrentRoomContext, chatRoomId=%s, %s", tostring(self.currentChatRoomId or ""), debug.traceback()))
  self.currentChatRoomId = nil
  self.currentVoiceRoomId = nil
  self.inVoiceServiceRoom = false
  self.audioOnList = {}
  EventManager:GetInstance():Broadcast(EventId.VoiceRoomAudioChange, nil)
end

function VoiceRoomManager:GetVoiceRoomData(chatRoomId)
  if string.IsNullOrEmpty(chatRoomId) then
    return nil
  end
  return self.voiceRoomDataMap[chatRoomId]
end

function VoiceRoomManager:SetVoiceRoomData(chatRoomId, voiceRoomData)
  if string.IsNullOrEmpty(chatRoomId) then
    return
  end
  self.voiceRoomDataMap[chatRoomId] = voiceRoomData
end

function VoiceRoomManager:ClearVoiceRoomData(chatRoomId)
  if string.IsNullOrEmpty(chatRoomId) then
    return
  end
  self.voiceRoomDataMap[chatRoomId] = nil
end

function VoiceRoomManager:GetVoiceRoomId(chatRoomId)
  local voiceRoomData = self:GetVoiceRoomData(chatRoomId)
  return voiceRoomData and voiceRoomData.roomid or nil
end

function VoiceRoomManager:InitVoiceRoomData(chatRoomId, voiceRoomId, playerSig, sdkAppId, currentPlayerInfoList)
  if string.IsNullOrEmpty(chatRoomId) or string.IsNullOrEmpty(voiceRoomId) or string.IsNullOrEmpty(playerSig) then
    return nil
  end
  local voiceRoomData = self:GetVoiceRoomData(chatRoomId)
  if voiceRoomData == nil then
    voiceRoomData = VoiceRoomData.New(voiceRoomId, playerSig, sdkAppId)
    self:SetVoiceRoomData(chatRoomId, voiceRoomData)
  else
    voiceRoomData:SetRoomId(voiceRoomId)
    voiceRoomData:SetUserSig(playerSig)
    voiceRoomData:SetSdkAppId(sdkAppId)
  end
  if type(currentPlayerInfoList) ~= "table" then
    return voiceRoomData
  end
  local keepUidMap = {}
  for _, info in pairs(currentPlayerInfoList) do
    local uid = info and info.uid or nil
    if not string.IsNullOrEmpty(uid) then
      keepUidMap[uid] = true
      local member = voiceRoomData:GetOrCreateMemberInfo(uid)
      if member then
        member.chatService = {
          isOwner = info.isOwner == true,
          isAdmin = info.isAdmin == true,
          isCommander = info.canOpenMic == true,
          inVoiceRoom = info.inVoiceRoom == true,
          canOpenMic = info.canOpenMic == true
        }
      end
    end
  end
  local membersList = voiceRoomData.membersList or {}
  local membersMap = voiceRoomData.members or {}
  for i = #membersList, 1, -1 do
    local uid = membersList[i]
    if not keepUidMap[uid] then
      membersMap[uid] = nil
      table.remove(membersList, i)
    end
  end
  voiceRoomData:RefreshOnlinePlayerCount()
  return voiceRoomData
end

function VoiceRoomManager:AddVoiceRoom(chatRoomId)
  if string.IsNullOrEmpty(chatRoomId) then
    return
  end
  if self:HasVoiceRoomID(chatRoomId) then
    return
  end
  table.insert(self.voiceRoomList, chatRoomId)
  EventManager:GetInstance():Broadcast(EventId.ShowBFVoiceRoom)
  local voiceRoomData = self:GetVoiceRoomData(chatRoomId)
  if voiceRoomData ~= nil then
    self:JoinVoiceRoom(chatRoomId)
  end
  Logger.Log(string.format("[VoiceChat][Lua] AddVoiceRoom ChatService, chatRoomId=%s", tostring(chatRoomId or "")))
end

function VoiceRoomManager:RemoveVoiceRoom(chatRoomId)
  if string.IsNullOrEmpty(chatRoomId) then
    return
  end
  if chatRoomId == self.currentChatRoomId then
    self:ExitVoiceRoom(chatRoomId)
    self:ClearCurrentRoomContext()
  end
  local remove_count = table.removebyvalue(self.voiceRoomList, chatRoomId)
  if 0 < remove_count then
    local roomCount = #self.voiceRoomList
    if roomCount <= 0 then
      EventManager:GetInstance():Broadcast(EventId.HideBFVoiceRoom)
    end
    Logger.Log(string.format("[VoiceChat][Lua] RemoveVoiceRoom ChatService, chatRoomId=%s", tostring(chatRoomId or "")))
  end
end

function VoiceRoomManager:HasVoiceRoomID(chatRoomId)
  if string.IsNullOrEmpty(chatRoomId) then
    return false
  end
  return table.hasvalue(self.voiceRoomList, chatRoomId)
end

function VoiceRoomManager:HasVoiceRoom()
  return #self.voiceRoomList > 0
end

function VoiceRoomManager:GetVoiceRoomList()
  return self.voiceRoomList
end

function VoiceRoomManager:GetCurrentRoomContext()
  return self.currentChatRoomId, self.currentVoiceRoomId
end

function VoiceRoomManager:GetCurrentChatRoomId()
  return self.currentChatRoomId
end

function VoiceRoomManager:GetCurrentVoiceRoomId()
  return self.currentVoiceRoomId
end

function VoiceRoomManager:IsInVoiceRoomVoiceService(chatRoomId)
  local targetChatRoomId = chatRoomId
  if string.IsNullOrEmpty(targetChatRoomId) then
    return false
  end
  if targetChatRoomId ~= self.currentChatRoomId then
    return false
  end
  if string.IsNullOrEmpty(self.currentVoiceRoomId) then
    return false
  end
  local voiceRoomData = self:GetVoiceRoomData(targetChatRoomId)
  if not voiceRoomData then
    return false
  end
  return self.inVoiceServiceRoom
end

function VoiceRoomManager:IsJoinRoomCmdPending(chatRoomId)
  if not self.joinRoomCmdPending then
    return false
  end
  if string.IsNullOrEmpty(chatRoomId) then
    return true
  end
  return self.joinRoomCmdPendingChatRoomId == chatRoomId
end

function VoiceRoomManager:GetRoomData(chatRoomId)
  local targetChatRoomId = chatRoomId
  if string.IsNullOrEmpty(targetChatRoomId) then
    return nil
  end
  local roomMgr = ChatManager2:GetInstance().Room
  if not roomMgr then
    return nil
  end
  return roomMgr:GetRoomData(targetChatRoomId)
end

function VoiceRoomManager:RequestUpdateRoomPermission(roomId, voiceRoomId, currentPlayerInfo)
end

function VoiceRoomManager:BuildJoinRoomMockResult(roomId)
  local roomMgr = ChatManager2:GetInstance().Room
  local roomData = roomMgr and roomMgr:GetRoomData(roomId) or nil
  if not roomData then
    return nil
  end
  local ownerUid = roomData.owner
  local selfUid = ChatInterface and ChatInterface.getPlayerUid and ChatInterface.getPlayerUid() or LuaEntry.Player.uid
  local memberList = {}
  table.insert(memberList, selfUid)
  if #memberList == 0 then
    memberList = roomData.getMemberList and roomData:getMemberList() or {}
  end
  local currentPlayerInfoList = {}
  for _, uid in pairs(memberList) do
    if not string.IsNullOrEmpty(uid) then
      table.insert(currentPlayerInfoList, {
        uid = uid,
        isOwner = uid == ownerUid,
        isAdmin = false,
        isCommander = false,
        canOpenMic = true,
        inVoiceRoom = true
      })
    end
  end
  return {
    roomId = roomId,
    voiceRoomId = roomId,
    playerSig = "mock_player_sig",
    currentPlayerInfoList = currentPlayerInfoList
  }
end

function VoiceRoomManager:RequestJoinRoom(roomId)
  if string.IsNullOrEmpty(roomId) then
    Logger.LogError("[VoiceChat][Lua] RequestJoinRoom failed, ret=-1, roomId is empty")
    return -1
  end
  if self:IsJoinRoomCmdPending(roomId) then
    Logger.LogError(string.format("[VoiceChat][Lua] RequestJoinRoom failed, ret=-2, pendingRoomId=%s, requestRoomId=%s", tostring(self.joinRoomCmdPendingChatRoomId or ""), tostring(roomId or "")))
    return -2
  end
  local voiceMgr = self.voiceManager
  if voiceMgr and voiceMgr.IsRoomOpPending then
    UIUtil.ShowTipsId("voice_room_tips10")
    Logger.LogError(string.format("[VoiceChat][Lua] RequestJoinRoom failed, ret=-3, IsRoomOpPending=true, roomId=%s", tostring(roomId or "")))
    return -3
  end
  if CoppaUtil.IsCoppaLimitWithTips() then
    return
  end
  if CS.StringUtils.VersionCompare(CS.GameEntry.Sdk.Version, "1.0.341") < 0 then
    UIUtil.ShowTipsId("season_alliance_photo_tips_31")
    return
  end
  self.joinRoomCmdPending = true
  self.joinRoomCmdPendingChatRoomId = roomId
  Logger.LogInfo("[VoiceChat][Lua] RequestJoinRoom ChatService")
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.VoiceJoinRoom, roomId)
  return 0
end

function VoiceRoomManager:RequestLeaveRoom(roomId)
  if string.IsNullOrEmpty(roomId) then
    Logger.LogError("[VoiceChat][Lua] RequestLeaveRoom failed, ret=-1, roomId is empty")
    return -1
  end
  local voiceMgr = self.voiceManager
  if voiceMgr and voiceMgr.IsRoomOpPending then
    UIUtil.ShowTipsId("voice_room_tips10")
    Logger.LogError(string.format("[VoiceChat][Lua] RequestLeaveRoom failed, ret=-2, IsRoomOpPending=true, roomId=%s", tostring(roomId or "")))
    return -2
  end
  Logger.LogInfo("[VoiceChat][Lua] RequestLeaveRoom ChatService")
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.VoiceLeaveRoom, roomId)
  return 0
end

function VoiceRoomManager:ApplyVoicePermissionInfo(chatRoomId, info)
  if type(info) ~= "table" then
    return
  end
  local uid = info.uid
  if string.IsNullOrEmpty(uid) then
    return
  end
  local voiceRoomData = self:GetVoiceRoomData(chatRoomId)
  if not voiceRoomData then
    return
  end
  voiceRoomData:SetChatServiceMemberInfo(uid, info)
end

function VoiceRoomManager:ApplyVoicePermissionInfoList(chatRoomId, infoList, isLeave)
  if type(infoList) ~= "table" then
    return
  end
  for _, info in pairs(infoList) do
    local uid = info and info.uid or nil
    if not string.IsNullOrEmpty(uid) then
      if isLeave then
        local voiceRoomData = self:GetVoiceRoomData(chatRoomId)
        if voiceRoomData then
          voiceRoomData:RemoveChatServiceMember(uid)
        end
      else
        self:ApplyVoicePermissionInfo(chatRoomId, info)
      end
    end
  end
end

function VoiceRoomManager:OnVoiceUpdateRoomInfoResult(result)
  if type(result) ~= "table" then
    return
  end
  local roomId = result.roomId
  if string.IsNullOrEmpty(roomId) then
    return
  end
  local roomData = self:GetRoomData(roomId)
  if not roomData then
    return
  end
  local voiceRoomData = self:GetVoiceRoomData(roomId)
  if not voiceRoomData then
    return
  end
  self:ApplyVoicePermissionInfoList(roomId, result.updateVoiceMemberList, false)
  self:ApplyVoicePermissionInfoList(roomId, result.addVoiceMemberList, false)
  self:ApplyVoicePermissionInfoList(roomId, result.removeVoiceMemberList, true)
  local selfPlayerId = LuaEntry.Player.uid
  local updateVoiceMemberList = result.updateVoiceMemberList
  if updateVoiceMemberList ~= nil then
    for _, memberInfo in ipairs(updateVoiceMemberList) do
      if memberInfo.uid == selfPlayerId then
        if memberInfo.canOpenMic == false then
          self:SetMicEnabled(roomId, false)
        end
        break
      end
    end
  end
  voiceRoomData:RefreshOnlinePlayerCount()
  EventManager:GetInstance():Broadcast(EventId.VoiceRoomMemberUpdate, roomId)
end

function VoiceRoomManager:OnVoiceJoinRoomResult(result)
  self.joinRoomCmdPending = false
  self.joinRoomCmdPendingChatRoomId = nil
  if type(result) ~= "table" then
    return
  end
  local roomId = result.roomId
  if string.IsNullOrEmpty(roomId) then
    return
  end
  local roomMgr = ChatManager2:GetInstance().Room
  local roomData = roomMgr and roomMgr:GetRoomData(roomId) or nil
  if not roomData then
    return
  end
  if result.agreeProtocol == false then
    self.pendingPrivacyAgreementRoomId = roomId
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVoicePrivacyBox, {anim = true})
    return
  end
  local voiceRoomInfo = result.voiceRoomInfo
  if type(voiceRoomInfo) ~= "table" then
    Logger.LogError(string.format("[VoiceChat][Lua] OnVoiceJoinRoomResult failed, voiceRoomInfo invalid, roomId=%s", tostring(roomId or "")))
    return
  end
  self.pendingPrivacyAgreementRoomId = nil
  self:InitVoiceRoomData(roomId, voiceRoomInfo.voiceRoomId, voiceRoomInfo.playerSig, voiceRoomInfo.sdkAppId, voiceRoomInfo.voiceMemberList)
  local joinRet = self:JoinVoiceRoom(roomId)
  if joinRet ~= 0 then
    Logger.LogError(string.format("[VoiceChat][Lua] OnVoiceJoinRoomResult join failed, roomId=%s, ret=%s", tostring(roomId or ""), tostring(joinRet)))
    return
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVoiceRoom, {anim = true})
    EventManager:GetInstance():Broadcast(EventId.EnterVoiceRoom, roomId)
  end
end

function VoiceRoomManager:AcceptPrivacyPolicyEnterVoiceRoom()
  local roomId = self.pendingPrivacyAgreementRoomId
  if string.IsNullOrEmpty(roomId) then
    return
  end
  if self:IsJoinRoomCmdPending(roomId) then
    return
  end
  local voiceMgr = self.voiceManager
  if voiceMgr and voiceMgr.IsRoomOpPending then
    UIUtil.ShowTipsId("voice_room_tips10")
    Logger.LogError(string.format("[VoiceChat][Lua] AcceptPrivacyPolicyEnterVoiceRoom failed, IsRoomOpPending=true, roomId=%s", tostring(roomId or "")))
    return
  end
  self.joinRoomCmdPending = true
  self.joinRoomCmdPendingChatRoomId = roomId
  self.pendingPrivacyAgreementRoomId = nil
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.VoiceJoinRoom, roomId, true)
end

function VoiceRoomManager:ClearEnterVoiceRoomPending()
  self.joinRoomCmdPending = false
  self.joinRoomCmdPendingChatRoomId = nil
  self.pendingPrivacyAgreementRoomId = nil
end

function VoiceRoomManager:OnVoiceLeaveRoomResult(result)
  if type(result) ~= "table" then
    return
  end
  local roomId = result.roomId
  local leaveSuccess = result.leaveSuccess == true
  if not leaveSuccess then
    return
  end
  self:ExitVoiceRoom(roomId)
  if string.IsNullOrEmpty(roomId) or roomId == self.currentChatRoomId then
    self:ClearCurrentRoomContext()
  end
  EventManager:GetInstance():Broadcast(EventId.ExitVoiceRoom, roomId)
end

function VoiceRoomManager:OnRequestHistoryMsgResult(_)
  local chatMgr = ChatManager2:GetInstance()
  local roomMgr = chatMgr and chatMgr.Room or nil
  if not roomMgr then
    return
  end
  local joinedRoomId = self.currentChatRoomId
  if string.IsNullOrEmpty(joinedRoomId) then
    return
  end
  local joinedRoomData = roomMgr:GetRoomData(joinedRoomId)
  local hasVoice = joinedRoomData and joinedRoomData.HasVoiceRoomFeature and joinedRoomData:HasVoiceRoomFeature() or false
  local hasVoiceRoomData = self:GetVoiceRoomData(joinedRoomId) ~= nil
  if not hasVoice or not hasVoiceRoomData then
    self:ExitVoiceRoom(joinedRoomId)
    self:ClearCurrentRoomContext()
  end
end

function VoiceRoomManager:EnsureVoiceInitialized(voiceMgr, chatRoomId)
  if not voiceMgr then
    Logger.LogError("[VoiceChat][Lua] EnsureVoiceInitialized failed, ret=-4, voiceMgr is nil")
    return -4
  end
  if voiceMgr.IsInitialized then
    return 0
  end
  local sdkAppId = ""
  if not string.IsNullOrEmpty(chatRoomId) then
    local voiceRoomData = self:GetVoiceRoomData(chatRoomId)
    sdkAppId = voiceRoomData and voiceRoomData:GetSdkAppId() or ""
  end
  local openId
  if ChatInterface and ChatInterface.getPlayerUid then
    openId = ChatInterface.getPlayerUid()
  end
  if string.IsNullOrEmpty(openId) and LuaEntry and LuaEntry.Player and LuaEntry.Player.uid then
    openId = tostring(LuaEntry.Player.uid)
  end
  if string.IsNullOrEmpty(openId) then
    Logger.LogError("[VoiceChat][Lua] EnsureVoiceInitialized failed, ret=-8, openId is empty")
    return -8
  end
  local appScene = VoiceChatAppScene and tonumber(VoiceChatAppScene.Rtc) or 2
  return voiceMgr:InitWithParams(sdkAppId, openId, appScene, true, false)
end

function VoiceRoomManager:JoinVoiceRoom(chatRoomId)
  if string.IsNullOrEmpty(chatRoomId) then
    Logger.LogError("[VoiceChat][Lua] JoinVoiceRoom failed, ret=-1, chatRoomId is empty")
    return -1
  end
  local roomMgr = ChatManager2:GetInstance().Room
  local roomData = roomMgr and roomMgr:GetRoomData(chatRoomId) or nil
  if not roomData then
    Logger.LogError(string.format("[VoiceChat][Lua] JoinVoiceRoom failed, ret=-2, roomData not found, chatRoomId=%s", tostring(chatRoomId or "")))
    return -2
  end
  if not roomData.HasVoiceRoomFeature or not roomData:HasVoiceRoomFeature() then
    Logger.LogError(string.format("[VoiceChat][Lua] JoinVoiceRoom failed, ret=-3, room has no voice feature, chatRoomId=%s", tostring(chatRoomId or "")))
    return -3
  end
  local voiceMgr = self.voiceManager
  if not voiceMgr then
    Logger.LogError(string.format("[VoiceChat][Lua] JoinVoiceRoom failed, ret=-4, voiceMgr is nil, chatRoomId=%s", tostring(chatRoomId or "")))
    return -4
  end
  self:BindCallbacks()
  local initRet = self:EnsureVoiceInitialized(voiceMgr, chatRoomId)
  if initRet ~= 0 then
    Logger.LogError(string.format("[VoiceChat][Lua] JoinVoiceRoom failed, ret=-5, initRet=%s, chatRoomId=%s", tostring(initRet), tostring(chatRoomId or "")))
    return -5
  end
  local voiceRoomId = self:GetVoiceRoomId(chatRoomId)
  if voiceRoomId == nil then
    Logger.LogError(string.format("[VoiceChat][Lua] JoinVoiceRoom failed, ret=-6, voiceRoomId is nil, chatRoomId=%s", tostring(chatRoomId or "")))
    return -6
  end
  Logger.LogInfo(string.format("[VoiceChat][Lua] JoinVoiceRoom VoiceService, chatRoomId=%s, voiceRoomId=%s", tostring(chatRoomId or ""), tostring(voiceRoomId or "")))
  local voiceRoomData = self:GetVoiceRoomData(chatRoomId)
  local userSig = voiceRoomData and voiceRoomData:GetUserSig() or nil
  if string.IsNullOrEmpty(userSig) then
    Logger.LogError(string.format("[VoiceChat][Lua] JoinVoiceRoom failed, ret=-7, userSig is empty, chatRoomId=%s, voiceRoomId=%s", tostring(chatRoomId or ""), tostring(voiceRoomId or "")))
    return -7
  end
  self.currentChatRoomId = chatRoomId
  self.currentVoiceRoomId = voiceRoomId
  local roomType = VoiceChatRoomType and tonumber(VoiceChatRoomType.Standard) or 2
  return voiceMgr:EnterRoom(chatRoomId, voiceRoomId, roomType, userSig)
end

function VoiceRoomManager:ExitVoiceRoom(chatRoomId)
  local voiceMgr = self.voiceManager
  if not voiceMgr then
    Logger.LogError(string.format("[VoiceChat][Lua] ExitVoiceRoom failed, ret=-1, voiceMgr is nil, chatRoomId=%s", tostring(chatRoomId or "")))
    return -1
  end
  self:BindCallbacks()
  if not voiceMgr.IsInitialized then
    Logger.LogError(string.format("[VoiceChat][Lua] ExitVoiceRoom failed, ret=-2, voiceMgr not initialized, chatRoomId=%s", tostring(chatRoomId or "")))
    return -2
  end
  Logger.LogInfo(string.format("[VoiceChat][Lua] ExitVoiceRoom VoiceService, chatRoomId=%s", tostring(chatRoomId or "")))
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIVoiceRoom)
  return voiceMgr:ExitRoom()
end

function VoiceRoomManager:SetMicEnabled(chatRoomId, enabled)
  if string.IsNullOrEmpty(chatRoomId) then
    Logger.LogError("[VoiceChat][Lua] SetMicEnabled failed, ret=-1, chatRoomId is empty")
    return -1
  end
  local roomMgr = ChatManager2:GetInstance().Room
  local roomData = roomMgr and roomMgr:GetRoomData(chatRoomId) or nil
  if not roomData then
    Logger.LogError(string.format("[VoiceChat][Lua] SetMicEnabled failed, ret=-2, roomData not found, chatRoomId=%s", tostring(chatRoomId or "")))
    return -2
  end
  local voiceRoomData = self:GetVoiceRoomData(chatRoomId)
  if not voiceRoomData then
    Logger.LogError(string.format("[VoiceChat][Lua] SetMicEnabled failed, ret=-2, voiceRoomData not found, chatRoomId=%s", tostring(chatRoomId or "")))
    return -2
  end
  local selfPlayerId = LuaEntry.Player.uid
  local selfMemberInfo = voiceRoomData.members and voiceRoomData.members[selfPlayerId] or nil
  local selfCanOpenMic = selfMemberInfo and selfMemberInfo.chatService and selfMemberInfo.chatService.canOpenMic == true or false
  if not selfCanOpenMic and enabled == true then
    UIUtil.ShowTipsId("voice_room_tips4")
    Logger.LogError(string.format("[VoiceChat][Lua] SetMicEnabled skip, selfCanOpenMic=%s, chatRoomId=%s", tostring(selfCanOpenMic), tostring(chatRoomId or "")))
    return -5
  end
  local voiceMgr = self.voiceManager
  if not voiceMgr then
    Logger.LogError(string.format("[VoiceChat][Lua] SetMicEnabled failed, ret=-3, voiceMgr is nil, chatRoomId=%s", tostring(chatRoomId or "")))
    return -3
  end
  self:BindCallbacks()
  if not voiceMgr.IsInitialized then
    Logger.LogError(string.format("[VoiceChat][Lua] SetMicEnabled failed, ret=-4, voiceMgr not initialized, chatRoomId=%s", tostring(chatRoomId or "")))
    return -4
  end
  local ret = voiceMgr:SetMicEnabled(enabled and true or false)
  return ret
end

function VoiceRoomManager:OnEnterRoomCompleted(result)
  self.lastEnterRoomResult = result
  local chatRoomId = result and result.ChatRoomId or nil
  local voiceRoomId = result and result.VoiceRoomId or nil
  local enterResult = result and result.Result or nil
  Logger.LogInfo(string.format("[VoiceChat][Lua] OnEnterRoomCompleted VoiceService, result=%s, chatRoomId=%s, voiceRoomId=%s", tostring(enterResult or ""), tostring(chatRoomId or ""), tostring(voiceRoomId or "")))
  if string.IsNullOrEmpty(chatRoomId) then
    return
  end
  if enterResult ~= nil and enterResult ~= 0 then
    Logger.LogError(string.format("[VoiceChat][Lua] OnEnterRoomCompleted failed, skip open UIVoiceRoom, chatRoomId=%s, result=%s", tostring(chatRoomId or ""), tostring(enterResult)))
    return
  end
  self.currentChatRoomId = chatRoomId
  self.currentVoiceRoomId = voiceRoomId
  self.inVoiceServiceRoom = true
  EventManager:GetInstance():Broadcast(EventId.EnterVoiceRoomVoiceService, chatRoomId)
  DataCenter.LWSoundManager:ChangeAllVolumeRatioToHalf()
  PostEventLog.Track("c_voice_room_enter")
end

function VoiceRoomManager:OnExitRoomCompleted(result)
  local chatRoomId = result and result.ChatRoomId or nil
  local voiceRoomId = result and result.VoiceRoomId or nil
  local exitResult = result and result.Result or nil
  Logger.LogInfo(string.format("[VoiceChat][Lua] OnExitRoomCompleted VoiceService, result=%s, chatRoomId=%s, voiceRoomId=%s", tostring(exitResult or ""), tostring(chatRoomId or ""), tostring(voiceRoomId or "")))
  if string.IsNullOrEmpty(chatRoomId) then
    return
  end
  if exitResult ~= nil and exitResult ~= 0 then
    Logger.LogError(string.format("[VoiceChat][Lua] OnExitRoomCompleted failed, chatRoomId=%s, result=%s", tostring(chatRoomId or ""), tostring(exitResult)))
    return
  end
  self:ClearVoiceRoomData(chatRoomId)
  self:ClearCurrentRoomContext()
  EventManager:GetInstance():Broadcast(EventId.ExitVoiceRoomVoiceService, chatRoomId)
  DataCenter.LWSoundManager:RestoreAllVolumeRatioFromSetting()
end

function VoiceRoomManager:OnRoomDisconnected(result)
  self.lastDisconnectResult = result
  local chatRoomId = result and result.ChatRoomId or nil
  if string.IsNullOrEmpty(chatRoomId) then
    return
  end
  local roomMgr = ChatManager2:GetInstance().Room
  local roomData = roomMgr and roomMgr:GetRoomData(chatRoomId) or nil
  if not roomData then
    return
  end
  local voiceRoomData = self:GetVoiceRoomData(chatRoomId)
  if not voiceRoomData then
    return
  end
  for uid, _ in pairs(voiceRoomData.members or {}) do
    voiceRoomData:RemoveVoiceServiceMember(uid)
  end
  self:ClearCurrentRoomContext()
end

function VoiceRoomManager:GetUpdateUserIds(update)
  local userIds = {}
  if not update or not update.UserIds then
    return userIds
  end
  local arr = update.UserIds
  if arr.Length then
    for i = 0, arr.Length - 1 do
      local uid = arr[i]
      if uid and uid ~= "" then
        table.insert(userIds, uid)
      end
    end
  else
    for _, uid in pairs(arr) do
      if uid and uid ~= "" then
        table.insert(userIds, uid)
      end
    end
  end
  return userIds
end

function VoiceRoomManager:OnUserUpdated(update)
  self.lastUserUpdate = update
  local chatRoomId = update and update.ChatRoomId or nil
  if string.IsNullOrEmpty(chatRoomId) then
    Logger.LogInfo(string.format("[VoiceChat][Lua] OnUserUpdated ignore, chatRoomId is empty, voiceRoomId=%s", tostring(self.currentVoiceRoomId or "")))
    return
  end
  local roomMgr = ChatManager2:GetInstance().Room
  local roomData = roomMgr and roomMgr:GetRoomData(chatRoomId) or nil
  local voiceRoomId = self:GetVoiceRoomId(chatRoomId) or self.currentVoiceRoomId
  local voiceRoomData = self:GetVoiceRoomData(chatRoomId)
  if not roomData or not voiceRoomData then
    Logger.LogInfo(string.format("[VoiceChat][Lua] OnUserUpdated ignore, roomData invalid, chatRoomId=%s, voiceRoomId=%s", tostring(chatRoomId or ""), tostring(voiceRoomId or "")))
    return
  end
  local userIds = self:GetUpdateUserIds(update)
  if #userIds == 0 then
    Logger.LogInfo(string.format("[VoiceChat][Lua] OnUserUpdated ignore, no userIds, chatRoomId=%s, voiceRoomId=%s, eventType=%s", tostring(chatRoomId or ""), tostring(voiceRoomId or ""), tostring(update and update.EventType or "")))
    return
  end
  local eventType = update and update.EventType or VoiceChatUserEventType.Unknown
  Logger.LogInfo(string.format("[VoiceChat][Lua] OnUserUpdated, chatRoomId=%s, voiceRoomId=%s, eventType=%s, userIds=%s", tostring(chatRoomId or ""), tostring(voiceRoomId or ""), tostring(eventType), table.concat(userIds, ",")))
  local hasAudioChanged = false
  local hasSelfMicEvent = false
  local hasSelfMicOnEvent = false
  for _, uid in ipairs(userIds) do
    if eventType == VoiceChatUserEventType.UserEnter then
      voiceRoomData:GetOrCreateVoiceServiceInfo(uid)
    elseif eventType == VoiceChatUserEventType.UserExit then
      voiceRoomData:RemoveVoiceServiceMember(uid)
    elseif eventType == VoiceChatUserEventType.UserMicOpened then
      voiceRoomData:SetVoiceServiceMemberInfo(uid, {isMicOn = true})
      if uid == LuaEntry.Player.uid then
        hasSelfMicEvent = true
        hasSelfMicOnEvent = true
      end
    elseif eventType == VoiceChatUserEventType.UserMicClosed then
      voiceRoomData:SetVoiceServiceMemberInfo(uid, {isMicOn = false})
      if uid == LuaEntry.Player.uid then
        hasSelfMicEvent = true
      end
    elseif eventType == VoiceChatUserEventType.UserHasAudio then
      voiceRoomData:SetVoiceServiceMemberInfo(uid, {isSpeaking = true})
      self:AddPlayerAudioOn(uid)
      hasAudioChanged = true
    elseif eventType == VoiceChatUserEventType.UserNoAudio then
      voiceRoomData:SetVoiceServiceMemberInfo(uid, {isSpeaking = false})
      self:RemovePlayerAudioOn(uid)
      hasAudioChanged = true
    end
  end
  if hasAudioChanged then
    EventManager:GetInstance():Broadcast(EventId.VoiceRoomAudioChange)
  end
  EventManager:GetInstance():Broadcast(EventId.VoiceRoomMemberUpdate, chatRoomId)
  if hasSelfMicEvent then
    Logger.LogInfo(string.format("[VoiceChat][Lua] OnUserUpdated hasSelfMicEvent, chatRoomId=%s, voiceRoomId=%s, eventType=%s, userIds=%s", tostring(chatRoomId or ""), tostring(voiceRoomId or ""), tostring(eventType), table.concat(userIds, ",")))
    EventManager:GetInstance():Broadcast(EventId.VoiceRoomSelfDeviceStatusUpdate, chatRoomId)
    if hasSelfMicOnEvent then
      PostEventLog.Track("c_voice_room_mic_on")
    end
  end
end

function VoiceRoomManager:AddPlayerAudioOn(uid)
  if string.IsNullOrEmpty(uid) then
    return
  end
  table.removebyvalue(self.audioOnList, uid)
  table.insert(self.audioOnList, uid)
end

function VoiceRoomManager:RemovePlayerAudioOn(uid)
  if string.IsNullOrEmpty(uid) then
    return
  end
  table.removebyvalue(self.audioOnList, uid)
end

function VoiceRoomManager:GetLastAudioOn()
  if string.IsNullOrEmpty(self.currentChatRoomId) then
    return nil
  end
  local count = #self.audioOnList
  if 0 < count then
    return self.audioOnList[count], true
  end
  local voiceRoomData = self:GetVoiceRoomData(self.currentChatRoomId)
  if not voiceRoomData then
    return nil
  end
  local membersList = voiceRoomData.membersList
  count = #membersList
  if 0 < count then
    local membersMap = voiceRoomData.members or {}
    for i = count, 1, -1 do
      local uid = membersList[i]
      local member = uid and membersMap[uid] or nil
      local chatService = member and member.chatService or nil
      if chatService and chatService.inVoiceRoom == true then
        return uid, false
      end
    end
  end
  return nil, false
end

function VoiceRoomManager:OnCustomEventReceived(evt)
  self.lastCustomEvent = evt
end

return VoiceRoomManager
