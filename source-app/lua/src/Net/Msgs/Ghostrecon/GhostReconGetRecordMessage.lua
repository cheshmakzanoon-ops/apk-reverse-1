local GhostReconGetRecordMessage = BaseClass("GhostReconGetRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GhostReconGetRecordMessage:OnCreate()
  base.OnCreate(self)
end

function GhostReconGetRecordMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActGhostreconManager:HandleRecord(message)
end

return GhostReconGetRecordMessage
