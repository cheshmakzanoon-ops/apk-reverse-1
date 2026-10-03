local CampProduceDataManager = BaseClass("CampProduceDataManager")
local CampCityProduceData = require("DataCenter.CampScience.CampCityProduceData")

function CampProduceDataManager:__init()
  self.campCityProduceOccList = {}
  self.userCampCityRewardArr = {}
  self.userCampDesTroyRewardRecordArr = {}
  self.campCityProduceDestroyList = {}
end

function CampProduceDataManager:__delete()
  self.campCityProduceOccList = nil
  self.userCampCityRewardArr = nil
  self.userCampDesTroyRewardRecordArr = nil
  self.campCityProduceDestroyList = nil
end

function CampProduceDataManager:InitData()
  SFSNetwork.SendMessage(MsgDefines.CampProductView)
end

function CampProduceDataManager:ReqCampProductView(message)
  local userCampCityRewardArr = message.userCampCityRewardArr
  if userCampCityRewardArr then
    for _, v in pairs(userCampCityRewardArr) do
      self.userCampCityRewardArr[v.cityId] = v
    end
    EventManager:GetInstance():Broadcast(EventId.UpdateCampProduceRewardList)
  end
  local campProductArr = message.campProductArr
  if campProductArr then
    for _, v in pairs(campProductArr) do
      local campCityOcc = self.campCityProduceOccList[v.cityId]
      if not campCityOcc then
        campCityOcc = CampCityProduceData.New()
        self.campCityProduceOccList[v.cityId] = campCityOcc
      end
      campCityOcc:ParseServer(v)
    end
    EventManager:GetInstance():Broadcast(EventId.UpdateCampProduceList)
  end
  local userCampDesTroyRewardRecordArr = message.userCampDesTroyRewardRecordArr
  if userCampDesTroyRewardRecordArr then
    for _, v in pairs(userCampDesTroyRewardRecordArr) do
      self.userCampDesTroyRewardRecordArr[v.cityId] = v
    end
    EventManager:GetInstance():Broadcast(EventId.UpdateCampProduceDesRecordList)
  end
end

function CampProduceDataManager:ReqProductReward(message)
  local receiveArr = message.receiveArr
  local needEvent = false
  if receiveArr then
    for _, v in pairs(receiveArr) do
      if v.errorCode == "S10000" and v.userCampCityRewardInfo ~= nil then
        self.userCampCityRewardArr[v.cityId] = v.userCampCityRewardInfo
        needEvent = true
      end
    end
  end
  if needEvent then
    EventManager:GetInstance():Broadcast(EventId.UpdateCampProduceRewardList)
  end
  if message.reward ~= nil and table.count(message.reward) > 0 then
    DataCenter.RewardManager:ShowCommonReward(message)
    DataCenter.RewardManager:AddRewardsAndRes(message)
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  if message.resources ~= nil then
    LuaEntry.Resource:UpdateResource(message.resources)
  end
  if message.gold ~= nil then
    LuaEntry.Player.gold = message.gold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshSeasonCityTitleRed)
end

function CampProduceDataManager:GetCampProduceOccList()
  return self.campCityProduceOccList
end

function CampProduceDataManager:GetCanReceiveRewardArrByCityId(cityId)
  return self.userCampCityRewardArr[cityId]
end

function CampProduceDataManager:ReqCampDestroyRewardMessage(message)
  local destroyReceiveArr = message.destroyReceiveArr
  local needEvent = false
  if destroyReceiveArr then
    for _, v in pairs(destroyReceiveArr) do
      if v.errorCode == "S10000" and v.userCampDesTroyRewardRecordInfo ~= nil then
        self.userCampDesTroyRewardRecordArr[v.cityId] = v.userCampDesTroyRewardRecordInfo
        needEvent = true
      end
    end
  end
  if needEvent then
    EventManager:GetInstance():Broadcast(EventId.UpdateCampProduceDesRecordList)
  end
  if message.reward ~= nil and table.count(message.reward) > 0 then
    DataCenter.RewardManager:ShowCommonReward(message)
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
  if message.resources ~= nil then
    LuaEntry.Resource:UpdateResource(message.resources)
  end
  if message.gold ~= nil then
    LuaEntry.Player.gold = message.gold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshSeasonCityTitleRed)
