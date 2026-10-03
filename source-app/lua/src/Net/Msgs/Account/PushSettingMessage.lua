local PushSettingMessage = BaseClass("PushSettingMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.PushSettingData:PushSettingHandle(t)
end

PushSettingMessage.OnCreate = OnCreate
PushSettingMessage.HandleMessage = HandleMessage
return PushSettingMessage
