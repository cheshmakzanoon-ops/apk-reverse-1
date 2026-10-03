local PushAllianceBloodNightTaskarrMessage = BaseClass("PushAllianceBloodNightTaskarrMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceBloodNightTaskarrMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BloodyNightDataManager:OnPushTask(t.allianceBloodNightTaskArr)
  end
end

return PushAllianceBloodNightTaskarrMessage
