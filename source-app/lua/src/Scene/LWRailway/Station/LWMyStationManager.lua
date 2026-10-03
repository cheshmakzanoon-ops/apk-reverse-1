local LWMyStationManager = BaseClass("LWMyStationManager", Singleton)
local PlaneTrain = require("Scene.LWRailway.PlaneTrain.PlaneTrain")
local PlatformBubble = require("Scene.LWRailway.Station.PlatformBubble")
local TruckStationBubble = require("Scene.LWRailway.Station.TruckStationBubble")
local Rail = require("Scene.LWRailway.Station.Rail")
local MyRailwayStation = require("Scene.LWRailway.Station.MyRailwayStation")
local Resource = CS.GameEntry.Resource
local TrainEnterEffect = "Assets/_Art_LastWar/Effect/Prefab/Zhucheng/Eff_Smoke_begin.prefab"
local TrainLeaveTime = 17
local NormalTrainAriDropEffect = "Assets/Main/Prefabs/LWRailway/TrainAirDropEffect.prefab"
local URTrainAirDropEffect = "Assets/Main/Prefabs/LWRailway/TrainAirDropEffect_UR.prefab"

function LWMyStationManager:__init()
  self.reqs = {}
  self.buildingUuid2TrainPath = {}
  self:AddListener()
end

function LWMyStationManager:__delete()
  self:RemoveListener()
  self:Destroy()
end

function LWMyStationManager:Destroy()
  if self.reqs then
    for _, v in pairs(self.reqs) do
      v:Destroy()
    end
    self.reqs = {}
  end
  self.buildingUuid2TrainPath = {}
  if self.airDropEffectReq then
    self.airDropEffectReq:Destroy()
    self.airDropEffectReq = nil
  end
  if self.airDropTimer then
    UIManager:GetInstance():SetUIMainEnable(true)
    self.airDropTimer:Stop()
    self.airDropTimer = nil
  end
  if self.planeTrain then
    self.planeTrain:Destroy()
    self.planeTrain = nil
  end
  if self.platformBubble then
    self.platformBubble:Destroy()
    self.platformBubble = nil
  end
  if self.stationBubble then
    self.stationBubble:Destroy()
    self.stationBubble = nil
  end
  if self.rail then
    self.rail:Destroy()
    self.rail = nil
  end
  if self.myStation then
    self.myStation:Destroy()
    self.myStation = nil
  end
  self:ClearDepartedTrain()
  self.cacheDepartedTrainUuid = nil
end

function LWMyStationManager:AddListener()
  function self.FuncOnExitCity(id)
    self:OnExitCity(id)
  end
  
  EventManager:GetInstance():AddListener(EventId.OnExitCityState, self.FuncOnExitCity)
  
  function self.FuncRefreshStationView(id)
    self:RefreshStationView(id)
  end
  
  EventManager:GetInstance():AddListener(EventId.BUILD_IN_VIEW, self.FuncRefreshStationView)
  
  function self.FuncRefreshTruckStationView(id)
    self:RefreshTruckStationView(id)
  end
  
  EventManager:GetInstance():AddListener(EventId.RefreshTruckStationView, self.FuncRefreshTruckStationView)
  
  function self.FuncRefreshRailwayStationView()
    self:RefreshRailwayStationView()
  end
  
  EventManager:GetInstance():AddListener(EventId.RefreshTrainStationView, self.FuncRefreshRailwayStationView)
  
  function self.FuncShowTrainAirDropEffect()
    self:ShowTrainAirDropEffect()
  end
  
  EventManager:GetInstance():AddListener(EventId.AllianceTrainBuySuccess, self.FuncShowTrainAirDropEffect)
  
  function self.FuncShowAllianceTrainDeparted(uuid)
    self:OnAllianceTrainDeparted(uuid)
  end
  
  EventManager:GetInstance():AddListener(EventId.AllianceTrainDeparted, self.FuncShowAllianceTrainDeparted)
end

function LWMyStationManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.OnExitCityState, self.FuncOnExitCity)
  EventManager:GetInstance():RemoveListener(EventId.BUILD_IN_VIEW, self.FuncRefreshStationView)
  EventManager:GetInstance():RemoveListener(EventId.RefreshTruckStationView, self.FuncRefreshTruckStationView)
  EventManager:GetInstance():RemoveListener(EventId.RefreshTrainStationView, self.FuncRefreshRailwayStationView)
  EventManager:GetInstance():RemoveListener(EventId.AllianceTrainBuySuccess, self.FuncShowTrainAirDropEffect)
  EventManager:GetInstance():RemoveListener(EventId.AllianceTrainDeparted, self.FuncShowAllianceTrainDeparted)
end

function LWMyStationManager:RefreshStationView(buildUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(buildUuid)
  if not buildData then
    return
  end
  if buildData.itemId == BuildingTypes.LW_BUILD_RAILWAY_STATION then
    self:RefreshRailwayStationView()
  elseif buildData.itemId == BuildingTypes.LW_BUILD_TRUCK_STATION_1 or buildData.itemId == BuildingTypes.LW_BUILD_TRUCK_STATION_2 or buildData.itemId == BuildingTypes.LW_BUILD_TRUCK_STATION_3 or buildData.itemId == BuildingTypes.LW_BUILD_TRUCK_STATION_4 then
    self:RefreshTruckStationView(buildUuid)
  end
end

function LWMyStationManager:ShowTrainAirDropEffect()
  if self.airDropEffectReq then
    self.airDropEffectReq:Destroy()
    self.airDropEffectReq = nil
  end
  local railwayStationData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_RAILWAY_STATION)
  if railwayStationData and CS.SceneManager.World then
    local railwayStation = CS.SceneManager.World:GetBuildingByPoint(railwayStationData.pointId)
    if railwayStation then
      local ModelGo = railwayStation.gameObject.transform:Find("ModelGo")
      local IsNewTrainFunctionOn = DataCenter.LWAllyStationDataManager:IsNewTrainFunctionOn()
      local effectPath = IsNewTrainFunctionOn and URTrainAirDropEffect or NormalTrainAriDropEffect
      self.airDropEffectReq = Resource:InstantiateAsync(effectPath)
      self.airDropEffectReq:completed("+", function(request)
        local gameObject = request.gameObject
        local transform = gameObject.transform
        transform:SetParent(ModelGo)
        transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        transform:Set_localPosition(-5.8, 0, -43.5)
        local timeline = transform:Find("vip_track"):GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
        timeline:Play()
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.buy_golden_train, false)
        if self.planeTrain then
          self.planeTrain:Destroy()
          self.planeTrain = nil
        end
        UIManager:GetInstance():SetUIMainEnable(false)
        self.airDropTimer = TimerManager:GetInstance():DelayInvoke(function()
          if self.airDropEffectReq then
            self.airDropEffectReq:Destroy()
            self.airDropEffectReq = nil
          end
          if self.airDropTimer then
            self.airDropTimer:Stop()
            self.airDropTimer = nil
          end
          self:RefreshRailwayStationView()
          UIManager:GetInstance():SetUIMainEnable(true)
        end, TrainAirDropEffectLength)
      end)
    end
  end
end

function LWMyStationManager:RefreshRailwayStationView()
  local railwayStationData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_RAILWAY_STATION)
  if railwayStationData and CS.SceneManager.World then
    local railwayStation = CS.SceneManager.World:GetBuildingByPoint(railwayStationData.pointId)
    if railwayStation then
      local truckStationBubbleParent = railwayStation.gameObject.transform:Find("ModelGo/Bubble")
      self:RefreshStationBubble(truckStationBubbleParent)
      self:RefreshStation(railwayStation.gameObject.transform:Find("ModelGo"))
      local allyTrainLock = DataCenter.LWAllyStationDataManager:IsTrainFunctionLock()
      local bubbleParent = railwayStation.gameObject.transform:Find("ModelGo/Platform/Bubble")
      local trainParent = railwayStation.gameObject.transform:Find("ModelGo/Platform/Train")
      if not allyTrainLock then
        bubbleParent.gameObject:SetActive(true)
        trainParent.gameObject:SetActive(true)
        local railParent = railwayStation.gameObject.transform:Find("ModelGo/A_build_Track_04")
        self:RefreshRail(railParent)
        self:RefreshBubble(bubbleParent)
        local allyTrainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
        self:RefreshTrainPlatformView(allyTrainData, trainParent)
        if self.cacheDepartedTrainUuid ~= nil then
          local uuid = self.cacheDepartedTrainUuid
          self.cacheDepartedTrainUuid = nil
          self:OnAllianceTrainDeparted(uuid)
        end
      else
        bubbleParent.gameObject:SetActive(false)
        trainParent.gameObject:SetActive(false)
      end
    end
  end
