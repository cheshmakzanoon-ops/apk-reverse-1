local PushPurchaseOrderUpdateMessage = BaseClass("PushPurchaseOrderUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.orders ~= nil then
    DataCenter.GroceryStoreOrderDataManager:DoWhenUpdateHandle(t)
  end
end

PushPurchaseOrderUpdateMessage.OnCreate = OnCreate
PushPurchaseOrderUpdateMessage.HandleMessage = HandleMessage
return PushPurchaseOrderUpdateMessage
