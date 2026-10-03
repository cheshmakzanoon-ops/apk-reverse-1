local PastureAnimalManager = BaseClass("PastureAnimalManager", Singleton)
local ResourceManager = CS.GameEntry.Resource
local AnimalModel = require("Scene.PastureAnimal.AnimalModel")
local animalMoveTime = 2000
local animal_fence_size = 3
local total_fence_area_size = animal_fence_size * animal_fence_size

local function __init(self)
  self.allAnimals = {}
  self:AddListener()
  self.tempCreateList = {}
  self.selectBuildUuid = 0
  self.delayCreateBuildList = {}
  self.selectBuildState = FarmStateType.None
  self.showAnimal = true
  self:CheckShowAnimal()
  self.timer = nil
  
  function self.timer_action(temp)
    self:OnUpdate()
  end
  
  self.buildDestroyFlag = {}
  self.cacheAreaIdToPos = {}
  self:AddTimer()
end

local function __delete(self)
  if self.allAnimals ~= nil then
    for _, v in pairs(self.allAnimals) do
      v:OnDestroy()
    end
    self.allAnimals = nil
  end
  self.tempCreateList = nil
  self.delayCreateBuildList = nil
  self:RemoveListener()
  self.selectBuildUuid = nil
  self.selectBuildState = nil
  self.timer_action = nil
  self.buildDestroyFlag = nil
  self.cacheAreaIdToPos = nil
  self:DeleteTimer()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
  EventManager:GetInstance():AddListener(EventId.BUILD_IN_VIEW, self.BuildInViewSignal)
  EventManager:GetInstance():AddListener(EventId.BUILD_OUT_VIEW, self.BuildOutViewSignal)
  EventManager:GetInstance():AddListener(EventId.BuildResourcesSecond, self.OnFeedSignal)
  EventManager:GetInstance():AddListener(EventId.AddSpeedSuccess, self.OnFeedSignal)
  EventManager:GetInstance():AddListener(EventId.HideBuildTopUI, self.BuildInViewSignal)
  EventManager:GetInstance():AddListener(EventId.ShowBuildTopUI, self.BuildOutViewSignal)
  EventManager:GetInstance():AddListener(EventId.Queue_Add, self.OnQueueAdd)
  EventManager:GetInstance():AddListener(EventId.GatherResourceItemFinish, self.OnGatherResourceItemFinish)
  EventManager:GetInstance():AddListener(EventId.Animal_Select, self.OnAnimalSelect)
  EventManager:GetInstance():AddListener(EventId.Animal_Unselect, self.OnAnimalUnSelect)
  EventManager:GetInstance():AddListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildSignal)
  EventManager:GetInstance():AddListener(EventId.ChangeShowAnimalState, self.CheckShowAnimalSignal)
  EventManager:GetInstance():AddListener(EventId.DeletePastureQueue, self.DeletePastureQueue)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.DeletePastureQueue, self.DeletePastureQueue)
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
  EventManager:GetInstance():RemoveListener(EventId.Animal_Select, self.OnAnimalSelect)
  EventManager:GetInstance():RemoveListener(EventId.Animal_Unselect, self.OnAnimalUnSelect)
  EventManager:GetInstance():RemoveListener(EventId.GatherResourceItemFinish, self.OnGatherResourceItemFinish)
  EventManager:GetInstance():RemoveListener(EventId.Queue_Add, self.OnQueueAdd)
  EventManager:GetInstance():RemoveListener(EventId.BUILD_IN_VIEW, self.BuildInViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.BUILD_OUT_VIEW, self.BuildOutViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.BuildResourcesSecond, self.OnFeedSignal)
  EventManager:GetInstance():RemoveListener(EventId.AddSpeedSuccess, self.OnFeedSignal)
  EventManager:GetInstance():RemoveListener(EventId.HideBuildTopUI, self.BuildInViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.ShowBuildTopUI, self.BuildOutViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildSignal)
  EventManager:GetInstance():RemoveListener(EventId.ChangeShowAnimalState, self.CheckShowAnimalSignal)
end

