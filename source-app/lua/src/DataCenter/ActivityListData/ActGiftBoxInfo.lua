local ActGiftBoxInfo = BaseClass("ActGiftBoxInfo")
local ActGolloesCardRankInfo = require("DataCenter.ActivityListData.ActGolloesCardRankInfo")
local ActGiftBoxScoreInfo = require("DataCenter.ActivityListData.ActGiftBoxScoreInfo")
local ActivityFreeRewardData = require("DataCenter.ActivityFreeRewardData.ActivityFreeRewardData")

local function __init(self)
  self.activityId = 0
  self.oneLotteryCount = 0
  self.fiveLotteryCount = 0
  self.lastResetTime = 0
  self.giftBoxs = {}
  self.lotteryList = {}
  self.selfRankScore = 0
  self.score = 0
  self.selfRank = 0
  self.rankList = {}
  self.rankRewardArr = {}
  self.scoreInfoArr = {}
  self.freeRewardState = 0
  self.freeReward = {}
  self.lastReceiveFreeTime = 0
  self.rewardPackGroupId = 0
  self.configId = 0
  self.useFreeTimes = 0
  self.activityFreeRewardData = ActivityFreeRewardData.New()
end

local function __delete(self)
  self.activityId = nil
  self.oneLotteryCount = nil
  self.fiveLotteryCount = nil
  self.lastResetTime = nil
  self.giftBoxs = nil
  self.lotteryList = nil
  self.selfRankScore = nil
  self.score = nil
  self.selfRank = nil
  self.rankList = nil
  self.rankRewardArr = nil
  self.scoreInfoArr = nil
  self.freeRewardState = nil
  self.freeReward = nil
  self.lastReceiveFreeTime = nil
  self.rewardPackGroupId = nil
  self.activityFreeRewardData = nil
  self.configId = nil
  self.useFreeTimes = 0
end

local function ParseInfo(self, message)
  if message == nil then
    return
  end
  if message.activityId then
    self.activityId = message.activityId
  end
  if message.id then
    self.configId = message.id
  end
  if message.oneLotteryCount then
    self.oneLotteryCount = message.oneLotteryCount
  end
  if message.fiveLotteryCount then
    self.fiveLotteryCount = message.fiveLotteryCount
  end
  if message.lastResetTime then
    self.lastResetTime = message.lastResetTime
  end
  if message.score then
    self.score = message.score
  end
  if message.giftBoxs then
    for i = 1, table.count(message.giftBoxs) do
      if self.giftBoxs then
        local existFlag = false
        table.walk(self.giftBoxs, function(k, v)
          if v.uuid == message.giftBoxs[i].uuid then
            v.itemId = message.giftBoxs[i].itemId
            existFlag = true
          end
        end)
        if not existFlag then
          do
            local newBox = {
              uuid = message.giftBoxs[i].uuid,
              itemId = message.giftBoxs[i].itemId
            }
            table.insert(self.giftBoxs, newBox)
          end
        end
      end
    end
  end
  if message.scoreArr then
    table.clear(self.scoreInfoArr)
    for k, v in ipairs(message.scoreArr) do
      local scoreData = ActGiftBoxScoreInfo.New()
      scoreData:ParseInfo(v)
      table.insert(self.scoreInfoArr, scoreData)
    end
  end
  if message.useFreeTimes then
    self.useFreeTimes = message.useFreeTimes
  end
  self.activityFreeRewardData:ParseData(message)
end

local function RefreshCount(self, fiveLottery)
  if fiveLottery == 1 then
    self.fiveLotteryCount = self.fiveLotteryCount + 1
  else
    self.oneLotteryCount = self.oneLotteryCount + 1
  end
end

local function ParseGiftBox(self, message)
  if message.newGiftBoxs then
    table.walk(self.giftBoxs, function(k, v)
      v.newBox = false
    end)
    for i = 1, table.count(message.newGiftBoxs) do
      local param = {}
      param.uuid = message.newGiftBoxs[i].uuid
      param.itemId = message.newGiftBoxs[i].itemId
      param.newBox = true
      local insertFlag = false
      for i = 1, 4 do
        if self.giftBoxs[i] == nil then
          self.giftBoxs[i] = param
          insertFlag = true
          break
        end
      end
      if insertFlag == false then
        table.insert(self.giftBoxs, param)
      end
    end
  end
  self.activityFreeRewardData:ParseData(message)
end

local function RefreshBox(self, uuid)
  if self.giftBoxs then
    for i = 1, 4 do
      if self.giftBoxs[i] and self.giftBoxs[i].uuid == uuid then
        self.giftBoxs[i] = nil
        break
      end
    end
  end
