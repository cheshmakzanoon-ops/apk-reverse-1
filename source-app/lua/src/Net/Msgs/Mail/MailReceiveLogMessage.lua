local MailReceiveLogMessage = BaseClass("MailReceiveLogMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MailReceiveLogMessage:OnCreate(arr)
  base.OnCreate(self)
  local oneArr = SFSArray.New()
  for k, param in ipairs(arr) do
    local one = SFSObject.New()
    one:PutUtfString("mailId", param.mailId)
    one:PutUtfString("title", param.title)
    one:PutUtfString("reportId", param.reportId)
    one:PutUtfString("integrity", param.integrity)
    one:PutUtfString("type", param.type)
    oneArr:AddSFSObject(one)
  end
  self.sfsObj:PutSFSArray("logs", oneArr)
end

function MailReceiveLogMessage:HandleMessage(t)
  base.HandleMessage(self, t)
end

return MailReceiveLogMessage
