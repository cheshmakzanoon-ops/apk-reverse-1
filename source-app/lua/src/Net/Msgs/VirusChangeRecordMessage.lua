local VirusChangeRecordMessage = BaseClass("VirusChangeRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

function VirusChangeRecordMessage:OnCreate()
  base.OnCreate(self)
end

function VirusChangeRecordMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.VirusDataManager:SetVirusHistory(t.ls)
end

return VirusChangeRecordMessage
