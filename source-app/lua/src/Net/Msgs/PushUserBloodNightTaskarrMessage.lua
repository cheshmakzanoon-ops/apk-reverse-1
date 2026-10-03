local PushUserBloodNightTaskarrMessage = BaseClass("PushUserBloodNightTaskarrMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushUserBloodNightTaskarrMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BloodyNightDataManager:OnPushTask(t.userBloodNightTaskArr)
  end
end

return PushUserBloodNightTaskarrMessage
