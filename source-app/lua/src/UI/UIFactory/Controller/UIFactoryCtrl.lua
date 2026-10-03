local UIFactoryCtrl = BaseClass("UIFactoryCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFactory)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Background)
end

local function InitData(self, factoryUid, buildId)
  self.factoryUid = factoryUid
  self.buildId = buildId
  local data = DataCenter.BattleLevel:GetPveTriggerBuildingInfo(self.buildId)
  self.isPve = data ~= nil
  self.speedAdd = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_FACTORY_SPEED)
  local robot = DataCenter.BuildQueueManager:GetQueueDataByBuildUuid(self.factoryUid, false, false)
  if robot ~= nil then
    self.speedAdd = self.speedAdd + robot:GetEffectValue(EffectDefine.ADD_FACTORY_SPEED)
  end
end

local function SendAddBoxMessage(self, type, needGoldNum)
  if type == ResourceType.Gold then
    local gold = LuaEntry.Player.gold
    if needGoldNum ~= nil and needGoldNum <= gold then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFactoryAddTip, self.factoryUid, self.buildId)
    else
      UIUtil.ShowTipsId("E100001")
    end
  else
    local num = LuaEntry.Resource:GetCntByResType(type)
    if needGoldNum ~= nil and needGoldNum <= num then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFactoryAddTip, self.factoryUid, self.buildId)
    else
      local lackTab = {}
      local param = {}
      param.type = ResLackType.Res
      param.resType = type
      param.targetNum = needGoldNum
      table.insert(lackTab, param)
      GoToResLack.GoToItemResLackList(lackTab)
    end
  end
end

local function GetProductData(self)
  local data = {}
  data.isLargeModel = false
  data.showAddBox = true
  local factoryData = DataCenter.FactoryDataManager:GetFactoryDataByBUuid(self.factoryUid)
  if factoryData ~= nil then
    local maxBoxNum = DataCenter.FactoryDataManager:GetMaxPlanZoneNum(self.buildId, self.isPve)
    local addNum = factoryData.unlocked
    local totalNum = addNum
    local items = DataCenter.FactoryDataManager:GetTypePriceByBuildid(self.buildId)
    local currentBuyNum = totalNum + 1
    for k, v in pairs(items) do
      if currentBuyNum == v.id then
        data.type = v.type
        data.needGoldNum = v.count
      end
    end
    if 4 <= totalNum then
      data.isLargeModel = true
    end
    if maxBoxNum <= totalNum then
      data.showAddBox = false
    end
    data.states = DataCenter.FactoryDataManager:GetFactoryAllStateByBuildUuid(self.factoryUid)
    data.state = DataCenter.FactoryDataManager:GetFactoryStateByBuildUuid(self.factoryUid)
    local workingList = factoryData.workingList
    local list = {}
    local effect = LuaEntry.Effect:GetGameEffect(EffectDefine.FACTORY_CANCEL_EFFECT_ID)
    table.walk(workingList, function(k, v)
      if v ~= nil then
        local tmp = {}
        tmp.product = v.product
        tmp.index = v.index
        tmp.startTime = v.startTime
        tmp.endTime = v.endTime
        tmp.stopTime = v.stopTime
        tmp.factoryUid = self.factoryUid
        tmp.state = data.states[k] or FactoryWorkState.Free
        tmp.showCancel = false
        table.insert(list, tmp)
      end
    end)
    data.workingList = list
    local workingCount = table.count(list)
    data.multiQueue = 1 < workingCount
    data.boxDataList = {}
    for i = 1, totalNum do
      local oneData = {}
      if factoryData.planZoneList[i] ~= nil and factoryData.planZoneList[i] ~= "0" then
        oneData.itemId = factoryData.planZoneList[i]
        oneData.needGoodIconList = {}
        oneData.index = i
        oneData.showCancel = 0 < effect and i > workingCount
        oneData.cancelIndex = i - workingCount
        oneData.factoryUid = self.factoryUid
        local template = DataCenter.FactoryDataManager:GetFactoryTemplate(factoryData.planZoneList[i])
        if template ~= nil then
          oneData.itemPic = "Assets/Main/Sprites/ItemIcons/" .. template.icon
          table.walk(template.need_resource, function(e, f)
            local temp = DataCenter.ResourceTemplateManager:GetResourceTemplate(e)
            local needGoodsIcon = ""
            if temp ~= nil then
              needGoodsIcon = string.format(LoadPath.LWCommonPath, temp.icon)
            end
            table.insert(oneData.needGoodIconList, needGoodsIcon)
          end)
          table.walk(template.need_resource_goods, function(e, f)
            local temp = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(e)
            local needGoodsIcon = ""
            if temp ~= nil then
              needGoodsIcon = "Assets/Main/Sprites/ItemIcons/" .. temp.pic
            end
            table.insert(oneData.needGoodIconList, needGoodsIcon)
          end)
        end
      end
      table.insert(data.boxDataList, oneData)
    end
    data.gatherList = {}
    table.walk(factoryData.productZoneList, function(k, v)
      local oneData = {}
      local template = DataCenter.FactoryDataManager:GetFactoryTemplate(v)
      if template == nil then
        return
      end
      local product = template:GetMainProduct()
      if product ~= nil then
        local itemId = product.itemId
        local itemNum = product.num
        oneData.itemId = itemId
        oneData.icon = template:GetProductShowIcon()
        oneData.name = template:GetProductShowName()
        oneData.itemNum = itemNum
        oneData.needCheckStorageNum = template:GetProductResourceItemNum()
        oneData.factoryId = v
        oneData.productList = DeepCopy(template.productList)
        oneData.exp = template.exp
        table.insert(data.gatherList, oneData)
      end
    end)
  end
  return data
