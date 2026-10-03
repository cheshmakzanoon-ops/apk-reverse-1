local PushGlobalStateChangeMessage = BaseClass("PushGlobalStateChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushGlobalStateChangeMessage:OnCreate()
  base.OnCreate(self)
end

function PushGlobalStateChangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  SFSNetwork.SendMessage(MsgDefines.FetchGlobalStateInfo)
end

return PushGlobalStateChangeMessage
