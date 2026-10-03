local PushCoffeeUpdateMessage = BaseClass("PushCoffeeUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, coffeeId)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.MakingCoffeeManager:UpdateCoffeeInfo(t)
end

PushCoffeeUpdateMessage.OnCreate = OnCreate
PushCoffeeUpdateMessage.HandleMessage = HandleMessage
return PushCoffeeUpdateMessage
