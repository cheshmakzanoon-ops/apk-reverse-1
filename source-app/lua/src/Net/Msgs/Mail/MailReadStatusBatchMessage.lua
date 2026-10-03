local MailReadStatusBatchMessage = BaseClass("MailReadStatusBatchMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, mailIds)
  base.OnCreate(self, mailIds)
  if type(mailIds) == "table" then
    mailIds = table.concat(mailIds, ",")
  end
  if string.IsNullOrEmpty(mailIds) then
    MailPrint("MailReadStatusBatchMessage error!")
  end
  if type(mailIds) == "string" then
    self.sfsObj:PutUtfString("uids", mailIds)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  Logger.Log(t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
  EventManager:GetInstance():Broadcast(EventId.MailPush)
end

MailReadStatusBatchMessage.OnCreate = OnCreate
MailReadStatusBatchMessage.HandleMessage = HandleMessage
return MailReadStatusBatchMessage
