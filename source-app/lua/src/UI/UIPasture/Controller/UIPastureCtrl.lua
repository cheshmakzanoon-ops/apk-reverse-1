local UIPastureCtrl = BaseClass("UIPastureCtrl", UIBaseCtrl)
local SHOW_ANIMAL_BUY_BELOW_LEVEL = 5
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPasture)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function InitData(self, uuid, btnType)
  local tempUuid = tonumber(uuid)
  self.btnType = btnType or nil
  self.isCanPlant = false
  self.buildUuid = 0
  self.buildId = 0
  self.usingItemAndResource = {}
  self.sendPlantMessage = false
  self.speedAdd = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_PASTURE_SPEED)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(tempUuid)
  if buildData ~= nil then
    self.buildId = buildData.itemId
    self.buildUuid = tempUuid
    local queueList = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(self.buildUuid)
    if queueList ~= nil then
      table.walk(queueList, function(k, v)
        if v:GetParaState() == QueueProductState.DEFAULT and v:GetQueueState() == NewQueueState.Free then
          self.isCanPlant = true
        end
      end)
    end
    local robot = DataCenter.BuildQueueManager:GetQueueDataByBuildUuid(self.buildUuid, false, false)
    if robot ~= nil then
      self.speedAdd = self.speedAdd + robot:GetEffectValue(EffectDefine.ADD_PASTURE_SPEED)
    end
  end
  local dataTableList = DataCenter.FarmingDataManager:GetFarmTemplateByBuildIdInGroup(self.buildId)
  self.unlockTip = nil
  local functionTemplate = dataTableList[1]
  if self.isCanPlant and not DataCenter.FarmingDataManager:IsUnlock(functionTemplate) then
    self.isCanPlant = false
    local needConditionId, needConditionLv
    table.walk(functionTemplate.unlock_condition, function(a, b)
      needConditionId = a
      needConditionLv = b
    end)
    local needPlayerLevel = false
    if not DataCenter.PlayerLevelManager:ReachLevel(functionTemplate.unlock_player_level) then
      needPlayerLevel = true
    end
    local descText = ""
    if needPlayerLevel then
      descText = Localization:GetString("120986", functionTemplate.unlock_player_level)
    elseif functionTemplate.unlock_type == TemplateUnlockType.Build then
      local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(needConditionId)
      if template then
        descText = Localization:GetString(GameDialogDefine.NEED_SOMETHING_REACH_SOMETHING, Localization:GetString(template.name), needConditionLv)
      end
    elseif functionTemplate.unlock_type == TemplateUnlockType.Science then
      local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(needConditionId, needConditionLv)
      if template then
        descText = Localization:GetString(GameDialogDefine.FARM_IS_LOCK_SCIENCE, Localization:GetString(template.name), needConditionLv)
      end
    elseif functionTemplate.unlock_type == TemplateUnlockType.Talent then
      local template = DataCenter.TalentTemplateManager:GetTemplate(needConditionId)
      if template then
        descText = Localization:GetString(GameDialogDefine.FARM_IS_LOCK_SCIENCE, template.name)
      end
    end
    self.unlockTip = descText
  end
  self.queueList = {}
  self.plantQueueList = {}
  self.tempResource = {}
end

local function GetBUuid(self)
  return self.buildUuid
end

local function ResetUsingItemAndResource(self)
  if self.usingItemAndResource == nil then
    return
  end
  table.remove(self.usingItemAndResource)
end

local function RemoveBusyQueueItemAndResource(self)
  local temp = {}
  table.walk(self.usingItemAndResource, function(k, v)
    local qUuid = v.qUuid
    local queueData = DataCenter.QueueDataManager:GetQueueByUuid(qUuid)
    if queueData == nil or queueData:GetQueueState() ~= NewQueueState.Free then
      table.insert(temp, v)
    end
  end)
  table.walk(temp, function(k, v)
    local pos = table.keyof(self.usingItemAndResource, v)
    if pos ~= nil then
      table.remove(self.usingItemAndResource, pos)
    end
  end)
end

local function AddUsingItemAndResource(self, id, num, count, qUuid)
  if id == nil or num == nil or count == nil then
    return
  end
  self:RemoveBusyQueueItemAndResource()
  num = num * count
  local find = false
  table.walk(self.usingItemAndResource, function(k, v)
    if qUuid == v.qUuid then
      v.num = v.num + num
    end
  end)
  if find == false then
    local data = {}
    data.id = id
    data.num = num
    data.qUuid = qUuid
    table.insert(self.usingItemAndResource, data)
  end
