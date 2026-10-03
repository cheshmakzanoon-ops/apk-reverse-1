local PushUserBuildStaminaChangeMessage = BaseClass("PushUserBuildStaminaChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.isBroken ~= nil then
    local state = t.cityBroken
    if state == true then
      return
    end
  end
  BuildBloodManager:GetInstance():ShowBuildBlood(t)
end

PushUserBuildStaminaChangeMessage.OnCreate = OnCreate
PushUserBuildStaminaChangeMessage.HandleMessage = HandleMessage
return PushUserBuildStaminaChangeMessage
