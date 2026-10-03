local AllianceCityOccupyInfo = BaseClass("AllianceCityOccupyInfo")

local function __init(self)
  self.cityId = 0
  self.abbr = ""
  self.allianceId = ""
  self.color = 0
  self.cityName = ""
  self.allianceName = ""
  self.occupyServerId = 0
  self.destroyServerId = 0
  self.destroyAllianceId = nil
  self.destroyAllianceAbbr = nil
  self.destroyAllianceName = nil
end

local function __delete(self)
  self.cityId = nil
  self.abbr = nil
  self.allianceId = nil
  self.cityName = nil
  self.allianceName = nil
  self.occupyServerId = nil
  self.destroyServerId = nil
  self.destroyAllianceId = nil
  self.destroyAllianceAbbr = nil
  self.destroyAllianceName = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  self.cityId = message.cityId or message.strongholdId
  if message.abbr ~= nil then
    self.abbr = message.abbr
  end
  if message.allainceId ~= nil then
    self.allianceId = message.allainceId
  end
  if message.color ~= nil then
    self.color = message.color
  end
  if message.cityName then
    self.cityName = message.cityName
  end
  if message.allianceName ~= nil then
    self.allianceName = message.allianceName
  end
  if message.occupyServerId ~= nil then
    self.occupyServerId = toInt(message.occupyServerId)
  end
  if message.destroyServerId ~= nil then
    self.destroyServerId = toInt(message.destroyServerId)
  end
  if message.destroyAllianceId ~= nil then
    self.destroyAllianceId = message.destroyAllianceId
  end
  if message.firstOccupyTime ~= nil then
    self.firstOccupyTime = toInt(message.firstOccupyTime)
  end
end

function AllianceCityOccupyInfo:ParseDataV2(cityId, message)
  if message == nil then
    return
  end
  self.cityId = cityId
  if message.abbr ~= nil then
    self.abbr = message.abbr
  end
  if message.allianceId ~= nil then
    self.allianceId = message.allianceId
  end
  if message.color ~= nil then
    self.color = message.color
  end
  if message.cityName then
    self.cityName = message.cityName
  end
  if message.allianceName ~= nil then
    self.allianceName = message.allianceName
  end
  if message.occupyServerId ~= nil then
    self.occupyServerId = toInt(message.occupyServerId)
  end
  if message.destroyServerId ~= nil then
    self.destroyServerId = toInt(message.destroyServerId)
  end
  if message.destroyAllianceId ~= nil then
    self.destroyAllianceId = message.destroyAllianceId
  end
end

local function ParseDataFromOccupy(self, message)
  if message == nil then
    return
  end
  if message.cityId ~= nil then
    self.cityId = message.cityId
  end
  if message.abbr ~= nil then
    self.abbr = message.abbr
  end
  if message.alId ~= nil then
    self.allianceId = message.alId
  end
  if message.name ~= nil then
    self.allianceName = message.name
  end
  if message.icon ~= nil then
    self.icon = message.icon
  end
  if message.oldAlId ~= nil then
    self.icon = message.oldAlId
  end
  if message.oldAbbr ~= nil then
    self.icon = message.oldAbbr
  end
  if message.oldName ~= nil then
    self.icon = message.oldName
  end
  if message.oldIcon ~= nil then
    self.icon = message.oldIcon
  end
end

local function ParseDataFormRewardInfo(self, message)
  if message == nil then
    return
  end
  if message.cityId ~= nil then
    self.cityId = message.cityId
  end
  local myAllianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  self.abbr = myAllianceData.abbr
  self.allianceId = myAllianceData.uid
  self.allianceName = myAllianceData.allianceName
  self.icon = myAllianceData.icon
end

function AllianceCityOccupyInfo:HasFirstOccupy()
  local cityDetail = DataCenter.WorldPointDetailManager:GetAllianceCityData(self.cityId)
  if cityDetail ~= nil and cityDetail:HasFirstOccupy() then
    self.firstOccupyTime = cityDetail.firstCrossOccupyInfo.firstOccupyTime
    return true
  end
  return self.firstOccupyTime ~= nil and self.firstOccupyTime > 0
end

function AllianceCityOccupyInfo:IsServerOccupied()
  return self.allianceId and self.allianceId == "-1"
end

function AllianceCityOccupyInfo:IsRuins()
  return toInt(self.destroyServerId) > 0
end

function AllianceCityOccupyInfo:IsNotRuins()
  return self.destroyServerId == nil or toInt(self.destroyServerId) <= 0
end

AllianceCityOccupyInfo.__init = __init
AllianceCityOccupyInfo.__delete = __delete
AllianceCityOccupyInfo.ParseData = ParseData
AllianceCityOccupyInfo.ParseDataFromOccupy = ParseDataFromOccupy
AllianceCityOccupyInfo.ParseDataFormRewardInfo = ParseDataFormRewardInfo
return AllianceCityOccupyInfo
