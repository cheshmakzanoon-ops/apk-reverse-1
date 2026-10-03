local UIFarmNewCtrl = BaseClass("UIFarmNewCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFarm)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Background)
end

local function InitData(self, data)
  local buildUuid = tonumber(data)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(buildUuid)
  self.speedAdd = 0
  if buildData ~= nil then
    self.buildId = buildData.itemId
  end
  self.speedAdd = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_FARM_SPEED)
  local farmLand = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.APS_BUILD_FARM)
  if farmLand ~= nil then
    local robot = DataCenter.BuildQueueManager:GetQueueDataByBuildUuid(farmLand.uuid, false, false)
    if robot ~= nil then
      self.speedAdd = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_FARM_SPEED) + robot:GetEffectValue(EffectDefine.ADD_FARM_SPEED)
    end
  end
  local queueData = DataCenter.QueueDataManager:GetQueueByBuildUuidForFarm(buildUuid)
  if queueData ~= nil then
    self.qUuid = queueData.uuid
  end
  self.productId = 0
  self.queueList = {}
  self.tempResource = {}
end

local function GetItemList(self, currentItemIndex)
  return self:GetFarmItemListData(currentItemIndex)
end

local function GetFarmItemListData(self, currentItemIndex)
  local tmp = {}
  if self.qUuid ~= nil and self.buildId ~= nil then
    local queueData = DataCenter.QueueDataManager:GetQueueByUuid(self.qUuid)
    if queueData:GetQueueState() == NewQueueState.Free then
      local dataTableList = DataCenter.FarmingDataManager:GetFarmTemplateByBuildIdInGroup(self.buildId, currentItemIndex)
      if dataTableList ~= nil then
        table.walk(dataTableList, function(k, v)
          local data = self:GetRecipeData(v)
          if data ~= nil then
            data.farmState = FarmStateType.Plant
            data.buildType = self.buildId
            data.sizeX = 130
            data.sizeY = 130
            table.insert(tmp, data)
          end
        end)
      end
    end
  end
  table.sort(tmp, function(a, b)
    if a.lockStatus == true and b.lockStatus == false then
      return true
    elseif a.lockStatus == b.lockStatus then
      if a.lockStatus then
        return a.order < b.order
      end
      return a.unlock_order < b.unlock_order
    end
    return false
  end)
  local list = {}
  for _, v in ipairs(tmp) do
    table.insert(list, v)
    if v.lockStatus == false then
      break
    end
  end
  return list
end

local function GetBarnItemListData(self)
  local list = {}
  if self.qUuid ~= nil and self.buildId ~= nil then
    local queueData = DataCenter.QueueDataManager:GetQueueByUuid(self.qUuid)
    if queueData:GetParaState() == QueueProductState.DEFAULT and queueData:GetQueueState() == NewQueueState.Free then
      local dataTableList = DataCenter.FarmingDataManager:GetFarmTemplateByBuildIdInGroup(self.buildId)
      if dataTableList ~= nil then
        table.walk(dataTableList, function(k, v)
          local data = self:GetRecipeData(v)
          if data ~= nil then
            data.farmState = FarmStateType.Plant
            data.buildType = self.buildId
            if data.modelName == "Cattle" then
              data.sizeX = 260
              data.sizeY = 182
            elseif data.modelName == "Ostrich" then
              data.sizeX = 171
              data.sizeY = 235
            else
              data.sizeX = 130
              data.sizeY = 130
            end
            table.insert(list, data)
          end
        end)
      end
    elseif queueData:GetParaState() == QueueProductState.DEFAULT and queueData:GetQueueState() == NewQueueState.Finish or queueData:GetParaState() == QueueProductState.PASTURE_MATURE and queueData:GetQueueState() == NewQueueState.Free then
      local data = {}
      data.icon = "Assets/Main/Sprites/UI/UIFarm/UIFarm_icon_kill"
      data.hasDes = false
      data.farmState = FarmStateType.Harvest
      data.order = 0
      data.buildType = self.buildId
      data.sizeX = 272
      data.sizeY = 272
      table.insert(list, data)
      local functionId = queueData.itemId
      local farmTemplate = DataCenter.FarmingDataManager:GetFramingTemplate(functionId)
      if farmTemplate ~= nil then
        local oneData = self:GetSecondRecipeData(farmTemplate)
        if oneData ~= nil then
          oneData.farmState = FarmStateType.Feed
          oneData.buildType = self.buildId
          data.sizeX = 272
          data.sizeY = 272
          table.insert(list, oneData)
        end
      end
    elseif queueData:GetParaState() == QueueProductState.PASTURE_MATURE and queueData:GetQueueState() == NewQueueState.Finish then
      local data = {}
      data.icon = "Assets/Main/Sprites/UI/UIFarm/UIFarm_icon_harvest2"
      data.hasDes = false
      data.farmState = FarmStateType.HarvestSecond
      data.order = 0
      data.buildType = self.buildId
      data.sizeX = 272
      data.sizeY = 272
      table.insert(list, data)
    end
  end
  table.sort(list, function(a, b)
    return a.order < b.order
  end)
  return list
