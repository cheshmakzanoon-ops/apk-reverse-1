local TruckRecordData = BaseClass("TruckRecordData")
local TrainData = require("DataCenter.LWRailway.Train.TrainData")

function TruckRecordData:__init(msg)
  self.trainData = TrainData.New(msg.train or msg)
  self.recordUuid = msg.record_uuid or 0
  self.recordTime = msg.record_time or 0
  self.isFavorite = msg.favorite or 0
end

function TruckRecordData:__delete()
  self.trainData = nil
  self.recordUuid = nil
  self.recordTime = nil
  self.isFavorite = nil
end

return TruckRecordData
