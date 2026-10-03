local UserGetTradeBankRecordsMessage = BaseClass("UserGetTradeBankRecordsMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.StorageShopManager:UserGetTradeBankRecordsHandle(t)
end

UserGetTradeBankRecordsMessage.OnCreate = OnCreate
UserGetTradeBankRecordsMessage.HandleMessage = HandleMessage
return UserGetTradeBankRecordsMessage
