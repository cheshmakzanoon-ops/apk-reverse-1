local PushExchangeInfoMessage = BaseClass("PushExchangeInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  GiftPackageData.InitPackage(t)
end

PushExchangeInfoMessage.OnCreate = OnCreate
PushExchangeInfoMessage.HandleMessage = HandleMessage
return PushExchangeInfoMessage
