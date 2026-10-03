local WarningBallManager = BaseClass("WarningBallManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.ballList = {}
  self.rankBallList = {}
  self:AddListener()
  
  function self.timer_action(temp)
    self:DoCheckFunction()
  end
  
  self:AddTimer()
  self.cdTime = {}
  self.ballMsgIsShow = false
end

local function __delete(self)
  self.ballList = nil
  self.rankBallList = nil
  self:RemoveListener()
  self:DeleteTimer()
  self.cdTime = nil
  self.ballMsgIsShow = nil
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.QUEUE_TIME_END, self.CheckCanGatherResSignal)
  EventManager:GetInstance():AddListener(EventId.GatherResourceItemFinish, self.CheckCanPlantSignal)
  EventManager:GetInstance():AddListener(EventId.BuildResourcesStart, self.CheckCanPlantSignal)
  EventManager:GetInstance():AddListener(EventId.BuildResourcesSecond, self.CheckCanPlantSignal)
  EventManager:GetInstance():AddListener(EventId.BuildPlace, self.CheckCanPlantSignal)
  EventManager:GetInstance():AddListener(EventId.BuildConnect, self.CheckNeedJoinRoadSignal)
  EventManager:GetInstance():AddListener(EventId.ResourceUpdated, self.CheckBuildUpgradeSignal)
  EventManager:GetInstance():AddListener(EventId.BuildLackConnect, self.CheckNeedJoinRoadSignal)
  EventManager:GetInstance():AddListener(EventId.OnScienceQueueFinish, self.CheckScienceSearchCompleteSignal)
  EventManager:GetInstance():AddListener(EventId.TrainingArmyFinish, self.CheckArmyQueueFreeSignal)
  EventManager:GetInstance():AddListener(EventId.TrainingArmy, self.CheckArmyQueueFreeSignal)
  EventManager:GetInstance():AddListener(EventId.ResourceFull, self.CheckResourceBuildingFullSignal)
  EventManager:GetInstance():AddListener(EventId.RefreshTopResByPickUp, self.RemoveResourceFullSignal)
  EventManager:GetInstance():AddListener(EventId.SoldResourceItem, self.CheckEmptyPastureSignal)
  EventManager:GetInstance():AddListener(EventId.AddFactoryProduct, self.CheckFactorySignal)
  EventManager:GetInstance():AddListener(EventId.GetFactoryData, self.CheckFactorySignal)
  EventManager:GetInstance():AddListener(EventId.GatherFactoryItem, self.CheckFactorySignal)
  EventManager:GetInstance():AddListener(EventId.HeroStationUpdate, self.CheckHeroStationWarningSignal)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.AddFactoryProduct, self.CheckFactorySignal)
  EventManager:GetInstance():RemoveListener(EventId.GetFactoryData, self.CheckFactorySignal)
  EventManager:GetInstance():RemoveListener(EventId.GatherFactoryItem, self.CheckFactorySignal)
  EventManager:GetInstance():RemoveListener(EventId.QUEUE_TIME_END, self.CheckCanGatherResSignal)
  EventManager:GetInstance():RemoveListener(EventId.GatherResourceItemFinish, self.CheckCanPlantSignal)
  EventManager:GetInstance():RemoveListener(EventId.BuildResourcesStart, self.CheckCanPlantSignal)
  EventManager:GetInstance():RemoveListener(EventId.BuildResourcesSecond, self.CheckCanPlantSignal)
  EventManager:GetInstance():RemoveListener(EventId.BuildPlace, self.CheckCanPlantSignal)
  EventManager:GetInstance():RemoveListener(EventId.BuildConnect, self.CheckNeedJoinRoadSignal)
  EventManager:GetInstance():RemoveListener(EventId.ResourceUpdated, self.CheckBuildUpgradeSignal)
  EventManager:GetInstance():RemoveListener(EventId.BuildLackConnect, self.CheckNeedJoinRoadSignal)
  EventManager:GetInstance():RemoveListener(EventId.OnScienceQueueFinish, self.CheckScienceSearchCompleteSignal)
  EventManager:GetInstance():RemoveListener(EventId.TrainingArmyFinish, self.CheckArmyQueueFreeSignal)
  EventManager:GetInstance():RemoveListener(EventId.TrainingArmy, self.CheckArmyQueueFreeSignal)
  EventManager:GetInstance():RemoveListener(EventId.ResourceFull, self.CheckResourceBuildingFullSignal)
  EventManager:GetInstance():RemoveListener(EventId.RefreshTopResByPickUp, self.RemoveResourceFullSignal)
  EventManager:GetInstance():RemoveListener(EventId.SoldResourceItem, self.CheckEmptyPastureSignal)
  EventManager:GetInstance():RemoveListener(EventId.HeroStationUpdate, self.CheckHeroStationWarningSignal)
end

local function InitData()
end

local function InitBallList(self)
  self.ballList = {}
  self.rankBallList = {}
  local currentTime = UITimeManager:GetInstance():GetServerTime()
  self.publicCd = 0
  local tableName = LuaEntry.Player:GetABTestTableName(TableName.Warning)
  LocalController:instance():visitTable(tableName, function(id, lineData)
    local item = WarningBallData.New()
    item:InitData(lineData, currentTime)
    if item.msgType ~= MessageBallType.None then
      self.ballList[item.msgType] = item
      self:CheckBallList(item.msgType)
      table.insert(self.rankBallList, item.msgType)
    end
  end)
  table.sort(self.rankBallList, function(leftKey, rightKey)
    return self.ballList[leftKey].order > self.ballList[rightKey].order
  end)
end

