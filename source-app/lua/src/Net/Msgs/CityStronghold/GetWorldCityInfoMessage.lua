local GetWorldCityInfoMessage = BaseClass("GetWorldCityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t then
    DataCenter.WorldAllianceCityDataManager:UpdateAllCityData(t, t.serverId, WorldAllianceCityType.Stronghold)
  end
end

GetWorldCityInfoMessage.OnCreate = OnCreate
GetWorldCityInfoMessage.HandleMessage = HandleMessage
return GetWorldCityInfoMessage
