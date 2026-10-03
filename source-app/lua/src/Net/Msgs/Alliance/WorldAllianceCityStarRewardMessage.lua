local WorldAllianceCityStarRewardMessage = BaseClass("WorldAllianceCityStarRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, cityId, uuid)
  base.OnCreate(self)
  self.sfsObj:PutInt("cityId", cityId)
  if uuid then
    self.sfsObj:PutLong("uuid", uuid)
  end
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif message.reward then
    DataCenter.RewardManager:AddRewardsAndRes(message)
    DataCenter.RewardManager:ShowCommonReward(message)
  end
end

WorldAllianceCityStarRewardMessage.OnCreate = OnCreate
WorldAllianceCityStarRewardMessage.HandleMessage = HandleMessage
return WorldAllianceCityStarRewardMessage
