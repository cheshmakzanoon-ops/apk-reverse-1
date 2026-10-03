local PushCityTradeInfoUpdateMessage = BaseClass("PushCityTradeInfoUpdateMessage", SFSBaseMessage)
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
    DataCenter.WorldAllianceCityDataManager:UpdateAllCityDataRequest(WorldAllianceCityType.TradingStation, t.server)
  end
end

PushCityTradeInfoUpdateMessage.OnCreate = OnCreate
PushCityTradeInfoUpdateMessage.HandleMessage = HandleMessage
return PushCityTradeInfoUpdateMessage