end

local function GetUsingItemAndResource(self, id)
  local result = 0
  self:RemoveBusyQueueItemAndResource()
  table.walk(self.usingItemAndResource, function(k, v)
    if id == v.id then
      result = result + v.num
    end
  end)
  return result
end

local function GetAnimalData(self)
  local data = {}
  local dataTableList = DataCenter.FarmingDataManager:GetFarmTemplateByBuildIdInGroup(self.buildId)
  data.farmState = FarmStateType.Plant
  data.sizeX = 130
  data.sizeY = 130
  data.unlock = self.isCanPlant
  data.unlockTip = self.unlockTip
  local animalNum = 0
  local queueList = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(self.buildUuid)
  if queueList ~= nil then
    table.walk(queueList, function(k, v)
      if v:GetParaState() == QueueProductState.DEFAULT and v:GetQueueState() == NewQueueState.Free then
      else
        animalNum = animalNum + 1
      end
    end)
  end
  if self.isCanPlant then
    local isFree = false
    if queueList ~= nil then
      table.walk(queueList, function(k, v)
        if v:GetParaState() == QueueProductState.DEFAULT and v:GetQueueState() == NewQueueState.Free then
          isFree = true
        end
      end)
    end
    data.unlock = isFree
  end
  if dataTableList ~= nil then
    local functionTemplate = dataTableList[1]
    data.productId = functionTemplate.id
    data.modelName = functionTemplate.modelName
    data.icon = "Assets/Main/Sprites/ItemIcons/" .. functionTemplate.icon
    data.hasDes = true
    data.name = functionTemplate.product_name
    local time = math.ceil(tonumber(functionTemplate.produce_time) / (1 + self.speedAdd / 100))
    data.produce_time = time
    data.order = functionTemplate.order
    table.walk(functionTemplate:GetNeedResource(animalNum), function(c, d)
      data.needResourceType = c
      data.needResourceNum = d
      data.needResourceIcon = DataCenter.ResourceManager:GetResourceIconByType(data.needResourceType)
    end)
    table.walk(functionTemplate.need_goods, function(e, f)
      data.needGoodsId = e
      data.needGoodsNum = f
      local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(data.needGoodsId)
      data.needGoodsIcon = ""
      if template ~= nil then
        data.needGoodsIcon = template:GetIconPath()
      end
    end)
  end
  return data
end

local function GetIrrigateData(self)
  local data = {}
  local dataTableList = DataCenter.FarmingDataManager:GetFarmTemplateByBuildIdInGroup(self.buildId)
  if dataTableList ~= nil then
    local functionTemplate = dataTableList[1]
    data.productId = functionTemplate.id
  end
  data.icon = "Assets/Main/Sprites/pve/feilaio"
  data.name = 395181
  data.hasDes = false
  data.farmState = FarmStateType.Irrigate
  data.order = 0
  data.sizeX = 130
  data.sizeY = 130
  data.canIrrigate = self:CheckIfCanIrrigate()
  data.needResourceIcon = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Water)
  data.irrigateInfo = DataCenter.PlayerCareerManager:GetIrrigationInfo(IrrigationType.Pasture)
  return data
end

local function CheckIfCanIrrigate(self)
  local unlock = DataCenter.PlayerCareerManager:CheckIfIrrigateAvailable(IrrigationType.Pasture)
  if not unlock then
    return false
  end
  if self.buildUuid == nil then
    return false
  end
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.buildUuid)
  local result = false
  if buildData ~= nil then
    local queueList = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(self.buildUuid)
    if queueList ~= nil then
      table.walk(queueList, function(k, v)
        if v:GetQueueState() == NewQueueState.Work and not v:CheckIfIrrigated() then
          result = result or true
        end
      end)
    end
  end
  return result
end

