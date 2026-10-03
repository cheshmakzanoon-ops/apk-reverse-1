local ActSeasonWeekCardInfo = BaseClass("ActSeasonWeekCardInfo")

local function __init(self)
  self.activityId = 0
  self.freeReward = {}
  self.reward = {}
  self.exchangeId = ""
  self.cardInfo = {}
end

local function __delete(self)
end

local function ParseActInfo(self, message)
  if message == nil then
    return
  end
  if message.activityId then
    self.activityId = message.activityId
  end
  if message.freeReward then
    self.freeReward = DataCenter.RewardManager:ReturnRewardParamForView(message.freeReward)
  end
  if message.reward then
    self.reward = DataCenter.RewardManager:ReturnRewardParamForView(message.reward)
  end
  if message.exchangeId then
    self.exchangeId = message.exchangeId
  end
  if message.cardInfo then
    self.cardInfo = {}
    self.cardInfo.startTime = message.cardInfo.startTime
    self.cardInfo.endTime = message.cardInfo.endTime
    self.cardInfo.lastReceiveFreeTime = message.cardInfo.lastReceiveFreeTime
    self.cardInfo.lastReceiveTime = message.cardInfo.lastReceiveTime
  end
end

local function UpdateTime(self, message)
  if message == nil then
    return
  end
  if message.lastReceiveFreeTime then
    self.cardInfo.lastReceiveFreeTime = message.lastReceiveFreeTime
  end
  if message.lastReceiveTime then
    self.cardInfo.lastReceiveTime = message.lastReceiveTime
  end
end

local function GetActRed(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local count = 0
  if self.cardInfo and next(self.cardInfo) then
    if self.cardInfo.lastReceiveFreeTime == 0 then
      count = count + 1
    elseif not UITimeManager:GetInstance():IsSameDayForServer(curTime // 1000, self.cardInfo.lastReceiveFreeTime // 1000) then
      count = count + 1
    end
    if self.cardInfo.endTime and self.cardInfo.endTime ~= 0 and curTime < self.cardInfo.endTime and not UITimeManager:GetInstance():IsSameDayForServer(curTime // 1000, self.cardInfo.lastReceiveTime // 1000) then
      count = count + 1
    end
    return count
  end
  return 1
end

ActSeasonWeekCardInfo.__init = __init
ActSeasonWeekCardInfo.__delete = __delete
ActSeasonWeekCardInfo.ParseActInfo = ParseActInfo
ActSeasonWeekCardInfo.UpdateTime = UpdateTime
ActSeasonWeekCardInfo.GetActRed = GetActRed
return ActSeasonWeekCardInfo
