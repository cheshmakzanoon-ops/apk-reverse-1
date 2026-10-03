local PushBountyHunterTriggerEventMessage = BaseClass("PushBountyHunterTriggerEventMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushBountyHunterTriggerEventMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushBountyHunterTriggerEventMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.activityId then
    local activityId = toInt(t.activityId)
    local actData = DataCenter.BountyHunterActDataManager:GetActData(activityId)
    if not actData then
      return
    end
    actData:UpdateEventData(t)
  end
end

return PushBountyHunterTriggerEventMessage
