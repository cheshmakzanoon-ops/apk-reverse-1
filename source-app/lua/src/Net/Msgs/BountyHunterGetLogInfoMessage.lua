local BountyHunterGetLogInfoMessage = BaseClass("BountyHunterGetLogInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BountyHunterGetLogInfoMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function BountyHunterGetLogInfoMessage:HandleMessage(t)
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
    if t.logKey then
      actData:UpdateBatLogData(t.logKey)
      EventManager:GetInstance():Broadcast(EventId.BountyHunterReceiveBatLogData, activityId)
    end
  end
end

return BountyHunterGetLogInfoMessage