local function UpdateBuildSignal(data)
  local bUuid = tonumber(data)
  if bUuid ~= nil then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
    if buildData ~= nil and (buildData.itemId == BuildingTypes.APS_BUILD_PASTURE_OSTRICH or buildData.itemId == BuildingTypes.APS_BUILD_PASTURE_CATTLE or buildData.itemId == BuildingTypes.APS_BUILD_PASTURE_SANDWORM) then
      if buildData.destroyStartTime > 0 then
        local list = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(bUuid)
        table.walk(list, function(k, v)
          PastureAnimalManager:GetInstance():RemoveAnimalByQueueUuid(v.uuid)
        end)
      else
        if CS.SceneManager.World == nil then
          return
        end
        local city = CS.SceneManager.World:GetBuildingByUuid(bUuid)
        if city ~= nil then
          local list = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(bUuid)
          table.walk(list, function(k, v)
            PastureAnimalManager:GetInstance():RemoveAnimalByQueueUuid(v.uuid)
            PastureAnimalManager:GetInstance():CreateAnimalByQueueUuid(v.uuid)
          end)
        end
      end
    end
  end
end

local function CheckShowAnimalSignal(data)
  PastureAnimalManager:GetInstance():CheckShowAnimal(data)
end

local function CheckShowAnimal(self, data)
  if CS.CommonUtils.IsDebug() then
    self.showAnimal = CS.GameEntry.Setting:GetPrivateBool("SHOW_ANIMAL", true)
  else
    self.showAnimal = true
  end
  if self.showAnimal == true then
    for k, v in pairs(self.allAnimals) do
      local request = v:GetRequest()
      if request ~= nil and request.gameObject then
        request.gameObject:SetActive(true)
      end
      v:ReInitState(k)
    end
  else
    for k, v in pairs(self.allAnimals) do
      local request = v:GetRequest()
      if request ~= nil and request.gameObject then
        request.gameObject:SetActive(false)
      end
    end
  end
end

local function ChangeCameraLodSignal(lod)
  PastureAnimalManager:GetInstance():UpdateLod(lod)
end

local function UpdateLod(self, lod)
  if self.lodCache ~= lod then
    self.lodCache = lod
    if self.lodCache <= 1 then
      for k, v in pairs(self.allAnimals) do
        v:ReInitState(k)
      end
      self:CheckDelayCreateList()
    end
  end
end

local function OnGatherResourceItemFinish(data)
  if data == nil or table.count(data) == 0 then
    return
  end
  table.walk(data, function(_, v)
    DataCenter.QueueDataManager:ResetQueue(v, QueueProductState.PASTURE_MATURE)
    PastureAnimalManager:GetInstance():OnGatherAnimalByQueueUuid(v)
  end)
end

local function OnAnimalSelect(data)
  PastureAnimalManager:GetInstance():DoAnimalSelect(data)
end

local function OnAnimalUnSelect(data)
  PastureAnimalManager:GetInstance():DoAnimalUnSelect()
end

local function DoAnimalSelect(self, data)
  table.walk(self.allAnimals, function(_, v)
    if v ~= nil then
      v:OnAnimalSelect(data)
    end
  end)
end

local function DoAnimalUnSelect(self)
  table.walk(self.allAnimals, function(_, v)
    if v ~= nil then
      v:OnAnimalSelect(nil)
    end
  end)
end

local function OnQueueAdd(data)
  local buildData
  if data == NewQueueType.OstrichBarn then
    buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.APS_BUILD_PASTURE_OSTRICH)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Add_Ostrich, false)
  elseif data == NewQueueType.CattleBarn then
    buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.APS_BUILD_PASTURE_CATTLE)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Add_Cattle, false)
  elseif data == NewQueueType.SandWormBarn then
    buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.APS_BUILD_PASTURE_SANDWORM)
  end
  if buildData ~= nil and buildData.destroyStartTime <= 0 then
    local list = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(buildData.uuid)
    table.walk(list, function(_, v)
      PastureAnimalManager:GetInstance():CreateAnimalByQueueUuid(v.uuid)
    end)
  end
end

local function BuildInViewSignal(data)
  local bUuid = tonumber(data)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData ~= nil and buildData.destroyStartTime <= 0 and PastureAnimalManager:GetInstance():CheckSetIsDelayCreateBuildUuid(bUuid) == true then
    local list = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(bUuid)
    table.walk(list, function(k, v)
      PastureAnimalManager:GetInstance():RemoveAnimalByQueueUuid(v.uuid)
      PastureAnimalManager:GetInstance():CreateAnimalByQueueUuid(v.uuid)
    end)
  end
end

