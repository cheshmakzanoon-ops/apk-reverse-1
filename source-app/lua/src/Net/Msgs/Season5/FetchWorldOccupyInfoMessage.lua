local FetchWorldOccupyInfoMessage = BaseClass("FetchWorldOccupyInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchWorldOccupyInfoMessage:OnCreate(serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
end

function FetchWorldOccupyInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil then
    DataCenter.WorldAllianceCityDataManager:UpdateAllCityDataFullData(t.content, t.serverId)
  end
end

return FetchWorldOccupyInfoMessage