local function CheckBallList(self, msgType)
  if msgType == MessageBallType.JoinRoad then
    self:CheckNeedJoinRoad()
  elseif msgType == MessageBallType.EmptyFarm then
    self:CheckCanPlant()
  elseif msgType == MessageBallType.CanGatherFarm then
    self:CheckCanGatherRes()
  elseif msgType == MessageBallType.BuildingUpgrade then
    self:CheckBuildUpgrade()
  elseif msgType == MessageBallType.MoneyFull then
    self:CheckMoneyFull()
  elseif msgType == MessageBallType.WaterFull then
    self:CheckWaterFull()
  elseif msgType == MessageBallType.OilFull then
    self:CheckOilFull()
  elseif msgType == MessageBallType.MetalFull then
    self:CheckMetalFull()
  elseif msgType == MessageBallType.ElectricityFull then
    self:CheckElectricityFull()
  elseif msgType == MessageBallType.BuildingComplete then
  elseif msgType == MessageBallType.SoldierTrainComplete then
    self:CheckSoldierTrainComplete()
  elseif msgType == MessageBallType.ScienceSearchComplete then
    self:CheckScienceSearchComplete()
  elseif msgType == MessageBallType.ArmyQueueFree then
    self:CheckArmyQueueFree()
  elseif msgType == MessageBallType.EmptyPasture then
    self:CheckEmptyPasture()
  elseif msgType == MessageBallType.CanGatherPasture then
    self:CheckCanGatherPasture()
  elseif msgType == MessageBallType.FactoryFree then
    self:CheckEmptyFactory()
  elseif msgType == MessageBallType.FactoryCanGather then
    self:CheckCanGatherFactory()
  elseif msgType == MessageBallType.HeroStationWarning then
    self:CheckHeroStationWarning()
  elseif msgType == MessageBallType.FactoryFreeNew then
    self:CheckFactoryFreeNew()
  end
end

local function CheckResourceBuildingFull(self, ballType, resourceType)
  local ballData = self.ballList[ballType]
  if ballData ~= nil then
    local hasFullResourceBuilding, buildUuid = DataCenter.BuildManager:HasResourceBuildingFull(resourceType)
    if hasFullResourceBuilding then
      local param = {}
      param.msgType = ballType
      param.buildUuid = buildUuid
      ballData:SetParam(param)
    else
      ballData:SetParam(nil)
    end
    if ballData.ballState == WarningBallState.Free and hasFullResourceBuilding == true then
      ballData:SetBallState(WarningBallState.Show)
    elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and hasFullResourceBuilding == true then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if ballData:CheckIsCanCheck(curTime) then
        ballData:SetBallState(WarningBallState.Show)
        ballData:ResetCDTime()
      else
        ballData:ChangeNeedCheckFlag(true)
      end
    elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and hasFullResourceBuilding == false then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if ballData:CheckIsCanCheck(curTime) then
        ballData:SetBallState(WarningBallState.Free)
        ballData:ResetCDTime()
      end
    elseif ballData.ballState == WarningBallState.Show and hasFullResourceBuilding == false then
      ballData:SetBallState(WarningBallState.Free)
      EventManager:GetInstance():Broadcast(EventId.MessageBallChange, ballType)
    end
  end
end

local function CheckMoneyFull(self)
  self:CheckResourceBuildingFull(MessageBallType.MoneyFull, ResourceType.Food)
end

local function CheckWaterFull(self)
  self:CheckResourceBuildingFull(MessageBallType.WaterFull, ResourceType.Water)
end

local function CheckOilFull(self)
  self:CheckResourceBuildingFull(MessageBallType.OilFull, ResourceType.Oil)
end

local function CheckMetalFull(self)
  self:CheckResourceBuildingFull(MessageBallType.MetalFull, ResourceType.Metal)
end

local function CheckElectricityFull(self)
  self:CheckResourceBuildingFull(MessageBallType.ElectricityFull, ResourceType.Electricity)
end

local function CheckBuildingComplete(self, data)
  local allBuildings = DataCenter.BuildManager:GetAllBuildUuid()
  local ballData = self.ballList[MessageBallType.BuildingComplete]
  local returnFlag = false
  if allBuildings ~= nil then
    local now = UITimeManager:GetInstance():GetServerTime()
    table.walk(allBuildings, function(k, v)
      if data ~= nil and v ~= data then
        return
      end
      if ballData ~= nil and returnFlag == false then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v)
        local flag = false
        if buildData ~= nil and buildData.state ~= BuildingStateType.FoldUp and buildData.updateTime <= now and buildData.level > 0 then
          flag = true
        end
        if flag == true then
          local param = {}
          param.msgType = MessageBallType.BuildingComplete
          param.buildUuid = buildData.uuid
          ballData:SetParam(param)
        else
          ballData:SetParam(nil)
        end
        if ballData.ballState == WarningBallState.Free and flag == true then
          ballData:SetBallState(WarningBallState.Show)
          returnFlag = true
        elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and flag == true then
          if ballData:CheckIsCanCheck(now) then
            ballData:SetBallState(WarningBallState.Show)
            ballData:ResetCDTime()
            returnFlag = true
          else
            ballData:ChangeNeedCheckFlag(true)
          end
        elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and flag == false then
          if ballData:CheckIsCanCheck(now) then
            ballData:SetBallState(WarningBallState.Free)
            ballData:ResetCDTime()
          end
        elseif ballData.ballState == WarningBallState.Show and flag == false then
          ballData:SetBallState(WarningBallState.Free)
          EventManager:GetInstance():Broadcast(EventId.MessageBallChange, MessageBallType.BuildingComplete)
        end
      end
    end)
  end
end

local function CheckSoldierTrainComplete(self)
  local buildingTypes = BarracksBuild
  local ballData = self.ballList[MessageBallType.SoldierTrainComplete]
  for _, v in ipairs(buildingTypes) do
    if ballData ~= nil then
      local queue = DataCenter.QueueDataManager:GetQueueByType(DataCenter.ArmyManager:GetArmyQueueTypeByBuildId(v))
      local buildData = DataCenter.BuildManager:GetFunbuildByItemID(v)
      local flag = false
      if buildData ~= nil and buildData.state ~= BuildingStateType.FoldUp and buildData.level > 0 and buildData.state == BuildingStateType.Normal and queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
        flag = true
      end
      if flag == true then
        local param = {}
        param.msgType = MessageBallType.SoldierTrainComplete
        param.buildUuid = buildData.uuid
        ballData:SetParam(param)
      else
        ballData:SetParam(nil)
      end
      if ballData.ballState == WarningBallState.Free and flag == true then
        ballData:SetBallState(WarningBallState.Show)
        break
      elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and flag == true then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if ballData:CheckIsCanCheck(curTime) then
          ballData:SetBallState(WarningBallState.Show)
          ballData:ResetCDTime()
          break
        else
          ballData:ChangeNeedCheckFlag(true)
        end
      elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and flag == false then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if ballData:CheckIsCanCheck(curTime) then
          ballData:SetBallState(WarningBallState.Free)
          ballData:ResetCDTime()
        end
      elseif ballData.ballState == WarningBallState.Show and flag == false then
        ballData:SetBallState(WarningBallState.Free)
        EventManager:GetInstance():Broadcast(EventId.MessageBallChange, MessageBallType.SoldierTrainComplete)
      end
    end
  end
