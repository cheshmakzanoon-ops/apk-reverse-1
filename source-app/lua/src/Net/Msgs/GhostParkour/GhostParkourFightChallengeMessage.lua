local GhostParkourFightChallengeMessage = BaseClass("GhostParkourFightChallengeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GhostParkourFightChallengeMessage:OnCreate(challengeUid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("challengeUid", challengeUid)
end

function GhostParkourFightChallengeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWGhostParkourDataManager:FightStartCheck(t)
  end
end

return GhostParkourFightChallengeMessage
