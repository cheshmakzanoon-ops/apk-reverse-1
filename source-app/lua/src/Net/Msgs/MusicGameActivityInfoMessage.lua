local MusicGameActivityInfoMessage = BaseClass("MusicGameActivityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MusicGameActivityInfoMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function MusicGameActivityInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActCrazyRockDataManager:UpdateActInfo(t)
  end
end

return MusicGameActivityInfoMessage
