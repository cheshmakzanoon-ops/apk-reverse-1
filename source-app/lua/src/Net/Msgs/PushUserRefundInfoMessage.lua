local PushUserRefundInfoMessage = BaseClass("PushUserRefundInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushUserRefundInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushUserRefundInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWRefundPunishManager:InitData(t)
  end
end

return PushUserRefundInfoMessage
