local VoiceRoomData = BaseClass("VoiceRoomData")

function VoiceRoomData:__init(roomid, userSig, sdkAppId)
  self:SetRoomId(roomid)
  self:SetUserSig(userSig)
  self:SetSdkAppId(sdkAppId)
  self.membersList = {}
  self.members = {}
  self.onlinePlayerCount = 0
end

function VoiceRoomData:SetRoomId(roomid)
  if type(roomid) == "string" and roomid ~= "" then
    self.roomid = roomid
  else
    self.roomid = nil
  end
end

function VoiceRoomData:SetUserSig(userSig)
  if type(userSig) == "string" then
    self.userSig = userSig
  else
    self.userSig = ""
  end
end

function VoiceRoomData:GetUserSig()
  return self.userSig
end

function VoiceRoomData:SetSdkAppId(sdkAppId)
  if type(sdkAppId) == "string" then
    self.sdkAppId = sdkAppId
  else
    self.sdkAppId = tostring(sdkAppId)
  end
end

function VoiceRoomData:GetSdkAppId()
  return self.sdkAppId
end

function VoiceRoomData:GetMemberInfo(uid)
  if not uid then
    return nil
  end
  return self.members[uid]
end

function VoiceRoomData:GetOrCreateMemberInfo(uid)
  if not uid or uid == "" then
    return nil
  end
  local member = self.members[uid]
  if not member then
    member = {
      uid = uid,
      chatService = nil,
      voiceService = nil
    }
    self.members[uid] = member
    table.insert(self.membersList, uid)
  end
  return member
end

function VoiceRoomData:GetOrCreateChatServiceInfo(uid)
  local member = self:GetOrCreateMemberInfo(uid)
  if not member then
    return nil
  end
  if not member.chatService then
    member.chatService = {
      isOwner = false,
      isAdmin = false,
      isCommander = false,
      canOpenMic = false,
      inVoiceRoom = true
    }
  end
  return member.chatService
end

function VoiceRoomData:GetOrCreateVoiceServiceInfo(uid)
  local member = self:GetOrCreateMemberInfo(uid)
  if not member then
    return nil
  end
  if not member.voiceService then
    member.voiceService = {
      isMicOn = false,
      isListening = true,
      isSpeaking = false
    }
  end
  return member.voiceService
end

function VoiceRoomData:TryRemoveEmptyMember(uid)
  local member = self.members[uid]
  if not member then
    return
  end
  if member.chatService == nil and member.voiceService == nil then
    for i = #self.membersList, 1, -1 do
      if self.membersList[i] == uid then
        table.remove(self.membersList, i)
        break
      end
    end
    self.members[uid] = nil
  end
end

function VoiceRoomData:RemoveChatServiceMember(uid)
  if not uid then
    return
  end
  local member = self.members[uid]
  if not member then
    return
  end
  member.chatService = nil
  self:TryRemoveEmptyMember(uid)
end

function VoiceRoomData:RemoveVoiceServiceMember(uid)
  if not uid then
    return
  end
  local member = self.members[uid]
  if not member then
    return
  end
  member.voiceService = nil
  self:TryRemoveEmptyMember(uid)
end

function VoiceRoomData:ClearMembers()
  self.membersList = {}
  self.members = {}
  self.onlinePlayerCount = 0
end

function VoiceRoomData:RefreshOnlinePlayerCount()
  local count = 0
  for _, memberUid in ipairs(self.membersList) do
    local member = self.members[memberUid]
    if member and member.chatService and member.chatService.inVoiceRoom == true then
      count = count + 1
    end
  end
  self.onlinePlayerCount = count
end

function VoiceRoomData:GetOnlinePlayerCount()
  return self.onlinePlayerCount or 0
end

function VoiceRoomData:SetChatServiceMemberInfo(uid, data)
  local info = self:GetOrCreateChatServiceInfo(uid)
  if not info or type(data) ~= "table" then
    return
  end
  if data.isOwner ~= nil then
    info.isOwner = data.isOwner and true or false
  end
  if data.isAdmin ~= nil then
    info.isAdmin = data.isAdmin and true or false
  end
  if data.isCommander ~= nil then
    info.isCommander = data.isCommander and true or false
  end
  if data.canOpenMic ~= nil then
    info.canOpenMic = data.canOpenMic and true or false
    info.isCommander = data.canOpenMic and true or false
  end
end

function VoiceRoomData:SetVoiceServiceMemberInfo(uid, data)
  if type(data) ~= "table" then
    return
  end
  local member = self:GetMemberInfo(uid)
  local info = member and member.voiceService or nil
  if not info then
    return
  end
  if data.isMicOn ~= nil then
    info.isMicOn = data.isMicOn and true or false
  end
  if data.isListening ~= nil then
    info.isListening = data.isListening and true or false
  end
  if data.isSpeaking ~= nil then
    info.isSpeaking = data.isSpeaking and true or false
  end
end

function VoiceRoomData:SetServerMemberInfo(uid, data)
  self:SetChatServiceMemberInfo(uid, data)
end

function VoiceRoomData:SetClientMemberInfo(uid, data)
  self:SetVoiceServiceMemberInfo(uid, data)
end

return VoiceRoomData
