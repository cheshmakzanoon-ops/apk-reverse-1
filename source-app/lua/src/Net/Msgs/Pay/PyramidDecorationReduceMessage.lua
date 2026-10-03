local PyramidDecorationReduceMessage = BaseClass("PyramidDecorationReduceMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PyramidDecorationReduceMessage:OnCreate(param)
  base.OnCreate(self)
end

function PyramidDecorationReduceMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ExchangeSpecialManager:OnResponsePyramidDecorationReduce(t)
    EventManager:GetInstance():Broadcast(EventId.PyramidReduceTips, t)
  end
end

return PyramidDecorationReduceMessage
