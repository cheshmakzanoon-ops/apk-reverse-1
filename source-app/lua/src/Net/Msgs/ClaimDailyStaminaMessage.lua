local ClaimDailyStaminaMessage = BaseClass("ClaimDailyStaminaMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  LuaEntry.Player:UpdateClaimFreeStamina(t)
end

ClaimDailyStaminaMessage.OnCreate = OnCreate
ClaimDailyStaminaMessage.HandleMessage = HandleMessage
return ClaimDailyStaminaMessage
