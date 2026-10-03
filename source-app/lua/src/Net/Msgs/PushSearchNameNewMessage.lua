local PushSearchNameNewMessage = BaseClass("PushSearchNameNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushSearchNameNewMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushSearchNameNewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.SendContactGiftSearchBack, t)
  end
end

return PushSearchNameNewMessage
