local WinterStormPushAchievementMessage = BaseClass("WinterStormPushAchievementMessage", SFSBaseMessage)
local base = SFSBaseMessage

function WinterStormPushAchievementMessage:OnCreate()
  base.OnCreate(self)
end

function WinterStormPushAchievementMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.WinterStormBattleAchievementNew, t)
  end
end

return WinterStormPushAchievementMessage
