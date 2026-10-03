local PushAllianceStarCeremonyInfoMessage = BaseClass("PushAllianceStarCeremonyInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceStarCeremonyInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceStarCeremonyInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceStarManager:UploadServerLog("PushAllianceStarCeremonyInfoMessage")
    DataCenter.AllianceStarManager:OnPushAllianceStarCeremonyInfoMessage(t)
  end
end

return PushAllianceStarCeremonyInfoMessage
