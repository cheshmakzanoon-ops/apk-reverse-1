local SeasonAttackCityRankMessage = BaseClass("SeasonAttackCityRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonAttackCityRankMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("activityId", activityId)
end

function SeasonAttackCityRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  EventManager:GetInstance():Broadcast(EventId.LWSeasonAttackCityRankInfoUpdate, t)
end

return SeasonAttackCityRankMessage
