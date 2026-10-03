local PushBountyHunterBatchAttackMessage = BaseClass("PushBountyHunterBatchAttackMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushBountyHunterBatchAttackMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushBountyHunterBatchAttackMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local params = {}
    params.actionType = BountyHunterAniActionType.SuperShoot
    params.triggerType = BountyHunterActionTriggerType.PushQueue
    params.data = t
    EventManager:GetInstance():Broadcast(EventId.BountyHunterAddAniActionToQueue, params)
    local actData = DataCenter.BountyHunterActDataManager:GetActData(t.activityId)
    if actData then
      actData:UpdateStashReward(t.stashReward)
      actData:UpdateScore(t.score)
      actData:UpdateTodayConsume(t)
      actData:UpdateTotalConsume(t)
    end
  end
end

return PushBountyHunterBatchAttackMessage
