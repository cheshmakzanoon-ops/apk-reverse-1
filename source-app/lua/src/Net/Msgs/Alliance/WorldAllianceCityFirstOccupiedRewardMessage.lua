local WorldAllianceCityFirstOccupiedRewardMessage = BaseClass("WorldAllianceCityFirstOccupiedRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, cityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("cityId", cityId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.reward then
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.RewardManager:ShowCommonReward(t)
  end
end

WorldAllianceCityFirstOccupiedRewardMessage.OnCreate = OnCreate
WorldAllianceCityFirstOccupiedRewardMessage.HandleMessage = HandleMessage
return WorldAllianceCityFirstOccupiedRewardMessage
