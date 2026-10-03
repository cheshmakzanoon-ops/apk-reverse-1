local FrontBreakSundayGetRankRewardInfoMessage = BaseClass("FrontBreakSundayGetRankRewardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function FrontBreakSundayGetRankRewardInfoMessage:OnCreate(type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", tonumber(type))
end

function FrontBreakSundayGetRankRewardInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  EventManager:GetInstance():Broadcast(EventId.FrontBreakSundayGetRankReward, message)
end

return FrontBreakSundayGetRankRewardInfoMessage
