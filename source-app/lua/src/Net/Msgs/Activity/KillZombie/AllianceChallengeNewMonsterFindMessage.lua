local AllianceChallengeNewMonsterFindMessage = BaseClass("AllianceChallengeNewMonsterFindMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceChallengeNewMonsterFindMessage:OnCreate(bossUid, pointId, extraInfo)
  base.OnCreate(self)
  self.sfsObj:PutLong("bossUid", bossUid)
  self.sfsObj:PutInt("pointId", pointId)
  self.sfsObj:PutUtfString("extraInfo", extraInfo)
end

function AllianceChallengeNewMonsterFindMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
end

return AllianceChallengeNewMonsterFindMessage
