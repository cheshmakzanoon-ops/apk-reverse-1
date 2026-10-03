local ActCookingData = BaseClass("ActCookingData")
local ActivityFreeRewardData = require("DataCenter.ActivityFreeRewardData.ActivityFreeRewardData")

local function __init(self)
  self.activityId = 0
  self.actMakeFoodId = 0
  self.selfScore = 0
  self.scoreReward = {}
  self.scoreList = {}
  self.receiveReward = {}
  self.activityFreeRewardData = ActivityFreeRewardData.New()
end

local function __delete(self)
  self.activityId = nil
  self.actMakeFoodId = nil
  self.selfScore = nil
  self.scoreReward = nil
  self.receiveReward = nil
  self.activityFreeRewardData = nil
end

local function ParseInfo(self, message)
  if message == nil then
    return
  end
  if message.id then
    self.actMakeFoodId = message.id
  end
  if message.totalScore then
    self.selfScore = message.totalScore
  end
  table.clear(self.scoreReward)
  table.clear(self.scoreList)
  if message.score_reward then
    for i = 1, table.count(message.score_reward) do
      table.insert(self.scoreReward, message.score_reward[i].reward)
      table.insert(self.scoreList, message.score_reward[i].score)
    end
  end
  table.clear(self.receiveReward)
  if message.rewards then
    local strArray = string.split(message.rewards, ",")
    for i = 1, table.count(strArray) do
      table.insert(self.receiveReward, tonumber(strArray[i]))
    end
  end
  self.activityFreeRewardData:ParseData(message)
end

local function SetActivityId(self, id)
  self.activityId = tonumber(id)
end

local function GetActScore(self)
  return self.selfScore
end

local function GetActNextTargetScore(self)
  for k, v in ipairs(self.scoreList) do
    if v > self.selfScore then
      return v
    end
  end
end

local function GetActScoreList(self)
  local ret = {}
  for k, v in ipairs(self.scoreList) do
    local oneData = {}
    oneData.selfScore = self.selfScore
    oneData.targetScore = v
    oneData.state = table.hasvalue(self.receiveReward, v) and 1 or 0
    oneData.reward = self.scoreReward[k]
    table.insert(ret, oneData)
  end
  return ret
end

local function CanGotoPackShop(self)
  return self.activityFreeRewardData:CanGotoPackShop()
end

local function CanGetFreePack(self)
  return self.activityFreeRewardData:CanGetFreePack()
end

local function GetGiftPackId(self)
  return self.activityFreeRewardData:GetGiftPackId()
end

local function GetFreeRewardHandle(self, message)
  if message == nil then
    return
  end
  local rewards = message.rewards
  if rewards then
    DataCenter.RewardManager:AddRewards(rewards)
    DataCenter.RewardManager:ShowCommonReward({reward = rewards})
  end
  self.activityFreeRewardData:OnReceiveFreeReward()
  EventManager:GetInstance():Broadcast(EventId.ActFreeRewardReceive)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function GetScoreRewardHandle(self, message)
  if message == nil or message.id ~= self.actMakeFoodId or message.aid ~= self.activityId then
    return
  end
  local rewards = message.rewards
  if rewards then
    DataCenter.RewardManager:AddRewards(rewards)
    DataCenter.RewardManager:ShowCommonReward({reward = rewards})
  end
  if message.score then
    table.insert(self.receiveReward, message.score)
    table.sort(self.receiveReward)
  end
  EventManager:GetInstance():Broadcast(EventId.ActCookingScoreRewardReceive)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function GetCookingRewardHandle(self, message)
  if message == nil then
    return
  end
  if message.base_reward ~= nil then
    DataCenter.RewardManager:AddRewards(message.base_reward)
  end
  if message.extra1_reward ~= nil then
    DataCenter.RewardManager:AddRewards(message.extra1_reward)
  end
  if message.extra2_reward ~= nil then
    DataCenter.RewardManager:AddRewards(message.extra2_reward)
  end
  if message.totalScore ~= nil then
    self.selfScore = message.totalScore
  end
  EventManager:GetInstance():Broadcast(EventId.ActCookingFinished, message)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function GetActRed(self, id)
  local ret = 0
  local tipNum = 0
  local canMakeCount = math.maxinteger
  if self.actMakeFoodId ~= 0 then
    local template = DataCenter.ActivityMakeFoodTemplateManager:GetActCookingTemplate(self.actMakeFoodId)
    for k, v in pairs(template.costItemDic) do
      local itemId = v.itemId
      local costNum = v.costNum
      local haveCount = DataCenter.ItemData:GetItemCount(itemId)
      local canMakeItem = haveCount // costNum
      canMakeCount = math.min(canMakeCount, canMakeItem)
    end
    tipNum = tipNum + canMakeCount
  end
  if self:CanGetFreePack() then
    ret = ret + 1
  end
  ret = ret + self:GetCanGetScoreBoxCount()
  return ret + tipNum, ret, tipNum
end

local function GetCanGetScoreBoxCount(self)
  local ret = 0
  for k, v in ipairs(self.scoreList) do
    if v <= self.selfScore and not table.hasvalue(self.receiveReward, v) then
      ret = ret + 1
    end
  end
  return ret
end

ActCookingData.__init = __init
ActCookingData.__delete = __delete
ActCookingData.ParseInfo = ParseInfo
ActCookingData.GetActScore = GetActScore
ActCookingData.GetActNextTargetScore = GetActNextTargetScore
ActCookingData.GetActScoreList = GetActScoreList
ActCookingData.CanGotoPackShop = CanGotoPackShop
ActCookingData.CanGetFreePack = CanGetFreePack
ActCookingData.GetGiftPackId = GetGiftPackId
ActCookingData.GetFreeRewardHandle = GetFreeRewardHandle
ActCookingData.GetCookingRewardHandle = GetCookingRewardHandle
ActCookingData.GetScoreRewardHandle = GetScoreRewardHandle
ActCookingData.SetActivityId = SetActivityId
ActCookingData.GetActRed = GetActRed
ActCookingData.GetCanGetScoreBoxCount = GetCanGetScoreBoxCount
return ActCookingData