local function BuildOutViewSignal(data)
  local bUuid = tonumber(data)
  PastureAnimalManager:GetInstance():CheckRemoveIsDelayCreateBuildUuid(bUuid)
  local list = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(bUuid)
  table.walk(list, function(k, v)
    PastureAnimalManager:GetInstance():RemoveAnimalByQueueUuid(v.uuid)
  end)
end

local function CheckSetIsDelayCreateBuildUuid(self, uuid)
  if self.lodCache ~= nil and self.lodCache > 1 then
    self.delayCreateBuildList[uuid] = false
    return false
  end
  return true
end

local function CheckRemoveIsDelayCreateBuildUuid(self, uuid)
  self.delayCreateBuildList[uuid] = nil
end

local function CheckDelayCreateList(self)
  for a, b in pairs(self.delayCreateBuildList) do
    local list = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(a)
    table.walk(list, function(k, v)
      PastureAnimalManager:GetInstance():RemoveAnimalByQueueUuid(v.uuid)
      PastureAnimalManager:GetInstance():CreateAnimalByQueueUuid(v.uuid)
    end)
  end
  self.delayCreateBuildList = {}
end

local function OnUpdate(self)
  if table.count(self.allAnimals) > 0 then
    local tmp
    tmp = table.walkex(self.allAnimals, function(k, v, t)
      v:UpdateState()
      if v:NeedCalculateWalkPath() then
        t = t or {}
        table.insert(t, k)
      end
      return t
    end, tmp)
    if tmp == nil then
      return
    end
    table.walk(tmp, function(k, v)
      local animal = self.allAnimals[v]
      if animal ~= nil then
        local areaIds, times = self:GetWalkPoints(animal)
        if areaIds ~= nil then
          local realPos = {}
          table.walk(areaIds, function(k1, v1)
            local tmpV3 = SceneUtils.TileIndexToWorld(animal:GetPointId())
            local areaV3 = self:GetCenterPosByAreaId(v1)
            local finalX = tmpV3.x + areaV3.x + math.random(0, 2) / 20 - 0.05
            local finalY = tmpV3.y + areaV3.y + math.random(0, 2) / 20 - 0.05
            local finalZ = tmpV3.z + areaV3.z + math.random(0, 2) / 20 - 0.05
            local pointV3 = Vector3.New(finalX, finalY, finalZ)
            table.insert(realPos, pointV3)
          end)
          animal:SetEndPos(realPos)
        end
      end
    end)
    if table.count(tmp) > 0 then
      table.walk(self.allAnimals, function(k, v)
        v:UpdateState()
      end)
    end
  end
end

local function GetWalkPoints(self, animal)
  local selfPoints = animal:GetPositionAndTime()
  if table.count(selfPoints) ~= 1 then
    return
  end
  local selfPos = Vector3.New(selfPoints[1].x, selfPoints[1].y, selfPoints[1].z)
  local selfAreaId = self:GetAreaIdByRealPos(selfPos, animal:GetPointId())
  local nextAllPath, pathTimes = self:GetNextAreaIds(selfAreaId)
  local index = 1
  local totalPathNum = table.count(nextAllPath)
  while index <= totalPathNum do
    local tmpPath = nextAllPath[index]
    local tmpTime = pathTimes[index]
    local isPathOk = true
    table.walk(self.allAnimals, function(k, v)
      if v:GetPointId() == animal:GetPointId() and v ~= animal then
        local pos, time = v:GetPositionAndTime()
        local tmpAreaIds = {}
        table.walk(pos, function(k1, v1)
          table.insert(tmpAreaIds, self:GetAreaIdByRealPos(v1, animal:GetPointId()))
        end)
        isPathOk = isPathOk and self:CheckPath(tmpPath, tmpTime, tmpAreaIds, time, selfAreaId)
      end
    end)
    if isPathOk then
      return tmpPath, tmpTime
    end
    index = index + 1
  end
  return nil
end

