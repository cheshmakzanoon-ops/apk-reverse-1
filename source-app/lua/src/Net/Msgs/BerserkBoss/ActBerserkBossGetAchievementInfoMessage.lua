local ActBerserkBossGetAchievementInfoMessage = BaseClass("UserGetAllBerserkBossMarchMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ActBerserkBossGetAchievementInfoMessage:OnCreate(activityId, bossUuid)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutLong("uuid", bossUuid)
end

function ActBerserkBossGetAchievementInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  DataCenter.LWBerserkBossManager:HandleRefreshBerserkBossAchievementRewardInfo(message)
end

return ActBerserkBossGetAchievementInfoMessage
