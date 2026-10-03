local GetGroceryOrderMessage = BaseClass("GetGroceryOrderMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  DataCenter.GroceryStoreOrderDataManager:GetGroceryStoreOrderHandle(message)
end

GetGroceryOrderMessage.OnCreate = OnCreate
GetGroceryOrderMessage.HandleMessage = HandleMessage
return GetGroceryOrderMessage
