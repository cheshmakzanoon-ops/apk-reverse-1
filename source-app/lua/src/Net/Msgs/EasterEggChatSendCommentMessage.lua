local EasterEggChatSendCommentMessage = BaseClass("EasterEggChatSendCommentMessage", SFSBaseMessage)
local base = SFSBaseMessage
local rapidjson = require("rapidjson")

local function OnCreate(self, chatData)
  if chatData == nil then
    Logger.LogError("\229\164\141\230\180\187\232\138\130\226\128\148\226\128\148\226\128\148\226\128\148\232\175\132\232\174\186\230\182\136\230\129\175\228\188\160\229\133\165chatData\228\184\186\231\169\186\239\188\129")
    return
  end
  self.sfsObj:PutLong("post", chatData.post)
  if chatData.roomId then
    self.sfsObj:PutUtfString("roomId", chatData.roomId)
  end
  if chatData.msg then
    self.sfsObj:PutUtfString("msg", chatData.msg)
  else
    self.sfsObj:PutUtfString("msg", "?")
  end
  if chatData.replyMsg then
    local jsonData = rapidjson.encode(chatData.replyMsg)
    self.sfsObj:PutUtfString("reply", jsonData)
  end
  if chatData.extra then
    local extra = chatData.extra
    local extraObj = SFSObject.New()
    if extra.opType ~= nil then
      extraObj:PutUtfString("opType", "3")
    end
    if extra.otherUid then
      extraObj:PutUtfString("otherUid", extra.otherUid)
    end
    if extra.eggUuid then
      extraObj:PutUtfString("eggUuid", extra.eggUuid)
    end
    if extra.answer then
      extraObj:PutUtfString("answer", tostring(extra.answer))
    end
    if extra.anonymousHead then
      extraObj:PutUtfString("anonymousHead", extra.anonymousHead)
    end
    self.sfsObj:PutSFSObject("extraObj", extraObj)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowErrorCodeTips(t)
  end
end

EasterEggChatSendCommentMessage.OnCreate = OnCreate
EasterEggChatSendCommentMessage.HandleMessage = HandleMessage
return EasterEggChatSendCommentMessage
