local PushNewSysRedPacketMessage = BaseClass("PushNewSysRedPacketMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  DataCenter.AllianceRedPacketManager:UpdateRedPacketByUUid(message)
  DataCenter.UIPopWindowManager:Push(UIWindowNames.UIRedenvelopeSend, message.uuid)
end

PushNewSysRedPacketMessage.OnCreate = OnCreate
PushNewSysRedPacketMessage.HandleMessage = HandleMessage
return PushNewSysRedPacketMessage
