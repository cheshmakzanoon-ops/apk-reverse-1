local LandlordGetCityPointInfoMessage = BaseClass("LandlordGetCityPointInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function LandlordGetCityPointInfoMessage:OnCreate(serverId, cityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("cityId", cityId)
end

function LandlordGetCityPointInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t.errorPara2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    EventManager:GetInstance():Broadcast(EventId.LandlordCityPointInfoUpdateByManual, t)
  end
end

return LandlordGetCityPointInfoMessage
