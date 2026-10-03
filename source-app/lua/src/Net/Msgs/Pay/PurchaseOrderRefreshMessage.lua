local PurchaseOrderRefreshMessage = BaseClass("PurchaseOrderRefreshMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil and param.type ~= nil then
    self.sfsObj:PutInt("type", param.type)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.serverTime ~= nil then
    CS.GameEntry.Timer:UpdateServerMilliseconds(t.serverTime)
    UITimeManager:GetInstance():UpdateServerMsDeltaTime(t.serverTime)
  end
  if t.groceryOrderList ~= nil then
    DataCenter.GroceryStoreOrderDataManager:GetGroceryStoreOrderHandle(t)
  else
    DataCenter.ResidentOrderDataManager:InitResidentOrderDataList(t)
    EventManager:GetInstance():Broadcast(EventId.RefreshResidentOrder)
  end
  if t.pveStaminaOrderList ~= nil then
    DataCenter.EnergyOrderManager:HandleRefresh(t)
  end
end

PurchaseOrderRefreshMessage.OnCreate = OnCreate
PurchaseOrderRefreshMessage.HandleMessage = HandleMessage
return PurchaseOrderRefreshMessage
