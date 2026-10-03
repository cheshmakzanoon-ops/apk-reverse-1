local FetchCityLightStatusInfoMessage = BaseClass("FetchCityLightStatusInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchCityLightStatusInfoMessage:OnCreate()
  base.OnCreate(self)
end

function FetchCityLightStatusInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.lightStatusArr then
    DataCenter.SeasonLightDataManager:UpdateLightBuff(2, t.lightStatusArr)
  end
end

return FetchCityLightStatusInfoMessage
