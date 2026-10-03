local PushGroupChatInviterMessage = BaseClass("PushGroupChatInviterMessage", SFSBaseMessage)

local function OnCreate(self)
end

local function HandleMessage(self, serverData)
  if serverData and serverData.data then
    ChatInterface.getGroupChatMgr():UpdateCdTime(serverData.data.members, serverData.data.roomId)
  end
  if serverData and serverData.errorCode then
    UIUtil.ShowErrorCodeTips(serverData)
    return
  else
    UIUtil.ShowTipsId("group_invite_success_tips")
  end
end

PushGroupChatInviterMessage.OnCreate = OnCreate
PushGroupChatInviterMessage.HandleMessage = HandleMessage
return PushGroupChatInviterMessage
