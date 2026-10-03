local ActLuckyRollInfo = BaseClass("ActLuckyRollInfo")

local function __init(self)
  self.activityId = ""
  self.list = {}
  self.curGetReward = {}
end

local function __delete(self)
  self.activityId = ""
  self.list = nil
  self.curGetReward = nil
end

local function SetActivityId(self, id)
  self.list[tonumber(id)] = {}
end

local function ParseEventData(self, message)
  if message == nil then
    return
  end
  if self.list[message.activityId] then
    if message.rollInfo then
      local rollInfo = message.rollInfo
      local param = {}
      param.fiveLotteryCount = rollInfo.tenLotteryCount
      param.lastResetTime = rollInfo.lastResetTime
      param.oneLotteryCount = rollInfo.oneLotteryCount
      param.totalLotteryCount = rollInfo.totalLotteryCount
      self.list[message.activityId].rollInfo = param
      self.list[message.activityId].lastReceiveFreeTime = rollInfo.lastReceiveFreeTime
    end
    if message.rollItemArr then
      local rollItemArr = message.rollItemArr
      local param = {}
      for i = 1, #rollItemArr do
        param[i] = {}
        param[i].chooseIndex = rollItemArr[i].chooseIndex
        param[i].itemId = rollItemArr[i].itemId
        param[i].position = rollItemArr[i].position
        param[i].type = rollItemArr[i].type
        param[i].needhero = rollItemArr[i].goods_needhero
        param[i].reward = {}
        if rollItemArr[i].type == 0 then
          local reward = DataCenter.RewardManager:ReturnRewardParamForView(rollItemArr[i].reward)
          if not table.IsNullOrEmpty(reward) then
            table.insert(param[i].reward, reward[1])
          end
        else
          local str = string.split(rollItemArr[i].reward, "|")
          for k = 1, #str do
            param[i].reward[k] = {}
            local rewardArr = string.split(str[k], ";")
            param[i].reward[k].itemId = rewardArr[1]
            param[i].reward[k].count = rewardArr[2]
          end
        end
      end
      self.list[message.activityId].rollItemArr = param
    end
    if message.stageArr then
      local stageArr = message.stageArr
      local param = {}
      for i = 1, #stageArr do
        param[i] = {}
        param[i].needLotteryNum = stageArr[i].needLotteryNum
        param[i].stage = stageArr[i].stage
        param[i].state = stageArr[i].state
        param[i].reward = {}
        param[i].reward = DataCenter.RewardManager:ReturnRewardParamForView(stageArr[i].reward)
      end
      self.list[message.activityId].stageArr = param
    end
    self.list[message.activityId].activityId = message.activityId
    self.list[message.activityId].drawMax = message.draw_max
    local costItemStr = string.split(message.cost_item, ";")
    local cost1Str = string.split(message.cost_1, ";")
    local cost2Str = string.split(message.cost_10, ";")
    self.list[message.activityId].cost_1 = {}
    for i = 1, #cost1Str do
      self.list[message.activityId].cost_1[i] = tonumber(cost1Str[i])
    end
    self.list[message.activityId].cost_5 = {}
    for i = 1, #cost2Str do
      self.list[message.activityId].cost_5[i] = tonumber(cost2Str[i])
    end
    self.list[message.activityId].cost_item = message.cost_item
    self.list[message.activityId].freeReward = DataCenter.RewardManager:ReturnRewardParamForView(message.Lucky_roulette_reward)
    self.list[message.activityId].gfitPackGroupId = message.Lucky_roulette_exchange
    self.list[message.activityId].heroShowId = message.hero_show or 0
  end
end

