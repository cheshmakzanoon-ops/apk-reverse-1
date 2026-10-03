local CityaltarDetailMessage = BaseClass("CityaltarDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CityaltarDetailMessage:OnCreate(cfgId, sid)
  base.OnCreate(self)
  self.sfsObj:PutInt("cfgId", cfgId)
  self.sfsObj:PutInt("sid", sid)
end

function CityaltarDetailMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonCityAltarManager:OnGetAltarInfoCallback(t)
  end
end

return CityaltarDetailMessage
