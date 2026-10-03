local FrontBreakSundayRewardMessage = BaseClass("FrontBreakSundayRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function FrontBreakSundayRewardMessage:OnCreate(activityId, taskId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(activityId))
  self.sfsObj:PutUtfString("taskId", tostring(taskId))
end

function FrontBreakSundayRewardMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.ActFrontBreakSundayDataManager:HandleTaskRewardMessage(message)
end

return FrontBreakSundayRewardMessage