local function GetCurStage(self, activityId)
  if self.list[activityId] then
    local data = self.list[activityId]
    for i = 1, #data.stageArr do
      if data.stageArr[i].state == 0 then
        return data.stageArr[i].stage
      end
    end
    if table.IsNullOrEmpty(data.stageArr) then
      return 0
    end
    return data.stageArr[#data.stageArr].stage
  end
end

local function GetInfoByActId(self, activityId)
  if self.list[activityId] then
    return self.list[activityId]
  end
  return nil
end

local function ChooseItemHandle(self, message)
  if self.list[message.activityId] then
    for i = 1, #self.list[message.activityId].rollItemArr do
      if message.itemId == self.list[message.activityId].rollItemArr[i].itemId then
        self.list[message.activityId].rollItemArr[i].chooseIndex = message.chooseIndex
      end
    end
  end
end

local function UpdateRollInfo(self, message)
  DataCenter.RewardManager:AddRewardsAndRes(message)
  if self.list[message.activityId] and message.rollInfo then
    local rollInfo = message.rollInfo
    self.list[message.activityId].rollInfo.fiveLotteryCount = rollInfo.tenLotteryCount
    self.list[message.activityId].rollInfo.lastResetTime = rollInfo.lastResetTime
    self.list[message.activityId].rollInfo.oneLotteryCount = rollInfo.oneLotteryCount
    self.list[message.activityId].rollInfo.totalLotteryCount = rollInfo.totalLotteryCount
    self.list[message.activityId].lastReceiveFreeTime = rollInfo.lastReceiveFreeTime
  end
  if message.gold then
    LuaEntry.Player.gold = message.gold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  if message.lotteryItems then
    self.curGetReward = message.lotteryItems
  end
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function UpdateStage(self, message)
  if self.list[message.activityId] then
    DataCenter.RewardManager:ShowCommonReward(message)
    self:UpdateRollInfo(message)
    self.list[message.activityId].stageArr[message.stage].state = 1
    EventManager:GetInstance():Broadcast(EventId.ActLuckyRollUpdate)
  end
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function GetCurRewardIndex(self)
  return self.curGetReward
end

local function GetLuckyRollRed(self, id)
  local count = 0
  local tipCount = 0
  local data = self:GetInfoByActId(id)
  if next(data) and data.cost_1[data.rollInfo.oneLotteryCount + 1] and data.cost_1[data.rollInfo.oneLotteryCount + 1] == 0 then
    tipCount = tipCount + 1
  end
  return count + tipCount, count, tipCount
end

local function CanGetFreePack(self, actId)
  local data = self:GetInfoByActId(actId)
  if data then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local lastTime = data.lastReceiveFreeTime
    local canGet = not UITimeManager:GetInstance():IsSameDayForServer(lastTime / 1000, curTime)
    return canGet
  end
  return false
end

local function CanGotoPackShop(self, actId)
  local data = self:GetInfoByActId(actId)
  if data then
    local canGetFreePack = self:CanGetFreePack(actId)
    if canGetFreePack then
      return true
    end
    local packs = GiftPackManager.GetPacksByGroupId(data.gfitPackGroupId, false)
    return not table.IsNullOrEmpty(packs)
  end
  return false
end

ActLuckyRollInfo.__init = __init
ActLuckyRollInfo.__delete = __delete
ActLuckyRollInfo.SetActivityId = SetActivityId
ActLuckyRollInfo.ParseEventData = ParseEventData
ActLuckyRollInfo.GetCurStage = GetCurStage
ActLuckyRollInfo.GetInfoByActId = GetInfoByActId
ActLuckyRollInfo.UpdateRollInfo = UpdateRollInfo
ActLuckyRollInfo.UpdateStage = UpdateStage
ActLuckyRollInfo.ChooseItemHandle = ChooseItemHandle
ActLuckyRollInfo.GetCurRewardIndex = GetCurRewardIndex
ActLuckyRollInfo.GetLuckyRollRed = GetLuckyRollRed
ActLuckyRollInfo.CanGetFreePack = CanGetFreePack
ActLuckyRollInfo.CanGotoPackShop = CanGotoPackShop
return ActLuckyRollInfo
