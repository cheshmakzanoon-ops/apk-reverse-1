local AllianceManagerRecommendationReceivedInviteMessage = BaseClass("AllianceManagerRecommendationReceivedInviteMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceManagerRecommendationReceivedInviteMessage:OnCreate(inviteUid, inviteAllianceId, seqId, roomId, isAgree)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("inviteUid", inviteUid)
  self.sfsObj:PutUtfString("inviteAllianceId", inviteAllianceId)
  self.sfsObj:PutLong("seqId", seqId)
  self.sfsObj:PutUtfString("roomId", roomId)
  self.sfsObj:PutBool("isAgree", isAgree)
end

function AllianceManagerRecommendationReceivedInviteMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.inviteAllianceId and t.inviteAllianceId == LuaEntry.Player.allianceId then
    DataCenter.AllianceBaseDataManager:Coalize()
  end
end

return AllianceManagerRecommendationReceivedInviteMessage