end

local function SendGatherMessage(self, gatherDic)
  if table.count(gatherDic) > 0 then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Product3, false)
    SFSNetwork.SendMessage(MsgDefines.GatherProduct, self.factoryUid, gatherDic)
  end
end

local function GetItemList(self, productLv)
  local dataTableList = DataCenter.FactoryDataManager:GetFactoryTemplateByBuildIdInGroup(self.buildId, productLv, self.isPve)
  local list = {}
  if dataTableList ~= nil then
    table.walk(dataTableList, function(k, v)
      local data = self:GetRecipeData(v)
      if data ~= nil then
        data.buildType = self.buildId
        data.sizeX = 200
        data.sizeY = 200
        table.insert(list, data)
      end
    end)
  end
  table.sort(list, function(a, b)
    if a.isUnlock == true and b.isUnlock == false then
      return true
    elseif a.isUnlock == b.isUnlock then
      return a.order < b.order
    end
    return false
  end)
  return list
end

local function ShowItemNum(self, type)
  return type == FactoryProductType.FactoryProductType_Resource_Item
end

local function GetRecipeData(self, functionTemplate)
  local data
  local product = functionTemplate:GetMainProduct()
  if product ~= nil then
    local itemId = product.itemId
    local canGetItemNum = product.num
    local type = product.type
    data = {}
    data.productId = functionTemplate.id
    data.modelName = functionTemplate.modelName
    data.itemId = itemId
    data.canGetItemNum = canGetItemNum
    data.icon = "Assets/Main/Sprites/ItemIcons/" .. functionTemplate.icon
    data.hasDes = true
    data.name = functionTemplate:GetNumProductName()
    local time = math.ceil(tonumber(functionTemplate:GetProductTime()) / (1 + self.speedAdd / 100))
    data.produce_time = time
    data.order = functionTemplate.order
    data.unlock_type = functionTemplate.unlock_type
    table.walk(functionTemplate.unlock_condition, function(a, b)
      data.needConditionId = a
      data.needConditionLv = b
    end)
    data.needGoodList = {}
    table.walk(functionTemplate.need_resource, function(c, d)
      local oneData = {}
      oneData.needType = "resource"
      oneData.needGoodsId = c
      oneData.needGoodsNum = d
      oneData.needGoodsIcon = DataCenter.ResourceManager:GetResourceIconByType(oneData.needGoodsId)
      table.insert(data.needGoodList, oneData)
    end)
    table.walk(functionTemplate.need_resource_goods, function(e, f)
      local oneData = {}
      oneData.needType = "good"
      oneData.needGoodsId = e
      oneData.needGoodsNum = f
      local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(oneData.needGoodsId)
      oneData.needGoodsIcon = ""
      if template ~= nil then
        oneData.needGoodsIcon = "Assets/Main/Sprites/ItemIcons/" .. template.pic
      end
      table.insert(data.needGoodList, oneData)
    end)
    data.itemIcon = functionTemplate:GetProductShowIcon()
    local itemData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(itemId, LuaEntry.Player.uid)
    data.curNum = 0
    data.showNum = self:ShowItemNum(type)
    if itemData ~= nil then
      data.curNum = itemData.number
    end
    data.isUnlock = DataCenter.FactoryDataManager:IsUnlockProductByProductId(data.productId)
    data.unlock_player_level = functionTemplate.unlock_player_level
  end
  return data
end

local function OnDragFinish(self, itemData, factoryUid)
  if self:CheckHasFreeQueue(factoryUid) then
    SFSNetwork.SendMessage(MsgDefines.SetOnePlan, factoryUid, itemData.productId)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Put_Formula, false)
  end
end

local function CheckIsStorageFull(self, itemId, num)
  local isFull = false
  local storageMax = DataCenter.ResourceItemDataManager:GetFreezerStorageMax()
  local curNum = DataCenter.ResourceItemDataManager:GetResourceItemTotalNumByType(ResourceItemType.Farming)
  if storageMax < curNum + num then
    isFull = true
  end
  return isFull
end

local function CheckHasFreeQueue(self, factoryUid)
  return DataCenter.FactoryDataManager:CheckHasFreeQueue(factoryUid)
end

local function OnSearchEnd(self, pointId, uuid)
  local worldPosition = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
  WorldArrowManager:GetInstance():ShowArrowEffect(uuid, worldPosition, ArrowType.Monster)
  GoToUtil.GotoWorldPos(worldPosition, CS.SceneManager.World.InitZoom)
end

local function GetProductLevels(self)
  return DataCenter.FactoryDataManager:GetProductLevels(self.buildId)
end

UIFactoryCtrl.CloseSelf = CloseSelf
UIFactoryCtrl.Close = Close
UIFactoryCtrl.InitData = InitData
UIFactoryCtrl.GetProductData = GetProductData
UIFactoryCtrl.SendAddBoxMessage = SendAddBoxMessage
UIFactoryCtrl.SendGatherMessage = SendGatherMessage
UIFactoryCtrl.GetItemList = GetItemList
UIFactoryCtrl.GetRecipeData = GetRecipeData
UIFactoryCtrl.OnDragFinish = OnDragFinish
UIFactoryCtrl.CheckIsStorageFull = CheckIsStorageFull
UIFactoryCtrl.CheckHasFreeQueue = CheckHasFreeQueue
UIFactoryCtrl.OnSearchEnd = OnSearchEnd
UIFactoryCtrl.GetProductLevels = GetProductLevels
UIFactoryCtrl.ShowItemNum = ShowItemNum
return UIFactoryCtrl
