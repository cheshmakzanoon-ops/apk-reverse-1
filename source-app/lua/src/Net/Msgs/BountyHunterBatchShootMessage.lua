local BountyHunterBatchShootMessage = BaseClass("BountyHunterBatchShootMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BountyHunterBatchShootMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutBool("useRefreshItem", param.useRefreshItem)
  self.sfsObj:PutInt("activityId", param.activityId)
end

function BountyHunterBatchShootMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
  EventManager:GetInstance():Broadcast(EventId.BountyHunterReceiveSuperShootMessage)
end

return BountyHunterBatchShootMessage
