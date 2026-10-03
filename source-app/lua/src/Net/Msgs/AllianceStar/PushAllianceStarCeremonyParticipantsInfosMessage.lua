local PushAllianceStarCeremonyParticipantsInfosMessage = BaseClass("PushAllianceStarCeremonyParticipantsInfosMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceStarCeremonyParticipantsInfosMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceStarCeremonyParticipantsInfosMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceStarManager:OnPushAllianceStarCeremonyParticipantsInfos(t)
  end
end

return PushAllianceStarCeremonyParticipantsInfosMessage
