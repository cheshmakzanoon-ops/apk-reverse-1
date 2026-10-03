local GroceryStoreOrderInfo = BaseClass("GroceryStoreOrderInfo")
local Setting = CS.GameEntry.Setting

local function __init(self)
  self.uuid = 0
  self.expTime = 0
  self.orderId = 0
  self.index = 0
  self.filledItemArr = {}
  self.rewardArr = {}
  self.money = 0
  self.state = PurchaseOrderState.NORMAL
  self.resource_goods = {}
end

local function __delete(self)
  self.uuid = nil
  self.expTime = nil
  self.orderId = nil
  self.index = nil
  self.filledItemArr = nil
  self.rewardArr = nil
  self.money = nil
  self.resource_goods = nil
  self.state = PurchaseOrderState.NORMAL
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.refreshTime ~= nil then
    self.expTime = message.refreshTime
  end
  if message.orderId ~= nil then
    self.orderId = message.orderId
  end
  if message.state ~= nil then
    self.state = message.state
  end
  if message.index ~= nil then
    self.index = message.index
  end
  if message.money ~= nil then
    self.money = message.money
  else
    self.money = 0
  end
  if message.rewardArr ~= nil then
    self.rewardArr = message.rewardArr
  else
    self.rewardArr = {}
  end
  if message.filledItemArr ~= nil then
    self.filledItemArr = message.filledItemArr
  else
    self.filledItemArr = {}
  end
end

local function CanDelete(self)
  local orderIdTemplate = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.Order), tostring(self.orderId))
  if orderIdTemplate == nil then
    return false
  end
  local productType = 0
  if orderIdTemplate.product_type ~= nil and orderIdTemplate.product_type ~= "" then
    productType = toInt(orderIdTemplate.product_type)
  end
  return productType ~= OrderItemType.ORDER_ITEM_TYPE_MONSTER
end

local function CanSend(self)
  local now = math.floor(UITimeManager:GetInstance():GetServerTime())
  local result = false
  if self.state == PurchaseOrderState.NORMAL or now > self.expTime and self.state == PurchaseOrderState.FINISH then
    result = true
    if self.resource_goods == nil or self.resource_goods[self.orderId] == nil then
      self.resource_goods = {}
      local orderIdTemplate = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.Order), tostring(self.orderId))
      if orderIdTemplate == nil then
        return false
      end
      local resource_goodsStr = orderIdTemplate.resource_goods or ""
      local vec = string.split(resource_goodsStr, "|")
      self.resource_goods[self.orderId] = {}
      for k, v in ipairs(vec) do
        local goodsVec = string.split(v, ";")
        if goodsVec == nil or table.count(goodsVec) ~= 2 then
          self.resource_goods[self.orderId] = nil
          return false
        end
        local product_id = toInt(goodsVec[1])
        local product_num = toInt(goodsVec[2])
        local param = {}
        param.productId = product_id
        param.productNum = product_num
        local productType = 0
        if orderIdTemplate.product_type ~= nil and orderIdTemplate.product_type ~= "" then
          productType = toInt(orderIdTemplate.product_type)
        end
        param.productType = productType
        self.resource_goods[self.orderId][product_id] = param
      end
    end
    for _, v in pairs(self.resource_goods[self.orderId]) do
      if v ~= nil then
        local product_id = v.productId
        local product_num = v.productNum
        local productType = v.productType
        if productType == OrderItemType.ORDER_ITEM_TYPE_RESOURCE_ITEM then
          local resourceTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(product_id)
          if resourceTemplate == nil then
            return false
          end
          local needNum = product_num
          local hasNum = 0
          local item = DataCenter.ResourceItemDataManager:GetItemDataByItemId(product_id)
          if item ~= nil then
            hasNum = item.number
          end
          result = result and needNum <= hasNum
        elseif productType == OrderItemType.ORDER_ITEM_TYPE_GOODS then
          local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(product_id)
          if itemTemplate == nil then
            return false
          end
          local needNum = product_num
          local hasNum = 0
          local item = DataCenter.ItemData:GetItemById(product_id)
          if item ~= nil then
            hasNum = item.count
          end
          result = result and needNum <= hasNum
        elseif productType == OrderItemType.ORDER_ITEM_TYPE_RESOURCE then
        elseif productType == OrderItemType.ORDER_ITEM_TYPE_MONSTER then
          result = result and product_id <= LuaEntry.Player.pveLevel
        elseif productType == OrderItemType.ORDER_ITEM_TYPE_SPECIAL_MONSTER then
          if self.filledItemArr == nil or table.count(self.filledItemArr) == 0 or table.count(self.filledItemArr) ~= table.count(self.resource_goods[self.orderId]) then
            return false
          end
          for k1, v1 in ipairs(self.filledItemArr) do
            if v1.index == product_id and product_num > v1.num then
              return false
            end
          end
        end
      end
      if result == false then
        return result
      end
    end
  end
  return result
end

local function HasOrderTypeOrder(self, guideOrderType, orderState, orderType, productId)
  local canSend = self:CanSend()
  if guideOrderType == GuideOrderType.CanSubmit then
    if canSend then
      return true
    end
  elseif guideOrderType == GuideOrderType.NoSubmit then
    if not canSend then
      return true
    end
  elseif guideOrderType == GuideOrderType.OrderItemType then
    if orderState == GuideOrderState.Finish and self.state ~= PurchaseOrderState.FINISH or orderState == GuideOrderState.Delete and self.state ~= PurchaseOrderState.DELETE or orderState == GuideOrderState.NoSubmit and self.state ~= PurchaseOrderState.NORMAL or orderState == GuideOrderState.CanSubmit and self.state ~= PurchaseOrderState.NORMAL or orderState == GuideOrderState.NoSubmit and canSend or orderState == GuideOrderState.CanSubmit and not canSend then
      return false
    end
    for _, v in pairs(self.resource_goods[self.orderId]) do
      if v ~= nil then
        local product_id = v.productId
        local productType = v.productType
        if productType == orderType then
          if productType == OrderItemType.ORDER_ITEM_TYPE_SPECIAL_MONSTER then
            if self.filledItemArr == nil or table.count(self.filledItemArr) == 0 then
              return false
            end
            for k1, v1 in ipairs(self.filledItemArr) do
              if tostring(v1.index) == productId then
                return true
              end
            end
          elseif productId == tostring(product_id) then
            return true
          end
        end
      end
    end
  end
  return false
end

GroceryStoreOrderInfo.__init = __init
GroceryStoreOrderInfo.__delete = __delete
GroceryStoreOrderInfo.ParseData = ParseData
GroceryStoreOrderInfo.CanSend = CanSend
GroceryStoreOrderInfo.CanDelete = CanDelete
GroceryStoreOrderInfo.HasOrderTypeOrder = HasOrderTypeOrder
return GroceryStoreOrderInfo
