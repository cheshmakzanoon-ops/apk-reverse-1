local PushMailBatchDelMessage = BaseClass("PushMailBatchDelMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization

local function HandleMessage(self, t)
  DataCenter.MailDataManager:HandleMailBatchDelMessage(t)
end

PushMailBatchDelMessage.HandleMessage = HandleMessage
return PushMailBatchDelMessage
