local PushImmediateToggleTypeMessage = BaseClass("PushImmediateToggleTypeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushImmediateToggleTypeMessage:OnCreate()
  base.OnCreate(self)
end

function PushImmediateToggleTypeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  DataCenter.FunctionOnManager:HandlePushImmediateToggleType(t)
end

return PushImmediateToggleTypeMessage
