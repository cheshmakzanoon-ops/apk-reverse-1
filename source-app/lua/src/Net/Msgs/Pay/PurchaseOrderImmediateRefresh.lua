local PurchaseOrderImmediateRefresh = BaseClass("PurchaseOrderImmediateRefresh", SFSBaseMessage)
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
  DataCenter.ResidentOrderDataManager:ImmediateRefreshHandle(t)
  EventManager:GetInstance():Broadcast(EventId.DelayRefreshResource, 0.2)
end

PurchaseOrderImmediateRefresh.OnCreate = OnCreate
PurchaseOrderImmediateRefresh.HandleMessage = HandleMessage
return PurchaseOrderImmediateRefresh
