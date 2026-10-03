local PushAllianceStarCeremonyPlanInfoMessage = BaseClass("PushAllianceStarCeremonyPlanInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceStarCeremonyPlanInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceStarCeremonyPlanInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceStarManager:OnPushAllianceStarCeremonyPlanInfoMessage(t)
  end
end

return PushAllianceStarCeremonyPlanInfoMessage
