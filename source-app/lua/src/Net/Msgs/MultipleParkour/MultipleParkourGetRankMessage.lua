local MultipleParkourGetRankMessage = BaseClass("MultipleParkourGetRankMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function MultipleParkourGetRankMessage:OnCreate(type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", tonumber(type))
end

function MultipleParkourGetRankMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  EventManager:GetInstance():Broadcast(EventId.MultipleParkourGetRank, message)
end

return MultipleParkourGetRankMessage