local function CheckPath(self, path1, time1, path2, time2, path1StartArea)
  if path1 == nil or path2 == nil or table.count(path1) == 0 or table.count(path2) == 0 then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local result = true
  if time2 == nil then
    table.walk(path1, function(k, v)
      if v == path2[1] then
        result = false
      end
    end)
  elseif path1[table.count(path1)] == path2[table.count(path2)] then
    result = false
  else
    do
      local startArea = path1StartArea
      local startTime = curTime
      local endArea, endTime
      local i = 1
      local maxI = table.count(time1)
      while i <= maxI do
        endArea = path1[i]
        endTime = time1[i]
        if endTime >= time2[table.count(time2)] and (startArea == path2[table.count(path2)] or endArea == path2[table.count(path2)]) then
          return false
        end
        local j = 1
        local maxJ = table.count(time2)
        while j < maxJ and 2 <= maxJ do
          local timeJ = time2[j]
          if startTime <= timeJ and endTime >= timeJ then
            if startArea == path2[j] and endArea == path2[j + 1] then
              result = false
              break
            end
            if startArea == path2[j + 1] and endArea == path2[j] then
              result = false
              break
            end
            if 1 < j then
              if startArea == path2[j - 1] and endArea == path2[j] then
                result = false
                break
              end
              if startArea == path2[j] and endArea == path2[j - 1] then
                result = false
                break
              end
            end
          end
          j = j + 1
        end
        if not result then
          goto lbl_143
        end
        startTime = endTime
        startArea = endArea
        i = i + 1
      end
    end
    goto lbl_143
  end
  ::lbl_143::
  return result
end

local function GetCenterPosByAreaId(self, areaId)
  if areaId == nil then
    return Vector3.New(0, 0, 0)
  end
  if self.cacheAreaIdToPos[areaId] ~= nil then
    return self.cacheAreaIdToPos[areaId]
  end
  local totalZ = 3.0
  local totalX = 3.0
  local gapX = totalX / animal_fence_size
  local gapZ = totalZ / animal_fence_size
  local startX = -2.3 + gapX / 2
  local startZ = -2.6 + gapZ / 2
  local row = math.floor((areaId - 1) / animal_fence_size)
  local col = (areaId - 1) % animal_fence_size
  local offset = Vector3.New(startX + col * gapX, 0, startZ + row * gapZ)
  self.cacheAreaIdToPos[areaId] = offset
  return offset
end

local function GetNextAreaIds(self, areaId)
  local path1 = {}
  local time = {}
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local minX = 0
  local maxX = animal_fence_size - 1
  local minZ = 0
  local maxZ = animal_fence_size - 1
  local areaX = (areaId - 1) % animal_fence_size
  local areaZ = math.floor((areaId - 1) / animal_fence_size)
  local indexX = -1
  local indexMaxX = 1
  while indexX <= indexMaxX do
    local indexZ = -1
    local indexMaxZ = 1
    while indexZ <= indexMaxZ do
      if (indexX ~= 0 or indexZ ~= 0) and (indexX == 0 or indexZ == 0) then
        local checkX = areaX + indexX
        local checkZ = areaZ + indexZ
        if minX <= checkX and maxX >= checkX and minZ <= checkZ and maxZ >= checkZ then
          local insertIndex = 1
          local count = table.count(path1)
          if 1 <= count then
            local r = math.random(1, 100) % (count + 5)
            if count < r then
              insertIndex = count + 1
            else
              insertIndex = r % (count + 1) + 1
            end
          end
          table.insert(path1, insertIndex, {
            checkZ * animal_fence_size + checkX + 1
          })
          table.insert(time, insertIndex, {
            animalMoveTime + curTime
          })
        end
      end
      indexZ = indexZ + 1
    end
    indexX = indexX + 1
  end
  return path1, time
end

local function GetAreaIdByRealPos(self, v3, pointId)
  local tmpV3 = SceneUtils.TileIndexToWorld(pointId)
  local centerPos = Vector3.New(v3.x - tmpV3.x, v3.y - tmpV3.y, v3.z - tmpV3.z)
  local areaId = self:GetAreaIdByCenterPos(centerPos)
  return areaId
end

local function GetAreaIdByCenterPos(self, v3)
  local areaId = 1
  local maxAreaId = total_fence_area_size
  local minL = -1
  local result = areaId
  while areaId <= maxAreaId do
    local centerPos = self:GetCenterPosByAreaId(areaId)
    local distance = Vector3.Distance(centerPos, v3)
    if minL < 0 or minL > distance then
      result = areaId
      minL = distance
    end
    areaId = areaId + 1
  end
  return result
end