end

local function GetRecipeData(self, functionTemplate)
  local data, itemId
  local canGetItemNum = 0
  table.walk(functionTemplate.get_goods, function(m, n)
    itemId = m
    canGetItemNum = n
  end)
  local resourceItemData = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemId)
  if resourceItemData ~= nil then
    data = {}
    data.productId = functionTemplate.id
    data.modelName = functionTemplate.modelName
    data.itemId = itemId
    data.canGetItemNum = canGetItemNum
    data.icon = "Assets/Main/Sprites/ItemIcons/" .. functionTemplate.icon
    data.hasDes = true
    data.name = functionTemplate:GetNumProductName()
    local time = math.ceil(tonumber(functionTemplate.produce_time) / (1 + self.speedAdd / 100))
    data.produce_time = time
    data.order = functionTemplate.order
    data.unlock_order = functionTemplate.unlock_order
    data.unlock_type = functionTemplate.unlock_type
    data.unlock_player_level = functionTemplate.unlock_player_level
    table.walk(functionTemplate.unlock_condition, function(a, b)
      data.needConditionId = a
      data.needConditionLv = b
    end)
    table.walk(functionTemplate:GetNeedResource(-1), function(c, d)
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
        data.needGoodsIcon = "Assets/Main/Sprites/ItemIcons/" .. template.pic
      end
    end)
    data.itemIcon = "Assets/Main/Sprites/ItemIcons/" .. resourceItemData.pic
    local itemData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(itemId, LuaEntry.Player.uid)
    data.curNum = 0
    if itemData ~= nil then
      data.curNum = itemData.number
    end
    local checkState = true
    if data.unlock_type ~= nil then
      if data.unlock_type == TemplateUnlockType.Build then
        checkState = self:CheckIsBuildEnough(data.needConditionId, data.needConditionLv)
      elseif data.unlock_type == TemplateUnlockType.Science then
        checkState = self:CheckIsScienceEnough(data.needConditionId, data.needConditionLv)
      elseif data.unlock_type == TemplateUnlockType.MonthCard then
        checkState = DataCenter.FarmingDataManager:CheckMonthCard(functionTemplate.unlock_condition)
      elseif data.unlock_type == TemplateUnlockType.Talent then
        checkState = DataCenter.TalentDataManager:IsTalentOpen(data.needConditionId)
      end
    end
    if not DataCenter.PlayerLevelManager:ReachLevel(data.unlock_player_level) then
      checkState = false
    end
    data.lockStatus = checkState
  end
  return data
end

local function GetSecondRecipeData(self, functionTemplate)
  local data, itemId
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
    data.produce_time = functionTemplate.second_produce_time
    data.icon = "Assets/Main/Sprites/UI/UIFarm/UIFarm_icon_feed"
    table.walk(functionTemplate.second_need_goods, function(e, f)
      data.needGoodsId = e
      data.needGoodsNum = f
      data.needGoodsIcon = ""
      local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(data.needGoodsId)
      if template ~= nil then
        data.needGoodsIcon = "Assets/Main/Sprites/ItemIcons/" .. template.pic
      end
    end)
    data.itemIcon = "Assets/Main/Sprites/ItemIcons/" .. resourceItemData.pic
    local itemData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(itemId, LuaEntry.Player.uid)
    data.curNum = 0
    if itemData ~= nil then
      data.curNum = itemData.number
    end
  end
  return data
end

local function CheckIsScienceEnough(self, scienceId, scienceLv)
  if scienceId == nil or scienceLv == nil then
    return true
  else
    return scienceLv <= DataCenter.ScienceManager:GetScienceLevel(scienceId)
  end
end

