local HeroExperimentRewardMessage = BaseClass("HeroExperimentRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.reward ~= nil then
    DataCenter.RewardManager:AddRewardsAndRes(t)
    EventManager:GetInstance():Broadcast(EventId.OnHeroTrialRewardGet, t)
  end
end

HeroExperimentRewardMessage.OnCreate = OnCreate
HeroExperimentRewardMessage.HandleMessage = HandleMessage
return HeroExperimentRewardMessage
