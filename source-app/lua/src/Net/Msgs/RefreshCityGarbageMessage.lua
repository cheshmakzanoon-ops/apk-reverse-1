local RefreshCityGarbageMessage = BaseClass("RefreshCityGarbageMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.GuideCityManager:RefreshCityGarbageHandle(t)
end

RefreshCityGarbageMessage.OnCreate = OnCreate
RefreshCityGarbageMessage.HandleMessage = HandleMessage
return RefreshCityGarbageMessage
