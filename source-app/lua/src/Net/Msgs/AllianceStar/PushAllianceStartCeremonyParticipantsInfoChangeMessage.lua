local PushAllianceStartCeremonyParticipantsInfoChangeMessage = BaseClass("PushAllianceStartCeremonyParticipantsInfoChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceStartCeremonyParticipantsInfoChangeMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceStartCeremonyParticipantsInfoChangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceStarManager:OnPushAllianceStartCeremonyParticipantsInfoChange(t)
  end
end

return PushAllianceStartCeremonyParticipantsInfoChangeMessage
