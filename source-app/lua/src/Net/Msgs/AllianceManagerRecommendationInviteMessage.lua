local AllianceManagerRecommendationInviteMessage = BaseClass("AllianceManagerRecommendationInviteMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceManagerRecommendationInviteMessage:OnCreate(targetUid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetUid", targetUid)
end

function AllianceManagerRecommendationInviteMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIUtil.ShowTipsId("alliance_invite_tips_invited")
    EventManager:GetInstance():Broadcast(EventId.AllianceRecommendationInvite, t)
  end
end

return AllianceManagerRecommendationInviteMessage
