local PushActivityVisitorMessage = BaseClass("PushActivityVisitorMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushActivityVisitorMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushActivityVisitorMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityVisitorManager:UpdateData(t)
    EventManager:GetInstance():Broadcast(EventId.ActivityVisitorDataUpdate)
  end
end

return PushActivityVisitorMessage
