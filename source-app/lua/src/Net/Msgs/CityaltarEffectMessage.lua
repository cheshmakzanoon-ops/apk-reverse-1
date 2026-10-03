local CityaltarEffectMessage = BaseClass("CityaltarEffectMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CityaltarEffectMessage:OnCreate(param)
  base.OnCreate(self)
end

function CityaltarEffectMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WorldAllianceCityDataManager:UpdateAllianceCityEffect(t, false, true)
  end
end

return CityaltarEffectMessage