local function FixCreatePos(self, areaId, queueType)
  local areaIds = {}
  for k, v in pairs(self.allAnimals) do
    local queueData = DataCenter.QueueDataManager:GetQueueByUuid(k)
    if queueData ~= nil and queueData.type == queueType then
      local pos = v:GetPositionAndTime()
      if table.count(pos) == 1 then
        local selfPos = Vector3.New(pos[1].x, pos[1].y, pos[1].z)
        local areaId = self:GetAreaIdByRealPos(selfPos, v:GetPointId())
        areaIds[areaId] = 1
      end
    end
  end
  if areaIds[areaId] == nil then
    return areaId
  end
  local currentCheckAreaId = 1
  local maxAreaId = total_fence_area_size
  while currentCheckAreaId <= maxAreaId do
    if areaIds[currentCheckAreaId] == nil then
      return currentCheckAreaId
    end
    currentCheckAreaId = currentCheckAreaId + 1
  end
  return areaId
end

local function CreateAnimalByQueueUuid(self, qUuid)
  if self.allAnimals[qUuid] == nil and self.tempCreateList[qUuid] == nil then
    local queueData = DataCenter.QueueDataManager:GetQueueByUuid(qUuid)
    if queueData ~= nil and (queueData.type == NewQueueType.SandWormBarn or queueData.type == NewQueueType.CattleBarn or queueData.type == NewQueueType.OstrichBarn) and (queueData:GetQueueState() == NewQueueState.Free and queueData:GetParaState() == QueueProductState.DEFAULT) == false then
      do
        local bUuid = queueData.funcUuid
        EventManager:GetInstance():Broadcast(EventId.SetNewAnimal, bUuid)
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
        if buildData ~= nil and buildData.state ~= BuildingStateType.FoldUp and queueData.itemId ~= nil then
          do
            local farmTemplate = DataCenter.FarmingDataManager:GetFramingTemplate(queueData.itemId)
            if farmTemplate ~= nil then
              local animalName = farmTemplate.modelName
              if animalName ~= nil then
                do
                  local request = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/World/" .. animalName .. "Model.prefab")
                  self.tempCreateList[qUuid] = request
                  request:completed("+", function()
                    if request.isError then
                      return
                    end
                    local pointId = buildData.pointId
                    local v3 = SceneUtils.TileIndexToWorld(pointId)
                    local offset = self:GetCenterPosByAreaId(self:FixCreatePos(AnimalQIdToAreaId[queueData.qid], queueData.type))
                    local pos = v3 + offset
                    request.gameObject:SetActive(self.showAnimal)
                    request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
                    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                    request.gameObject.name = "Animal" .. qUuid
                    request.gameObject.transform:Set_position(pos.x, pos.y, pos.z)
                    local animal = AnimalModel.New()
                    animal:OnCreate(request, animalName, pointId)
                    self.allAnimals[qUuid] = animal
                    self.allAnimals[qUuid]:SetData(qUuid)
                    self.tempCreateList[qUuid] = nil
                    self:CheckDoGuideShowAnim(queueData, pos)
                  end)
                end
              end
            end
          end
        end
      end
    end
  elseif self.allAnimals[qUuid] ~= nil then
    local queueData = DataCenter.QueueDataManager:GetQueueByUuid(qUuid)
    if queueData ~= nil and (queueData.type == NewQueueType.SandWormBarn or queueData.type == NewQueueType.CattleBarn or queueData.type == NewQueueType.OstrichBarn) and (queueData:GetQueueState() == NewQueueState.Free and queueData:GetParaState() == QueueProductState.DEFAULT) == false then
      local bUuid = queueData.funcUuid
      local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
      if buildData ~= nil and buildData.state ~= BuildingStateType.FoldUp then
        local pointId = buildData.pointId
        local v3 = SceneUtils.TileIndexToWorld(pointId)
        local offset = self:GetCenterPosByAreaId(AnimalQIdToAreaId[queueData.qid])
        local pos = v3 + offset
        if queueData.itemId ~= nil then
          local request = self.allAnimals[qUuid]:GetRequest()
          if request ~= nil and request.gameObject then
            request.gameObject:SetActive(self.showAnimal)
          end
          self.allAnimals[qUuid]:OnUpdatePosition(pointId, pos)
          self.allAnimals[qUuid]:ReInitState(qUuid)
        end
      end
    end
  end
end

local function RemoveAnimalByQueueUuid(self, qUuid)
  if self.allAnimals[qUuid] ~= nil then
    local request = self.allAnimals[qUuid]:GetRequest()
    if request ~= nil and request.gameObject then
      request.gameObject:SetActive(false)
    end
  end
end

