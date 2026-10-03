local PushMailGroupNewDeleteMessage = BaseClass("PushMailGroupNewDeleteMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushMailGroupNewDeleteMessage:OnCreate(mailId)
  base.OnCreate(self)
end

function PushMailGroupNewDeleteMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  DataCenter.MailDataManager:OnPresidentMailGMDelete(t)
end

return PushMailGroupNewDeleteMessage
