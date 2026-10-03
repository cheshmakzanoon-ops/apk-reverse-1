local ActivityFreeRewardData = BaseClass("ActivityFreeRewardData")

local function __init(self)
  self.activityId = 0
  self.freeRewardState = 0
  self.freeReward = {}
  self.lastReceiveFreeTime = 0
  self.rewardPackGroupId = 0
  self.nextRefreshTime = 0
end

local function __delete(self)
  self.activityId = nil
  self.freeRewardState = nil
  self.freeReward = nil
  self.lastReceiveFreeTime = nil
  self.rewardPackGroupId = nil
  self.nextRefreshTime = nil
end

local function CanGetFreePack(self)
  if self.freeRewardState then
    return self.freeRewardState == 0
  end
end

local function CanGotoPackShop(self)
  local canGetFreePack = self:CanGetFreePack()
  if canGetFreePack then
    return true
  end
  local packs = GiftPackManager.GetPacksByGroupId(self.rewardPackGroupId, false)
  return not table.IsNullOrEmpty(packs)
end

local function ParseData(self, param)
  if param.free_reward then
    self.freeRewardState = param.free_reward
  end
  if param.freeReward then
    self.freeRewardState = param.freeReward
  end
  if param.free then
    self.freeRewardState = param.free
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.freeRewardState == 0 then
    self.lastReceiveFreeTime = curTime - 86400000
  elseif self.freeRewardState == 1 then
    self.lastReceiveFreeTime = curTime
  end
  if param.boxExchange then
    self.rewardPackGroupId = param.boxExchange
  end
  if param.boxReward then
    self.freeReward = DataCenter.RewardManager:ReturnRewardParamForView(param.boxReward)
  end
  local isSkipSetFreeDataFromRewrdData = false
  local activityId = param.activityId
  if activityId then
    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
    if activityData and activityData.type == EnumActivity.GiftBoxActivity.Type then
      isSkipSetFreeDataFromRewrdData = true
    end
  end
  if param.exchange_para then
    self.rewardPackGroupId = param.exchange_para
  end
  if param.reward and not isSkipSetFreeDataFromRewrdData then
    self.freeReward = DataCenter.RewardManager:ReturnRewardParamForView(param.reward)
  end
  if param.box_exchange then
    self.rewardPackGroupId = param.box_exchange
  end
  if param.box_reward then
    self.freeReward = DataCenter.RewardManager:ReturnRewardParamForView(param.box_reward)
  end
  if param.box_exchange then
    self.rewardPackGroupId = param.box_exchange
  end
  if param.free_reward then
    self.freeReward = DataCenter.RewardManager:ReturnRewardParamForView(param.free_reward)
  end
end

local function OnReceiveFreeReward(self)
  self.freeRewardState = 1
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.lastReceiveFreeTime = curTime
end

local function GetGiftPackId(self)
  return self.rewardPackGroupId
end

ActivityFreeRewardData.__init = __init
ActivityFreeRewardData.__delete = __delete
ActivityFreeRewardData.CanGetFreePack = CanGetFreePack
ActivityFreeRewardData.CanGotoPackShop = CanGotoPackShop
ActivityFreeRewardData.ParseData = ParseData
ActivityFreeRewardData.OnReceiveFreeReward = OnReceiveFreeReward
ActivityFreeRewardData.GetGiftPackId = GetGiftPackId
return ActivityFreeRewardData