local function GetFeedData(self)
  local data = {}
  local dataTableList = DataCenter.FarmingDataManager:GetFarmTemplateByBuildIdInGroup(self.buildId)
  if dataTableList ~= nil then
    local functionTemplate = dataTableList[1]
    local itemId
    local canGetItemNum = 0
    table.walk(functionTemplate.second_get_goods, function(m, n)
      itemId = m
      canGetItemNum = n
    end)
    local resourceItemData = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemId)
    if resourceItemData ~= nil then
      data = {}
      data.productId = functionTemplate.id
      data.itemId = itemId
      data.canGetItemNum = canGetItemNum
      data.hasDes = true
      data.name = functionTemplate.second_product_name
      data.order = functionTemplate.order
      do
        local time = math.ceil(tonumber(functionTemplate.second_produce_time) / (1 + self.speedAdd / 100))
        data.produce_time = time
        data.icon = "Assets/Main/Sprites/UI/UIFarm/UIFarm_icon_feed"
        table.walk(functionTemplate.second_need_goods, function(e, f)
          data.needGoodsId = e
          data.needGoodsNum = f
          data.needGoodsIcon = ""
          local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(data.needGoodsId)
          if template ~= nil then
            data.needGoodsIcon = template:GetIconPath()
            data.icon = data.needGoodsIcon
          end
        end)
        data.needGoodsCurNum = 0
        local itemData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(data.needGoodsId, LuaEntry.Player.uid)
        if itemData ~= nil then
          data.needGoodsCurNum = itemData.number
        end
        data.itemIcon = "Assets/Main/Sprites/ItemIcons/" .. resourceItemData.pic
      end
    end
  end
  data.farmState = FarmStateType.Feed
  data.sizeX = 130
  data.sizeY = 130
  data.unlock = self:CanFeed()
  if data.unlock then
    local isFeed = false
    if data.needGoodsCurNum >= data.needGoodsNum then
      isFeed = true
    end
    data.unlock = isFeed
  end
  return data
end

local function CanFeed(self)
  if self.buildUuid == nil then
    return false
  end
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.buildUuid)
  local result = false
  if buildData ~= nil then
    local queueList = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(self.buildUuid)
    if queueList ~= nil then
      table.walk(queueList, function(k, v)
        if v:GetParaState() == QueueProductState.DEFAULT and v:GetQueueState() == NewQueueState.Finish or v:GetParaState() == QueueProductState.PASTURE_MATURE and v:GetQueueState() == NewQueueState.Free or v:GetParaState() == QueueProductState.DEFAULT and v:GetQueueState() == NewQueueState.Work then
          result = true
        end
      end)
    end
  end
  return result
end

local function GetGatherData(self)
  local data = {}
  local dataTableList = DataCenter.FarmingDataManager:GetFarmTemplateByBuildIdInGroup(self.buildId)
  if dataTableList ~= nil then
    local functionTemplate = dataTableList[1]
    data.productId = functionTemplate.id
  end
  data.icon = "Assets/Main/Sprites/UI/UIFarm/UIFarm_icon_harvest2"
  data.hasDes = false
  data.farmState = FarmStateType.HarvestSecond
  data.order = 0
  data.sizeX = 130
  data.sizeY = 130
  data.unlock = self:CanHarvest()
  return data
end

local function CanHarvest(self)
  if self.buildUuid == nil then
    return false
  end
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.buildUuid)
  local result = false
  if buildData ~= nil then
    local queueList = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(self.buildUuid)
    if queueList ~= nil then
      table.walk(queueList, function(k, v)
        if v:GetParaState() == QueueProductState.PASTURE_MATURE and v:GetQueueState() == NewQueueState.Finish then
          result = true
        end
      end)
    end
  end
  return result
end

local function CheckIsResourceEnough(self, needResourceType, needResourceNum, count)
  if needResourceType == nil or needResourceNum == nil or count == nil then
    return true
  else
    local totalNum = needResourceNum * count + self:GetUsingItemAndResource(needResourceType)
    return totalNum <= LuaEntry.Resource:GetCntByResType(needResourceType)
  end
end

local function CheckIsResourceGoodsEnough(self, needGoodsId, needGoodsNum, count)
  if needGoodsId == nil or needGoodsNum == nil or count == nil then
    return true
  else
    local cnt = 0
    local item = DataCenter.ResourceItemDataManager:GetItemDataByItemId(needGoodsId, LuaEntry.Player.uid)
    if item ~= nil then
      cnt = item.number
    end
    needGoodsNum = needGoodsNum + self:GetUsingItemAndResource(needGoodsId)
    local totalNum = needGoodsNum * count
    return cnt >= needGoodsNum
  end
end

