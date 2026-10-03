local CrossThroneSendRedPacketMessage = BaseClass("CrossThroneSendRedPacketMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CrossThroneSendRedPacketMessage:OnCreate()
  base.OnCreate(self)
end

function CrossThroneSendRedPacketMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
end

return CrossThroneSendRedPacketMessage
