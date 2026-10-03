local GetCrossDeclareWarCityListMessage = BaseClass("GetCrossDeclareWarCityListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetCrossDeclareWarCityListMessage:OnCreate(targetServer)
  base.OnCreate(self)
  self.sfsObj:PutInt("targetServer", toInt(targetServer))
end

function GetCrossDeclareWarCityListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonDataManager:SetCrossDeclareWarCityList(t)
end

return GetCrossDeclareWarCityListMessage