local function OnPlant(self, curPos, itemData, queueData)
  if queueData ~= nil and self:GetPlantState() == false and (queueData.type == NewQueueType.SandWormBarn or queueData.type == NewQueueType.CattleBarn or queueData.type == NewQueueType.OstrichBarn) and itemData.farmState == FarmStateType.Plant then
    self.productId = itemData.productId
    if self.plantQueueList[queueData.uuid] == nil and queueData:GetQueueState() == NewQueueState.Free and queueData:GetParaState() == QueueProductState.DEFAULT then
      if self:CheckIsResourceEnough(itemData.needResourceType, itemData.needResourceNum, 1) and self:CheckIsResourceGoodsEnough(itemData.needGoodsId, itemData.needGoodsNum, 1) then
        self.plantQueueList[queueData.uuid] = 1
        self:SetPlantState(true)
        SFSNetwork.SendMessage(MsgDefines.FarmFarming, {
          queueData.uuid
        }, self.productId)
        if itemData.needResourceNum ~= nil then
          local desNum = itemData.needResourceNum
          local pos = CS.SceneManager.World:WorldToScreenPoint(curPos)
          DataCenter.DropResourceEffectManager:DropOneItemEffect(pos, itemData.icon, queueData.funcUuid)
          DataCenter.DecResourceEffectManager:DecOneItemEffect(curPos, itemData.needResourceIcon, -desNum, queueData.funcUuid)
        elseif itemData.needGoodsNum ~= nil then
          local desNum = itemData.needGoodsNum
          local pos = CS.SceneManager.World:WorldToScreenPoint(curPos)
          DataCenter.DropResourceEffectManager:DropOneItemEffect(pos, itemData.icon, queueData.funcUuid)
          DataCenter.DecResourceEffectManager:DecOneItemEffect(curPos, itemData.needGoodsIcon, -desNum, queueData.funcUuid)
        end
      else
        local lackTab = {}
        local param = {}
        param.type = ResLackType.Res
        param.resType = itemData.needResourceType
        param.targetNum = itemData.needResourceNum
        table.insert(lackTab, param)
        GoToResLack.GoToItemResLackList(lackTab)
      end
    end
  end
end

local function OnIrrigateAnimal(self, curPos, itemData, queueData)
  if queueData and itemData.farmState == FarmStateType.Irrigate and not queueData:CheckIfIrrigated() and queueData:GetQueueState() == NewQueueState.Work and tostring(itemData.productId) == queueData.itemId then
    local costNum = itemData.irrigateInfo.cost
    if not self:CheckIsResourceEnough(ResourceType.Water, costNum) then
      local pos = CS.SceneManager.World:WorldToScreenPoint(curPos)
      local lackTab = {}
      local param = {}
      param.type = ResLackType.Res
      param.resType = ResourceType.Water
      param.targetNum = costNum - self.tempResource[ResourceType.Water]
      table.insert(lackTab, param)
      GoToResLack.GoToItemResLackList(lackTab, nil, Vector3.New(pos.x, pos.y, pos.z))
      CS.SceneManager.World:QuitFocus(LookAtFocusTime)
      DataCenter.CareerEffectManager:RemoveAll()
    elseif self.queueList[queueData.uuid] == nil then
      if itemData.irrigateInfo.remainTimes > 0 then
        self.queueList[queueData.uuid] = 1
        SFSNetwork.SendMessage(MsgDefines.FarmerIrrigate, queueData.uuid)
        DataCenter.DecResourceEffectManager:DecOneItemEffect(curPos, itemData.needResourceIcon, -costNum, queueData.uuid)
        if self.tempResource[ResourceType.Water] ~= nil then
          self.tempResource[ResourceType.Water] = self.tempResource[ResourceType.Water] - costNum
        end
      else
        UIUtil.ShowTipsId(GameDialogDefine.LACK_RESOURCE)
      end
    end
  end
end