end

function LWMyStationManager:RefreshTrainPlatformView(data, parent)
  if self.airDropTimer then
    return
  end
  if self.planeTrain then
    if data then
      if DataCenter.LWAllyStationDataManager:IsTrainClosed() then
        self.planeTrain:Destroy()
        self.planeTrain = nil
        return
      end
      if self.planeTrain.uuid == data.uuid then
        self.planeTrain:Refresh(data, parent)
      else
        self.planeTrain:Destroy()
        self.planeTrain = PlaneTrain.New(data, parent)
      end
    else
      self.planeTrain:Destroy()
      self.planeTrain = nil
    end
  else
    if DataCenter.LWAllyStationDataManager:IsTrainClosed() then
      return
    end
    if data then
      self.planeTrain = PlaneTrain.New(data, parent)
    end
  end
end

function LWMyStationManager:RefreshBubble(parent)
  if self.platformBubble then
    self.platformBubble:Destroy()
  end
  self.platformBubble = PlatformBubble.New(parent)
end

function LWMyStationManager:RefreshStationBubble(parent)
  if self.stationBubble then
    self.stationBubble:Destroy()
  end
  self.stationBubble = TruckStationBubble.New(parent)
end

function LWMyStationManager:RefreshRail(parent)
  if self.rail then
    self.rail:Destroy()
  end
  self.rail = Rail.New(parent)
end

function LWMyStationManager:RefreshStation(parent)
  if self.myStation then
    self.myStation:Destroy()
  end
  self.myStation = MyRailwayStation.New(parent)
end

function LWMyStationManager:RefreshTruckStationView(buildUuidOrList)
  if type(buildUuidOrList) == "table" then
    for _, uuid in ipairs(buildUuidOrList) do
      self:RefreshOneTruckStation(uuid)
    end
  else
    self:RefreshOneTruckStation(buildUuidOrList)
  end
end

