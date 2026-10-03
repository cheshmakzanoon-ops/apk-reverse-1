local PushRobotEffectChangeMessage = BaseClass("PushRobotEffectChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
end

PushRobotEffectChangeMessage.OnCreate = OnCreate
PushRobotEffectChangeMessage.HandleMessage = HandleMessage
return PushRobotEffectChangeMessage
