local MultipleParkourSingleMatchMessage = BaseClass("MultipleParkourSingleMatchMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function MultipleParkourSingleMatchMessage:OnCreate(type, again)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", tonumber(type))
  local a = again or false
  self.sfsObj:PutBool("again", a)
end

function MultipleParkourSingleMatchMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  EventManager:GetInstance():Broadcast(EventId.MultipleParkourSingleMatchResult)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
end

return MultipleParkourSingleMatchMessage
