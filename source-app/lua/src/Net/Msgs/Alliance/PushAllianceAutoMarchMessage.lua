local PushAllianceAutoMarchMessage = BaseClass("PushAllianceAutoMarchMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.ActivityTipsManager:AddTempTip(MainUITipType.AllyCity, MainUITipCondition.AllOut, "GOGOGO", 2000264)
end

PushAllianceAutoMarchMessage.OnCreate = OnCreate
PushAllianceAutoMarchMessage.HandleMessage = HandleMessage
return PushAllianceAutoMarchMessage
