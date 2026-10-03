local PushDragonResultCheersMessage = BaseClass("PushDragonResultCheersMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushDragonResultCheersMessage:OnCreate()
  base.OnCreate(self)
end

function PushDragonResultCheersMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.DragonResultCheersPush, t)
  end
end

return PushDragonResultCheersMessage
