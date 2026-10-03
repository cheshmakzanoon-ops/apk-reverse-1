local MusicReceiveTaskRewardMessage = BaseClass("MusicReceiveTaskRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MusicReceiveTaskRewardMessage:OnCreate(activityId, taskId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("taskId", taskId)
end

function MusicReceiveTaskRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActCrazyRockTaskManager:OnTaskGetReward(t)
  end
end

return MusicReceiveTaskRewardMessage
