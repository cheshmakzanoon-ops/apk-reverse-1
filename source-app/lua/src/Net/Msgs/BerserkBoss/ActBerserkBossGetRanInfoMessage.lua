local ActBerserkBossGetRanInfoMessage = BaseClass("PushActBerserkBossUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ActBerserkBossGetRanInfoMessage:OnCreate(type, bossUuid, rankStart, rankEnd)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutLong("uuid", bossUuid)
  self.sfsObj:PutInt("start", rankStart)
  self.sfsObj:PutInt("end", rankEnd)
end

function ActBerserkBossGetRanInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWBerserkBossManager:HandleRefreshBerserkBossRankInfo(message)
  end
end

return ActBerserkBossGetRanInfoMessage
