local ValentineFollowMatchListMessage = BaseClass("ValentineFollowMatchListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ValentineFollowMatchListMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function ValentineFollowMatchListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.playerArr ~= nil and t.activityId then
    DataCenter.ValentineDataManager:SetMatchList(t.activityId, t.playerArr)
    EventManager:GetInstance():Broadcast(EventId.ValentineOnRecMatchList)
  end
end

return ValentineFollowMatchListMessage
