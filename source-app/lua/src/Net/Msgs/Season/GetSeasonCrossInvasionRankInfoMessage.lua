local GetSeasonCrossInvasionRankInfoMessage = BaseClass("GetSeasonCrossInvasionRankInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetSeasonCrossInvasionRankInfoMessage:OnCreate(rankType, weekNum, periodType)
  base.OnCreate(self)
  if rankType ~= nil and weekNum ~= nil and periodType ~= nil then
    self.sfsObj:PutInt("rankType", rankType)
    self.sfsObj:PutInt("weekNum", weekNum)
    self.sfsObj:PutInt("periodType", periodType)
  end
end

function GetSeasonCrossInvasionRankInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId("season_mastery_104")
    return
  end
  if t.rankType ~= nil and t.weekNum ~= nil and t.periodType ~= nil then
    t.requestTime = UITimeManager:GetInstance():GetServerTime()
    EventManager:GetInstance():Broadcast(EventId.LWSeasonRankUpdateNew, t)
  end
  if t.rankType == 1 and t.weekNum == 0 and t.periodType == 0 then
    EventManager:GetInstance():Broadcast(EventId.SeasonRankUpdate, t)
  end
end

return GetSeasonCrossInvasionRankInfoMessage