end

local function CheckScienceSearchComplete(self)
  local ballData = self.ballList[MessageBallType.ScienceSearchComplete]
  if ballData ~= nil then
    local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Science)
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_SCIENE)
    local flag = false
    if buildData ~= nil and buildData.state ~= BuildingStateType.FoldUp and buildData.level > 0 and buildData.state == BuildingStateType.Normal and queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
      flag = true
    end
    if flag == true then
      local param = {}
      param.msgType = MessageBallType.ScienceSearchComplete
      param.buildUuid = buildData.uuid
      ballData:SetParam(param)
    else
      ballData:SetParam(nil)
    end
    if ballData.ballState == WarningBallState.Free and flag == true then
      ballData:SetBallState(WarningBallState.Show)
    elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and flag == true then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if ballData:CheckIsCanCheck(curTime) then
        ballData:SetBallState(WarningBallState.Show)
        ballData:ResetCDTime()
      else
        ballData:ChangeNeedCheckFlag(true)
      end
    elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and flag == false then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if ballData:CheckIsCanCheck(curTime) then
        ballData:SetBallState(WarningBallState.Free)
        ballData:ResetCDTime()
      end
    elseif ballData.ballState == WarningBallState.Show and flag == false then
      ballData:SetBallState(WarningBallState.Free)
      EventManager:GetInstance():Broadcast(EventId.MessageBallChange, MessageBallType.ScienceSearchComplete)
    end
  end
end

local function CheckArmyQueueFree(self)
  local buildingTypes = BarracksBuild
  local ballData = self.ballList[MessageBallType.ArmyQueueFree]
  for _, v in ipairs(buildingTypes) do
    if ballData ~= nil then
      local queue = DataCenter.QueueDataManager:GetQueueByType(DataCenter.ArmyManager:GetArmyQueueTypeByBuildId(v))
      local buildData = DataCenter.BuildManager:GetFunbuildByItemID(v)
      local flag = false
      if buildData ~= nil and buildData.state ~= BuildingStateType.FoldUp and buildData.level > 0 and buildData.state == BuildingStateType.Normal and queue ~= nil and queue:GetQueueState() == NewQueueState.Free then
        flag = true
      end
      if flag == true then
        local param = {}
        param.msgType = MessageBallType.ArmyQueueFree
        param.buildUuid = buildData.uuid
        ballData:SetParam(param)
      else
        ballData:SetParam(nil)
      end
      if ballData.ballState == WarningBallState.Free and flag == true then
        ballData:SetBallState(WarningBallState.Show)
        break
      elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and flag == true then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if ballData:CheckIsCanCheck(curTime) then
          ballData:SetBallState(WarningBallState.Show)
          ballData:ResetCDTime()
          break
        else
          ballData:ChangeNeedCheckFlag(true)
        end
      elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and flag == false then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if ballData:CheckIsCanCheck(curTime) then
          ballData:SetBallState(WarningBallState.Free)
          ballData:ResetCDTime()
        end
      elseif ballData.ballState == WarningBallState.Show and flag == false then
        ballData:SetBallState(WarningBallState.Free)
        EventManager:GetInstance():Broadcast(EventId.MessageBallChange, MessageBallType.ArmyQueueFree)
      end
    end
  end
end

local function CheckBuildUpgradeSignal(data)
  DataCenter.WarningBallManager:CheckBuildUpgrade()
  DataCenter.WarningBallManager:CheckArmyQueueFree()
end

local function CheckNeedJoinRoadSignal(data)
  DataCenter.WarningBallManager:CheckNeedJoinRoad()
end

local function CheckEmptyPastureSignal(data)
  DataCenter.WarningBallManager:CheckEmptyPasture()
end

local function CheckCanGatherPastureSignal(data)
  DataCenter.WarningBallManager:CheckCanGatherPasture()
end

local function CheckFactorySignal(data)
  DataCenter.WarningBallManager:CheckFactoryFreeNew()
  DataCenter.WarningBallManager:CheckEmptyFactory()
  DataCenter.WarningBallManager:CheckCanGatherFactory()
end

local function CheckCanGatherResSignal(data)
  if data ~= nil then
    if data == NewQueueType.Field then
      DataCenter.WarningBallManager:CheckCanGatherRes()
    elseif data == NewQueueType.FootSoldier or data == NewQueueType.CarSoldier or data == NewQueueType.BowSoldier then
      DataCenter.WarningBallManager:CheckArmyQueueFree()
      DataCenter.WarningBallManager:CheckSoldierTrainComplete()
    elseif data == NewQueueType.Science then
      DataCenter.WarningBallManager:CheckScienceSearchComplete()
    elseif data == NewQueueType.OstrichBarn or data == NewQueueType.CattleBarn or data == NewQueueType.SandWormBarn then
      DataCenter.WarningBallManager:CheckCanGatherPasture()
    end
  end
end

local function CheckCanPlantSignal(data)
  DataCenter.WarningBallManager:CheckCanGatherRes()
  DataCenter.WarningBallManager:CheckCanPlant()
  DataCenter.WarningBallManager:CheckEmptyPasture()
  DataCenter.WarningBallManager:CheckCanGatherPasture()
end

local function CheckResourceBuildingFullSignal(data)
  if data == ResourceType.Electricity then
    DataCenter.WarningBallManager:CheckElectricityFull()
  elseif data == ResourceType.Metal then
    DataCenter.WarningBallManager:CheckMetalFull()
  elseif data == ResourceType.Oil then
    DataCenter.WarningBallManager:CheckOilFull()
  elseif data == ResourceType.Water then
    DataCenter.WarningBallManager:CheckWaterFull()
  elseif data == ResourceType.Food then
    DataCenter.WarningBallManager:CheckMoneyFull()
  end
