local HeroMonthCardData = BaseClass("HeroMonthCardData")

local function __init(self)
  self.activityId = 0
  self.startTime = 0
  self.endTime = 0
  self.exchangeId = nil
  self.buy = BuyFlag.NOT_BUY
  self.rewardArr = {}
  self.groupId = 0
end

local function __delete(self)
end

local function ParseData(self, message)
  if message.activityId ~= nil then
    self.activityId = message.activityId
  end
  if message.startTime ~= nil then
    self.startTime = message.startTime
  end
  if message.endTime ~= nil then
    self.endTime = message.endTime
  end
  if message.buy ~= nil then
    self.buy = message.buy
  end
  if message.exchangeId ~= nil then
    self.exchangeId = message.exchangeId
  end
  if message.rewardArr ~= nil then
    self.rewardArr = message.rewardArr
    table.walk(self.rewardArr, function(_, v)
      v.reward = DataCenter.RewardManager:ReturnRewardParamForView(v.reward)
    end)
    table.sort(self.rewardArr, function(k, v)
      return k.day < v.day
    end)
  end
  if message.group ~= nil then
    self.groupId = message.group
  end
end

local function IsActive(self)
  if self.buy ~= BuyFlag.BUY then
    return false
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  return self.endTime ~= nil and now <= self.endTime
end

local function GetReward(self, day)
  if self.rewardArr ~= nil and day <= table.count(self.rewardArr) then
    return self.rewardArr[day]
  end
  return nil
end

local function SetRewardState(self, day, state)
  if self.rewardArr ~= nil and day <= table.count(self.rewardArr) then
    self.rewardArr[day].state = state
  end
end

HeroMonthCardData.__init = __init
HeroMonthCardData.__delete = __delete
HeroMonthCardData.ParseData = ParseData
HeroMonthCardData.IsActive = IsActive
HeroMonthCardData.GetReward = GetReward
HeroMonthCardData.SetRewardState = SetRewardState
return HeroMonthCardData
