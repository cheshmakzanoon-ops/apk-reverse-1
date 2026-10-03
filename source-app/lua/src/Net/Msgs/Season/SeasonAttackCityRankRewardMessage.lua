local SeasonAttackCityRankRewardMessage = BaseClass("SeasonAttackCityRankRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonAttackCityRankRewardMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("activityId", activityId)
end

function SeasonAttackCityRankRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  EventManager:GetInstance():Broadcast(EventId.LWSeasonAttackCityRankRewardUpdate, t)
end

return SeasonAttackCityRankRewardMessage
