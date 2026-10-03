local SeasonGetStationDetailInfoMessage = BaseClass("SeasonGetStationDetailInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonGetStationDetailInfoMessage:OnCreate(cityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("stationId", cityId)
end

function SeasonGetStationDetailInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.HSRDataManager:HandelOneStationHistory(t)
  end
end

return SeasonGetStationDetailInfoMessage
