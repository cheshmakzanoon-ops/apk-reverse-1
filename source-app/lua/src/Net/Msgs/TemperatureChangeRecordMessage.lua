local TemperatureChangeRecordMessage = BaseClass("TemperatureChangeRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

function TemperatureChangeRecordMessage:OnCreate()
  base.OnCreate(self)
end

function TemperatureChangeRecordMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.TemperatureManager:SetTemperatureHistory(t.ls)
end

return TemperatureChangeRecordMessage
