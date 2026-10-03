local SeasonGetZoneTrainActivityInfoMessage = BaseClass("SeasonGetZoneTrainActivityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonGetZoneTrainActivityInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function SeasonGetZoneTrainActivityInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  DataCenter.HSRDataManager:HandelActivityData(t)
end

return SeasonGetZoneTrainActivityInfoMessage
