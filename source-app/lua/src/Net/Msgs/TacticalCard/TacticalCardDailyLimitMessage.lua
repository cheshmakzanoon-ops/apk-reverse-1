local TacticalCardDailyLimitMessage = BaseClass("TacticalCardDailyLimitMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    return
  end
  DataCenter.TacticalCardDataManager:UpdateDailyLimit(message)
end

TacticalCardDailyLimitMessage.OnCreate = OnCreate
TacticalCardDailyLimitMessage.HandleMessage = HandleMessage
return TacticalCardDailyLimitMessage
