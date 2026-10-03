local SeasonPhotoTaskGetRewardMessage = BaseClass("SeasonPhotoTaskGetRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonPhotoTaskGetRewardMessage:OnCreate(activityId, taskId_)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("taskId", taskId_ or -1)
end

function SeasonPhotoTaskGetRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if table.IsNullOrEmpty(t.reward) and table.IsNullOrEmpty(t.resource) and table.IsNullOrEmpty(t.photoTaskArr) then
    return
  end
  if t.reward or t.resource then
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.RewardManager:ShowCommonReward(t)
  end
  if t.photoTaskInfo then
    t.photoTaskInfo.reward = DataCenter.RewardManager:ReturnRewardParamForView(t.photoTaskInfo.reward)
    DataCenter.SeasonPhotoManager:UpdateReward(t.photoTaskInfo)
  end
  if t.photoTaskArr then
    for i, v in ipairs(t.photoTaskArr) do
      v.reward = DataCenter.RewardManager:ReturnRewardParamForView(v.reward)
    end
    DataCenter.SeasonPhotoManager:UpdateRewardList(t.photoTaskArr)
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonPhotoTaskListUpdate)
end

return SeasonPhotoTaskGetRewardMessage
