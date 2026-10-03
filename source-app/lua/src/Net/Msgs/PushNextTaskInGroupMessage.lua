local PushNextTaskInGroupMessage = BaseClass("PushNextTaskInGroupMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushNextTaskInGroupMessage:OnCreate()
  base.OnCreate(self)
end

function PushNextTaskInGroupMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil then
    DataCenter.TaskManager:PushUpdateTaskHandle(t)
  end
end

return PushNextTaskInGroupMessage
