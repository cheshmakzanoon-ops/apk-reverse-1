local ActivityHeroScoreRewardMessage = BaseClass("ActivityHeroScoreRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("aid", activityId)
  self.sfsObj:PutInt("index", index)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityPersonalArmsDataManager:ScoreRewardGet(t)
    EventManager:GetInstance():Broadcast(EventId.ActivityPersonalArmsScoreReward, t.aid)
  end
end

ActivityHeroScoreRewardMessage.OnCreate = OnCreate
ActivityHeroScoreRewardMessage.HandleMessage = HandleMessage
return ActivityHeroScoreRewardMessage
