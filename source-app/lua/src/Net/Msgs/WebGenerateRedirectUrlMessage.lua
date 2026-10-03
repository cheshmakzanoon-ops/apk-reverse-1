local WebGenerateRedirectUrlMessage = BaseClass("WebGenerateRedirectUrlMessage", SFSBaseMessage)
local base = SFSBaseMessage

function WebGenerateRedirectUrlMessage:OnCreate(type)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("type", type)
end

function WebGenerateRedirectUrlMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local type = t.type
    if type == WebGenerateUrlType.AccountScore then
      DataCenter.AccountScoreManager:OnRecUrl(t)
    end
  end
end

return WebGenerateRedirectUrlMessage
