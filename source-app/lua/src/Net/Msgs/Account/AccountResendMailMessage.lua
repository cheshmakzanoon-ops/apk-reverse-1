local AccountResendMailMessage = BaseClass("AccountResendMailMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutUtfString("account", param.account)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  EventManager:GetInstance():Broadcast(EventId.AccountResendMailEvent)
end

AccountResendMailMessage.OnCreate = OnCreate
AccountResendMailMessage.HandleMessage = HandleMessage
return AccountResendMailMessage
