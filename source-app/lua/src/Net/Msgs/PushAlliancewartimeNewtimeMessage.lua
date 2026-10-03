local PushAlliancewartimeNewtimeMessage = BaseClass("PushAlliancewartimeNewtimeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAlliancewartimeNewtimeMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAlliancewartimeNewtimeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.UILWSeasonAllianceWarTimeManager:OnSetTimePush(t)
  end
end

return PushAlliancewartimeNewtimeMessage
