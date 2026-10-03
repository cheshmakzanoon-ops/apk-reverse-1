local UIGroceryStoreCtrl = BaseClass("UIGroceryStoreCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIGroceryStore)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Background, false)
end

local function GetPanelData(self)
  local orderArr = DataCenter.GroceryStoreOrderDataManager.groceryStoreOrderDic
  if orderArr == nil then
    return nil
  end
  local param = {}
  param.orderList = {}
  param.firstKill = nil
  param.selectDataIndex = DataCenter.GroceryStoreOrderDataManager.currentSelectDataIndex
  table.walk(orderArr, function(k, v)
    if v == nil or v.state == PurchaseOrderState.LOCKED then
      if param.selectDataIndex == v.index + 1 then
        param.selectDataIndex = -1
        DataCenter.GroceryStoreOrderDataManager.currentSelectDataIndex = -1
      end
      return
    end
    local orderIdTemplate = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.Order), tostring(v.orderId))
    local productType = 0
    if orderIdTemplate ~= nil then
      if orderIdTemplate.product_type ~= nil and orderIdTemplate.product_type ~= "" then
        productType = toInt(orderIdTemplate.product_type)
      end
      local order = {}
      local resource_goodsStr = orderIdTemplate.resource_goods
      if resource_goodsStr == nil or resource_goodsStr == "" then
        return
      end
      local goodsVec = string.split(resource_goodsStr, ";")
      if goodsVec == nil or table.count(goodsVec) ~= 2 then
        return
      end
      local product_id = toInt(goodsVec[1])
      local product_num = toInt(goodsVec[2])
      order.productType = productType
      order.canSend = v:CanSend()
      order.isSend = v.state == PurchaseOrderState.FINISH
      order.isDelete = v.state == PurchaseOrderState.DELETE
      order.index = v.index
      order.dataIndex = v.index + 1
      order.endTime = v.expTime
      order.uuid = v.uuid
      order.sortIndex = v.index
      if productType == OrderItemType.ORDER_ITEM_TYPE_MONSTER then
        order.sortIndex = -1
      end
      order.canDelete = v:CanDelete()
      if productType == OrderItemType.ORDER_ITEM_TYPE_RESOURCE_ITEM then
        local resourceTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(product_id)
        if resourceTemplate == nil then
          return
        end
        order.needNum = product_num
        local item = DataCenter.ResourceItemDataManager:GetItemDataByItemId(product_id)
        if item ~= nil then
          order.hasNum = item.number
        else
          order.hasNum = 0
        end
        order.productId = product_id
        order.canUseDiamond = DataCenter.ResourceItemDataManager:ResourceItemCanBuyInOrder(product_id)
        order.icon = string.format(LoadPath.ItemPath, resourceTemplate.pic)
        order.name = Localization:GetString(resourceTemplate.name)
        order.desc = Localization:GetString(resourceTemplate.desc)
      elseif productType == OrderItemType.ORDER_ITEM_TYPE_GOODS then
        local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(product_id)
        if itemTemplate == nil then
          return
        end
        order.needNum = product_num
        local item = DataCenter.ItemData:GetItemById(product_id)
        if item ~= nil then
          order.hasNum = item.count
        else
          order.hasNum = 0
        end
        order.productId = product_id
        order.icon = string.format(LoadPath.ItemPath, itemTemplate.icon)
        order.name = DataCenter.ItemTemplateManager:GetName(product_id)
        order.desc = Localization:GetString(itemTemplate.description)
      elseif productType == OrderItemType.ORDER_ITEM_TYPE_RESOURCE then
      elseif productType == OrderItemType.ORDER_ITEM_TYPE_MONSTER then
        order.needNum = 1
        order.hasNum = 0
        if order.canSend == true then
          order.hasNum = 1
        end
        order.productId = product_id
        local vec = string.split(orderIdTemplate.show_para, ";")
        if table.count(vec) ~= 3 then
          return
        end
        order.icon = LoadPath.HeroIconsSmallPath .. vec[1]
        order.name = Localization:GetString("300665", tostring(order.productId)) .. " " .. Localization:GetString(vec[2])
        order.desc = Localization:GetString(vec[3])
      elseif productType == OrderItemType.ORDER_ITEM_TYPE_SPECIAL_MONSTER then
        order.needNum = 1
        order.hasNum = 0
        if order.canSend == true then
          order.hasNum = 1
        end
        order.productId = product_id
        local vec = string.split(orderIdTemplate.show_para, ";")
        if table.count(vec) ~= 3 then
          return
        end
        order.icon = LoadPath.HeroIconsSmallPath .. vec[1]
        order.name = Localization:GetString("300665", tostring(order.productId)) .. " " .. Localization:GetString(vec[2])
        order.desc = Localization:GetString(vec[3])
      end
      local reward = {}
      if v.money ~= nil and 0 < v.money then
        local rewardData = {}
        rewardData.num = v.money
        rewardData.icon = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Food)
        rewardData.rewardType = RewardType.FOOD
        table.insert(reward, rewardData)
      end
      if v.rewardArr ~= nil then
        local rewardList = DataCenter.RewardManager:ReturnRewardParamForView(v.rewardArr)
        table.walk(rewardList, function(_, j)
          local rewardData = {}
          rewardData.num = j.count
          rewardData.rewardType = j.rewardType
          rewardData.icon = DataCenter.RewardManager:GetPicByType(j.rewardType, j.itemId)
          table.insert(reward, rewardData)
        end)
      end
      order.reward = reward
      table.insert(param.orderList, order)
    end
  end)
  table.sort(param.orderList, function(k, v)
    return k.sortIndex < v.sortIndex
  end)
  if param.selectDataIndex == -1 and #param.orderList > 0 then
    param.selectDataIndex = param.orderList[1].dataIndex
  end
  return param
