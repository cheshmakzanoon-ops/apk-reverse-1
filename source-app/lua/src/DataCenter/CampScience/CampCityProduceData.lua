local CampCityProduceData = BaseClass("CampCityProduceData")

function CampCityProduceData:__init()
  self.campId = 0
  self.cityId = 0
  self.serverId = 0
  self.num = 0
  self.uuid = 0
end

function CampCityProduceData:__delete()
  self.campId = nil
  self.cityId = nil
  self.serverId = nil
  self.num = nil
  self.uuid = nil
end

function CampCityProduceData:ParseServer(message)
  local campId = message.campId
  if campId then
    self.campId = message.campId
  end
  local cityId = message.cityId
  if cityId then
    self.cityId = message.cityId
  end
  local serverId = message.serverId
  if serverId then
    self.serverId = message.serverId
  end
  local num = message.num
  if num then
    self.num = message.num
  end
  local uuid = message.uuid
  if uuid then
    self.uuid = message.uuid
  end
end

function CampCityProduceData:GetLeftNum()
  local receiveReward = DataCenter.CampProduceDataManager:GetCanReceiveRewardArrByCityId(self.cityId)
  local receiveNum = 0
  if receiveReward then
    receiveNum = receiveReward.receiveNum
  end
  return self.num - receiveNum
end

return CampCityProduceData
