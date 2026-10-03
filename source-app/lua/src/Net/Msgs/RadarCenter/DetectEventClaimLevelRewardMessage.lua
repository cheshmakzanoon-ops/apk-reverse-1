local DetectEventClaimLevelRewardMessage = BaseClass("DetectEventClaimLevelRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, rewardLevel)
  base.OnCreate(self)
  self.sfsObj:PutInt("rewardLevel", rewardLevel)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RadarCenterDataManager:GetClaimLevelReward(t)
    EventManager:GetInstance():Broadcast(EventId.DetectInfoChangeClaimLevelReward, t)
  end
end

DetectEventClaimLevelRewardMessage.OnCreate = OnCreate
DetectEventClaimLevelRewardMessage.HandleMessage = HandleMessage
return DetectEventClaimLevelRewardMessage
