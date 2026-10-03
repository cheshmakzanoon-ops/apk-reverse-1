local BountyHunterScreenShootMessage = BaseClass("BountyHunterScreenShootMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BountyHunterScreenShootMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function BountyHunterScreenShootMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.BountyHunterReceiveScreenShootMessage)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

return BountyHunterScreenShootMessage
