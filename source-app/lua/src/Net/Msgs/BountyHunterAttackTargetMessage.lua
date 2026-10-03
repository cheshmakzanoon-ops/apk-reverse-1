local BountyHunterAttackTargetMessage = BaseClass("BountyHunterAttackTargetMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BountyHunterAttackTargetMessage:OnCreate(activityId, targetId, num)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutLong("targetId", targetId)
  self.sfsObj:PutInt("num", num)
end

function BountyHunterAttackTargetMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.BountyHunterReceiveAttackTargetMessage)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

return BountyHunterAttackTargetMessage