end

local function RemoveResourceFullSignal(data)
  if data == ResourceType.Electricity then
    DataCenter.WarningBallManager:RemoveResourceFull(MessageBallType.ElectricityFull)
  elseif data == ResourceType.Metal then
    DataCenter.WarningBallManager:RemoveResourceFull(MessageBallType.MetalFull)
  elseif data == ResourceType.Oil then
    DataCenter.WarningBallManager:RemoveResourceFull(MessageBallType.OilFull)
  elseif data == ResourceType.Water then
    DataCenter.WarningBallManager:RemoveResourceFull(MessageBallType.WaterFull)
  elseif data == ResourceType.Food then
    DataCenter.WarningBallManager:RemoveResourceFull(MessageBallType.MoneyFull)
  end
end

local function RemoveResourceFull(self, ballType)
  local ballData = self.ballList[ballType]
  if ballData ~= nil then
    ballData:SetParam(nil)
    if ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if ballData:CheckIsCanCheck(curTime) then
        ballData:SetBallState(WarningBallState.Free)
        ballData:ResetCDTime()
      end
    elseif ballData.ballState == WarningBallState.Show then
      ballData:SetBallState(WarningBallState.Free)
      EventManager:GetInstance():Broadcast(EventId.MessageBallChange, ballType)
    end
  end
end

local function CheckBuildingCompleteSignal(data)
  DataCenter.WarningBallManager:CheckBuildingComplete(data)
  DataCenter.WarningBallManager:CheckArmyQueueFree()
end

local function CheckSoldierTrainCompleteSignal(data)
  DataCenter.WarningBallManager:CheckSoldierTrainComplete()
end

local function CheckScienceSearchCompleteSignal(data)
  DataCenter.WarningBallManager:CheckScienceSearchComplete()
end

local function CheckArmyQueueFreeSignal(data)
  DataCenter.WarningBallManager:CheckArmyQueueFree()
  DataCenter.WarningBallManager:CheckSoldierTrainComplete()
end

local function CheckHeroStationWarningSignal()
  DataCenter.WarningBallManager:CheckHeroStationWarning()
end

local function CheckBuildUpgrade(self, data)
  if self.ballList[MessageBallType.BuildingUpgrade] ~= nil then
    local ballData = self.ballList[MessageBallType.BuildingUpgrade]
    local buildIdList = DataCenter.BuildManager:GetCanUpgradeBuildUuidList()
    local canUpgrade = false
    local bUuid = 0
    if buildIdList ~= nil and 0 < #buildIdList then
      canUpgrade = true
      bUuid = buildIdList[1]
    end
    if canUpgrade then
      local param = {}
      param.msgType = MessageBallType.BuildingUpgrade
      param.buildUuid = bUuid
      ballData:SetParam(param)
    else
      ballData:SetParam(nil)
    end
    if ballData.ballState == WarningBallState.Free and canUpgrade == true then
      ballData:SetBallState(WarningBallState.Show)
    elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and canUpgrade == true then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if ballData:CheckIsCanCheck(curTime) then
        ballData:SetBallState(WarningBallState.Show)
      else
        ballData:ChangeNeedCheckFlag(true)
      end
    elseif ballData.ballState == WarningBallState.Show and canUpgrade == false then
      ballData:SetBallState(WarningBallState.Free)
      EventManager:GetInstance():Broadcast(EventId.MessageBallChange, MessageBallType.BuildingUpgrade)
    end
  end
end

local function CheckNeedJoinRoad(self, data)
  if self.ballList[MessageBallType.JoinRoad] ~= nil then
    local ballData = self.ballList[MessageBallType.JoinRoad]
    local buildIdList = DataCenter.BuildManager:GetCanJoinRoadBuildUuidList()
    local canJoinRoad = false
    local bUuid = 0
    if buildIdList ~= nil and 0 < #buildIdList then
      canJoinRoad = true
      bUuid = buildIdList[1]
    end
    if canJoinRoad then
      local param = {}
      param.msgType = MessageBallType.JoinRoad
      param.buildUuid = bUuid
      ballData:SetParam(param)
    else
      ballData:SetParam(nil)
    end
    if ballData.ballState == WarningBallState.Free and canJoinRoad == true then
      ballData:SetBallState(WarningBallState.Show)
    elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and canJoinRoad == true then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if ballData:CheckIsCanCheck(curTime) then
        ballData:SetBallState(WarningBallState.Show)
        ballData:ResetCDTime()
      else
        ballData:ChangeNeedCheckFlag(true)
      end
    elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and canJoinRoad == false then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if ballData:CheckIsCanCheck(curTime) then
        ballData:SetBallState(WarningBallState.Free)
        ballData:ResetCDTime()
      end
    elseif ballData.ballState == WarningBallState.Show and canJoinRoad == false then
      ballData:SetBallState(WarningBallState.Free)
      EventManager:GetInstance():Broadcast(EventId.MessageBallChange, MessageBallType.JoinRoad)
    end
  end
end

local function CheckCanPlant(self, data)
  if self.ballList[MessageBallType.EmptyFarm] ~= nil then
    local ballData = self.ballList[MessageBallType.EmptyFarm]
    local buildIdList = DataCenter.QueueDataManager:GetBuildUuidInFreeQueueByType(NewQueueType.Field)
    local canPlant = false
    local bUuid = 0
    if buildIdList ~= nil and 0 < table.count(buildIdList) then
      bUuid = buildIdList[1]
    end
    table.walk(buildIdList, function(_, v)
      local queueData = DataCenter.QueueDataManager:GetQueueByBuildUuidForFarm(v)
      if queueData and queueData.state == NewQueueState.Free then
        canPlant = true
      end
    end)
    if canPlant then
      local param = {}
      param.msgType = MessageBallType.EmptyFarm
      param.buildUuid = bUuid
      ballData:SetParam(param)
    else
      ballData:SetParam(nil)
    end
    if ballData.ballState == WarningBallState.Free and canPlant == true then
      ballData:SetBallState(WarningBallState.Show)
    elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and canPlant == true then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if ballData:CheckIsCanCheck(curTime) then
        ballData:SetBallState(WarningBallState.Show)
        ballData:ResetCDTime()
      else
        ballData:ChangeNeedCheckFlag(true)
      end
    elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and canPlant == false then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if ballData:CheckIsCanCheck(curTime) then
        ballData:SetBallState(WarningBallState.Free)
        ballData:ResetCDTime()
      end
    elseif ballData.ballState == WarningBallState.Show and canPlant == false then
      ballData:SetBallState(WarningBallState.Free)
      EventManager:GetInstance():Broadcast(EventId.MessageBallChange, MessageBallType.EmptyFarm)
    end
  end
