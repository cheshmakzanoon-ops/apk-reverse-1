local PushAllianceJoinWelcomeMsgMessage = BaseClass("PushAllianceJoinWelcomeMsgMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceJoinWelcomeMsgMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceJoinWelcomeMsgMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceMemberDataManager:SetNewJoinMembersInfo({t})
  end
end

return PushAllianceJoinWelcomeMsgMessage
