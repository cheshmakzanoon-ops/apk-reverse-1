local GetCityWarInfo = BaseClass("GetCityWarInfo", SFSBaseMessage)
local base = SFSBaseMessage

function GetCityWarInfo:OnCreate(nServerId)
  base.OnCreate(self)
  if nServerId ~= nil and nServerId ~= 0 and nServerId ~= -1 then
    self.sfsObj:PutInt("serverId", nServerId)
  end
end

function GetCityWarInfo:HandleMessage(data)
  base.HandleMessage(self, data)
  if data ~= nil and data.cityInfoList ~= nil then
    DataCenter.WorldAllianceCityDataManager:OnGetCityWarInfo(data)
  end
end

return GetCityWarInfo