end

local function CheckCanGatherRes(self, data)
  if self.ballList[MessageBallType.CanGatherFarm] ~= nil then
    local ballData = self.ballList[MessageBallType.CanGatherFarm]
    local buildIdList = DataCenter.QueueDataManager:GetBuildUuidInFinishQueueByType(NewQueueType.Field)
    local canPlant = false
    local bUuid = 0
    if buildIdList ~= nil and 0 < #buildIdList then
      canPlant = true
      bUuid = buildIdList[1]
    else
    end
    if canPlant then
      local param = {}
      param.msgType = MessageBallType.CanGatherFarm
      param.buildUuid = bUuid
      ballData:SetParam(param)
    else
      ballData:SetParam(nil)
    end
    if ballData.ballState == WarningBallState.Free and canPlant == true then
      ballData:SetBallState(WarningBallState.Show)
    elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and canPlant == true then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if ballData:CheckIsCanCheck(curTime) then
        ballData:SetBallState(WarningBallState.Show)
        ballData:ResetCDTime()
      else
        ballData:ChangeNeedCheckFlag(true)
      end
    elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and canPlant == false then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if ballData:CheckIsCanCheck(curTime) then
        ballData:SetBallState(WarningBallState.Free)
        ballData:ResetCDTime()
      end
    elseif ballData.ballState == WarningBallState.Show and canPlant == false then
      ballData:SetBallState(WarningBallState.Free)
      EventManager:GetInstance():Broadcast(EventId.MessageBallChange, MessageBallType.CanGatherFarm)
    end
  end
end

local function CheckEmptyPasture(self)
  if self.ballList[MessageBallType.EmptyPasture] ~= nil then
    local ballData = self.ballList[MessageBallType.EmptyPasture]
    local buildIdList = DataCenter.QueueDataManager:GetPastureAllFreeBuilding()
    local hasFreePastureBuilding = false
    local bUuid = 0
    for _, v in ipairs(buildIdList) do
      local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v)
      if buildData ~= nil and buildData.state ~= BuildingStateType.FoldUp then
        local dataTableList = DataCenter.FarmingDataManager:GetFarmTemplateByBuildIdInGroup(buildData.itemId)
        if dataTableList ~= nil and 0 < table.count(dataTableList) then
          local functionTemplate = dataTableList[1]
          if functionTemplate ~= nil and functionTemplate.second_need_goods ~= nil then
            local needGoodsId = 0
            local needGoodsNum = 0
            local currentNum = 0
            for k, v in pairs(functionTemplate.second_need_goods) do
              needGoodsId = k
              needGoodsNum = v
              break
            end
            local itemData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(needGoodsId, LuaEntry.Player.uid)
            if itemData ~= nil then
              currentNum = itemData.number
            end
            if needGoodsNum <= currentNum then
              bUuid = v
              hasFreePastureBuilding = true
              break
            end
          end
        end
      end
    end
    if hasFreePastureBuilding then
      local param = {}
      param.msgType = MessageBallType.EmptyPasture
      param.buildUuid = bUuid
      ballData:SetParam(param)
    else
      ballData:SetParam(nil)
    end
    if ballData.ballState == WarningBallState.Free and hasFreePastureBuilding == true then
      ballData:SetBallState(WarningBallState.Show)
    elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and hasFreePastureBuilding == true then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if ballData:CheckIsCanCheck(curTime) then
        ballData:SetBallState(WarningBallState.Show)
        ballData:ResetCDTime()
      else
        ballData:ChangeNeedCheckFlag(true)
      end
    elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and hasFreePastureBuilding == false then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if ballData:CheckIsCanCheck(curTime) then
        ballData:SetBallState(WarningBallState.Free)
        ballData:ResetCDTime()
      end
    elseif ballData.ballState == WarningBallState.Show and hasFreePastureBuilding == false then
      ballData:SetBallState(WarningBallState.Free)
      EventManager:GetInstance():Broadcast(EventId.MessageBallChange, MessageBallType.EmptyPasture)
    end
  end
end

local function CheckCanGatherPasture(self)
  if self.ballList[MessageBallType.CanGatherPasture] ~= nil then
    local ballData = self.ballList[MessageBallType.CanGatherPasture]
    local buildIdList = DataCenter.QueueDataManager:GetBuildUuidInFinishQueueForPasture()
    local canGather = false
    local bUuid = 0
    if buildIdList ~= nil and 0 < #buildIdList then
      canGather = true
      bUuid = buildIdList[1]
    end
    if canGather then
      local param = {}
      param.msgType = MessageBallType.CanGatherPasture
      param.buildUuid = bUuid
      ballData:SetParam(param)
    else
      ballData:SetParam(nil)
    end
    if ballData.ballState == WarningBallState.Free and canGather == true then
      ballData:SetBallState(WarningBallState.Show)
    elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and canGather == true then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if ballData:CheckIsCanCheck(curTime) then
        ballData:SetBallState(WarningBallState.Show)
        ballData:ResetCDTime()
      else
        ballData:ChangeNeedCheckFlag(true)
      end
    elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and canGather == false then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if ballData:CheckIsCanCheck(curTime) then
        ballData:SetBallState(WarningBallState.Free)
        ballData:ResetCDTime()
      end
    elseif ballData.ballState == WarningBallState.Show and canGather == false then
      ballData:SetBallState(WarningBallState.Free)
      EventManager:GetInstance():Broadcast(EventId.MessageBallChange, MessageBallType.CanGatherPasture)
    end
  end
