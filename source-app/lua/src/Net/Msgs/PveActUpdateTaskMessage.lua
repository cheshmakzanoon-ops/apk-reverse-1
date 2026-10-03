local PveActUpdateTaskMessage = BaseClass("PveActUpdateTaskMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PveActUpdateTaskMessage:OnCreate()
  base.OnCreate(self)
end

function PveActUpdateTaskMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  DataCenter.PveActManager:HandleUpdateTask(message)
end

return PveActUpdateTaskMessage
