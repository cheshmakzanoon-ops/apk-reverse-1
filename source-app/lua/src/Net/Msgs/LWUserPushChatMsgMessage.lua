local LWUserPushChatMsgMessage = BaseClass("LWUserPushChatMsgMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uid, msg, roomId, pushCode, atUids, isAtAll)
  base.OnCreate(self)
  if uid then
    self.sfsObj:PutUtfString("uid", tostring(uid))
  end
  if msg then
    self.sfsObj:PutUtfString("msg", msg)
  end
  if roomId then
    self.sfsObj:PutUtfString("roomId", roomId)
  end
  if pushCode then
    self.sfsObj:PutUtfString("pushCode", tostring(pushCode))
  end
  if atUids then
    self.sfsObj:PutUtfStringArray("targets", atUids)
  end
  if isAtAll then
    self.sfsObj:PutBool("atAll", isAtAll)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
end

LWUserPushChatMsgMessage.OnCreate = OnCreate
LWUserPushChatMsgMessage.HandleMessage = HandleMessage
return LWUserPushChatMsgMessage
