local PushPurchaseOrderMessage = BaseClass("PushPurchaseOrderMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.ResidentOrderDataManager:PushPurchaseOrderHandle(t)
end

PushPurchaseOrderMessage.OnCreate = OnCreate
PushPurchaseOrderMessage.HandleMessage = HandleMessage
return PushPurchaseOrderMessage
