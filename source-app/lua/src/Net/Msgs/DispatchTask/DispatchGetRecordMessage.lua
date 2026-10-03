local DispatchGetRecordMessage = BaseClass("DispatchGetRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DispatchGetRecordMessage:OnCreate(type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
end

function DispatchGetRecordMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActDispatchTaskDataManager:HandleRecord(message)
end

return DispatchGetRecordMessage
