local TakeSeasonVirusAchievementTaskMessage = BaseClass("TakeSeasonVirusAchievementTaskMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, id)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", id)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode ~= "E100172" then
      UIUtil.ShowTipsId(errCode)
    end
  elseif t.maxDamage ~= nil and t.activityId ~= nil then
    local actData = DataCenter.ActivityListDataManager:GetActivityDataById(t.activityId)
    if actData ~= nil and actData.type == EnumActivity.BossLogin.Type then
      DataCenter.LWSeasonBossLoginDataManager.maxDamage = t.maxDamage
      EventManager:GetInstance():Broadcast(EventId.OnActBossRewardRefresh, t.id, t.state)
      EventManager:GetInstance():Broadcast(EventId.SeasonVirusBossReddot)
      SFSNetwork.SendMessage(MsgDefines.GetSeasonVirusAchievementTaskInfo, tostring(t.activityId))
    end
    DataCenter.RewardManager:ShowCommonReward(t)
    DataCenter.RewardManager:AddRewardsAndRes(t)
  end
end

TakeSeasonVirusAchievementTaskMessage.OnCreate = OnCreate
TakeSeasonVirusAchievementTaskMessage.HandleMessage = HandleMessage
return TakeSeasonVirusAchievementTaskMessage
