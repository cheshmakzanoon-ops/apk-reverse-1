local PushAccountDeviceSendVerifyCodeMessage = BaseClass("PushAccountDeviceSendVerifyCodeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAccountDeviceSendVerifyCodeMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAccountDeviceSendVerifyCodeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local emailExpireTime = t.emailExpireTime
    if not string.IsNullOrEmpty(emailExpireTime) then
      CS.GameEntry.Setting:SetPrivateString("LW_EmailResendExpireTime", tostring(emailExpireTime))
    end
    DataCenter.AccountManager:SetMailVerifyCodeType(t.type)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAccountVerify, t.mail or "", 6)
  end
end

return PushAccountDeviceSendVerifyCodeMessage
