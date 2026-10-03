local PushChatRoomMembersQuitMessage = BaseClass("PushChatRoomMembersQuitMessage", SFSBaseMessage)

local function OnCreate(self)
end

local function HandleMessage(self, serverData)
  if serverData.errorCode then
    UIUtil.ShowErrorCodeTips(serverData)
    return
  end
end

PushChatRoomMembersQuitMessage.OnCreate = OnCreate
PushChatRoomMembersQuitMessage.HandleMessage = HandleMessage
return PushChatRoomMembersQuitMessage
