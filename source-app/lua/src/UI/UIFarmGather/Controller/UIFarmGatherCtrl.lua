local UIFarmGatherCtrl = BaseClass("UIFarmGatherCtrl", UIBaseCtrl)
local GatherEffectController = require("UI.UIFarmGather.GatherEffectController")

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFarmGather)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function InitData(self, data)
  local buildUuid = tonumber(data)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(buildUuid)
  if buildData ~= nil then
    self.buildId = buildData.itemId
    self.pointId = buildData.pointId
  end
  local queueData = DataCenter.QueueDataManager:GetQueueByBuildUuidForFarm(buildUuid)
  if queueData ~= nil then
    self.qUuid = queueData.uuid
  end
  self.productId = 0
  self.queueList = {}
  self.close = nil
end

local function GetItemList(self)
  if self.buildId == BuildingTypes.APS_BUILD_FARM_FIELD then
    return self:GetFarmItemListData()
  else
    return self:GetBarnItemListData()
  end
end

local function GetFarmItemListData(self)
  local list = {}
  if self.qUuid ~= nil and self.buildId ~= nil then
    local queueData = DataCenter.QueueDataManager:GetQueueByUuid(self.qUuid)
    if queueData:GetQueueState() == NewQueueState.Finish then
      local data = {}
      data.icon = "Assets/Main/Sprites/UI/UIFarm/UIFarm_icon_harvest"
      data.hasDes = false
      data.farmState = FarmStateType.Harvest
      data.order = 0
      data.buildType = self.buildId
      data.sizeX = 205
      data.sizeY = 164
      table.insert(list, data)
    end
  end
  return list
end

local function GetBarnItemListData(self)
  local list = {}
  if self.qUuid ~= nil and self.buildId ~= nil then
    local queueData = DataCenter.QueueDataManager:GetQueueByUuid(self.qUuid)
    if queueData:GetParaState() == QueueProductState.PASTURE_MATURE and queueData:GetQueueState() == NewQueueState.Finish then
      local data = {}
      data.icon = "Assets/Main/Sprites/UI/UIFarm/UIFarm_icon_harvest2"
      data.hasDes = false
      data.farmState = FarmStateType.HarvestSecond
      data.order = 0
      data.buildType = self.buildId
      data.sizeX = 130
      data.sizeY = 130
      table.insert(list, data)
    end
  end
  return list
end

local function OnDragTrigger(self, curPos, itemData, queueData)
  if DataCenter.ResourceItemDataManager:CanSendQueueFinishBatchMessage() ~= true then
    return
  end
  if queueData ~= nil and not self.close then
    if queueData.type == NewQueueType.Field then
      if itemData.farmState == FarmStateType.Harvest and queueData:GetQueueState() == NewQueueState.Finish and self.queueList[queueData.uuid] == nil then
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
              if DataCenter.RecommendShowManager:IsShowByType(RecommendShowType.FarmGet) then
                DataCenter.RecommendShowManager:RemoveOne(RecommendShowType.FarmGet, true)
              end
              if DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ResourceItemFull, tostring(BuildingTypes.FUN_BUILD_COLD_STORAGE)) then
                DataCenter.GuideManager:SetGuideEndCallBack(function()
                  GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
                end)
              else
                GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
              end
              self:OnDragFinish(itemData)
            else
              SFSNetwork.SendMessage(MsgDefines.QueueFinishBatch, {
                queueData.uuid
              }, QueueProductState.DEFAULT)
              local pointId = SceneUtils.WorldToTileIndex(curPos)
              GatherEffectController:GetInstance():AddOneEffect(pointId)
              local pos = CS.SceneManager.World:WorldToScreenPoint(curPos)
              local icon = "Assets/Main/Sprites/ItemIcons/" .. resourceItemData.pic
              local rewardTyp = RewardType.GOODS
              local count = functionTemplate.show_num
              if queueData:CheckIfIrrigated() then
                count = functionTemplate.show_num * 2
              end
              UIUtil.DoFly(tonumber(rewardTyp), count, icon, pos, Vector3.New(0, 0, 0), nil, nil, nil, true)
              DataCenter.PlayerLevelManager:FlyExp(ExpSource.Farming, pos, functionTemplate.exp)
              local str = tostring(queueData.funcUuid) .. ";" .. tostring(itemId)
              EventManager:GetInstance():Broadcast(EventId.ShowCapacity, str)
              local index = math.random(1, 4)
              local effId
              if index == 1 then
                effId = SoundAssetId.Music_Effect_Product1_1
              elseif index == 2 then
                effId = SoundAssetId.Music_Effect_Product1_2
              elseif index == 3 then
                effId = SoundAssetId.Music_Effect_Product1_3
              elseif index == 4 then
                effId = SoundAssetId.Music_Effect_Product1_4
              end
              DataCenter.LWSoundManager:PlaySound(effId, false)
            end
            if self.isInGuide then
              do
                local pointId = SceneUtils.WorldToTileIndex(curPos)
                self:RemoveGuidePointId(pointId)
                if table.count(self.guideLeftPointIds) == 0 then
                  self:OnDragFinish(itemData)
                end
              end
            end
          end
        end
      end
    elseif queueData.type == NewQueueType.Barn and itemData.farmState == FarmStateType.HarvestSecond and queueData:GetParaState() == QueueProductState.PASTURE_MATURE and queueData:GetQueueState() == NewQueueState.Finish and self.queueList[queueData.uuid] == nil then
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
              self:OnDragFinish(itemData)
            else
              local pos = CS.SceneManager.World:WorldToScreenPoint(curPos)
              local icon = "Assets/Main/Sprites/ItemIcons/" .. resourceItemData.pic
              local rewardTyp = RewardType.GOODS
              UIUtil.DoFly(tonumber(rewardTyp), 1, icon, pos, Vector3.New(0, 0, 0))
              DataCenter.PlayerLevelManager:FlyExp(ExpSource.Farming, pos, functionTemplate.exp)
              local str = tostring(queueData.funcUuid) .. ";" .. tostring(itemId)
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

