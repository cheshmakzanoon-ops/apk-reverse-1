local CityaltarListMessage = BaseClass("CityaltarListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CityaltarListMessage:OnCreate(param)
  base.OnCreate(self)
end

function CityaltarListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonCityAltarManager:OnGetCityAltarListCallback(t)
  end
end

return CityaltarListMessage
