local MailGetMutiMessage = BaseClass("MailGetMutiMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, clientSeqUid, time, count, isFirst, uuids)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("clientseq", clientSeqUid)
  self.sfsObj:PutLong("time", time)
  self.sfsObj:PutInt("count", count)
  if isFirst then
    self.sfsObj:PutUtfString("firstCmd", "YES")
  end
  if uuids then
    self.sfsObj:PutUtfStringArray("uuids", uuids)
  end
  self.sfsObj:PutBool("isAll", true)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
end

MailGetMutiMessage.OnCreate = OnCreate
MailGetMutiMessage.HandleMessage = HandleMessage
return MailGetMutiMessage
