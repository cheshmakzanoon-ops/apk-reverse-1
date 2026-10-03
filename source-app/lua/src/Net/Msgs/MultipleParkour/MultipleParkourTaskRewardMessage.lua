local MultipleParkourTaskRewardMessage = BaseClass("MultipleParkourTaskRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function MultipleParkourTaskRewardMessage:OnCreate(activityId, taskId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(activityId))
  self.sfsObj:PutUtfString("taskId", tostring(taskId))
end

function MultipleParkourTaskRewardMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.MultipleParkourActivityManager:HandleTaskRewardMessage(message)
end

return MultipleParkourTaskRewardMessage
