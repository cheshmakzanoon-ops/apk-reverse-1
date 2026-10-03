local ValentineSendActivityInfoMessage = BaseClass("ValentineSendActivityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ValentineSendActivityInfoMessage:OnCreate(activityId, fromType)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("fromType", fromType)
end

function ValentineSendActivityInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.activityId and t.newMutualFollow then
    DataCenter.ValentineDataManager:SetNewMutualFollow(t.activityId, t.newMutualFollow)
    EventManager:GetInstance():Broadcast(EventId.ValentineSendActRecInfo)
  end
end

return ValentineSendActivityInfoMessage
