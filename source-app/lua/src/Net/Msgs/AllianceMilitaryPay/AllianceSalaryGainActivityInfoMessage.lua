local AllianceSalaryGainActivityInfoMessage = BaseClass("AllianceSalaryGainActivityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceSalaryGainActivityInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function AllianceSalaryGainActivityInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceMilitaryPayDataManager:SaveAllianceMilitaryPayInfo(t)
  end
end

return AllianceSalaryGainActivityInfoMessage
