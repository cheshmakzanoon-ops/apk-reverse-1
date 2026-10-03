local IdleGameChallengeMessage = BaseClass("IdleGameChallengeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function IdleGameChallengeMessage:OnCreate(bossId)
  base.OnCreate(self)
  self.sfsObj:PutInt("bossId", bossId)
end

function IdleGameChallengeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.T11IdleGameDataManager:OnChallengeBossMessage(t)
  end
end

return IdleGameChallengeMessage
