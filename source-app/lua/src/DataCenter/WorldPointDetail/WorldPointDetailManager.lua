local WorldPointDetailManager = BaseClass("WorldPointDetailManager")
local AllianceResourceData = require("DataCenter.WorldPointDetail.WorldAllianceResourceData")
local WorldSuppliesDetailData = require("DataCenter.WorldPointDetail.WorldSuppliesPointData")

local function __init(self)
  self.worldPointDetailList = {}
  self.worldAllianceCityList = {}
  self.worldAllianceResourceDataList = {}
  self.worldSuppliesDataList = {}
  self.personalDiscoverSuppliesInfo = {}
end

local function __delete(self)
  self.worldPointDetailList = nil
  self.worldAllianceCityList = nil
  self.worldAllianceResourceDataList = nil
  self.worldSuppliesDataList = nil
  self.personalDiscoverSuppliesInfo = nil
end

local function UpdateDetail(self, message)
  local detailData = WorldPointDetailData.New()
  detailData:ParseData(message)
  if detailData.pointId > 0 then
    self.worldPointDetailList[detailData.pointId] = detailData
  end
  return detailData
end

local function UpdateAllianceCity(self, message, stronghold)
  local detail = WorldAllianceCityData.New()
  detail:ParseData(message)
  if detail.cityId ~= nil then
    self.worldPointDetailList[detail.cityId] = detail
  elseif detail.strongholdId ~= nil then
    self.worldPointDetailList[detail.strongholdId] = detail
  end
  return detail
end

local function GetAllianceCityData(self, cityId)
  return self.worldPointDetailList[cityId]
end

local function GetDetailByPointId(self, pointId)
  return self.worldPointDetailList[pointId]
end

local function UpdateAllianceCollectResourceDetail(self, message)
  local uuid = message.uuid
  if uuid then
    local data = self.worldAllianceResourceDataList[uuid]
    if not data then
      data = AllianceResourceData.New()
      self.worldAllianceResourceDataList[uuid] = data
    end
    data:ParseData(message)
    EventManager:GetInstance():Broadcast(EventId.WorldGetAllianceCollectResDetailUpdate)
  end
end

local function GetAllianceResourceData(self, uuid)
  return self.worldAllianceResourceDataList[uuid]
end

function WorldPointDetailManager:UpdateWorldSuppliesPointDetail(message)
  local uuid = message.uuid
  if uuid then
    local data = self.worldSuppliesDataList[uuid]
    if not data then
      data = WorldSuppliesDetailData.New()
      self.worldSuppliesDataList[uuid] = data
    end
    data:ParseData(message)
    EventManager:GetInstance():Broadcast(EventId.WorldGetAllianceCollectResDetailUpdate)
  end
end

function WorldPointDetailManager:GetWorldSuppliesPointDetailData(uuid)
  return self.worldSuppliesDataList[uuid]
end

function WorldPointDetailManager:UpdateWorldChargeData(message)
  local uuid = message.uuid
  if uuid then
    local data = self.worldSuppliesDataList[uuid]
    if not data then
      return
    end
    data:ParseDataCharge(message)
    EventManager:GetInstance():Broadcast(EventId.WorldGetAllianceCollectResDetailUpdate)
  end
end

function WorldPointDetailManager:GetPersonalDiscoverSuppliesInfo(sendMsg)
  if sendMsg then
    SFSNetwork.SendMessage(MsgDefines.PersonalDiscoverSuppliesInfo)
  end
  return self.personalDiscoverSuppliesInfo
end

function WorldPointDetailManager:UpdatePersonalDiscoverSuppliesInfo(message)
  self.personalDiscoverSuppliesInfo = message
  EventManager:GetInstance():Broadcast(EventId.PersonalDiscoverSuppliesInfo)
end

WorldPointDetailManager.__init = __init
WorldPointDetailManager.__delete = __delete
WorldPointDetailManager.UpdateDetail = UpdateDetail
WorldPointDetailManager.GetDetailByPointId = GetDetailByPointId
WorldPointDetailManager.UpdateAllianceCity = UpdateAllianceCity
WorldPointDetailManager.GetAllianceCityData = GetAllianceCityData
WorldPointDetailManager.UpdateAllianceCollectResourceDetail = UpdateAllianceCollectResourceDetail
WorldPointDetailManager.GetAllianceResourceData = GetAllianceResourceData
return WorldPointDetailManager
