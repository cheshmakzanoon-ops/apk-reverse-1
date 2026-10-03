local HeroPropertyData = BaseClass("HeroPropertyData")

local function __init(self, propertyData)
  if propertyData == nil then
    self.propertyData = {}
  else
    self.propertyData = propertyData
  end
end

local function __delete(self)
  self.propertyData = nil
end

local function GetProperty(self, propertyType)
  if self.propertyData == nil or not self.propertyData[propertyType] then
    return 0
  end
  return self.propertyData[propertyType]
end

local function GetAllProperty(self)
  return DeepCopy(self.propertyData)
end

function HeroPropertyData:GetAllPropertyReadOnly()
  return self.propertyData
end

local function SetProperty(self, propertyType, value)
  if self.propertyData[propertyType] ~= value then
    self.isDirty = true
  end
  self.propertyData[propertyType] = value
end

local function Clear(self)
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    table.clear(self.propertyData)
  else
    self.propertyData = {}
  end
  self.isDirty = false
end

local function ClearDirtyState(self)
  self.isDirty = false
end

local function WalkAllProperties(self, func)
  if self.propertyData == nil then
    return
  end
  for k, v in pairs(self.propertyData) do
    func(k, v)
  end
end

HeroPropertyData.__init = __init
HeroPropertyData.__delete = __delete
HeroPropertyData.GetProperty = GetProperty
HeroPropertyData.GetAllProperty = GetAllProperty
HeroPropertyData.SetProperty = SetProperty
HeroPropertyData.Clear = Clear
HeroPropertyData.ClearDirtyState = ClearDirtyState
HeroPropertyData.WalkAllProperties = WalkAllProperties
return HeroPropertyData
