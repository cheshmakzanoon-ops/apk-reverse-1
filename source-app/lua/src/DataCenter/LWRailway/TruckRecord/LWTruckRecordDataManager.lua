local LWTruckRecordDataManager = BaseClass("LWTruckRecordDataManager")
local TruckRecordData = require("DataCenter.LWRailway.TruckRecord.TruckRecordData")
local TruckRobData = require("DataCenter.LWRailway.TruckRecord.TruckRobData")
local TruckRobSimpleRecord = require("DataCenter.LWRailway.TruckRecord.TruckRobSimpleRecord")
local TrainData = require("DataCenter.LWRailway.Train.TrainData")
local Setting = CS.GameEntry.Setting

function LWTruckRecordDataManager:__init()
  self:AddListener()
  self.truckSendList = {}
  self.truckSendMap = {}
  self.truckCollectList = {}
  self.truckCollectMap = {}
  self.truckRobList = {}
end

function LWTruckRecordDataManager:__delete()
  self:RemoveListener()
  self.truckSendList = nil
  self.truckCollectList = nil
  self.truckSendMap = nil
  self.truckCollectMap = nil
  self.truckRobList = nil
end

function LWTruckRecordDataManager:AddListener()
end

function LWTruckRecordDataManager:RemoveListener()
end

function LWTruckRecordDataManager:OnGetTruckRecordList(message)
  if message and message.type then
    if message.type == TruckRecordType.TruckSend then
      self.truckSendList = self.truckSendList or {}
      local begin = message.start + 1
      if message.train_array then
        for k, v in ipairs(message.train_array) do
          local data = TruckRecordData.New(v)
          self.truckSendList[begin + k - 1] = data
          self.truckSendMap[data.trainData.uuid] = data
        end
      end
    elseif message.type == TruckRecordType.TruckCollect then
      if message.start == 0 then
        self.truckCollectList = {}
      end
      local begin = message.start + 1
      if message.train_array then
        for k, v in ipairs(message.train_array) do
          local data = TruckRecordData.New(v)
          data.isFavorite = 1
          self.truckCollectList[begin + k - 1] = data
          self.truckCollectMap[data.trainData.uuid] = data
        end
      end
    elseif message.type == TruckRecordType.TruckRob then
      if message.start == 0 then
        self.truckRobList = {}
      end
      local begin = message.start + 1
      if message.train_array then
        for k, v in ipairs(message.train_array) do
          local data = TruckRobSimpleRecord.New(v)
          self.truckRobList[begin + k - 1] = data
        end
      end
    end
    EventManager:GetInstance():Broadcast(EventId.TruckRecordListArrive, message.type)
  end
end

function LWTruckRecordDataManager:OnFavoriteAdd(message)
  if message then
    if message.record_uuid then
      local data = self.truckSendMap[message.train_uuid]
      if data then
        data.isFavorite = 1
      end
      data = self.truckCollectMap[message.train_uuid]
      if data then
        data.isFavorite = 1
      end
    end
    EventManager:GetInstance():Broadcast(EventId.TruckRecordFavoriteAdd, message)
  end
end

function LWTruckRecordDataManager:OnFavoriteRemove(message)
  if message then
    if message.record_uuid then
      local data = self.truckSendMap[message.train_uuid]
      if data then
        data.isFavorite = 0
      end
      data = self.truckCollectMap[message.train_uuid]
      if data then
        data.isFavorite = 0
      end
    end
    EventManager:GetInstance():Broadcast(EventId.TruckRecordFavoriteRemove, message)
  end
end

function LWTruckRecordDataManager:OnGetTruckRobBattleReportDetail(message)
  if message then
    local recordData = TruckRecordData.New(message)
    EventManager:GetInstance():Broadcast(EventId.TruckRecordDetailDataArrive, recordData)
  end
end

function LWTruckRecordDataManager:GetTruckRecordList(recordType)
  if recordType == TruckRecordType.TruckSend then
    return self.truckSendList
  elseif recordType == TruckRecordType.TruckRob then
    return self.truckRobList
  elseif recordType == TruckRecordType.TruckCollect then
    return self.truckCollectList
  end
end

function LWTruckRecordDataManager:GetIsWantedPlayerByUid(playerUid)
  local key = SettingKeys.TRUCK_WANTED_KEY .. playerUid
  local hasValue = Setting:HasSetting(key)
  if hasValue then
    local time = Setting:GetString(key)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local openDays = UITimeManager:GetInstance():GetBetweenDaysForServer(time / 1000, curTime / 1000)
    if 3 <= openDays then
      Setting:RemoveSetting(key)
      return false
    end
    return true
  end
  return false
end

function LWTruckRecordDataManager:SetWantedPlayerByUid(playerUid)
  local key = SettingKeys.TRUCK_WANTED_KEY .. playerUid
  local curTime = UITimeManager:GetInstance():GetServerTime()
  Setting:SetString(key, curTime)
end

return LWTruckRecordDataManager