function LWMyStationManager:RefreshOneTruckStation(buildUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(buildUuid)
  if not buildData or not CS.SceneManager.World then
    return
  end
  local truckStation = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
  if truckStation then
    local truck = truckStation.gameObject.transform:Find("ModelGo/Normal/TruckModel")
    if not IsNull(truck) then
      local truckStationState = DataCenter.LWMyStationDataManager:GetTruckStationState(buildUuid)
      if truckStationState == TruckStationState.Ready or truckStationState == TruckStationState.Exhausted or truckStationState == TruckStationState.Reward then
        truck.gameObject:SetActive(true)
        self:RefreshTruckModel(buildUuid, truck)
      else
        truck.gameObject:SetActive(false)
      end
    end
  end
end

function LWMyStationManager:RefreshTruckModel(buildUuid, parent)
  local newTruckPath = self:GetTruckPathByBuildUuid(buildUuid)
  local curTruckPath = self.buildingUuid2TrainPath[buildUuid]
  if newTruckPath ~= curTruckPath then
    self:RemoveTruckModel(buildUuid)
    self:AddTruckModel(buildUuid, parent, newTruckPath)
  end
end

function LWMyStationManager:RemoveTruckModel(buildUuid)
  if self.reqs[buildUuid] then
    self.reqs[buildUuid]:Destroy()
  end
end

function LWMyStationManager:AddTruckModel(buildUuid, parent, truckPath)
  local trainData = DataCenter.LWMyStationDataManager:GetMyTrainByBuildUuid(buildUuid)
  if not trainData then
    return
  end
  self.buildingUuid2TrainPath[buildUuid] = truckPath
  self.reqs[buildUuid] = Resource:InstantiateAsync(truckPath)
  self.reqs[buildUuid]:completed("+", function(req)
    local gameObject = req.gameObject
    if IsNull(req.gameObject) then
      return
    end
    local transform = gameObject.transform
    transform:SetParent(parent)
    transform:Set_localPosition(0, 0, 0)
    transform:Set_localEulerAngles(0, 0, 0)
    transform:Set_localScale(1, 1, 1)
    local animator = transform:GetComponentInChildren(typeof(CS.SimpleAnimation))
    if animator:GetState("Idle") then
      animator:Play("Idle")
    else
      animator:Play("idle")
    end
  end)
end

function LWMyStationManager:GetTruckPathByBuildUuid(buildUuid)
  local trainData = DataCenter.LWMyStationDataManager:GetMyTrainByBuildUuid(buildUuid)
  if trainData then
    return trainData:GetCityModelPath()
  end
  return ""
end

function LWMyStationManager:DepartureOneTruck(trainData)
end

function LWMyStationManager:OnAllianceTrainDeparted(trainUuid)
  if not CS.SceneManager:IsInCity() then
    self.cacheDepartedTrainUuid = trainUuid
    return
  end
  local railwayStationData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_RAILWAY_STATION)
  if railwayStationData and CS.SceneManager.World then
    local railwayStation = CS.SceneManager.World:GetBuildingByPoint(railwayStationData.pointId)
    if railwayStation then
      self.cacheDepartedTrainUuid = nil
      local allyTrainLock = DataCenter.LWAllyStationDataManager:IsTrainFunctionLock()
      local trainParent = railwayStation.gameObject.transform:Find("ModelGo/Platform/Train")
      if not allyTrainLock then
        local allyTrainData = DataCenter.LWAllyStationDataManager:GetAllyTrainByUuid(trainUuid)
        if allyTrainData ~= nil then
          local departureTs = allyTrainData.departureTs
          local now = UITimeManager:GetInstance():GetServerTime()
          if 5000 < now - departureTs then
            return
          end
          self:ClearDepartedTrain()
          self.departedPlaneTrain = PlaneTrain.New(allyTrainData, trainParent, true)
          if self.departedPlaneTrain.transform then
            self.departedPlaneTrainTween = self.departedPlaneTrain.transform:DOLocalMoveZ(-120, TrainLeaveTime):SetEase(CS.DG.Tweening.Ease.InQuart)
            DataCenter.LWSoundManager:PlaySound(SoundAssetId.train_leave, false)
          end
          self.trainEnterEffect = Resource:InstantiateAsync(TrainEnterEffect)
          self.trainEnterEffect:completed("+", function(request)
            if self.departedPlaneTrain == nil then
              request:Destroy()
              return
            end
            if IsNull(self.departedPlaneTrain.transform) then
              request:Destroy()
              return
            end
            local go = request.gameObject
            local trans = go.transform
            trans:SetParent(self.departedPlaneTrain.transform)
            trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            trans:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
            trans:Set_localPosition(ResetPosition.x, ResetPosition.y, -15)
          end)
          self.departedPlaneTrainTimer = TimerManager:GetInstance():DelayInvoke(function()
            self:ClearDepartedTrain()
          end, TrainLeaveTime)
        end
      end
    end
  end
end

function LWMyStationManager:TryMoveCameraLookAtTrainStation()
  local railwayStationData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_RAILWAY_STATION)
  if railwayStationData then
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.LW_BUILD_RAILWAY_STATION)
    local worldPointPos = BuildingUtils.GetBuildModelCenterVec(railwayStationData.pointId, template.tileX, template.tileY, ForceChangeScene.City)
    if CS.SceneManager.World then
      worldPointPos.z = worldPointPos.z - 30
      CS.SceneManager.World:Lookat(worldPointPos)
    end
  end
end

function LWMyStationManager:ClearDepartedTrain()
  if self.departedPlaneTrain ~= nil then
    self.departedPlaneTrain:Destroy()
    self.departedPlaneTrain = nil
  end
  if self.departedPlaneTrainTween ~= nil then
    self.departedPlaneTrainTween:Kill()
    self.departedPlaneTrainTween = nil
  end
  if self.departedPlaneTrainTimer ~= nil then
    self.departedPlaneTrainTimer:Stop()
    self.departedPlaneTrainTimer = nil
  end
  if self.trainEnterEffect then
    self.trainEnterEffect:Destroy()
    self.trainEnterEffect = nil
  end
end

function LWMyStationManager:OnExitCity()
  self:Destroy()
end

return LWMyStationManager
