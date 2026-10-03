local SeasonGetStationMiniInfoMessage = BaseClass("SeasonGetStationMiniInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonGetStationMiniInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function SeasonGetStationMiniInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.HSRDataManager:HandelAllStationCurHistory(t)
  end
end

return SeasonGetStationMiniInfoMessage
