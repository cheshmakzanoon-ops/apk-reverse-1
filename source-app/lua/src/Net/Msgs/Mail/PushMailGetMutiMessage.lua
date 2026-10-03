local PushMailGetMutiMessage = BaseClass("PushMailGetMutiMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.MailDataManager:HandleMailGetMutiMessage(t)
end

PushMailGetMutiMessage.HandleMessage = HandleMessage
return PushMailGetMutiMessage
