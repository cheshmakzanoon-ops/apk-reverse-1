local PushAlCityInfoUpdateMessage = BaseClass("PushAlCityInfoUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WorldAllianceCityDataManager:UpdateAllCityDataRequest(WorldAllianceCityType.Stronghold, t.server)
  end
end

PushAlCityInfoUpdateMessage.OnCreate = OnCreate
PushAlCityInfoUpdateMessage.HandleMessage = HandleMessage
return PushAlCityInfoUpdateMessage
