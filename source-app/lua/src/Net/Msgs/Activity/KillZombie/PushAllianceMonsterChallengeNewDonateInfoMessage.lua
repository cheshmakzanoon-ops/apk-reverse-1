local PushAllianceMonsterChallengeNewDonateInfoMessage = BaseClass("PushAllianceMonsterChallengeNewDonateInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceMonsterChallengeNewDonateInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceMonsterChallengeNewDonateInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityKillZombieManager:OnPushNewAllianceChallengeDonateInfo(t)
  end
end

return PushAllianceMonsterChallengeNewDonateInfoMessage
