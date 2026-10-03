local EarthOrderFillOneMessage = BaseClass("EarthOrderFillOneMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutLong("uuid", param.uuid)
    self.sfsObj:PutLong("index", param.index)
    if param.type ~= nil then
      self.sfsObj:PutInt("type", param.type)
    end
    if param.productType ~= nil and param.productType == OrderItemType.ORDER_ITEM_TYPE_GOODS then
      self.sfsObj:PutLong("resourceItemUuid", 0)
      self.sfsObj:PutUtfString("itemUuid", param.resourceItemUuid)
    elseif param.productType ~= nil and param.productType == OrderItemType.ORDER_ITEM_TYPE_MONSTER then
      self.sfsObj:PutLong("resourceItemUuid", 0)
    elseif param.productType ~= nil and param.productType == OrderItemType.ORDER_ITEM_TYPE_SPECIAL_MONSTER then
      self.sfsObj:PutLong("resourceItemUuid", 0)
    else
      self.sfsObj:PutLong("resourceItemUuid", param.resourceItemUuid)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.OnQuestRedCountChanged)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.orderObj ~= nil and message.orderObj.type == OrderType.GROCERY_ORDER then
    DataCenter.GroceryStoreOrderDataManager:GroceryStoreOrderFillOneHandle(message)
    return
  end
  DataCenter.EarthOrderDataManager:EarthOrderFillOneHandle(message)
end

EarthOrderFillOneMessage.OnCreate = OnCreate
EarthOrderFillOneMessage.HandleMessage = HandleMessage
return EarthOrderFillOneMessage
