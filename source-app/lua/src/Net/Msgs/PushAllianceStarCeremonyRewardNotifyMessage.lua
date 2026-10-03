local PushAllianceStarCeremonyRewardNotifyMessage = BaseClass("PushAllianceStarCeremonyRewardNotifyMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceStarCeremonyRewardNotifyMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceStarCeremonyRewardNotifyMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceStarManager:OnPushAllianceStarCeremonyRewardNotify(t)
  end
end

return PushAllianceStarCeremonyRewardNotifyMessage
