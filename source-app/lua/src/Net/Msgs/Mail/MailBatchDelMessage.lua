local MailBatchDelMessage = BaseClass("MailBatchDelMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization

local function OnCreate(self, mailIds, param)
  if type(mailIds) == "table" then
    mailIds = table.concat(mailIds, ",")
  end
  if string.IsNullOrEmpty(mailIds) then
    MailPrint("MailBatchDel string error!!")
  end
  if type(mailIds) == "string" then
    self.sfsObj:PutUtfString("uids", mailIds)
  end
  self.sfsObj:PutUtfString("type", tostring(param))
end

local function HandleMessage(self, t)
  DataCenter.MailDataManager:HandleMailBatchDelMessage(t)
end

MailBatchDelMessage.OnCreate = OnCreate
MailBatchDelMessage.HandleMessage = HandleMessage
return MailBatchDelMessage
