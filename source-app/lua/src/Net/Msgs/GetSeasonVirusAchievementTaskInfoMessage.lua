local GetSeasonVirusAchievementTaskInfoMessage = BaseClass("GetSeasonVirusAchievementTaskInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("activityId", activityId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
  else
    local actBossTask = t["0"]
    local seasonBossTask = t["1"]
    if actBossTask ~= nil then
      DataCenter.ActBossDataManager.maxDamage = actBossTask.maxDamage
      DataCenter.ActBossDataManager.todayMaxDamage = actBossTask.todayMaxDamage
      for _, v in ipairs(actBossTask.tasks) do
        local taskInfo = DataCenter.ActBossDataManager:GetAchievementTaskData(v.id)
        if taskInfo ~= nil then
          taskInfo.state = v.state
          taskInfo.reward = v.reward
          if v.damageShowTime then
            taskInfo.damageShowTime = v.damageShowTime
          end
        end
      end
    end
    if seasonBossTask ~= nil then
      DataCenter.LWSeasonBossLoginDataManager.maxDamage = seasonBossTask.maxDamage
      DataCenter.LWSeasonBossLoginDataManager.todayMaxDamage = seasonBossTask.todayMaxDamage
      for _, v in ipairs(seasonBossTask.tasks) do
        local taskInfo = DataCenter.LWSeasonBossLoginDataManager:GetAchievementTaskData(v.id)
        if taskInfo ~= nil then
          taskInfo.state = v.state
          taskInfo.reward = v.reward
          if v.damageShowTime then
            taskInfo.damageShowTime = v.damageShowTime
          end
        end
      end
    end
    EventManager:GetInstance():Broadcast(EventId.SeasonVirusBossAchievementRefresh)
  end
end

GetSeasonVirusAchievementTaskInfoMessage.OnCreate = OnCreate
GetSeasonVirusAchievementTaskInfoMessage.HandleMessage = HandleMessage
return GetSeasonVirusAchievementTaskInfoMessage
