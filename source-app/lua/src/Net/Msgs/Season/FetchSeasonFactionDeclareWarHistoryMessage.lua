local FetchSeasonFactionDeclareWarHistoryMessage = BaseClass("FetchSeasonFactionDeclareWarHistoryMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchSeasonFactionDeclareWarHistoryMessage:OnCreate(pageNum, pageSize, round, allianceId)
  base.OnCreate(self)
  self.sfsObj:PutInt("pageNum", pageNum)
  self.sfsObj:PutInt("pageSize", pageSize or 100)
  self.sfsObj:PutInt("round", round)
  if allianceId ~= nil and allianceId ~= 0 and allianceId ~= "" then
    self.sfsObj:PutUtfString("allianceId", allianceId)
  end
end

function FetchSeasonFactionDeclareWarHistoryMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    return
  end
  if t and t.pageNum and t.pageSize and t.list then
    EventManager:GetInstance():Broadcast(EventId.LWSeasonFactionDeclareHistory, t)
  end
end

return FetchSeasonFactionDeclareWarHistoryMessage
