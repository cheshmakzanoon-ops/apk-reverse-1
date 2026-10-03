local GetCityBrokenInfoMessage = BaseClass("PushCityBrokenRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  LuaEntry.Effect:SetBreachData(t)
end

GetCityBrokenInfoMessage.OnCreate = OnCreate
GetCityBrokenInfoMessage.HandleMessage = HandleMessage
return GetCityBrokenInfoMessage
