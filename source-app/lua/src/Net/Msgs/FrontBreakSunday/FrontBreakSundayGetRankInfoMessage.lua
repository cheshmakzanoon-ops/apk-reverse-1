local FrontBreakSundayGetRankInfoMessage = BaseClass("FrontBreakSundayGetRankInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function FrontBreakSundayGetRankInfoMessage:OnCreate(type, rankStart, rankEnd)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", tonumber(type))
  self.sfsObj:PutInt("start", rankStart)
  self.sfsObj:PutInt("end", rankEnd)
end

function FrontBreakSundayGetRankInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  EventManager:GetInstance():Broadcast(EventId.FrontBreakSundayGetRank, message)
end

return FrontBreakSundayGetRankInfoMessage
