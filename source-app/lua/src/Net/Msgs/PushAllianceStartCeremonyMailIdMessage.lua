local PushAllianceStartCeremonyMailIdMessage = BaseClass("PushAllianceStartCeremonyMailIdMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceStartCeremonyMailIdMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceStartCeremonyMailIdMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceStarManager:OnPushAllianceStartCeremonyMailId(t)
  end
end

return PushAllianceStartCeremonyMailIdMessage