local function CheckIsBuildEnough(self, buildId, buildLv)
  if buildId == nil or buildLv == nil then
    return true
  else
    return DataCenter.BuildManager:IsExistBuildByTypeLv(buildId, buildLv)
  end
end

local function CheckIsResourceEnough(self, needResourceType, needResourceNum, count)
  if needResourceType == nil or needResourceNum == nil or count == nil then
    return true
  else
    local totalNum = needResourceNum * count
    if self.tempResource[needResourceType] == nil then
      self.tempResource[needResourceType] = LuaEntry.Resource:GetCntByResType(needResourceType)
    end
    return totalNum <= self.tempResource[needResourceType]
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
    local totalNum = needGoodsNum * count
    return needGoodsNum <= cnt
  end
end

local function OnDragTrigger(self, curPos, itemData, queueData)
  if queueData ~= nil then
    if queueData.type == NewQueueType.Field then
      if itemData.farmState == FarmStateType.Plant then
        self.productId = itemData.productId
        if queueData:GetQueueState() == NewQueueState.Free and self.queueList[queueData.uuid] == nil then
          if self:CheckIsResourceEnough(itemData.needResourceType, itemData.needResourceNum, 1) and self:CheckIsResourceGoodsEnough(itemData.needGoodsId, itemData.needGoodsNum, 1) then
            self.queueList[queueData.uuid] = 1
            if self.isInGuide then
              local pointId = SceneUtils.WorldToTileIndex(curPos)
              if self.guideHasFarmPoint == nil then
                self.guideHasFarmPoint = {}
              end
              if self.guideHasFarmPoint[pointId] == nil then
                self.guideHasFarmPoint[pointId] = true
              end
              SFSNetwork.SendMessage(MsgDefines.FarmFarming, {
                queueData.uuid
              }, self.productId)
              if self.guideLeftCount <= table.count(self.guideHasFarmPoint) then
                DataCenter.GuideManager:DoNext()
              end
            else
              SFSNetwork.SendMessage(MsgDefines.FarmFarming, {
                queueData.uuid
              }, self.productId)
              if self.tempResource[itemData.needResourceType] ~= nil then
                self.tempResource[itemData.needResourceType] = self.tempResource[itemData.needResourceType] - itemData.needResourceNum
              end
            end
            if itemData.needResourceNum ~= nil then
              local desNum = itemData.needResourceNum
              DataCenter.DecResourceEffectManager:DecOneItemEffect(curPos, itemData.needResourceIcon, -desNum, queueData.funcUuid)
            elseif itemData.needGoodsNum ~= nil then
              local desNum = itemData.needGoodsNum
              DataCenter.DecResourceEffectManager:DecOneItemEffect(curPos, itemData.needGoodsIcon, -desNum, queueData.funcUuid)
            end
            local index = math.random(1, 4)
            local effId
            if index == 1 then
              effId = SoundAssetId.Music_Effect_Plant1
            elseif index == 2 then
              effId = SoundAssetId.Music_Effect_Plant2
            elseif index == 3 then
              effId = SoundAssetId.Music_Effect_Plant3
            elseif index == 4 then
              effId = SoundAssetId.Music_Effect_Plant4
            end
            DataCenter.LWSoundManager:PlaySound(effId, false)
          elseif not self:CheckIsResourceEnough(itemData.needResourceType, itemData.needResourceNum, 1) then
            local pos = CS.SceneManager.World:WorldToScreenPoint(curPos)
            local lackTab = {}
            local param = {}
            param.type = ResLackType.Res
            param.resType = itemData.needResourceType
            param.targetNum = itemData.needResourceNum
            param.curNum = self.tempResource[itemData.needResourceType]
            table.insert(lackTab, param)
            GoToResLack.GoToItemResLackList(lackTab, false, nil, true)
            CS.SceneManager.World:QuitFocus(LookAtFocusTime)
          end
        end
      end
    elseif queueData.type == NewQueueType.Barn then
      if itemData.farmState == FarmStateType.Plant then
        self.productId = itemData.productId
        if self.queueList[queueData.uuid] == nil and queueData:GetQueueState() == NewQueueState.Free and queueData:GetParaState() == QueueProductState.DEFAULT then
          if self:CheckIsResourceEnough(itemData.needResourceType, itemData.needResourceNum, 1) and self:CheckIsResourceGoodsEnough(itemData.needGoodsId, itemData.needGoodsNum, 1) then
            self.queueList[queueData.uuid] = 1
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
            UIUtil.ShowTips(Localization:GetString(GameDialogDefine.LACK_RESOURCE))
          end
        end
      elseif itemData.farmState == FarmStateType.Harvest then
        if (queueData:GetParaState() == QueueProductState.DEFAULT and queueData:GetQueueState() == NewQueueState.Finish or queueData:GetParaState() == QueueProductState.PASTURE_MATURE and queueData:GetQueueState() == NewQueueState.Free) and self.queueList[queueData.uuid] == nil then
          local tempQueue = DataCenter.QueueDataManager:GetQueueByUuid(self.qUuid)
          if tempQueue ~= nil and tempQueue.itemId == queueData.itemId then
            local functionId = queueData.itemId
            local functionTemplate = DataCenter.FarmingDataManager:GetFramingTemplate(functionId)
            if functionTemplate ~= nil then
              local itemId = ""
              local num = 0
              table.walk(functionTemplate.get_goods, function(m, n)
                itemId = m
                num = n
              end)
              local resourceItemData = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemId)
              if resourceItemData ~= nil then
                self.queueList[queueData.uuid] = 1
                if self:CheckIsStorageFull(itemData.farmState, queueData.uuid) then
                  if DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ResourceItemFull, tostring(BuildingTypes.FUN_BUILD_COLD_STORAGE)) then
                    DataCenter.GuideManager:SetGuideEndCallBack(function()
                      GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
                    end)
                  else
                    GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
                  end
                else
                  do
                    local pos = CS.SceneManager.World:WorldToScreenPoint(curPos)
                    local icon = "Assets/Main/Sprites/ItemIcons/" .. resourceItemData.pic
                    local str = tostring(queueData.funcUuid) .. ";" .. tostring(itemId)
                    local rewardTyp = RewardType.GOODS
                    UIUtil.DoFly(tonumber(rewardTyp), 1, icon, pos, UIUtil.GetUIMainSavePos(UIMainSavePosType.Goods))
                    EventManager:GetInstance():Broadcast(EventId.ShowCapacity, str)
                  end
                end
              end
            end
          end
        end
      elseif itemData.farmState == FarmStateType.Feed then
        if queueData:GetParaState() == QueueProductState.DEFAULT and queueData:GetQueueState() == NewQueueState.Finish or queueData:GetParaState() == QueueProductState.PASTURE_MATURE and queueData:GetQueueState() == NewQueueState.Free then
          local tempQueue = DataCenter.QueueDataManager:GetQueueByUuid(self.qUuid)
          if tempQueue ~= nil and tempQueue.itemId == queueData.itemId and self.queueList[queueData.uuid] == nil then
            if self:CheckIsResourceEnough(itemData.needResourceType, itemData.needResourceNum, 1) and self:CheckIsResourceGoodsEnough(itemData.needGoodsId, itemData.needGoodsNum, 1) then
              Logger.Log("feed")
              Logger.Log(queueData.uuid)
              self.queueList[queueData.uuid] = 1
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
            else
              UIUtil.ShowTips(Localization:GetString(GameDialogDefine.LACK_RESOURCE))
            end
          end
        end
      elseif itemData.farmState == FarmStateType.HarvestSecond and queueData:GetParaState() == QueueProductState.PASTURE_MATURE and queueData:GetQueueState() == NewQueueState.Finish and self.queueList[queueData.uuid] == nil then
        local tempQueue = DataCenter.QueueDataManager:GetQueueByUuid(self.qUuid)
        if tempQueue ~= nil and tempQueue.itemId == queueData.itemId then
          local functionId = queueData.itemId
          local functionTemplate = DataCenter.FarmingDataManager:GetFramingTemplate(functionId)
          if functionTemplate ~= nil then
            local itemId = ""
            local num = 0
            table.walk(functionTemplate.second_get_goods, function(m, n)
              itemId = m
              num = n
            end)
            local resourceItemData = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemId)
            if resourceItemData ~= nil then
              self.queueList[queueData.uuid] = 1
              if self:CheckIsStorageFull(itemData.farmState, queueData.uuid) then
                if DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ResourceItemFull, tostring(BuildingTypes.FUN_BUILD_COLD_STORAGE)) then
                  DataCenter.GuideManager:SetGuideEndCallBack(function()
                    GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
                  end)
                else
                  GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
                end
              else
                local pos = CS.SceneManager.World:WorldToScreenPoint(curPos)
                local icon = "Assets/Main/Sprites/ItemIcons/" .. resourceItemData.pic
                local str = tostring(queueData.funcUuid) .. ";" .. tostring(itemId)
                local rewardTyp = RewardType.GOODS
                UIUtil.DoFly(tonumber(rewardTyp), 1, icon, pos, UIUtil.GetUIMainSavePos(UIMainSavePosType.Goods))
                EventManager:GetInstance():Broadcast(EventId.ShowCapacitySecond, str)
              end
              Logger.Log("Harvest")
              Logger.Log(queueData.uuid)
            end
          end
        end
      end
    end
  end
