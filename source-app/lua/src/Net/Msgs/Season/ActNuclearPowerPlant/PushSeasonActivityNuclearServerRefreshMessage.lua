local PushSeasonNuclearServerScoreRefreshMessage = BaseClass("PushSeasonNuclearServerScoreRefreshMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode then
    local msg = t.errorMsg or ""
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.zoneScore and t.zoneScore.score then
    local curServerId = LuaEntry.Player:GetCurServerId()
    DataCenter.WorldAllianceCityDataManager:SetThroneNuclearScore(t.zoneScore.score, curServerId)
    EventManager:GetInstance():Broadcast(EventId.ActNuclearScoreUpdate)
  end
end

PushSeasonNuclearServerScoreRefreshMessage.OnCreate = OnCreate
PushSeasonNuclearServerScoreRefreshMessage.HandleMessage = HandleMessage
return PushSeasonNuclearServerScoreRefreshMessage
