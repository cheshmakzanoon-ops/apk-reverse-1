local AllianceSalaryNotifyAllFinishTaskMessage = BaseClass("AllianceSalaryNotifyAllFinishTaskMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceSalaryNotifyAllFinishTaskMessage:OnCreate(configId)
  base.OnCreate(self)
  self.sfsObj:PutInt("configId", configId)
end

function AllianceSalaryNotifyAllFinishTaskMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceMilitaryPayDataManager:OnShareSuccess(t)
  end
end

return AllianceSalaryNotifyAllFinishTaskMessage
