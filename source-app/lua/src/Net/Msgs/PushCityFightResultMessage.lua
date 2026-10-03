local PushCityFightResultMessage = BaseClass("PushCityFightResultMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.GuideCityManager:PushCityFightResultHandle(t)
end

PushCityFightResultMessage.OnCreate = OnCreate
PushCityFightResultMessage.HandleMessage = HandleMessage
return PushCityFightResultMessage