local function OnFeedAnimal(self, curPos, itemData, queueData)
  if queueData ~= nil and itemData.farmState == FarmStateType.Feed and (queueData:GetParaState() == QueueProductState.DEFAULT and queueData:GetQueueState() == NewQueueState.Finish or queueData:GetParaState() == QueueProductState.PASTURE_MATURE and queueData:GetQueueState() == NewQueueState.Free) and tostring(itemData.productId) == queueData.itemId and self.queueList[queueData.uuid] == nil then
    if self:CheckIsResourceEnough(itemData.needResourceType, itemData.needResourceNum, 1) and self:CheckIsResourceGoodsEnough(itemData.needGoodsId, itemData.needGoodsNum, 1) then
      self.queueList[queueData.uuid] = 1
      self:AddUsingItemAndResource(itemData.needResourceType, itemData.needResourceNum, 1, queueData.uuid)
      self:AddUsingItemAndResource(itemData.needGoodsId, itemData.needGoodsNum, 1, queueData.uuid)
      local param = {}
      param.product_id = itemData.productId
      DataCenter.GuideManager:SetCompleteNeedParam(param)
      DataCenter.GuideManager:CheckGuideComplete()
      SFSNetwork.SendMessage(MsgDefines.FeedAnimal, {
        queueData.uuid
      })
      if itemData.needResourceNum ~= nil then
        local desNum = itemData.needResourceNum
        local pos = CS.SceneManager.World:WorldToScreenPoint(curPos)
        DataCenter.DropResourceEffectManager:DropOneItemEffect(pos, itemData.icon, queueData.funcUuid)
        DataCenter.DecResourceEffectManager:DecOneItemEffect(curPos, itemData.needResourceIcon, -desNum, queueData.funcUuid)
      elseif itemData.needGoodsNum ~= nil then
        local desNum = itemData.needGoodsNum
        local pos = CS.SceneManager.World:WorldToScreenPoint(curPos)
        DataCenter.DropResourceEffectManager:DropOneItemEffect(pos, itemData.icon, queueData.funcUuid)
        DataCenter.DecResourceEffectManager:DecOneItemEffect(curPos, itemData.needGoodsIcon, -desNum, queueData.funcUuid)
      end
      if queueData.type == NewQueueType.OstrichBarn then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Farm_Ostrich1, false)
      else
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Feed, false)
      end
    else
      UIUtil.ShowTipsId(GameDialogDefine.LACK_RESOURCE)
    end
  end
end

local function OnGatherProduct(self, curPos, itemData, queueData)
  if queueData ~= nil and itemData.farmState == FarmStateType.HarvestSecond and queueData:GetParaState() == QueueProductState.PASTURE_MATURE and queueData:GetQueueState() == NewQueueState.Finish and self.queueList[queueData.uuid] == nil and tostring(itemData.productId) == queueData.itemId then
    local functionId = queueData.itemId
    local functionTemplate = DataCenter.FarmingDataManager:GetFramingTemplate(functionId)
    if functionTemplate ~= nil then
      self.queueList[queueData.uuid] = 1
      if self:CheckIsStorageFull(itemData.farmState, queueData.uuid) then
        if DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ResourceItemFull, tostring(BuildingTypes.FUN_BUILD_COLD_STORAGE)) then
          DataCenter.GuideManager:SetGuideEndCallBack(function()
            GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
          end)
        else
          GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
        end
      elseif DataCenter.ResourceItemDataManager:CanSendQueueFinishBatchMessage() == true then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Product2, false)
        SFSNetwork.SendMessage(MsgDefines.QueueFinishBatch, {
          queueData.uuid
        }, QueueProductState.PASTURE_MATURE)
        local pos = CS.SceneManager.World:WorldToScreenPoint(curPos)
        DataCenter.PlayerLevelManager:FlyExp(ExpSource.Pasture, pos, functionTemplate.exp)
        table.walk(functionTemplate.second_get_goods, function(m, n)
          local resourceItemData = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(m)
          local icon = resourceItemData:GetIconPath()
          local rewardType = RewardType.GOODS
          local tempNum = 1
          if queueData:CheckIfIrrigated() then
            tempNum = 2
          end
          UIUtil.DoFly(tonumber(rewardType), tempNum, icon, pos, Vector3.New(0, 0, 0))
          local str = tostring(queueData.funcUuid) .. ";" .. tostring(m)
          EventManager:GetInstance():Broadcast(EventId.ShowCapacitySecond, str)
        end)
      end
    end
  end
end

local function OnDragFinish(self, closePanel)
  self.productId = 0
  self.queueList = {}
  self.plantQueueList = {}
  PastureAnimalManager:GetInstance():SetSelectBuildState(FarmStateType.None)
  PastureAnimalManager:GetInstance():SetSelectBUuid(0)
  if closePanel == true then
    self:CloseSelf()
  end
end

local function CheckIsStorageFull(self, farmState, qUuid)
  local isFull = false
  local addNum = 0
  table.walk(self.queueList, function(k, v)
    local queueData = DataCenter.QueueDataManager:GetQueueByUuid(k)
    if queueData ~= nil and queueData:GetQueueState() == NewQueueState.Finish then
      local functionId = queueData.itemId
      local farmTemplate = DataCenter.FarmingDataManager:GetFramingTemplate(functionId)
      if farmTemplate ~= nil then
        local canGetNum = 0
        local itemId = 0
        if farmState == FarmStateType.HarvestSecond then
          do
            local isDouble = queueData:CheckIfIrrigated()
            table.walk(farmTemplate.second_get_goods, function(m, n)
              itemId = m
              canGetNum = (isDouble and n * 2 or n) + canGetNum
            end)
            if DataCenter.ResourceItemDataManager:CheckIsStorageFull(addNum + canGetNum) then
              isFull = true
            else
              addNum = canGetNum + addNum
            end
          end
        end
      end
    end
  end)
  if isFull then
    self.queueList[qUuid] = nil
  end
  return isFull
