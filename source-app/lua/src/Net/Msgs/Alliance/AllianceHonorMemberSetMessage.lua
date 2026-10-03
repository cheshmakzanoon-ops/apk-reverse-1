local AllianceHonorMemberSetMessage = BaseClass("AllianceHonorMemberSetMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceHonorMemberSetMessage:OnCreate(targetUid, isHonorMember)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetUid", targetUid)
  self.sfsObj:PutBool("isHonorMember", isHonorMember)
end

function AllianceHonorMemberSetMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceMemberDataManager:RefreshMemberHonorState(t)
    if t.isHonorMember then
      UIUtil.ShowTipsId("alliance_member_tips_royalMemberOn")
    else
      UIUtil.ShowTipsId("alliance_member_tips_royalMemberOff")
    end
  end
end

return AllianceHonorMemberSetMessage
