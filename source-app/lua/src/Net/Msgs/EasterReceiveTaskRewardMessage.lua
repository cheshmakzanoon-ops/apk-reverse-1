local EasterReceiveTaskRewardMessage = BaseClass("EasterReceiveTaskRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EasterReceiveTaskRewardMessage:OnCreate(activityId, taskId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(activityId))
  self.sfsObj:PutUtfString("taskId", tostring(taskId))
end

function EasterReceiveTaskRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActEasterEggTaskManager:OnTaskGetReward(t)
  end
end

return EasterReceiveTaskRewardMessage
