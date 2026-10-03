local PushMultipleParkourRankPraiseMessage = BaseClass("PushMultipleParkourRankPraiseMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PushMultipleParkourRankPraiseMessage:OnCreate()
  base.OnCreate(self)
end

function PushMultipleParkourRankPraiseMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  EventManager:GetInstance():Broadcast(EventId.MultipleParkourRankPraise, message)
end

return PushMultipleParkourRankPraiseMessage
