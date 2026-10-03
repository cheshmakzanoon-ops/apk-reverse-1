local PushMailGetMessage = BaseClass("PushMailGetMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  DataCenter.MailDataManager:HandleMailGetMessage(message)
end

PushMailGetMessage.HandleMessage = HandleMessage
return PushMailGetMessage
