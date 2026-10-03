local SendFriendsCircleCommentMessage = BaseClass("SendFriendsCircleCommentMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uid, table, reply)
  if uid then
    self.sfsObj:PutUtfString("friendsUid", uid)
  end
  if not table then
    ChatPrint("ChatShareCommand \229\136\134\228\186\171\230\178\161\228\188\160\229\143\130\239\188\129\239\188\129\239\188\129 ")
    return
  end
  self.sfsObj:PutLong("post", table.post)
  if table.roomId then
    self.sfsObj:PutUtfString("roomId", table.roomId)
  end
  if table.msg then
    self.sfsObj:PutUtfString("msg", table.msg)
  else
    self.sfsObj:PutUtfString("msg", "?")
  end
  if reply then
    self.sfsObj:PutUtfString("reply", reply)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowErrorCodeTips(t)
  end
end

SendFriendsCircleCommentMessage.OnCreate = OnCreate
SendFriendsCircleCommentMessage.HandleMessage = HandleMessage
return SendFriendsCircleCommentMessage
