local PushAihelpNewUnreadMessage = BaseClass("PushAihelpNewUnreadMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAihelpNewUnreadMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAihelpNewUnreadMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.unreadCount then
    CS.AIHelp.AIHelpProxy.SetAiHelpUnreadMsgCount(t.unreadCount)
  end
end

return PushAihelpNewUnreadMessage