end

local function GetPlantState(self)
  return self.sendPlantMessage
end

local function SetPlantState(self, value)
  self.sendPlantMessage = value
end

local function IsMax(self)
  local queueList = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(self.buildUuid)
  if queueList ~= nil then
    for k, v in pairs(queueList) do
      if v:GetParaState() == QueueProductState.DEFAULT and v:GetQueueState() == NewQueueState.Free then
        return false
      end
    end
  end
  return true
end

local function CanShowBuy(self)
  if not self:IsMax() then
    return true
  end
  local currentNum = 0
  local queueList = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(self.buildUuid)
  if queueList ~= nil then
    for k, v in pairs(queueList) do
      if v:GetParaState() == QueueProductState.DEFAULT and v:GetQueueState() == NewQueueState.Free then
      else
        currentNum = currentNum + 1
      end
    end
  end
  return currentNum < SHOW_ANIMAL_BUY_BELOW_LEVEL
end

local function GetBtnType(self)
  return self.btnType
end

local function ShowFeedQueueTime(self)
  local queueList = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(self.buildUuid)
  for k, v in pairs(queueList) do
    if v ~= nil and v:GetQueueState() == NewQueueState.Work then
      local signal = SFSObject.New()
      signal:PutLong("bUuid", self.buildUuid)
      signal:PutLong("queueUuid", k)
      EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildShow, signal)
      break
    end
  end
end

local function CheckIsResourceEnough(self, needResourceType, needResourceNum)
  if needResourceType == nil or needResourceNum == nil then
    return true
  else
    local totalNum = needResourceNum
    if self.tempResource[needResourceType] == nil then
      self.tempResource[needResourceType] = LuaEntry.Resource:GetCntByResType(needResourceType)
    end
    return totalNum <= self.tempResource[needResourceType]
  end
end

UIPastureCtrl.CloseSelf = CloseSelf
UIPastureCtrl.Close = Close
UIPastureCtrl.InitData = InitData
UIPastureCtrl.CheckIsResourceEnough = CheckIsResourceEnough
UIPastureCtrl.CheckIsResourceGoodsEnough = CheckIsResourceGoodsEnough
UIPastureCtrl.GetBUuid = GetBUuid
UIPastureCtrl.GetAnimalData = GetAnimalData
UIPastureCtrl.GetGatherData = GetGatherData
UIPastureCtrl.GetFeedData = GetFeedData
UIPastureCtrl.OnPlant = OnPlant
UIPastureCtrl.OnFeedAnimal = OnFeedAnimal
UIPastureCtrl.OnGatherProduct = OnGatherProduct
UIPastureCtrl.OnDragFinish = OnDragFinish
UIPastureCtrl.CheckIsStorageFull = CheckIsStorageFull
UIPastureCtrl.GetPlantState = GetPlantState
UIPastureCtrl.SetPlantState = SetPlantState
UIPastureCtrl.IsMax = IsMax
UIPastureCtrl.ResetUsingItemAndResource = ResetUsingItemAndResource
UIPastureCtrl.AddUsingItemAndResource = AddUsingItemAndResource
UIPastureCtrl.GetUsingItemAndResource = GetUsingItemAndResource
UIPastureCtrl.RemoveBusyQueueItemAndResource = RemoveBusyQueueItemAndResource
UIPastureCtrl.CanFeed = CanFeed
UIPastureCtrl.CanHarvest = CanHarvest
UIPastureCtrl.GetBtnType = GetBtnType
UIPastureCtrl.ShowFeedQueueTime = ShowFeedQueueTime
UIPastureCtrl.CanShowBuy = CanShowBuy
UIPastureCtrl.GetIrrigateData = GetIrrigateData
UIPastureCtrl.OnIrrigateAnimal = OnIrrigateAnimal
UIPastureCtrl.CheckIfCanIrrigate = CheckIfCanIrrigate
UIPastureCtrl.CheckIsResourceEnough = CheckIsResourceEnough
return UIPastureCtrl
