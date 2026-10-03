local PushUserRoadStaminaChangeMessage = BaseClass("PushUserRoadStaminaChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  BuildBloodManager:GetInstance():ShowRoadBlood(t)
end

PushUserRoadStaminaChangeMessage.OnCreate = OnCreate
PushUserRoadStaminaChangeMessage.HandleMessage = HandleMessage
return PushUserRoadStaminaChangeMessage
