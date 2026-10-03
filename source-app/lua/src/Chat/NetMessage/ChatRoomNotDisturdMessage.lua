local ChatRoomNotDisturdMessage = BaseClass("ChatRoomNotDisturdMessage", SFSBaseMessage)

local function OnCreate(self, roomId, setting)
  if roomId then
    self.sfsObj:PutUtfString("roomId", roomId)
  end
  if setting ~= nil then
    self.sfsObj:PutBool("value", setting)
  end
end

local function HandleMessage(self, msg)
  if msg.errorCode then
    UIUtil.ShowErrorCodeTips(msg)
  else
    ChatInterface.getGroupChatMgr():UpdateNotDisturbingRoom(msg.roomId, msg.value)
  end
end

ChatRoomNotDisturdMessage.OnCreate = OnCreate
ChatRoomNotDisturdMessage.HandleMessage = HandleMessage
return ChatRoomNotDisturdMessage