local function OnDragFinish(self, itemData)
  self.productId = 0
  self.queueList = {}
  self.close = true
  self:CloseSelf()
  local checkLv = LuaEntry.DataConfig:TryGetNum("arrow_show", "k1")
  if checkLv >= DataCenter.BuildManager.MainLv and DataCenter.BuildManager.MainLv > 1 and not DataCenter.RecommendShowManager:IsHaveShowRecommend() then
    WorldArrowManager:GetInstance():ShowArrowEffect(0, SceneUtils.TileIndexToWorld(self.pointId), ArrowType.Farm)
  end
end

local function CheckIsStorageFull(self, farmState, qUuid)
  local isFull = false
  local addNum = 0
  table.walk(self.queueList, function(k, v)
    local queueData = DataCenter.QueueDataManager:GetQueueByUuid(k)
    if queueData ~= nil then
      local functionId = queueData.itemId
      if functionId == nil or functionId == "" then
        return
      end
      local farmTemplate = DataCenter.FarmingDataManager:GetFramingTemplate(functionId)
      if farmTemplate ~= nil then
        local canGetNum = 0
        local itemId = 0
        if farmState == FarmStateType.Harvest then
          table.walk(farmTemplate.get_goods, function(m, n)
            itemId = m
            canGetNum = n
          end)
          if DataCenter.ResourceItemDataManager:CheckIsStorageFull(addNum + canGetNum) then
            isFull = true
          else
            addNum = canGetNum + addNum
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

local function RemoveGuidePointId(self, pointId)
  if self.guideLeftPointIds ~= nil then
    local removeId
    for k, v in ipairs(self.guideLeftPointIds) do
      if v == pointId then
        removeId = k
        break
      end
    end
    if removeId ~= nil then
      table.remove(self.guideLeftPointIds, removeId)
    end
  end
end

UIFarmGatherCtrl.CloseSelf = CloseSelf
UIFarmGatherCtrl.Close = Close
UIFarmGatherCtrl.InitData = InitData
UIFarmGatherCtrl.GetItemList = GetItemList
UIFarmGatherCtrl.GetFarmItemListData = GetFarmItemListData
UIFarmGatherCtrl.GetBarnItemListData = GetBarnItemListData
UIFarmGatherCtrl.OnDragTrigger = OnDragTrigger
UIFarmGatherCtrl.OnDragFinish = OnDragFinish
UIFarmGatherCtrl.CheckIsStorageFull = CheckIsStorageFull
UIFarmGatherCtrl.RemoveGuidePointId = RemoveGuidePointId
return UIFarmGatherCtrl
