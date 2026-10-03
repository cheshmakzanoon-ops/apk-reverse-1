local UserGetActBossAchievementRewardMessage = BaseClass("UserGetActBossAchievementRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserGetActBossAchievementRewardMessage:OnCreate(activityId, taskId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("activityId", activityId)
  self.sfsObj:PutInt("id", taskId)
end

function UserGetActBossAchievementRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode ~= "E100172" then
      UIUtil.ShowTipsId(errCode)
    end
  elseif t.maxDamage ~= nil and t.activityId ~= nil then
    local actData = DataCenter.ActivityListDataManager:GetActivityDataById(t.activityId)
    if actData ~= nil and actData.type == EnumActivity.WorldBoss.Type then
      DataCenter.ActBossDataManager.maxDamage = t.maxDamage
      EventManager:GetInstance():Broadcast(EventId.OnActBossRewardRefresh, t.id, t.state)
      EventManager:GetInstance():Broadcast(EventId.SeasonVirusBossReddot)
      SFSNetwork.SendMessage(MsgDefines.UserGetActBossAchievement, tostring(t.activityId))
    end
    DataCenter.RewardManager:ShowCommonReward(t)
    DataCenter.RewardManager:AddRewardsAndRes(t)
  end
end

return UserGetActBossAchievementRewardMessage
