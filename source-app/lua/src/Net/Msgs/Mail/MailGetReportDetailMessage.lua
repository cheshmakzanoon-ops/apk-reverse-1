local MailGetReportDetailMessage = BaseClass("MailGetReportDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, reportId)
  base.OnCreate(self)
  if reportId ~= nil then
    self.sfsObj:PutLong("fightReportUuid", reportId)
  end
  CommonUtil.PlayerPrefsSetString("LAST_SKIRMISH_MAIL_UUID", tostring(reportId))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  BattleReportUtil.HandleMailGetReportDetailMessage(t)
end

MailGetReportDetailMessage.OnCreate = OnCreate
MailGetReportDetailMessage.HandleMessage = HandleMessage
return MailGetReportDetailMessage
