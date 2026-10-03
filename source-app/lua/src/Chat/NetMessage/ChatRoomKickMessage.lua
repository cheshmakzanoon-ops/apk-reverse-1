local ChatRoomKickMessage = BaseClass("ChatRoomKickMessage", SFSBaseMessage)

local function OnCreate(self, roomId, group, members)
  if roomId then
    self.sfsObj:PutUtfString("roomId", roomId)
  end
  if group then
    self.sfsObj:PutUtfString("group", group)
  end
  if members then
    local uidArr = SFSArray.New()
    for i, v in ipairs(members) do
      uidArr:AddUtfString(v)
    end
    self.sfsObj:PutSFSArray("members", uidArr)
  end
end

local function HandleMessage(self, msg)
  if msg.errorCode then
    UIUtil.ShowErrorCodeTips(msg)
  end
end

ChatRoomKickMessage.OnCreate = OnCreate
ChatRoomKickMessage.HandleMessage = HandleMessage
return ChatRoomKickMessage
