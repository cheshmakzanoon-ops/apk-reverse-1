local WinterStormSideScorePushMessage = BaseClass("WinterStormSideScorePushMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.ActWinterStormManager:HandleSideScorePush(t)
end

WinterStormSideScorePushMessage.OnCreate = OnCreate
WinterStormSideScorePushMessage.HandleMessage = HandleMessage
return WinterStormSideScorePushMessage