end

local function CheckEmptyFactory(self)
  local buildingTypes = FactoryBuild
  local ballData = self.ballList[MessageBallType.FactoryFree]
  for _, v in ipairs(buildingTypes) do
    if ballData ~= nil and v ~= BuildingTypes.FUN_BUILD_FOODSHOP then
      local buildData = DataCenter.BuildManager:GetFunbuildByItemID(v)
      local flag = false
      if buildData ~= nil and buildData.state ~= BuildingStateType.FoldUp and buildData.level > 0 then
        local factoryData = DataCenter.FactoryDataManager:GetFactoryDataByBUuid(buildData.uuid)
        if factoryData ~= nil then
          local itemId = factoryData:CheckCanGetProduct()
          if itemId < 0 and 0 >= #factoryData.planZoneList then
            local dataTableList = DataCenter.FactoryDataManager:GetFactoryTemplateByBuildIdInGroup(v)
            table.walk(dataTableList, function(_, factoryItem)
              if flag == true then
                return
              end
              local checkState = false
              if factoryItem.unlock_type == TemplateUnlockType.Build then
                checkState = CommonUtil.CheckIsBuildEnough(factoryItem.needConditionId, factoryItem.needConditionLv)
              elseif factoryItem.unlock_type == TemplateUnlockType.Science then
                checkState = CommonUtil.CheckIsScienceEnough(factoryItem.needConditionId, factoryItem.needConditionLv)
              end
              if checkState == false then
                return
              end
              flag = true
              table.walk(factoryItem.need_resource_goods, function(resourceGoodsId, resourceGoodsNum)
                if CommonUtil.CheckIsResourceGoodsEnough(resourceGoodsId, resourceGoodsNum) == false then
                  flag = false
                end
              end)
              table.walk(factoryItem.need_resource, function(resourceId, resourceNum)
                if CommonUtil.CheckIsResourceEnough(resourceId, resourceNum) == false then
                  flag = false
                end
              end)
            end)
          end
        end
      end
      if not DataCenter.FactoryDataManager:HasUnlockItemByBuildId(v) then
        flag = false
      end
      if flag == true then
        local param = {}
        param.msgType = MessageBallType.FactoryFree
        param.buildUuid = buildData.uuid
        ballData:SetParam(param)
      else
        ballData:SetParam(nil)
      end
      if ballData.ballState == WarningBallState.Free and flag == true then
        ballData:SetBallState(WarningBallState.Show)
        break
      elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and flag == true then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if ballData:CheckIsCanCheck(curTime) then
          ballData:SetBallState(WarningBallState.Show)
          ballData:ResetCDTime()
          break
        else
          ballData:ChangeNeedCheckFlag(true)
        end
      elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and flag == false then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if ballData:CheckIsCanCheck(curTime) then
          ballData:SetBallState(WarningBallState.Free)
          ballData:ResetCDTime()
        end
      elseif ballData.ballState == WarningBallState.Show and flag == false then
        ballData:SetBallState(WarningBallState.Free)
        EventManager:GetInstance():Broadcast(EventId.MessageBallChange, MessageBallType.FactoryFree)
      end
    end
  end
end

local function CheckCanGatherFactory(self)
  local buildingTypes = FactoryBuild
  local ballData = self.ballList[MessageBallType.FactoryCanGather]
  local maxGatherNum = DataCenter.FactoryDataManager:GetProductZoneNum()
  for _, v in ipairs(buildingTypes) do
    if ballData ~= nil then
      local buildData = DataCenter.BuildManager:GetFunbuildByItemID(v)
      local flag = false
      if buildData ~= nil and buildData.state ~= BuildingStateType.FoldUp and buildData.level > 0 then
        local factoryData = DataCenter.FactoryDataManager:GetFactoryDataByBUuid(buildData.uuid)
        if factoryData ~= nil then
          local itemId = factoryData:CheckCanGetProduct()
          if 0 < itemId then
            flag = true
          end
        end
      end
      if flag == true then
        local param = {}
        param.msgType = MessageBallType.FactoryCanGather
        param.buildUuid = buildData.uuid
        ballData:SetParam(param)
      else
        ballData:SetParam(nil)
      end
      if ballData.ballState == WarningBallState.Free and flag == true then
        ballData:SetBallState(WarningBallState.Show)
        break
      elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and flag == true then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if ballData:CheckIsCanCheck(curTime) then
          ballData:SetBallState(WarningBallState.Show)
          ballData:ResetCDTime()
          break
        else
          ballData:ChangeNeedCheckFlag(true)
        end
      elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and flag == false then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if ballData:CheckIsCanCheck(curTime) then
          ballData:SetBallState(WarningBallState.Free)
          ballData:ResetCDTime()
        end
      elseif ballData.ballState == WarningBallState.Show and flag == false then
        ballData:SetBallState(WarningBallState.Free)
        EventManager:GetInstance():Broadcast(EventId.MessageBallChange, MessageBallType.FactoryCanGather)
      end
    end
  end
end

local function CheckHeroStationWarning(self)
  local ballData = self.ballList[MessageBallType.HeroStationWarning]
  if ballData == nil then
    return
  end
  local stationId = DataCenter.HeroStationManager:GetWarningStationId()
  local flag = stationId ~= nil
  DataCenter.HeroStationManager:SetWarningStationId(nil)
  if flag == true then
    local buildId = DataCenter.HeroStationManager:GetBuildIdByStationId(stationId)
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    local param = {}
    param.msgType = MessageBallType.HeroStationWarning
    param.stationId = stationId
    param.describeParam = {
      Localization:GetString(tostring(buildTemplate.name))
    }
    ballData:SetParam(param)
  else
    ballData:SetParam(nil)
  end
  if ballData.ballState == WarningBallState.Free and flag == true then
    ballData:SetBallState(WarningBallState.Show)
  elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and flag == true then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if ballData:CheckIsCanCheck(curTime) then
      ballData:SetBallState(WarningBallState.Show)
      ballData:ResetCDTime()
    else
      ballData:ChangeNeedCheckFlag(true)
    end
  elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and flag == false then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if ballData:CheckIsCanCheck(curTime) then
      ballData:SetBallState(WarningBallState.Free)
      ballData:ResetCDTime()
    end
  elseif ballData.ballState == WarningBallState.Show and flag == false then
    ballData:SetBallState(WarningBallState.Free)
    EventManager:GetInstance():Broadcast(EventId.MessageBallChange, MessageBallType.HeroStationWarning)
  end
