local ValentineFollowListMessage = BaseClass("ValentineFollowListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ValentineFollowListMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", param.activityId)
end

function ValentineFollowListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ValentineDataManager:ParseMatchSuccessListData(t)
    EventManager:GetInstance():Broadcast(EventId.RefreshValentineMatchSuccessList)
  end
end

return ValentineFollowListMessage
