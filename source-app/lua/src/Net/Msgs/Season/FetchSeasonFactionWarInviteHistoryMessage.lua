local FetchSeasonFactionWarInviteHistoryMessage = BaseClass("FetchSeasonFactionWarInviteHistoryMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchSeasonFactionWarInviteHistoryMessage:OnCreate(pageNum, pageSize, pageType, round)
  base.OnCreate(self)
  self.sfsObj:PutInt("pageNum", pageNum)
  self.sfsObj:PutInt("pageSize", pageSize)
  self.sfsObj:PutInt("pageType", pageType)
  self.sfsObj:PutInt("round", round)
end

function FetchSeasonFactionWarInviteHistoryMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t and t.pageNum and t.pageSize and t.list then
    EventManager:GetInstance():Broadcast(EventId.LWSeasonFactionInviteHistoryUpdate, t)
  end
end

return FetchSeasonFactionWarInviteHistoryMessage
