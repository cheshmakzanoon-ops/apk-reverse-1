local ViewSeasonPreTaskMessage = BaseClass("ViewSeasonPreTaskMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ViewSeasonPreTaskMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("activityId", activityId)
end

function ViewSeasonPreTaskMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonPreviewManager:HandlePreTaskData(t)
  end
end

return ViewSeasonPreTaskMessage
