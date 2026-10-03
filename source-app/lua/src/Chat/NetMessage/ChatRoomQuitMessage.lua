local ChatRoomQuitMessage = BaseClass("ChatRoomQuitMessage", SFSBaseMessage)

local function OnCreate(self, roomId, group)
  if roomId then
    self.sfsObj:PutUtfString("roomId", roomId)
  end
  if group then
    self.sfsObj:PutUtfString("group", group)
  end
end

local function HandleMessage(self, msg)
  if msg.errorCode then
    UIUtil.ShowErrorCodeTips(msg)
  end
end

ChatRoomQuitMessage.OnCreate = OnCreate
ChatRoomQuitMessage.HandleMessage = HandleMessage
return ChatRoomQuitMessage
