local CollectTrainRewardMessage = BaseClass("CollectTrainRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  if message.trainData then
    DataCenter.LWMyStationDataManager:OnRewardCollected(message.trainData)
  end
  if message.reward then
    DataCenter.RewardManager:AddRewardsAndRes(message)
    DataCenter.RewardManager:ShowCommonReward(message)
  end
end

CollectTrainRewardMessage.OnCreate = OnCreate
CollectTrainRewardMessage.HandleMessage = HandleMessage
return CollectTrainRewardMessage
