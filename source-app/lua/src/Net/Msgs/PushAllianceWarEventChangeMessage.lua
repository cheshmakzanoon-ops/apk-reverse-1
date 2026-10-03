local PushAllianceWarEventChangeMessage = BaseClass("PushAllianceWarEventChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceWarEventChangeMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceWarEventChangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  Logger.LogInfo("PushAllianceWarEventChangeMessage " .. t.type)
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceWarEventDataManager:HandlePushAllianceWarEventChangeMessage(t)
  end
end

return PushAllianceWarEventChangeMessage
