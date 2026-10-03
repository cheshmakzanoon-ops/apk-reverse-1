local PushDispatchDelTaskMessage = BaseClass("PushDispatchDelTaskMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PushDispatchDelTaskMessage:OnCreate()
  base.OnCreate(self)
end

function PushDispatchDelTaskMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.uuids then
    DataCenter.ActDispatchTaskDataManager:DeleteSingleTasks(message.uuids)
  end
end

return PushDispatchDelTaskMessage
