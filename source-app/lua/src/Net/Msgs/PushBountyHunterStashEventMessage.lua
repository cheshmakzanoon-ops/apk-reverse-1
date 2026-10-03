local PushBountyHunterStashEventMessage = BaseClass("PushBountyHunterStashEventMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushBountyHunterStashEventMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushBountyHunterStashEventMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local activityData = DataCenter.BountyHunterActDataManager:GetActData(t.activityId)
    if activityData then
      activityData:UpdateSingleEventBossData(t.triggerEvent)
      EventManager:GetInstance():Broadcast(EventId.BountyHunterBossEventUpdate)
    end
  end
end

return PushBountyHunterStashEventMessage
