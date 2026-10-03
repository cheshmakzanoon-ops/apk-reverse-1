local AccountLoginSendVerifyCodeMessage = BaseClass("AccountLoginSendVerifyCodeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutUtfString("mail", param.mail)
    self.sfsObj:PutUtfString("lang", CS.GameEntry.Localization:GetLanguageName())
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
end

AccountLoginSendVerifyCodeMessage.OnCreate = OnCreate
AccountLoginSendVerifyCodeMessage.HandleMessage = HandleMessage
return AccountLoginSendVerifyCodeMessage
