local TrainSceneManager = BaseClass("TrainSceneManager")
local SpriteRenderer = CS.UnityEngine.SpriteRenderer
local Resource = CS.GameEntry.Resource
local TouchWrapper = CS.BitBenderGames.TouchWrapper
local EventSystem = CS.UnityEngine.EventSystems.EventSystem
local GameQualitySettings = require("Util.GameQualitySettings")
local Train = require("Scene.LWRailway.Train.Train")
local ScenePath = "Assets/Main/Prefabs/LWRailway/TrainScene.prefab"
local sceneOffset = 10000
local CELL_WIDTH = 2
local CELL_HEIGHT = 4
local COLUMN = 6
local DEFAULT_ROW = 4
local RANDOM_RANGE = 1
local ROAD_LENGTH = 11.82
local MOVE_SPEED = 1
local Z_OFFSET = -1
local NodeName = {
  [TrainTab.Enemy] = "TrainEnemy",
  [TrainTab.Mine] = "TrainMine",
  [TrainTab.Ally] = "TrainAlly"
}

function TrainSceneManager:__init()
  self.loaded = false
  self.loadStartTime = 0
end

function TrainSceneManager:__delete()
  self:Destroy()
end

function TrainSceneManager:AddListeners()
  if self.onTrainListDataRefreshFunc == nil then
    function self.onTrainListDataRefreshFunc(trainTab)
      self:OnTrainListDataRefresh(trainTab)
    end
    
    EventManager:GetInstance():AddListener(EventId.RefreshTrainListData, self.onTrainListDataRefreshFunc)
  end
  if self.onTrainTabChangeFunc == nil then
    function self.onTrainTabChangeFunc(trainTab)
      self:OnTrainTabChange(trainTab)
    end
    
    EventManager:GetInstance():AddListener(EventId.TrainTabChange, self.onTrainTabChangeFunc)
  end
  if self.onRefreshMyTruckFunc == nil then
    function self.onRefreshMyTruckFunc()
      self:OnRefreshMyTruck()
    end
    
    EventManager:GetInstance():AddListener(EventId.RefreshMyTruck, self.onRefreshMyTruckFunc)
  end
  if self.onDelAllyTrainFunc == nil then
    function self.onDelAllyTrainFunc()
      self:OnRefreshMyTruck()
    end
    
    EventManager:GetInstance():AddListener(EventId.DelAllyTrain, self.onDelAllyTrainFunc)
  end
end

function TrainSceneManager:RemoveListeners()
  if self.onTrainListDataRefreshFunc ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.RefreshTrainListData, self.onTrainListDataRefreshFunc)
    self.onTrainListDataRefreshFunc = nil
  end
  if self.onTrainTabChangeFunc ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.TrainTabChange, self.onTrainTabChangeFunc)
    self.onTrainTabChangeFunc = nil
  end
  if self.onRefreshMyTruckFunc ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.RefreshMyTruck, self.onRefreshMyTruckFunc)
    self.onRefreshMyTruckFunc = nil
  end
  if self.onDelAllyTrainFunc ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.DelAllyTrain, self.onDelAllyTrainFunc)
    self.onDelAllyTrainFunc = nil
  end
end

function TrainSceneManager:AddUpdateTimer()
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

