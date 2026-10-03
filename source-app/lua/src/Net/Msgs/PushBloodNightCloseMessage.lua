local PushBloodNightCloseMessage = BaseClass("PushBloodNightCloseMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushBloodNightCloseMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushBloodNightCloseMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.serverId then
    DataCenter.BloodyNightDataManager:HandlePushBloodNightClose(t.serverId)
  end
end

return PushBloodNightCloseMessage
