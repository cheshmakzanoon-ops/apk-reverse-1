local MyAlCityInfo = BaseClass("MyAlCityInfo")

local function __init(self)
  self.cityId = nil
  self.cityName = nil
  self.giveUpEndTime = nil
  self.durability = nil
  self.lastDurabilityTime = nil
  self.changeNameTime = nil
end

local function __delete(self)
  self.cityId = nil
  self.cityName = nil
  self.giveUpEndTime = nil
  self.durability = nil
  self.lastDurabilityTime = nil
  self.changeNameTime = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  self.cityId = toInt(message.cityId or message.strongholdId)
  if message.strongholdId then
    self.strongholdId = message.strongholdId
    self.stronghold = true
  else
    self.stronghold = false
  end
  if message.giveUpTime then
    self.giveUpEndTime = message.giveUpTime
  end
  if message.durability then
    self.durability = message.durability
  end
  if message.lastDurabilityTime then
    self.lastDurabilityTime = message.lastDurabilityTime
  end
  if message.cityName then
    self.cityName = message.cityName
  end
  if message.changeNameTime then
    self.changeNameTime = message.changeNameTime
  end
end

local function SetGiveUpTime(self, endTime)
  self.giveUpEndTime = endTime
end

local function SetChangeNameTime(self, endTime)
  self.changeNameTime = endTime
end

local function SetChangeName(self, name)
  self.cityName = name
end

local function GetName(self)
  if not string.IsNullOrEmpty(self.cityName) then
    return self.cityName
  end
  local cityData = LocalController:instance():getLine(TableName.WorldCity, self.cityId)
  if cityData and cityData then
    return CS.GameEntry.Localization:GetString(cityData.name)
  end
  return ""
end

MyAlCityInfo.__init = __init
MyAlCityInfo.__delete = __delete
MyAlCityInfo.ParseData = ParseData
MyAlCityInfo.SetGiveUpTime = SetGiveUpTime
MyAlCityInfo.SetChangeNameTime = SetChangeNameTime
MyAlCityInfo.SetChangeName = SetChangeName
MyAlCityInfo.GetName = GetName
return MyAlCityInfo
