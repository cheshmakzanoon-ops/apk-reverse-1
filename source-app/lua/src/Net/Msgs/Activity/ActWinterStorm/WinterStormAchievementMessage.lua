local WinterStormAchievementMessage = BaseClass("WinterStormAchievementMessage", SFSBaseMessage)
local base = SFSBaseMessage

function WinterStormAchievementMessage:OnCreate()
  base.OnCreate(self)
end

function WinterStormAchievementMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.WinterStormAchievementList, t)
  end
end

return WinterStormAchievementMessage