function TrainSceneManager:RemoveUpdateTimer()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function TrainSceneManager:OnUpdate()
  if not self.updateTimer then
    return
  end
  local deltaDistance = MOVE_SPEED * Time.deltaTime
  self.distance = self.distance + deltaDistance
  self.dynamic:Set_localPosition(0, 0, self.distance)
  if self.distance >= self.roadBoundary then
    self.road:Set_localPosition(0, 0, self.distance // ROAD_LENGTH * ROAD_LENGTH)
    self.roadBoundary = self.roadBoundary + ROAD_LENGTH
  end
end

function TrainSceneManager:Enter(param)
  self:DataDefine(param)
  self:LoadScene()
  DataCenter.ActWinterStormManager:TryCancelMatch(WinterStormCancelType.Train)
end

function TrainSceneManager:Exit()
  self:Destroy()
end

function TrainSceneManager:Destroy()
  self:RemoveUpdateTimer()
  self:RemoveListeners()
  self:ComponentDestroy()
  self:UnInitCamera()
  self:DestroyScene()
  self:DataDestroy()
end

function TrainSceneManager:LoadScene()
  if self.sceneLoadRequest then
    return
  end
  local req = Resource:InstantiateAsync(ScenePath)
  req:completed("+", function()
    local sceneRoot = req.gameObject.transform
    sceneRoot:Set_localPosition(sceneOffset, 0, sceneOffset)
    self:OnSceneLoadFinish()
  end)
  self.sceneLoadRequest = req
end

function TrainSceneManager:OnSceneLoadFinish()
  self:InitCamera()
  EventManager:GetInstance():Broadcast(EventId.TrainSceneCameraInitFinish)
  self:ComponentDefine()
  self:AddUpdateTimer()
  self:AddListeners()
  self:OnTrainTabChange(self.param.trainTab)
  self.loaded = true
end

function TrainSceneManager:FixRow(fix)
  self.ROW = fix + DEFAULT_ROW
  self.TRAIN_OFFSET_X = (1 - COLUMN) * CELL_WIDTH * 0.5
  self.TRAIN_OFFSET_Z = (self.ROW - 1) * CELL_HEIGHT * 0.5
end

function TrainSceneManager:ComponentDefine()
  self.trainsDictByTab = {}
  self.trainsListByTab = {}
  self.tabGo = {}
  local transform = self.sceneLoadRequest.gameObject.transform
  self.dynamic = transform:Find("Dynamic")
  for i = 1, TrainTab.MAX do
    self.tabGo[i] = self.dynamic:Find(NodeName[i]).gameObject
    self.tabGo[i].transform:Set_localPosition(self.TRAIN_OFFSET_X, 0, self.TRAIN_OFFSET_Z)
  end
  self.road = transform:Find("Static/Road")
  self.road:Set_localPosition(0, 0, 0)
  local bgPath = DataCenter.SeasonDataManager:GetTrainSceneSkin()
  if SeasonUtil.GetSeasonType() == SeasonMapType.Darkness and DataCenter.BloodyNightDataManager:IsSunrise() then
    bgPath = "Assets/Main/Sprites/Scene/zyf_chengjimaoyi_bg.png"
  end
  if bgPath ~= nil and bgPath ~= "" then
    local SpriteRendererType = typeof(SpriteRenderer)
    for i = 1, 9 do
      local spr = transform:Find("Static/Road/Road" .. i)
      if spr ~= nil then
        local com = spr:GetComponent(SpriteRendererType)
        if com ~= nil then
          com:LoadSprite(bgPath)
        end
      end
    end
  end
end

function TrainSceneManager:ComponentDestroy()
  for i = 1, TrainTab.MAX do
    self:RemoveTrains(i)
  end
  self.trainsDictByTab = {}
  self.trainsListByTab = {}
  self.tabGo = {}
  self.dynamic = nil
  self.road = nil
end

function TrainSceneManager:DataDefine(param)
  self.param = param
  self.hasTrain = {}
  self.distance = 0
  self.roadBoundary = ROAD_LENGTH
  self.loaded = false
  self.loadStartTime = UITimeManager:GetInstance():GetServerTime()
end

function TrainSceneManager:DataDestroy()
  self.param = nil
  self.hasTrain = {}
  self.distance = nil
  self.roadBoundary = nil
  self.loaded = false
  self.loadStartTime = 0
end

function TrainSceneManager:DestroyScene()
  if self.sceneLoadRequest then
    self.sceneLoadRequest:Destroy()
    self.sceneLoadRequest = nil
  end
end

function TrainSceneManager:InitCamera()
  self.camera = self.sceneLoadRequest.gameObject.transform:Find("Dynamic/Camera"):GetComponent(typeof(CS.UnityEngine.Camera))
  GameQualitySettings.TogglePostProcess(true)
end

function TrainSceneManager:UnInitCamera()
  if self.camera then
    self.camera.targetTexture = nil
    self.camera = nil
  end
end

function TrainSceneManager:GetTouchItemScreenPos(modelPos)
  local newPos = PosConverse.WorldToScreenPos(modelPos, self.camera)
  if CommonUtil.IsArabicAutoMirrorOpen() then
    newPos.x = Screen.width - newPos.x
  end
  return newPos
end

function TrainSceneManager:OnRefreshMyTruck()
  self:OnTrainListDataRefresh(TrainTab.Mine)
end

function TrainSceneManager:OnTrainListDataRefresh(tabType)
  self:RefreshTrains(tabType)
  if self.curTab == tabType then
    EventManager:GetInstance():Broadcast(EventId.TrainPlaceFinish, self.trainsListByTab[tabType])
  end
end

function TrainSceneManager:OnTrainTabChange(tabType)
  self.curTab = tabType
  self:ShowTrains(tabType)
  EventManager:GetInstance():Broadcast(EventId.TrainPlaceFinish, self.trainsListByTab[tabType])
end

function TrainSceneManager:ShowTrains(tabType)
  for k, v in pairs(self.tabGo) do
    v:SetActive(k == tabType)
  end
  if self.hasTrain[tabType] then
    self:PlayTrucksAnim(tabType)
  else
    self:RefreshTrains(tabType)
  end
end

function TrainSceneManager:RefreshTrains(tabType)
  self:RemoveTrains(tabType)
  self:CreateTrains(tabType)
  self.hasTrain[tabType] = true
end

function TrainSceneManager:RemoveTrains(tabType)
  if self.trainsDictByTab then
    if self.trainsDictByTab[tabType] then
      for k, v in pairs(self.trainsDictByTab[tabType]) do
        v:Destroy()
      end
    end
    self.trainsDictByTab[tabType] = {}
    self.trainsListByTab[tabType] = {}
  end
end

function TrainSceneManager:PlayTrucksAnim(tabType)
  local trainList = self.trainsListByTab[tabType] or {}
  for _, v in pairs(trainList) do
    if v.trainData and v.trainData.type == TrainType.Truck then
      v:PlayAnim("Move")
    end
  end
end

function TrainSceneManager:CreateTrains(tabType)
  local dataList = {}
  local specialList = {}
  local allyTrain
  if tabType == TrainTab.Enemy then
    local enemyList = DataCenter.LWTrainDataManager:GetEnemyTruckList()
    for i = #enemyList, 1, -1 do
      if enemyList[i].quality == 5 or enemyList[i].enemy then
        table.insert(specialList, enemyList[i])
      else
        table.insert(dataList, enemyList[i])
      end
    end
    allyTrain = DataCenter.LWTrainDataManager:GetEnemyTrain()
  elseif tabType == TrainTab.Mine then
    dataList = DataCenter.LWMyStationDataManager:GetMyDepartureTrains()
    allyTrain = DataCenter.LWAllyStationDataManager:GetMyTravelingTrain()
  end
  self.TRAIN_COLUMN = allyTrain and 1 or 0
  self.TRUCK_COLUMN = COLUMN - self.TRAIN_COLUMN
  self.CELL_COUNT = self.TRUCK_COLUMN * self.ROW
  local randomPool = {}
  local specialPool = {}
  for i = 1, self.CELL_COUNT do
    randomPool[i] = i
    specialPool[i] = i
  end
  for _, v in pairs(specialList) do
    local newTrain = Train.New(v, nil, self.tabGo[tabType].transform, true)
    self:PlaceASpecialTrain(tabType, newTrain, specialPool, randomPool)
    self.trainsDictByTab[tabType][newTrain.uuid] = newTrain
    table.insert(self.trainsListByTab[tabType], newTrain)
  end
  for _, v in pairs(dataList) do
    local newTrain = Train.New(v, nil, self.tabGo[tabType].transform, true)
    self:PlaceATrain(tabType, newTrain, randomPool)
    self.trainsDictByTab[tabType][newTrain.uuid] = newTrain
    table.insert(self.trainsListByTab[tabType], newTrain)
  end
  table.sort(self.trainsListByTab[tabType], function(a, b)
    return a:GetPositionIndex() < b:GetPositionIndex()
  end)
  if allyTrain then
    local newAllyTrain = Train.New(allyTrain, nil, self.tabGo[tabType].transform, true)
    self:PlaceAllyTrain(newAllyTrain)
    self.trainsDictByTab[tabType][newAllyTrain.uuid] = newAllyTrain
    table.insert(self.trainsListByTab[tabType], newAllyTrain)
  end
end

function TrainSceneManager:PlaceAllyTrain(train)
  local posIndex = self.CELL_COUNT + 1
  local z = 0
  if self.ROW > DEFAULT_ROW then
    local offset = (self.ROW - DEFAULT_ROW) * CELL_HEIGHT * 0.5
    z = -offset
  end
  train:SetLocalPosition((COLUMN - 1) * CELL_WIDTH, 0, z + Z_OFFSET)
  train:SetPositionIndex(posIndex)
end

function TrainSceneManager:PlaceASpecialTrain(tabType, train, specialPool, randomPool)
  local poolSize = #specialPool
  if 0 < poolSize then
    local poolIndex = math.random(poolSize)
    local posIndex = specialPool[poolIndex]
    table.removebyvalue(specialPool, posIndex)
    table.removebyvalue(specialPool, posIndex + 1)
    table.removebyvalue(specialPool, posIndex - 1)
    table.removebyvalue(specialPool, posIndex + self.TRUCK_COLUMN)
    table.removebyvalue(specialPool, posIndex - self.TRUCK_COLUMN)
    table.removebyvalue(randomPool, posIndex)
    local posX = (posIndex - 1) % self.TRUCK_COLUMN
    local posZ = (posIndex - 1) // self.TRUCK_COLUMN
    train:SetLocalPosition(posX * CELL_WIDTH + RANDOM_RANGE * math.random() - 0.5 * RANDOM_RANGE, 0, -posZ * CELL_HEIGHT + RANDOM_RANGE * math.random() - 0.5 * RANDOM_RANGE + Z_OFFSET)
    train:SetPositionIndex(posIndex)
  else
    self:PlaceATrain(tabType, train, randomPool)
  end
end

function TrainSceneManager:PlaceATrain(tabType, train, randomPool)
  if tabType == TrainTab.Mine then
    local posIndex = train.trainData.index
    local localPos = self:GetMyTrainLocalPos(posIndex)
    train:SetLocalPosition(localPos.x, 0, localPos.z)
    train:SetPositionIndex(posIndex)
  elseif tabType == TrainTab.Enemy then
    local poolSize = #randomPool
    local poolIndex = math.random(poolSize)
    local posIndex = table.remove(randomPool, poolIndex)
    local posX = (posIndex - 1) % self.TRUCK_COLUMN
    local posZ = (posIndex - 1) // self.TRUCK_COLUMN
    train:SetLocalPosition(posX * CELL_WIDTH + RANDOM_RANGE * math.random() - 0.5 * RANDOM_RANGE, 0, -posZ * CELL_HEIGHT + RANDOM_RANGE * math.random() - 0.5 * RANDOM_RANGE + Z_OFFSET)
    train:SetPositionIndex(posIndex)
  end
end

function TrainSceneManager:GetMyTrainLocalPos(index)
  local posX = index - 1 + (COLUMN - 4) // 2
  local posZ = self.ROW * 0.5
  return Vector3(posX * CELL_WIDTH, 0, -posZ * CELL_HEIGHT)
end

function TrainSceneManager:GetMyTrainWorldPos(index)
  return self.tabGo[TrainTab.Mine].transform:TransformPoint(self:GetMyTrainLocalPos(index))
end

function TrainSceneManager:ShowSelectRing(train)
  if train then
    local dict = self.trainsDictByTab[self.curTab]
    if dict then
      for _, v in pairs(dict) do
        v:ShowSelectRing(train.uuid == v.uuid)
      end
    end
  end
end

function TrainSceneManager:GetTrain(trainUuid)
  if self.trainsDictByTab then
    for _, dict in pairs(self.trainsDictByTab) do
      for uuid, train in pairs(dict) do
        if uuid == trainUuid then
          return train
        end
      end
    end
  end
end

function TrainSceneManager:Loaded()
  return self.loaded
end

function TrainSceneManager:LoadTime()
  return checknumber(self.loadStartTime)
end

return TrainSceneManager
