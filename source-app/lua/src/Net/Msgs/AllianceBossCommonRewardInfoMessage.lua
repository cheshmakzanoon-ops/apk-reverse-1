local AllianceBossCommonRewardInfoMessage = BaseClass("AllianceBossCommonRewardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceBossCommonRewardInfoMessage:OnCreate(serverId, bossType)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("bossType", bossType or AllyDrillBoss.RoadHog)
end

function AllianceBossCommonRewardInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllyDrillDataManager:RecMsgAllianceBossRewardInfo(t)
  end
end

return AllianceBossCommonRewardInfoMessage
