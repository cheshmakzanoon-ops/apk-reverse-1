local PushAlSysStateMessage = BaseClass("PushAlSysStateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.AllianceBaseDataManager:UpdateAlSysState(t.sysAlState, t.stateEndTime)
  EventManager:GetInstance():Broadcast(EventId.AlSysStateChange)
end

PushAlSysStateMessage.OnCreate = OnCreate
PushAlSysStateMessage.HandleMessage = HandleMessage
return PushAlSysStateMessage