end

local function OnDragFinish(self, itemData)
  if DataCenter.GuideManager:IsCanCloseUI(UIWindowNames.UIFarm) then
    self.productId = 0
    self.queueList = {}
    self:CloseSelf()
  end
end

local function CheckIsStorageFull(self, farmState, qUuid)
  local isFull = false
  local storageMax = DataCenter.ResourceItemDataManager:GetFreezerStorageMax()
  Logger.Log("storage max num", storageMax)
  local curStorage = DataCenter.ResourceItemDataManager:GetResourceItemTotalNumByType(ResourceItemType.Farming)
  table.walk(self.queueList, function(k, v)
    local queueData = DataCenter.QueueDataManager:GetQueueByUuid(k)
    if queueData ~= nil then
      local functionId = queueData.itemId
      local farmTemplate = DataCenter.FarmingDataManager:GetFramingTemplate(functionId)
      if farmTemplate ~= nil then
        local canGetNum = 0
        local itemId = 0
        if farmState == FarmStateType.Harvest then
          table.walk(farmTemplate.get_goods, function(m, n)
            itemId = m
            canGetNum = n
          end)
          if storageMax < curStorage + canGetNum then
            isFull = true
          else
            curStorage = canGetNum + curStorage
          end
        elseif farmState == FarmStateType.HarvestSecond then
          table.walk(farmTemplate.second_get_goods, function(m, n)
            itemId = m
            canGetNum = n
          end)
          if storageMax < curStorage + canGetNum then
            isFull = true
          else
            curStorage = canGetNum + curStorage
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

local function SendFarmPosLog(self, buildData)
  local uuid = buildData.uuid
  local result = 1
  local listBuilds = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildData.itemId)
  if listBuilds ~= nil and table.count(listBuilds) > 0 then
    table.sort(listBuilds, function(a, b)
      local posA = SceneUtils.IndexToTilePos(a.pointId)
      local posB = SceneUtils.IndexToTilePos(b.pointId)
      if posA.y < posB.y then
        return true
      elseif posA.y > posB.y then
        return false
      elseif posA.x < posB.x then
        return true
      elseif posA.x > posB.x then
        return false
      end
      return false
    end)
    for k, v in ipairs(listBuilds) do
      if v.uuid == uuid then
        result = k
        break
      end
    end
  end
  return result
