local SeasonGetTrainStationInfoMessage = BaseClass("SeasonGetTrainStationInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonGetTrainStationInfoMessage:OnCreate(trainTime)
  base.OnCreate(self)
  self.sfsObj:PutLong("trainTime", trainTime)
end

function SeasonGetTrainStationInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.HSRDataManager:HandelAllStationOldHistory(t)
  end
end

return SeasonGetTrainStationInfoMessage
