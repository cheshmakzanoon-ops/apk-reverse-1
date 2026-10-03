local ResourceReduceCalcMamanger = BaseClass("ResourceReduceCalcMamanger")

local function __init(self)
  self.updateSecTimer = nil
  self.checkResourceType = {}
  self.checkResourceType[ResourceType.FLINT] = true
  self.checkResourceTypeFun = {}
  self.checkResourceTypeFun[ResourceType.FLINT] = self._calcFlintReduceCount
  self.resourceReduceCount = {}
end

local function __delete(self)
  self:RemoveListener()
end

function ResourceReduceCalcMamanger:OnEnterGame()
  self:CheckReduce()
end

function ResourceReduceCalcMamanger:AddListener()
  EventManager:GetInstance():AddListenerWithSelf(EventId.BUILDING_FURNACE_DATA_UPDATE, self.FurnaceStateChange, self)
end

function ResourceReduceCalcMamanger:RemoveListener()
  EventManager:GetInstance():RemoveListener2(EventId.BUILDING_FURNACE_DATA_UPDATE, self.FurnaceStateChange)
end

function ResourceReduceCalcMamanger:OnUpdateSec()
  local flag = false
  for key, value in pairs(self.checkResourceType) do
    if self.checkResourceTypeFun then
      local fun = self.checkResourceTypeFun[key]
      if fun and type(fun) == "function" then
        local result = fun(self)
        if not flag and result then
          flag = true
        end
      end
    end
  end
  if not flag then
    self:StopTimer()
  else
    EventManager:GetInstance():Broadcast(EventId.RESOURCE_REDUCE_TICK)
  end
end

function ResourceReduceCalcMamanger:CheckReduce()
  local flag = false
  for key, value in pairs(self.checkResourceType) do
    if self.checkResourceTypeFun then
      local fun = self.checkResourceTypeFun[key]
      if fun and type(fun) == "function" then
        local result = fun(self)
        if not flag and result then
          flag = true
        end
      end
    end
  end
  if flag then
    if self.updateSecTimer == nil then
      self.updateSecTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdateSec, self, false, false, false)
      self.updateSecTimer:Start()
    end
  else
    self:StopTimer()
  end
end

function ResourceReduceCalcMamanger:StopTimer()
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
end

function ResourceReduceCalcMamanger:_calcFlintReduceCount()
  local flag = false
  local data = DataCenter.BuildManager.buildingExtData
  local addValue = 0
  if data then
    local now = UITimeManager:GetInstance():GetServerTime()
    for key, value in pairs(data) do
      if value.state == PERSONAL_FURNACE_STATE.RUN or value.state == PERSONAL_FURNACE_STATE.OVER_RUN then
        if self.furnaceLastTime == nil then
          self.furnaceLastTime = value.startTime
        end
        local time = now - self.furnaceLastTime
        if time < 60000 then
          return true
        end
        time = now - value.startTime
        if time < 0 then
          time = 0
        else
          time = Mathf.Floor(time / 1000)
        end
        self.furnaceLastTime = now
        local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(value.uuid)
        if buildingData then
          local buildId = buildingData.itemId
          local level = buildingData.level
          local buildCurLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
          local reduceValue = 0
          if value.state == PERSONAL_FURNACE_STATE.RUN then
            reduceValue = buildCurLevelTemplate.coal_normal[2] / 60
          end
          if value.state == PERSONAL_FURNACE_STATE.OVER_RUN then
            reduceValue = buildCurLevelTemplate.coal_overload[2] / 60
          end
          addValue = addValue + toInt(time * reduceValue)
          flag = true
        end
      end
    end
  end
  if 0 < addValue then
    self.resourceReduceCount[ResourceType.FLINT] = addValue
  end
  Logger.Log("calc reudce resource : ResourceType.FLINT" .. tostring(self.resourceReduceCount[ResourceType.FLINT]))
  return flag
end

function ResourceReduceCalcMamanger:FurnaceStateChange()
  self:CheckReduce()
end

function ResourceReduceCalcMamanger:GetReduceValue(reourceType)
  if self.resourceReduceCount[reourceType] then
    return self.resourceReduceCount[reourceType]
  end
  return 0
end

ResourceReduceCalcMamanger.__init = __init
ResourceReduceCalcMamanger.__delete = __delete
return ResourceReduceCalcMamanger