local function RemoveAllAnimal(self)
  local keys = table.keys(self.allAnimals)
  table.walk(keys, function(_, qUuid)
    if self.allAnimals == nil or self.allAnimals[qUuid] == nil then
      return
    end
    self.allAnimals[qUuid]:OnDestroy()
    self.allAnimals[qUuid] = nil
  end)
  for k, v in pairs(self.tempCreateList) do
    v:Destroy()
  end
  self.tempCreateList = {}
end

local function OnGatherAnimalByQueueUuid(self, qUuid)
  if self.allAnimals[qUuid] ~= nil then
    self.allAnimals[qUuid]:OnGatherAnimal()
  end
end

local function SetSelectBUuid(self, uuid)
  self.selectBuildUuid = uuid
end

local function GetSelectBUuid(self)
  return self.selectBuildUuid
end

local function SetSelectBuildState(self, state)
  self.selectBuildState = state
end

local function GetSelectBuildState(self)
  return self.selectBuildState
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

local function OnFeedSignal(data)
  PastureAnimalManager:GetInstance():OnFeedAnimal(data)
end

local function OnFeedAnimal(self, qUuid)
  if self.allAnimals[qUuid] ~= nil then
    self.allAnimals[qUuid]:CheckAnimalState()
    self.allAnimals[qUuid]:RefreshSelectAndFeedEffect()
  end
  self:OnUpdate()
end

local function GetAnimPos(self, qUuid)
  if self.allAnimals[qUuid] ~= nil then
    return self.allAnimals[qUuid]:GetCurrentPos()
  end
end

local function CheckDoGuideShowAnim(self, queue, pos)
  if DataCenter.GuideManager:InGuide() then
    local template = DataCenter.GuideManager:GetCurTemplate()
    if template.type == GuideType.PlayMovie and template.para1 ~= nil and template.para1 ~= "" then
      local playMovieType = tonumber(template.para1)
      if playMovieType == GuidePlayMovieType.ShowOstrichAnim and queue.type == NewQueueType.OstrichBarn then
        if self.allAnimals[queue.uuid] ~= nil then
          self.allAnimals[queue.uuid].gameObject:SetActive(false)
        end
        DataCenter.GuideCityAnimManager:AfterLoadShowOstrichScene(queue.type, queue.uuid, pos)
      elseif playMovieType == GuidePlayMovieType.ShowCowAnim and queue.type == NewQueueType.CattleBarn then
        if self.allAnimals[queue.uuid] ~= nil then
          self.allAnimals[queue.uuid].gameObject:SetActive(false)
        end
        DataCenter.GuideCityAnimManager:AfterLoadShowCowScene(queue.type, queue.uuid, pos)
      end
    end
  end
end

local function DoGuideShowAnim(self, queueType, qUuid, pos)
  local time = 0
  if self.allAnimals[qUuid] ~= nil then
    self.allAnimals[qUuid].gameObject:SetActive(self.showAnimal)
    time = self.allAnimals[qUuid]:DoGuideShowAnim()
  end
  DataCenter.GuideCityAnimManager:PlayShowOstrichEffect(time, pos)
end

local function DoWhenAnimalTouchOver(self, currentQueueUid)
  local bUuid = PastureAnimalManager:GetInstance():GetSelectBUuid()
  local state = PastureAnimalManager:GetInstance():GetSelectBuildState()
  local queueUuid
  local pos = VecZero
  local list = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(bUuid)
  if state == FarmStateType.Feed then
    for k, v in pairs(list) do
      if v ~= nil and v:GetParaState() == QueueProductState.DEFAULT and v:GetQueueState() == NewQueueState.Finish or v:GetParaState() == QueueProductState.PASTURE_MATURE and v:GetQueueState() == NewQueueState.Free then
        local animal = self.allAnimals[k]
        if animal ~= nil then
          queueUuid = k
          pos = animal:GetCurrentPos()
          if k == currentQueueUid then
            break
          end
        end
      end
    end
  elseif state == FarmStateType.Irrigate then
    for k, v in pairs(list) do
      if v ~= nil and not v:CheckIfIrrigated() and v:GetQueueState() == NewQueueState.Work then
        local animal = self.allAnimals[k]
        if animal ~= nil then
          queueUuid = k
          pos = animal:GetCurrentPos()
          if k == currentQueueUid then
            break
          end
        end
      end
    end
  elseif state == FarmStateType.HarvestSecond then
    for k, v in pairs(list) do
      if v:GetParaState() == QueueProductState.PASTURE_MATURE and v:GetQueueState() == NewQueueState.Finish then
        local animal = self.allAnimals[k]
        if animal ~= nil then
          queueUuid = k
          pos = animal:GetCurrentPos()
          if k == currentQueueUid then
            break
          end
        end
      end
    end
  end
  if queueUuid ~= nil then
    local signal = SFSObject.New()
    signal:PutLong("queueUuid", queueUuid)
    local posX = math.modf(pos.x)
    local posY = math.modf(pos.y)
    local posZ = math.modf(pos.z)
    signal:PutInt("posX", posX)
    signal:PutInt("posY", posY)
    signal:PutInt("posZ", posZ)
    EventManager:GetInstance():Broadcast(EventId.TouchPastureAnimal, signal)
  end
