local AccountLoginSendVerifyCodeMessage = BaseClass("AccountLoginSendVerifyCodeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  local emailExpireTime = t.emailExpireTime
  if not string.IsNullOrEmpty(emailExpireTime) then
    CS.GameEntry.Setting:SetPrivateString("LW_EmailResendExpireTime", tostring(emailExpireTime))
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAddAccount)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAccountVerify, t.mail, 1)
end

AccountLoginSendVerifyCodeMessage.OnCreate = OnCreate
AccountLoginSendVerifyCodeMessage.HandleMessage = HandleMessage
return AccountLoginSendVerifyCodeMessage
