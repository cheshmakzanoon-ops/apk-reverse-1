local AccountDeviceSendVerifyCodeMessage = BaseClass("AccountDeviceSendVerifyCodeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AccountDeviceSendVerifyCodeMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("mail", param.mail)
  self.sfsObj:PutUtfString("type", param.oType)
end

function AccountDeviceSendVerifyCodeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return AccountDeviceSendVerifyCodeMessage
