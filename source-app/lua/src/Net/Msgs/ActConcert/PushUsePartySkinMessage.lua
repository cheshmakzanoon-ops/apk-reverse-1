local PushUsePartySkinMessage = BaseClass("PushUsePartySkinMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushUsePartySkinMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushUsePartySkinMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local data = {
      pointId = t.pointId,
      operator = t.operator
    }
    EventManager:GetInstance():Broadcast(EventId.BuildMainStartPartyShowTips, data)
  end
end

return PushUsePartySkinMessage
