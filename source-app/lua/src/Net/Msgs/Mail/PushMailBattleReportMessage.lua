local PushMailBattleReportMessage = BaseClass("PushMailBattleReportMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.MailDataManager:HandlePushMailBattleReportMessage(t)
end

PushMailBattleReportMessage.OnCreate = OnCreate
PushMailBattleReportMessage.HandleMessage = HandleMessage
return PushMailBattleReportMessage
