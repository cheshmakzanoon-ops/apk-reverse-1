local DispatchLeaveMessageMessage = BaseClass("DispatchLeaveMessageMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DispatchLeaveMessageMessage:OnCreate(recordId, msgId, targetServer)
  base.OnCreate(self)
  self.sfsObj:PutLong("recordUuid", recordId)
  self.sfsObj:PutInt("msgId", msgId)
  self.sfsObj:PutInt("targetServer", targetServer)
end

function DispatchLeaveMessageMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
end

return DispatchLeaveMessageMessage