end

function CampProduceDataManager:GetUserCampDesTroyRewardRecordByCityID(cityId)
  return self.userCampDesTroyRewardRecordArr[cityId]
end

function CampProduceDataManager:GetCanReceiveProduceReward()
  local produceCount = 0
  local cityMgr = DataCenter.AllianceCityTemplateManager
  for k, v in pairs(self.campCityProduceOccList) do
    if 0 < v:GetLeftNum() then
      local cityMeta = cityMgr:GetTemplate(toInt(v.cityId), LuaEntry.Player:GetSourceServerId())
      local resOutPut = cityMeta:ParseCampResOutput()
      if resOutPut and 0 < #resOutPut then
        local count = checknumber(resOutPut[1].count)
        produceCount = produceCount + v:GetLeftNum() * count
      end
    end
  end
  if 0 < produceCount then
    return produceCount, 0
  end
  local destroyCount = 0
  local campDesCityList = DataCenter.WorldAllianceCityDataManager:GetCampDestroyCityList()
  for cityId, _ in pairs(campDesCityList) do
    local cityMeta = cityMgr:GetTemplate(toInt(cityId), LuaEntry.Player:GetSourceServerId())
    local resOutPut = cityMeta:GetCampDestroyResOutput()
    if resOutPut then
      local count = checknumber(resOutPut.count)
      local hasRev = self:GetUserCampDesTroyRewardRecordByCityID(cityId) ~= nil
      if not hasRev then
        destroyCount = destroyCount + count
      end
    end
  end
  return 0, destroyCount
end

function CampProduceDataManager:GetProduceRed()
  local produceCount = 0
  local cityMgr = DataCenter.AllianceCityTemplateManager
  for k, v in pairs(self.campCityProduceOccList) do
    if 0 < v:GetLeftNum() then
      local cityMeta = cityMgr:GetTemplate(toInt(v.cityId), LuaEntry.Player:GetSourceServerId())
      local resOutPut = cityMeta:ParseCampResOutput()
      if resOutPut and 0 < #resOutPut then
        local count = checknumber(resOutPut[1].count)
        if 0 < v:GetLeftNum() * count then
          return true
        end
      end
    end
  end
  return false
end

function CampProduceDataManager:GetDestroyRed()
  local campDesCityList = DataCenter.WorldAllianceCityDataManager:GetCampDestroyCityList()
  local cityMgr = DataCenter.AllianceCityTemplateManager
  for cityId, _ in pairs(campDesCityList) do
    local cityMeta = cityMgr:GetTemplate(toInt(cityId), LuaEntry.Player:GetSourceServerId())
    local resOutPut = cityMeta:GetCampDestroyResOutput()
    if resOutPut then
      local hasRev = self:GetUserCampDesTroyRewardRecordByCityID(cityId) ~= nil
      if not hasRev then
        return true
      end
    end
  end
  return false
end

local hasDataALL = false

function CampProduceDataManager:RepCampDestroyList()
  hasDataALL = false
  SFSNetwork.SendMessage(MsgDefines.CampDestroyCityLogList, 1, 100)
end

function CampProduceDataManager:ReqCampDestroyList(message)
  local hasNewData = false
  if message and message.page and message.pageSize and message.list then
    for k, v in ipairs(message.list) do
      if self.campCityProduceDestroyList[v.cityId] == nil then
        hasNewData = true
        self.campCityProduceDestroyList[v.cityId] = v
      end
    end
    if hasDataALL and not hasNewData then
      return
    end
    if #message.list >= message.pageSize then
      SFSNetwork.SendMessage(MsgDefines.CampDestroyCityLogList, toInt(message.page) + 1, 100)
    else
      hasDataALL = true
    end
  end
  if hasDataALL then
    EventManager:GetInstance():Broadcast(EventId.GetCampDestroyCityList)
  end
end

function CampProduceDataManager:GetShowOccDestroyRecordData()
  return self.campCityProduceDestroyList
end

return CampProduceDataManager