end

local function CheckFactoryFreeNew(self)
  local ballData = self.ballList[MessageBallType.FactoryFreeNew]
  if ballData ~= nil then
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_FOODSHOP)
    local flag = false
    if buildData ~= nil and buildData.state ~= BuildingStateType.FoldUp and buildData.level > 0 then
      local factoryData = DataCenter.FactoryDataManager:GetFactoryDataByBUuid(buildData.uuid)
      if factoryData ~= nil then
        local itemId = factoryData:CheckCanGetProduct()
        if itemId < 0 and 0 >= #factoryData.planZoneList then
          local dataTableList = DataCenter.FactoryDataManager:GetFactoryTemplateByBuildIdInGroup(BuildingTypes.FUN_BUILD_FOODSHOP)
          table.walk(dataTableList, function(_, factoryItem)
            if flag == true then
              return
            end
            local checkState = false
            if factoryItem.unlock_type == TemplateUnlockType.Build then
              checkState = CommonUtil.CheckIsBuildEnough(factoryItem.needConditionId, factoryItem.needConditionLv)
            elseif factoryItem.unlock_type == TemplateUnlockType.Science then
              checkState = CommonUtil.CheckIsScienceEnough(factoryItem.needConditionId, factoryItem.needConditionLv)
            end
            if checkState == false then
              return
            end
            flag = true
            table.walk(factoryItem.need_resource_goods, function(resourceGoodsId, resourceGoodsNum)
              if CommonUtil.CheckIsResourceGoodsEnough(resourceGoodsId, resourceGoodsNum) == false then
                flag = false
              end
            end)
            table.walk(factoryItem.need_resource, function(resourceId, resourceNum)
              if CommonUtil.CheckIsResourceEnough(resourceId, resourceNum) == false then
                flag = false
              end
            end)
          end)
        end
      end
    end
    if not DataCenter.FactoryDataManager:HasUnlockItemByBuildId(BuildingTypes.FUN_BUILD_FOODSHOP) then
      flag = false
    end
    if flag == true then
      local param = {}
      param.msgType = MessageBallType.FactoryFreeNew
      param.buildUuid = buildData.uuid
      ballData:SetParam(param)
    else
      ballData:SetParam(nil)
    end
    if ballData.ballState == WarningBallState.Free and flag == true then
      ballData:SetBallState(WarningBallState.Show)
    elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and flag == true then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if ballData:CheckIsCanCheck(curTime) then
        ballData:SetBallState(WarningBallState.Show)
        ballData:ResetCDTime()
      else
        ballData:ChangeNeedCheckFlag(true)
      end
    elseif (ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait) and flag == false then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if ballData:CheckIsCanCheck(curTime) then
        ballData:SetBallState(WarningBallState.Free)
        ballData:ResetCDTime()
      end
    elseif ballData.ballState == WarningBallState.Show and flag == false then
      ballData:SetBallState(WarningBallState.Free)
      EventManager:GetInstance():Broadcast(EventId.MessageBallChange, MessageBallType.FactoryFreeNew)
    end
  end
end

local function CheckBag(self)
  if not CS.SceneManager.IsInPVE() then
    return
  end
  local ballData = self.ballList[MessageBallType.BagMax]
  local storageCurExtra = LuaEntry.Effect:GetGameEffect(EffectDefine.STORAGE_MAX_EXTRA)
  local curNum = DataCenter.ResourceItemDataManager:GetResourceItemTotalNumByType(ResourceItemType.Farming)
  local maxNum = DataCenter.ResourceItemDataManager:GetFreezerStorageMax(true) + storageCurExtra
  if curNum >= maxNum then
    local param = {}
    param.msgType = MessageBallType.BagMax
    ballData:SetParam(param)
    if ballData.ballState == WarningBallState.Free then
      ballData:SetBallState(WarningBallState.Show)
      EventManager:GetInstance():Broadcast(EventId.MessageBallChange, MessageBallType.BagMax)
    elseif ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if ballData:CheckIsCanCheck(curTime) then
        ballData:SetBallState(WarningBallState.Show)
        ballData:ResetCDTime()
      else
        ballData:ChangeNeedCheckFlag(true)
      end
    elseif ballData.ballState == WarningBallState.Cold or ballData.ballState == WarningBallState.Wait then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if ballData:CheckIsCanCheck(curTime) then
        ballData:SetBallState(WarningBallState.Free)
        ballData:ResetCDTime()
      end
    elseif ballData.ballState == WarningBallState.Show then
      ballData:SetBallState(WarningBallState.Free)
      EventManager:GetInstance():Broadcast(EventId.MessageBallChange, MessageBallType.BagMax)
    end
  end
end

local function OnBallClick(self, param)
end

