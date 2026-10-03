local ViewSeasonPhotoTasklistMessage = BaseClass("ViewSeasonPhotoTasklistMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ViewSeasonPhotoTasklistMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId or DataCenter.SeasonPhotoManager.activityId)
end

function ViewSeasonPhotoTasklistMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.photoTaskArr then
    for i, v in ipairs(t.photoTaskArr) do
      v.reward = DataCenter.RewardManager:ReturnRewardParamForView(v.reward)
    end
    DataCenter.SeasonPhotoManager.taskList = t.photoTaskArr
    DataCenter.SeasonPhotoManager:UpdateReward()
    EventManager:GetInstance():Broadcast(EventId.SeasonPhotoTaskListUpdate, t.activityId)
  end
end

return ViewSeasonPhotoTasklistMessage
