local PushGameServerChatRoomCreateMessage = BaseClass("PushGameServerChatRoomCreateMessage", SFSBaseMessage)

local function OnCreate(self)
end

local function HandleMessage(self, serverData)
  if serverData.errorCode then
    UIUtil.ShowErrorCodeTips(serverData)
    return
  end
end

PushGameServerChatRoomCreateMessage.OnCreate = OnCreate
PushGameServerChatRoomCreateMessage.HandleMessage = HandleMessage
return PushGameServerChatRoomCreateMessage