local function GetAllShowBallList(self, isPve)
  local list
  if self:CheckChapterAndGuideCondition() == false then
    return list
  end
  local currentTime = UITimeManager:GetInstance():GetServerTime()
  if self.publicCd == nil then
    return list
  end
  if isPve then
    list = {}
    for i, v in pairs(self.ballList) do
      if v.msgType == MessageBallType.BagMax then
        table.insert(list, v)
      end
    end
  else
    if currentTime - self.publicCd < self:GetCDTime() * 1000 then
      return list
    end
    list = table.walkex(self.rankBallList, function(k, v, l, self_ballList)
      local data = self_ballList[v]
      if data.ballState == WarningBallState.Show and (l == nil or #l < LargestWarningBallCount) then
        l = l or {}
        l[#l + 1] = data
      end
      return l
    end, list, self.ballList)
  end
  return list
end

local function GetWarningBallByType(self, type)
  return self.ballList[type]
end

local function DoCheckFunction(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if table.IsEmpty(self.ballList) then
    self:InitBallList()
  end
  table.walkex(self.ballList, function(k, v, ret, thiz, checkTime)
    if (v.ballState == WarningBallState.Wait or v.ballState == WarningBallState.Cold) and v.needCheckFlag > 0 and v:CheckIsCanCheck(checkTime) then
      v:ChangeNeedCheckFlag(false)
      thiz:CheckBallList(k)
    end
  end, nil, self, curTime)
  local showBall = self:GetAllShowBallList()
  if showBall ~= nil and 0 < #showBall then
    EventManager:GetInstance():Broadcast(EventId.MessageBallChange, showBall[1].msgType)
  end
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function GetShowWarningBall(self, isPve)
  local list = self:GetAllShowBallList(isPve)
  if list ~= nil and 0 < #list then
    local currentTime = UITimeManager:GetInstance():GetServerTime()
    self.publicCd = currentTime
    return list[1]
  end
end

local function GetCDTime(self)
  if self.cdTime == nil then
    self.cdTime = {}
  end
  local lv = DataCenter.BuildManager.MainLv
  if self.cdTime[lv] ~= nil then
    return self.cdTime[lv]
  end
  local str = LuaEntry.DataConfig:TryGetStr("public_cd", "k2")
  local vec1 = string.split(str, "|")
  local index = 1
  local total = table.count(vec1)
  while index <= total do
    local vec2 = string.split(vec1[index], ";")
    if table.count(vec2) == 2 then
      local configLv = toInt(vec2[1])
      local configTime = toInt(vec2[2])
      if lv <= configLv then
        self.cdTime[lv] = configTime
        return configTime
      end
    end
    index = index + 1
  end
  return 300
end

local function CheckChapterAndGuideCondition(self)
  if DataCenter.GuideManager:InGuide() == true then
    return false
  end
  if DataCenter.ChapterTaskManager:IsCompleteAllChapter() == false and not CS.SceneManager.IsInPVE() then
    local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
    if chapterId ~= nil and chapterId <= MessageBallShowAfterChapterId then
      return false
    end
  end
  return true
end

local function SetBallMsg(self, state)
  self.ballMsgIsShow = state
end

local function GetBallMsg(self)
  return self.ballMsgIsShow
end

WarningBallManager.__init = __init
WarningBallManager.__delete = __delete
WarningBallManager.AddListener = AddListener
WarningBallManager.RemoveListener = RemoveListener
WarningBallManager.InitData = InitData
WarningBallManager.InitBallList = InitBallList
WarningBallManager.CheckBallList = CheckBallList
WarningBallManager.CheckBuildUpgrade = CheckBuildUpgrade
WarningBallManager.CheckNeedJoinRoad = CheckNeedJoinRoad
WarningBallManager.CheckCanPlant = CheckCanPlant
WarningBallManager.CheckCanGatherRes = CheckCanGatherRes
WarningBallManager.OnBallClick = OnBallClick
WarningBallManager.GetAllShowBallList = GetAllShowBallList
WarningBallManager.GetWarningBallByType = GetWarningBallByType
WarningBallManager.CheckBuildUpgradeSignal = CheckBuildUpgradeSignal
WarningBallManager.CheckNeedJoinRoadSignal = CheckNeedJoinRoadSignal
WarningBallManager.CheckCanPlantSignal = CheckCanPlantSignal
WarningBallManager.CheckCanGatherResSignal = CheckCanGatherResSignal
WarningBallManager.DoCheckFunction = DoCheckFunction
WarningBallManager.AddTimer = AddTimer
WarningBallManager.DeleteTimer = DeleteTimer
WarningBallManager.GetShowWarningBall = GetShowWarningBall
WarningBallManager.CheckBuildingCompleteSignal = CheckBuildingCompleteSignal
WarningBallManager.CheckSoldierTrainCompleteSignal = CheckSoldierTrainCompleteSignal
WarningBallManager.CheckScienceSearchCompleteSignal = CheckScienceSearchCompleteSignal
WarningBallManager.CheckResourceBuildingFullSignal = CheckResourceBuildingFullSignal
WarningBallManager.CheckArmyQueueFreeSignal = CheckArmyQueueFreeSignal
WarningBallManager.CheckHeroStationWarningSignal = CheckHeroStationWarningSignal
WarningBallManager.RemoveResourceFullSignal = RemoveResourceFullSignal
WarningBallManager.CheckMoneyFull = CheckMoneyFull
WarningBallManager.CheckWaterFull = CheckWaterFull
WarningBallManager.CheckOilFull = CheckOilFull
WarningBallManager.CheckMetalFull = CheckMetalFull
WarningBallManager.CheckElectricityFull = CheckElectricityFull
WarningBallManager.CheckResourceBuildingFull = CheckResourceBuildingFull
WarningBallManager.RemoveResourceFull = RemoveResourceFull
WarningBallManager.CheckBuildingComplete = CheckBuildingComplete
WarningBallManager.CheckSoldierTrainComplete = CheckSoldierTrainComplete
WarningBallManager.CheckScienceSearchComplete = CheckScienceSearchComplete
WarningBallManager.CheckArmyQueueFree = CheckArmyQueueFree
WarningBallManager.CheckEmptyPasture = CheckEmptyPasture
WarningBallManager.CheckCanGatherPasture = CheckCanGatherPasture
WarningBallManager.CheckEmptyPastureSignal = CheckEmptyPastureSignal
WarningBallManager.CheckCanGatherPastureSignal = CheckCanGatherPastureSignal
WarningBallManager.CheckEmptyFactory = CheckEmptyFactory
WarningBallManager.CheckCanGatherFactory = CheckCanGatherFactory
WarningBallManager.CheckHeroStationWarning = CheckHeroStationWarning
WarningBallManager.CheckFactorySignal = CheckFactorySignal
WarningBallManager.CheckFactoryFreeNew = CheckFactoryFreeNew
WarningBallManager.CheckBag = CheckBag
WarningBallManager.GetCDTime = GetCDTime
WarningBallManager.CheckChapterAndGuideCondition = CheckChapterAndGuideCondition
WarningBallManager.SetBallMsg = SetBallMsg
WarningBallManager.GetBallMsg = GetBallMsg
return WarningBallManager