end

local function DeletePastureQueue(quid)
  PastureAnimalManager:GetInstance():RemoveAnimalByQueueUuid(quid)
end

PastureAnimalManager.__init = __init
PastureAnimalManager.__delete = __delete
PastureAnimalManager.AddListener = AddListener
PastureAnimalManager.RemoveListener = RemoveListener
PastureAnimalManager.BuildInViewSignal = BuildInViewSignal
PastureAnimalManager.BuildOutViewSignal = BuildOutViewSignal
PastureAnimalManager.CreateAnimalByQueueUuid = CreateAnimalByQueueUuid
PastureAnimalManager.RemoveAnimalByQueueUuid = RemoveAnimalByQueueUuid
PastureAnimalManager.SetSelectBUuid = SetSelectBUuid
PastureAnimalManager.GetSelectBUuid = GetSelectBUuid
PastureAnimalManager.SetSelectBuildState = SetSelectBuildState
PastureAnimalManager.GetSelectBuildState = GetSelectBuildState
PastureAnimalManager.OnGatherAnimalByQueueUuid = OnGatherAnimalByQueueUuid
PastureAnimalManager.DeleteTimer = DeleteTimer
PastureAnimalManager.AddTimer = AddTimer
PastureAnimalManager.OnUpdate = OnUpdate
PastureAnimalManager.OnFeedSignal = OnFeedSignal
PastureAnimalManager.OnFeedAnimal = OnFeedAnimal
PastureAnimalManager.GetAreaIdByCenterPos = GetAreaIdByCenterPos
PastureAnimalManager.GetCenterPosByAreaId = GetCenterPosByAreaId
PastureAnimalManager.GetNextAreaIds = GetNextAreaIds
PastureAnimalManager.GetAreaIdByRealPos = GetAreaIdByRealPos
PastureAnimalManager.GetWalkPoints = GetWalkPoints
PastureAnimalManager.CheckPath = CheckPath
PastureAnimalManager.GetAnimPos = GetAnimPos
PastureAnimalManager.FixCreatePos = FixCreatePos
PastureAnimalManager.OnQueueAdd = OnQueueAdd
PastureAnimalManager.OnGatherResourceItemFinish = OnGatherResourceItemFinish
PastureAnimalManager.DoGuideShowAnim = DoGuideShowAnim
PastureAnimalManager.CheckDoGuideShowAnim = CheckDoGuideShowAnim
PastureAnimalManager.OnAnimalSelect = OnAnimalSelect
PastureAnimalManager.OnAnimalUnSelect = OnAnimalUnSelect
PastureAnimalManager.DoAnimalSelect = DoAnimalSelect
PastureAnimalManager.DoAnimalUnSelect = DoAnimalUnSelect
PastureAnimalManager.DoWhenAnimalTouchOver = DoWhenAnimalTouchOver
PastureAnimalManager.ChangeCameraLodSignal = ChangeCameraLodSignal
PastureAnimalManager.UpdateLod = UpdateLod
PastureAnimalManager.CheckSetIsDelayCreateBuildUuid = CheckSetIsDelayCreateBuildUuid
PastureAnimalManager.CheckRemoveIsDelayCreateBuildUuid = CheckRemoveIsDelayCreateBuildUuid
PastureAnimalManager.CheckDelayCreateList = CheckDelayCreateList
PastureAnimalManager.UpdateBuildSignal = UpdateBuildSignal
PastureAnimalManager.RemoveAllAnimal = RemoveAllAnimal
PastureAnimalManager.CheckShowAnimalSignal = CheckShowAnimalSignal
PastureAnimalManager.CheckShowAnimal = CheckShowAnimal
PastureAnimalManager.DeletePastureQueue = DeletePastureQueue
return PastureAnimalManager
