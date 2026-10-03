local PurchaseOrderFinishMessage = BaseClass("PurchaseOrderFinishMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.PurchaseOrderFinish, true)
  if param ~= nil then
    self.sfsObj:PutLong("uuid", param.uuid)
    if param.type ~= nil then
      self.sfsObj:PutInt("type", param.type)
    end
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.PurchaseOrderFinish, false)
  local order = t.order
  if order ~= nil and order.type == PurchaseOrderType.GROCERY_ORDER then
    DataCenter.GroceryStoreOrderDataManager:GroceryStoreOrderFillOneHandle(t)
  elseif order ~= nil and order.type == PurchaseOrderType.ENERGY_ORDER then
    DataCenter.EnergyOrderManager:HandleFinish(t)
  else
    DataCenter.ResidentOrderDataManager:PurchaseOrderFinishHandle(t)
  end
  EventManager:GetInstance():Broadcast(EventId.GuideWaitMessage)
end

PurchaseOrderFinishMessage.OnCreate = OnCreate
PurchaseOrderFinishMessage.HandleMessage = HandleMessage
return PurchaseOrderFinishMessage
