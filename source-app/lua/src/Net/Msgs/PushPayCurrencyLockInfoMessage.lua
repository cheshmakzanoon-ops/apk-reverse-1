local PushPayCurrencyLockInfoMessage = BaseClass("PushPayCurrencyLockInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushPayCurrencyLockInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushPayCurrencyLockInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.PayCurrencyLockManager:UpdateLockInfo(t)
  end
end

return PushPayCurrencyLockInfoMessage
