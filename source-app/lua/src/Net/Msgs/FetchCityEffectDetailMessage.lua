local FetchCityEffectDetailMessage = BaseClass("FetchCityEffectDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchCityEffectDetailMessage:OnCreate()
  base.OnCreate(self)
end

function FetchCityEffectDetailMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  EventManager:GetInstance():Broadcast(EventId.CityEffectDetailUpdate, t)
end

return FetchCityEffectDetailMessage
