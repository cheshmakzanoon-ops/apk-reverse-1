local PushRoomMemberKickMessage = BaseClass("PushRoomMemberKickMessage", SFSBaseMessage)

local function OnCreate(self)
end

local function HandleMessage(self, serverData)
  if serverData.errorCode then
    UIUtil.ShowErrorCodeTips(serverData)
    return
  end
end

PushRoomMemberKickMessage.OnCreate = OnCreate
PushRoomMemberKickMessage.HandleMessage = HandleMessage
return PushRoomMemberKickMessage
