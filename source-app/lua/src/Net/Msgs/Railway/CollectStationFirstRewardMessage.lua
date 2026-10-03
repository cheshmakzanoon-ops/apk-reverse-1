local CollectStationFirstReward = BaseClass("CollectStationFirstReward", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  if message.trainData then
    DataCenter.LWMyStationDataManager:OnFirstRewardGet(message.trainData)
  end
  if message.reward then
    DataCenter.RewardManager:AddRewardsAndRes(message)
    DataCenter.RewardManager:ShowCommonReward(message)
  end
end

CollectStationFirstReward.OnCreate = OnCreate
CollectStationFirstReward.HandleMessage = HandleMessage
return CollectStationFirstReward
