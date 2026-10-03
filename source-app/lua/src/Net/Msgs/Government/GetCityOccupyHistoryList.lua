local GetCityOccupyHistoryList = BaseClass("GetCityOccupyHistoryList", SFSBaseMessage)
local base = SFSBaseMessage
local __uuid

function GetCityOccupyHistoryList:OnCreate(uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

function GetCityOccupyHistoryList:HandleMessage(t)
  base.HandleMessage(self, t)
  DataCenter.ZoneWarManager:SetCityOccupyHistoryList(t.ls, t.uuid)
end

return GetCityOccupyHistoryList
