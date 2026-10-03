local AlGetjoinmsgMessage = BaseClass("AlGetjoinmsgMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AlGetjoinmsgMessage:OnCreate(param)
  base.OnCreate(self)
end

function AlGetjoinmsgMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceMemberDataManager:SetNewJoinMembersInfo(t.joinMsgList or {})
  end
end

return AlGetjoinmsgMessage
