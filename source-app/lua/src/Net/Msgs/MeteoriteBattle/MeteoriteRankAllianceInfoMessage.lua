local MeteoriteRankAllianceInfoMessage = BaseClass("MeteoriteRankAllianceInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MeteoriteRankAllianceInfoMessage:OnCreate(grabTimes, sRank, count)
  base.OnCreate(self)
  self.sfsObj:PutInt("grabTimes", grabTimes)
  self.sfsObj:PutInt("startRank", sRank or 1)
  self.sfsObj:PutInt("count", count or 100)
end

function MeteoriteRankAllianceInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActMeteoriteBattleManager:OnHandleRankInfo(t, false)
end

return MeteoriteRankAllianceInfoMessage
