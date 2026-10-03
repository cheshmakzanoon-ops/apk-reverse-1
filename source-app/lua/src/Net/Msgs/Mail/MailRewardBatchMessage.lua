local MailRewardBatchMessage = BaseClass("MailRewardBatchMessage", SFSBaseMessage)

function MailRewardBatchMessage:OnCreate(mailIds, param, types)
  if type(mailIds) == "table" then
    mailIds = table.concat(mailIds, ",")
  end
  if string.IsNullOrEmpty(mailIds) then
    MailPrint("MailRewardBatchMessage error!")
  end
  if type(mailIds) == "string" then
    self.sfsObj:PutUtfString("uids", mailIds)
  end
  self.sfsObj:PutUtfString("type", tostring(param))
  if not string.IsNullOrEmpty(types) then
    self.sfsObj:PutUtfString("types", tostring(types))
  end
end

function MailRewardBatchMessage:HandleMessage(message)
  DataCenter.MailDataManager:HandleMailRewardBatchMessage(message)
end

return MailRewardBatchMessage
