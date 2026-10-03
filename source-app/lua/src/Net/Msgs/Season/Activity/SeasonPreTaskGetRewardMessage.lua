local SeasonPreTaskGetRewardMessage = BaseClass("SeasonPreTaskGetRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonPreTaskGetRewardMessage:OnCreate(activityId, taskId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("activityId", tostring(activityId))
  self.sfsObj:PutUtfString("taskId", tostring(taskId))
end

function SeasonPreTaskGetRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonPreviewManager:HandleRewardData(t)
  end
end

return SeasonPreTaskGetRewardMessage
