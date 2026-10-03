local CityRebuildCarManager = BaseClass("CityRebuildCarManager")
local LWCityRebuildCar = require("Scene.CityRebuildAni.CityRebuildCar")
local ResourceManager = CS.GameEntry.Resource

function CityRebuildCarManager:__init()
  self.cars = {}
  self.cachePos = {}
  self.cacheTasks = {}
  self.hideCar = false
  self.moveCar = false
end

function CityRebuildCarManager:__delete()
  for _, car in pairs(self.cars) do
    car:Delete()
  end
  self.cars = nil
  self.cachePos = nil
  self.carPosList = nil
  self.cacheTasks = nil
  self.hideCar = false
  self.moveCar = false
  self:RemoveListener()
end

function CityRebuildCarManager:OnInitCar()
  self:AddListener()
  self:ShowCars(true)
end

function CityRebuildCarManager:AddListener()
end

function CityRebuildCarManager:RemoveListener()
end

function CityRebuildCarManager:ShowCars(hideTween)
  if not CS.SceneManager:IsInCity() then
    return
  end
  if not LuaEntry.Player:AtHomeNow() then
    return
  end
  if self.hideCar then
    return
  end
  local march = DataCenter.CityRebuildDataManager:GetMarchInfo()
  if march and 0 < #march then
    for key, value in pairs(march) do
      local car = self.cars[key]
      if car then
        car:OnlyShowInRebuild()
      else
        local pos, index = self:GetNewPos()
        if pos then
          car = LWCityRebuildCar.New()
          car:ShowInRebuild(pos, value, not hideTween and self.cacheTasks[key] == nil, index)
          self.cars[key] = car
        end
        self.cacheTasks[key] = true
      end
    end
  else
    local num = LuaEntry.DataConfig:TryGetStr("alliance_rescue_config", "k7")
    if not string.IsNullOrEmpty(num) then
      local result = {}
      for segment in string.gmatch(num, "([^-]+)") do
        table.insert(result, segment)
      end
      for indexs = 1, tonumber(result[1]) do
        local car = self.cars[indexs]
        if car then
          car:OnlyShowInRebuild()
        else
          local pos, index = self:GetNewPos()
          if pos then
            car = LWCityRebuildCar.New()
            car:ShowInRebuild(pos, nil, not hideTween and self.cacheTasks[indexs] == nil, index)
            self.cars[indexs] = car
          end
          self.cacheTasks[indexs] = true
        end
      end
    end
  end
end

function CityRebuildCarManager:MoveCars()
  if not self.moveCar then
    self.moveCar = true
    if self.cars then
      for index, car in ipairs(self.cars) do
        car:MoveToZ()
      end
    end
  end
end

function CityRebuildCarManager:GetNewPos()
  local posList = self:GetCarPosList()
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

function CityRebuildCarManager:HideCars()
  if self.cars then
    for _, car in pairs(self.cars) do
      car:Hide()
    end
  end
end

function CityRebuildCarManager:GetCarsActive()
  if self.cars then
    for _, car in pairs(self.cars) do
      if car:GetCarActive() then
        return true
      end
    end
  end
  return false
end

function CityRebuildCarManager:OnReleaseCity()
  for _, car in pairs(self.cars) do
    car:Delete()
  end
  self.cars = {}
  self.cachePos = {}
  self.hideCar = false
end

function CityRebuildCarManager:GetCarPosList()
  if self.carPosList == nil then
    self.carPosList = {}
    local posArray = LuaEntry.DataConfig:TryGetStr("alliance_rescue_config", "k9")
    if not string.IsNullOrEmpty(posArray) then
      local posList = string.split(posArray, ";")
      for _, data in ipairs(posList) do
        local xz = string.split(data, ",")
        if #xz == 2 then
          local pos = Vector3.New(tonumber(xz[1]), 0, tonumber(xz[2]))
          table.insert(self.carPosList, pos)
        end
      end
    end
  end
  return self.carPosList
end

return CityRebuildCarManager
