local PushAllianceStarCeremonyInteractionInfoMessage = BaseClass("PushAllianceStarCeremonyInteractionInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceStarCeremonyInteractionInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceStarCeremonyInteractionInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceStarManager:OnPushAllianceStarCeremonyInteractionInfo(t)
  end
end

return PushAllianceStarCeremonyInteractionInfoMessage
