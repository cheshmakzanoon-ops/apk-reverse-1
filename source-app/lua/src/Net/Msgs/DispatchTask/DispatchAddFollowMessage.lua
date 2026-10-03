local DispatchAddFollowMessage = BaseClass("DispatchAddFollowMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DispatchAddFollowMessage:OnCreate(uuid, targetServer)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("targetServer", targetServer)
end

function DispatchAddFollowMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return DispatchAddFollowMessage
