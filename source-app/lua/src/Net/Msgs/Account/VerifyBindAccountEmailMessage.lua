local VerifyBindAccountEmailMessage = BaseClass("VerifyBindAccountEmailMessage", SFSBaseMessage)
local base = SFSBaseMessage

function VerifyBindAccountEmailMessage:OnCreate(param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutInt("changeType", param.changeType)
    if param.oldVerifyCode then
      self.sfsObj:PutUtfString("oldVerifyCode", param.oldVerifyCode)
    end
    if param.newVerifyCode then
      self.sfsObj:PutUtfString("newVerifyCode", param.newVerifyCode)
    end
  end
end

function VerifyBindAccountEmailMessage:HandleMessage(t)
  base.HandleMessage(self, t)
end

return VerifyBindAccountEmailMessage