end

local function ParseLotteryCount(self, message)
  if message.lotteryCounts then
    self.lotteryList = {}
    local lotteryCounts = message.lotteryCounts
    for i = 1, table.count(lotteryCounts) do
      local param = {}
      param.count = lotteryCounts[i].count
      param.itemId = lotteryCounts[i].itemId
      table.insert(self.lotteryList, param)
    end
  end
end

local function CompareAllNum(self)
  return self.fiveLotteryCount * 5 + self.oneLotteryCount
end

local function GetActRed(self)
  local redNum = 0
  local tipNum = 0
  local template = DataCenter.ActGiftBoxData:GetActTemplateByActId(tonumber(self.activityId))
  if template and self.useFreeTimes < template.cost_1_free then
    tipNum = tipNum + (template.cost_1_free - self.useFreeTimes)
  end
  if self.activityFreeRewardData.freeRewardState == 0 then
    redNum = redNum + 1
  end
  redNum = redNum + self:GetActBoxRed()
  return redNum + tipNum, redNum, tipNum
end

local function GetActBoxRed(self)
  local redNum = 0
  if self.scoreInfoArr then
    for k, v in ipairs(self.scoreInfoArr) do
      if self.score >= v.targetScore and v.state == 0 then
        redNum = redNum + 1
      end
    end
  end
  return redNum
end

local function ParseRankInfo(self, message)
  if message.selfScore then
    self.selfRankScore = message.selfScore
  end
  if message.selfRank then
    self.selfRank = message.selfRank
  end
  if message.rankList and next(message.rankList) then
    for i = 1, #message.rankList do
      local info = ActGolloesCardRankInfo.New()
      info:ParseRankInfo(message.rankList[i])
      self.rankList[i] = info
    end
  end
  if message.rankRewardArr and next(message.rankRewardArr) then
    for i = 1, #message.rankRewardArr do
      self.rankRewardArr[i] = {}
      self.rankRewardArr[i].reward = DataCenter.RewardManager:ReturnRewardParamForView(message.rankRewardArr[i].reward)
      self.rankRewardArr[i].startN = message.rankRewardArr[i].start
      self.rankRewardArr[i].endN = message.rankRewardArr[i]["end"]
    end
  end
end

local function IsRankDataReach(self)
  return self.selfRank ~= 0
end

local function GetRankList(self)
  return self.rankList
end

local function GetRewardArr(self)
  return self.rankRewardArr
end

local function GetScore(self)
  return self.score
end

local function GetScoreArr(self)
  return self.scoreInfoArr
end

local function ReceiveScoreReward(self, message)
  if message.index and self.scoreInfoArr and #self.scoreInfoArr >= message.index then
    self.scoreInfoArr[message.index + 1].state = 1
  end
end

local function ReceiveFreeReward(self)
  if self.activityFreeRewardData then
    self.activityFreeRewardData:OnReceiveFreeReward()
  end
end

local function UpdateScore(self, message)
  if message.score then
    self.score = message.score
  end
end

local function RefreshUseFreeTimes(self, message)
  if message.useFreeTimes then
    self.useFreeTimes = message.useFreeTimes
  end
end

ActGiftBoxInfo.__init = __init
ActGiftBoxInfo.__delete = __delete
ActGiftBoxInfo.ParseInfo = ParseInfo
ActGiftBoxInfo.RefreshCount = RefreshCount
ActGiftBoxInfo.ParseGiftBox = ParseGiftBox
ActGiftBoxInfo.RefreshBox = RefreshBox
ActGiftBoxInfo.ParseLotteryCount = ParseLotteryCount
ActGiftBoxInfo.CompareAllNum = CompareAllNum
ActGiftBoxInfo.GetActRed = GetActRed
ActGiftBoxInfo.GetActBoxRed = GetActBoxRed
ActGiftBoxInfo.ParseRankInfo = ParseRankInfo
ActGiftBoxInfo.GetRankList = GetRankList
ActGiftBoxInfo.GetRewardArr = GetRewardArr
ActGiftBoxInfo.GetScore = GetScore
ActGiftBoxInfo.GetScoreArr = GetScoreArr
ActGiftBoxInfo.ReceiveScoreReward = ReceiveScoreReward
ActGiftBoxInfo.ReceiveFreeReward = ReceiveFreeReward
ActGiftBoxInfo.UpdateScore = UpdateScore
ActGiftBoxInfo.IsRankDataReach = IsRankDataReach
ActGiftBoxInfo.RefreshUseFreeTimes = RefreshUseFreeTimes
return ActGiftBoxInfo
