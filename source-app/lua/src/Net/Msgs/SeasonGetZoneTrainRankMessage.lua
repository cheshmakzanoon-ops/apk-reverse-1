local SeasonGetZoneTrainRankMessage = BaseClass("SeasonGetZoneTrainRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonGetZoneTrainRankMessage:OnCreate(type, subType)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutInt("subType", subType)
end

function SeasonGetZoneTrainRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.HSRDataManager:HandleRankData(t)
  end
end

return SeasonGetZoneTrainRankMessage
