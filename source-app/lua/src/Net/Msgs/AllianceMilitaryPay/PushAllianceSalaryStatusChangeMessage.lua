local PushAllianceSalaryStatusChangeMessage = BaseClass("PushAllianceSalaryStatusChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceSalaryStatusChangeMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceSalaryStatusChangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceMilitaryPayDataManager:OnActivityStatusChange(t)
  end
end

return PushAllianceSalaryStatusChangeMessage
