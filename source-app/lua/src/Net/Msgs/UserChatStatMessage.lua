local UserChatStatMessage = BaseClass("UserChatStatMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function getMsgExtra(post, media, senderLevel, extra)
  if post == nil and media == nil and senderLevel == nil then
    return nil
  end
  local ret = SFSObject.New()
  if not string.IsNullOrEmpty(media) then
    ret:PutUtfString("media", tostring(media))
  end
  ret:PutUtfString("post", tostring(post))
  if not senderLevel ~= nil then
    ret:PutInt("senderLevel", toInt(senderLevel))
  end
  if extra then
    for key, value in pairs(extra) do
      ret:PutUtfString(tostring(key), tostring(value))
    end
  end
  return ret
end

local function OnCreate(self, type, chatData)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
  local extra = getMsgExtra(chatData.post, chatData.media, chatData.senderLevel, chatData.extra)
  if extra then
    self.sfsObj:PutSFSObject("msgExtra", extra)
  end
  self.sfsObj:PutUtfString("roomId", tostring(chatData.roomId))
  self.sfsObj:PutUtfString("msg", tostring(chatData.msg))
  self.sfsObj:PutUtfString("sendTime", tostring(chatData.sendLocalTime))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  ChatInterface.getRoomMgr():ShowNewYearGift(t)
end

UserChatStatMessage.OnCreate = OnCreate
UserChatStatMessage.HandleMessage = HandleMessage
return UserChatStatMessage
