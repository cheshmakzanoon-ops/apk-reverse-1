local BountyHunterRefreshStageMessage = BaseClass("BountyHunterRefreshStageMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BountyHunterRefreshStageMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function BountyHunterRefreshStageMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.BountyHunterReceiveRefreshStageMessage)
  end
end

return BountyHunterRefreshStageMessage
