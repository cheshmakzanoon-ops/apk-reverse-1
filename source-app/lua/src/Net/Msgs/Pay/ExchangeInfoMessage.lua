local ExchangeInfoMessage = BaseClass("ExchangeInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.usePush ~= nil and t.usePush == true then
    return
  end
  GiftPackageData.InitPackage(t)
end

ExchangeInfoMessage.OnCreate = OnCreate
ExchangeInfoMessage.HandleMessage = HandleMessage
return ExchangeInfoMessage
