local SeasonGetZoneTrainTradeRecordsMessage = BaseClass("SeasonGetZoneTrainTradeRecordsMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonGetZoneTrainTradeRecordsMessage:OnCreate(trainUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", trainUuid)
end

function SeasonGetZoneTrainTradeRecordsMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.uuid then
    DataCenter.HSRDataManager:HandleMyHistoryByTrain(t)
  end
end

return SeasonGetZoneTrainTradeRecordsMessage