end

local function GetDataFromServer(self)
  DataCenter.GroceryStoreOrderDataManager:SendGetGroceryStoreOrder()
end

local function GetAllCompleteReward(self, uuid)
  DataCenter.GroceryStoreOrderDataManager:SendGroceryStoreOrderEnd(uuid)
end

local function CompleteOneOrder(self, data, action)
  local productType = data.productType
  if productType == OrderItemType.ORDER_ITEM_TYPE_RESOURCE_ITEM and data.hasNum < data.needNum then
    local tmp = {}
    tmp[data.productId] = data.needNum
    local param = DataCenter.ResourceItemDataManager:GetAllLackResourceItemParams(tmp, action)
    if param.canBuy == true and param.totalDiamond > 0 then
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_FailClick, false)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceItemLack, {anim = true}, param)
      return
    end
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Gulu_Order_Button, false)
  self:DoCompleteOneOrder(data.uuid)
end

local function DoCompleteOneOrder(self, uuid)
  DataCenter.GroceryStoreOrderDataManager:SendGroceryStoreOrderFillOne(uuid)
end

local function GotoFactory(self, productId, type)
  if type == OrderItemType.ORDER_ITEM_TYPE_MONSTER or type == OrderItemType.ORDER_ITEM_TYPE_SPECIAL_MONSTER then
    local maxLevel = DataCenter.MonsterManager:GetCurCanAttackMaxLevel()
    local level = math.min(maxLevel, productId)
    GoToUtil.FindMonster(level)
  else
    GoToUtil.GotoColdStorage(productId)
  end
end

local function OnSearchEnd(self, pointId, uuid)
  local worldPosition = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
  self:CloseSelf()
  GoToUtil.GotoWorldPos(worldPosition, CS.SceneManager.World.InitZoom, nil, function()
    WorldArrowManager:GetInstance():ShowArrowEffect(uuid, worldPosition, ArrowType.Monster)
  end)
end

local function DeleteOne(self, uuid)
  DataCenter.GroceryStoreOrderDataManager:DeleteOneOrder(uuid)
end

UIGroceryStoreCtrl.CloseSelf = CloseSelf
UIGroceryStoreCtrl.Close = Close
UIGroceryStoreCtrl.GetPanelData = GetPanelData
UIGroceryStoreCtrl.GetDataFromServer = GetDataFromServer
UIGroceryStoreCtrl.GetAllCompleteReward = GetAllCompleteReward
UIGroceryStoreCtrl.CompleteOneOrder = CompleteOneOrder
UIGroceryStoreCtrl.GotoFactory = GotoFactory
UIGroceryStoreCtrl.OnSearchEnd = OnSearchEnd
UIGroceryStoreCtrl.DoCompleteOneOrder = DoCompleteOneOrder
UIGroceryStoreCtrl.DeleteOne = DeleteOne
return UIGroceryStoreCtrl
