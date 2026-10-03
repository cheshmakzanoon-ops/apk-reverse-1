local PushSingleAllianceSalaryInfoChangeMessage = BaseClass("PushSingleAllianceSalaryInfoChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushSingleAllianceSalaryInfoChangeMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushSingleAllianceSalaryInfoChangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceMilitaryPayDataManager:OnDailySalaryStatusChange(t)
  end
end

return PushSingleAllianceSalaryInfoChangeMessage
