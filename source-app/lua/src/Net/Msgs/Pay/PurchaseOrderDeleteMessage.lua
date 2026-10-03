local PurchaseOrderDeleteMessage = BaseClass("PurchaseOrderDeleteMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutLong("uuid", param.uuid)
    if param.type ~= nil then
      self.sfsObj:PutInt("type", param.type)
    end
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.order ~= nil then
    if t.order.type == PurchaseOrderType.GROCERY_ORDER then
      DataCenter.GroceryStoreOrderDataManager:DeleteOrderFinishHandle(t)
    elseif t.order.type == PurchaseOrderType.PURCHASE_ORDER then
      DataCenter.ResidentOrderDataManager:DeleteOrderFinishHandle(t)
    elseif t.order.type == PurchaseOrderType.ENERGY_ORDER then
      DataCenter.EnergyOrderManager:HandleDelete(t)
    end
  end
end

PurchaseOrderDeleteMessage.OnCreate = OnCreate
PurchaseOrderDeleteMessage.HandleMessage = HandleMessage
return PurchaseOrderDeleteMessage
