local PushSeasonHunterBattleInfoMessage = BaseClass("PushSeasonHunterBattleInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushSeasonHunterBattleInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushSeasonHunterBattleInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local activityInfo = DataCenter.SeasonHunterManager.activityInfo
  if not activityInfo then
    activityInfo = {}
    DataCenter.SeasonHunterManager.activityInfo = activityInfo
  end
  activityInfo.wolfNum = t.wolfNum
  activityInfo.score = t.score
  activityInfo.matchRank = t.matchRank
  EventManager:GetInstance():Broadcast(EventId.SeasonHunterBattleInfo)
end

return PushSeasonHunterBattleInfoMessage
