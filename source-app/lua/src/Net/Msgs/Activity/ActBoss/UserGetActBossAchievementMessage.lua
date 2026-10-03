local UserGetActBossAchievementMessage = BaseClass("UserGetActBossAchievementMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserGetActBossAchievementMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("activityId", activityId)
end

function UserGetActBossAchievementMessage:HandleMessage(t)
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
      for _, v in ipairs(t.tasks) do
        local taskInfo = DataCenter.ActBossDataManager:GetAchievementTaskData(v.id)
        if taskInfo ~= nil then
          taskInfo.state = v.state
          taskInfo.reward = v.reward
          if v.damageShowTime then
            taskInfo.damageShowTime = v.damageShowTime
          end
        end
      end
      EventManager:GetInstance():Broadcast(EventId.OnActBossRankRefresh)
    end
  end
end

return UserGetActBossAchievementMessage