end

local function GetProductLevels(self)
  return DataCenter.FarmingDataManager:GetProductLevels()
end

UIFarmNewCtrl.CloseSelf = CloseSelf
UIFarmNewCtrl.Close = Close
UIFarmNewCtrl.InitData = InitData
UIFarmNewCtrl.GetItemList = GetItemList
UIFarmNewCtrl.GetFarmItemListData = GetFarmItemListData
UIFarmNewCtrl.GetBarnItemListData = GetBarnItemListData
UIFarmNewCtrl.GetRecipeData = GetRecipeData
UIFarmNewCtrl.GetSecondRecipeData = GetSecondRecipeData
UIFarmNewCtrl.CheckIsScienceEnough = CheckIsScienceEnough
UIFarmNewCtrl.CheckIsBuildEnough = CheckIsBuildEnough
UIFarmNewCtrl.CheckIsResourceEnough = CheckIsResourceEnough
UIFarmNewCtrl.CheckIsResourceGoodsEnough = CheckIsResourceGoodsEnough
UIFarmNewCtrl.OnDragTrigger = OnDragTrigger
UIFarmNewCtrl.OnDragFinish = OnDragFinish
UIFarmNewCtrl.CheckIsStorageFull = CheckIsStorageFull
UIFarmNewCtrl.SendFarmPosLog = SendFarmPosLog
UIFarmNewCtrl.GetProductLevels = GetProductLevels
return UIFarmNewCtrl
