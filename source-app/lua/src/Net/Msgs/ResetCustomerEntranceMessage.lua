local ResetCustomerEntranceMessage = BaseClass("ResetCustomerEntranceMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
end

ResetCustomerEntranceMessage.OnCreate = OnCreate
ResetCustomerEntranceMessage.HandleMessage = HandleMessage
return ResetCustomerEntranceMessage
