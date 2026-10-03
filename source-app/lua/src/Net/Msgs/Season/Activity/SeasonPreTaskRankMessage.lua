local SeasonPreTaskRankMessage = BaseClass("SeasonPreTaskRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonPreTaskRankMessage:OnCreate(activityId, taskId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("activityId", activityId)
  self.sfsObj:PutUtfString("taskId", taskId)
end

function SeasonPreTaskRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonPreviewManager:HandleRankData(t)
  end
end

return SeasonPreTaskRankMessage
