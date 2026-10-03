local PushDispatchFullTaskMessage = BaseClass("PushDispatchFullTaskMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PushDispatchFullTaskMessage:OnCreate()
  base.OnCreate(self)
end

function PushDispatchFullTaskMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  DataCenter.ActDispatchTaskDataManager:UpdateAllSingleTasks(message)
end

return PushDispatchFullTaskMessage
