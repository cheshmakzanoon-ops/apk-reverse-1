local GoogleCancelBindMessage = BaseClass("GoogleCancelBindMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GoogleCancelBindMessage:OnCreate(param)
  base.OnCreate(self)
  if param ~= nil then
    DataCenter.AccountManager:SetParam(param)
    if not string.IsNullOrEmpty(param.type) then
      self.sfsObj:PutUtfString("type", param.type)
    end
    if not string.IsNullOrEmpty(param.account) then
      self.sfsObj:PutUtfString("account", param.account)
    end
  end
end

function GoogleCancelBindMessage:HandleMessage(t)
  base.HandleMessage(self, t)
end

return GoogleCancelBindMessage
