local ViewAllianceTradeLogMessage = BaseClass("ViewAllianceTradeLogMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ViewAllianceTradeLogMessage:OnCreate(type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
end

function ViewAllianceTradeLogMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.type then
    EventManager:GetInstance():Broadcast(EventId.ViewAllianceTradeLog, t)
  end
end

return ViewAllianceTradeLogMessage
