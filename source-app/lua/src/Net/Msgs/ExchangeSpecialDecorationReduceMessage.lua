local ExchangeSpecialDecorationReduceMessage = BaseClass("ExchangeSpecialDecorationReduceMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ExchangeSpecialDecorationReduceMessage:OnCreate(id)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", tonumber(id))
end

function ExchangeSpecialDecorationReduceMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ExchangeSpecialManager:OnResponseExchangeSpecialDecorationReduce(t)
    EventManager:GetInstance():Broadcast(EventId.PyramidReduceTips, t)
  end
end

return ExchangeSpecialDecorationReduceMessage
