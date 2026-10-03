local LWDispatchTaskCarManager = BaseClass("LWDispatchTaskCarManager")
local LWDispatchTaskCar = require("DataCenter.LWDispatchTaskCarManager.LWDispatchTaskCar")

function LWDispatchTaskCarManager:__init()
  self.cars = {}
  self.cachePos = {}
  self.cacheTasks = {}
  self.hideCar = false
end

function LWDispatchTaskCarManager:__delete()
  for _, car in pairs(self.cars) do
    car:Delete()
  end
  self.cars = nil
  self.cachePos = nil
  self.cacheTasks = nil
  self.hideCar = false
  self:RemoveListener()
end

function LWDispatchTaskCarManager:OnEnterGame()
  self:AddListener()
  if DataCenter.ActDispatchTaskDataManager:CheckUnlock() then
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_DISPATCH_TASK)
    if buildData and buildData.level > 0 then
      DataCenter.ActDispatchTaskDataManager:GetAllSingleTasksFromServer(true)
    end
  end
  self:ShowCars()
end

function LWDispatchTaskCarManager:AddListener()
  if self.inited then
    return
  end
  self.inited = true
  self.onBuildFinish_action = BindCallback(self, self.OnBuildingUpgradeDone)
  self.onEnterCity_action = BindCallback(self, self.OnEnterCity)
  self.onReleaseCity_action = BindCallback(self, self.OnReleaseCity)
  self.onFirstShowCar_action = BindCallback(self, self.FirstShowCar)
  self.onUpdateTask_action = BindCallback(self, self.OnUpdateTask)
  self.onGuideFlowStart_action = BindCallback(self, self.OnGuideFlowStart)
  self.onGuideFlowDone_action = BindCallback(self, self.OnGuideFlowDone)
  EventManager:GetInstance():AddListener(EventId.GF_enter_city, self.onEnterCity_action)
  EventManager:GetInstance():AddListener(EventId.GF_building_upgrade_done, self.onBuildFinish_action)
  EventManager:GetInstance():AddListener(EventId.BeforeReleaseCity, self.onReleaseCity_action)
  EventManager:GetInstance():AddListener(EventId.DispatchTaskFirstPush, self.onFirstShowCar_action)
  EventManager:GetInstance():AddListener(EventId.DispatchTaskUpdateSingle, self.onUpdateTask_action)
  EventManager:GetInstance():AddListener(EventId.GF_guide_start, self.onGuideFlowStart_action)
  EventManager:GetInstance():AddListener(EventId.GF_guide_done, self.onGuideFlowDone_action)
end

function LWDispatchTaskCarManager:RemoveListener()
  if not self.inited then
    return
  end
  self.inited = false
  EventManager:GetInstance():RemoveListener(EventId.GF_enter_city, self.onEnterCity_action)
  EventManager:GetInstance():RemoveListener(EventId.GF_building_upgrade_done, self.onBuildFinish_action)
  EventManager:GetInstance():RemoveListener(EventId.BeforeReleaseCity, self.onReleaseCity_action)
  EventManager:GetInstance():RemoveListener(EventId.DispatchTaskFirstPush, self.onFirstShowCar_action)
  EventManager:GetInstance():RemoveListener(EventId.DispatchTaskUpdateSingle, self.onUpdateTask_action)
  EventManager:GetInstance():RemoveListener(EventId.GF_guide_start, self.onGuideFlowStart_action)
  EventManager:GetInstance():RemoveListener(EventId.GF_guide_done, self.onGuideFlowDone_action)
  self.onBuildFinish_action = nil
  self.onEnterCity_action = nil
  self.onReleaseCity_action = nil
  self.onFirstShowCar_action = nil
  self.onUpdateTask_action = nil
  self.onGuideFlowStart_action = nil
  self.onGuideFlowDone_action = nil
end

function LWDispatchTaskCarManager:OnBuildingUpgradeDone(info)
  local buildingId = info.itemId
  if buildingId == BuildingTypes.LW_BUILD_DISPATCH_TASK then
  end
end

function LWDispatchTaskCarManager:FirstShowCar()
  self:ShowCars()
end

function LWDispatchTaskCarManager:OnEnterCity()
  self.hideCar = false
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_DISPATCH_TASK)
  if not buildData or buildData.level < 1 then
    return
  end
  self:ShowCars()
end

function LWDispatchTaskCarManager:ShowCars(hideTween)
  if not CS.SceneManager:IsInCity() then
    return
  end
  if not LuaEntry.Player:AtHomeNow() then
    return
  end
  if not DataCenter.ActDispatchTaskDataManager:CheckUnlock() then
    return
  end
  local datas = DataCenter.ActDispatchTaskDataManager:GetSingleTaskAssist()
  if self.hideCar then
    return
  end
  local removeList = {}
  for uuid, car in pairs(self.cars) do
    if not table.containsKey(datas, uuid) then
      table.insert(removeList, uuid)
    end
  end
  for _, uuid in ipairs(removeList) do
    local car = self.cars[uuid]
    self.cars[uuid] = nil
    self.cacheTasks[uuid] = nil
    table.insert(self.cachePos, car.index)
    car:Delete()
  end
  for uuid, data in pairs(datas) do
    local car = self.cars[uuid]
    if car then
      car:OnlyShow()
    else
      local pos, index = self:GetNewPos()
      if pos then
        car = LWDispatchTaskCar.New()
        car:Show(pos, data, not hideTween and self.cacheTasks[uuid] == nil, index)
        self.cars[uuid] = car
      end
      self.cacheTasks[uuid] = true
    end
  end
end

function LWDispatchTaskCarManager:GetNewPos()
  local posList = DataCenter.ActDispatchTaskDataManager:GetCarPosList()
  if #self.cachePos > 0 then
    table.sort(self.cachePos, function(a, b)
      return a < b
    end)
    local index = self.cachePos[1]
    local pos = posList[index]
    table.remove(self.cachePos, 1)
    return pos, index
  end
  local posCount = #posList
  local carCount = table.count(self.cars)
  local index = carCount + 1
  if posCount >= index then
    return posList[index], index
  end
  return nil, nil
end

function LWDispatchTaskCarManager:HideCars()
  if self.cars then
    for _, car in pairs(self.cars) do
      car:Hide()
    end
  end
end

function LWDispatchTaskCarManager:OnUpdateTask()
  if not CS.SceneManager:IsInCity() then
    return
  end
  DataCenter.BuildBubbleManager:OnRefreshDispatchTaskBubble()
  self:ShowCars()
end

function LWDispatchTaskCarManager:OnReleaseCity()
  for _, car in pairs(self.cars) do
    car:Delete()
  end
  self.cars = {}
  self.cachePos = {}
  self.hideCar = false
end

function LWDispatchTaskCarManager:OnGuideFlowStart(flowId)
  if flowId == 2002 then
    self.hideCar = true
    self:HideCars()
  end
end

function LWDispatchTaskCarManager:OnGuideFlowDone(flowId)
  if flowId == 2002 then
    self.hideCar = false
    self:ShowCars(true)
  end
end

return LWDispatchTaskCarManager
