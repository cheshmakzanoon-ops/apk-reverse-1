local ActivityTreasureHuntNewData = BaseClass("ActivityTreasureHuntNewData")

local function __init(self)
  self.activityId = -1
  self.finishedLv = 0
  self.finalRewardIndex = 0
  self.digRecordDic = {}
  self.superRewardGotTimesDic = {}
  self.normalRewardGotTimesDic = {}
  self.itemBoughtTimes = 0
  self.exchange = ""
  self.recommend = 0
  self.claimedLv = {}
  self.normalRewardCanClaim = {}
  self.historyTotalReward = {}
  self.consume_num = -1
end

local function __delete(self)
  self.activityId = nil
  self.finishedLv = nil
  self.finalRewardIndex = nil
  self.digRecordDic = nil
  self.superRewardGotTimesDic = nil
  self.normalRewardGotTimesDic = nil
  self.itemBoughtTimes = nil
  self.exchange = nil
  self.recommend = nil
  self.claimedLv = nil
  self.normalRewardCanClaim = nil
  self.historyTotalReward = nil
  self.consume_num = nil
end

local function ResetLevelInfo(self, tempLv)
  self.finishedLv = tempLv
  self.finalRewardIndex = 0
  self.digRecordDic = {}
end

local function ParseData(self, msg)
  if not msg then
    return
  end
  if msg.activityId then
    self.activityId = msg.activityId
  end
  if msg.level then
    self.finishedLv = msg.level
  end
  if msg.bigRewardIndex then
    self.finalRewardIndex = msg.bigRewardIndex
  end
  if msg.bigRewardReceive then
    self.claimedLv = msg.bigRewardReceive
  end
  if msg.digRecord then
    self.digRecordDic = {}
    for i, v in ipairs(msg.digRecord) do
      self:AddOneDigRecord(v)
    end
  end
  if msg.specialBigRewardReward then
    self.superRewardGotTimesDic = {}
    for i, v in ipairs(msg.specialBigRewardReward) do
      local tb = {}
      tb.rewardIndex = v.index
      tb.gotTimes = v.count
      self.superRewardGotTimesDic[tb.rewardIndex] = tb
    end
  end
  if msg.normalBigRewardReward then
    self.normalRewardGotTimesDic = {}
    for i, v in ipairs(msg.normalBigRewardReward) do
      local tb = {}
      tb.rewardIndex = v.index
      tb.gotTimes = v.count
      self.normalRewardGotTimesDic[tb.rewardIndex] = tb
    end
  end
  if msg.buyGoodsCount then
    self.itemBoughtTimes = msg.buyGoodsCount
  end
  if msg.exchange then
    self.exchange = msg.exchange
  end
  if msg.recommend then
    self.recommend = msg.recommend
  end
  if msg.totalReward then
    self.normalRewardCanClaim = msg.totalReward
  end
  if msg.historyTotalReward then
    self.historyTotalReward = msg.historyTotalReward
  end
  if msg.consume_num then
    self.consume_num = msg.consume_num
  end
end

local function AddOneDigRecord(self, t)
  local tb = {}
  tb.blockIndex = t.digIndex
  tb.rewardIndex = t.goodsIndex
  self.digRecordDic[tb.blockIndex] = tb
  return tb
end

local function UpdateSuperReward(self, bigRewardIndex)
  self.finalRewardIndex = bigRewardIndex
end

local function AddToCanClaimReward(self, reward)
  if not self.normalRewardCanClaim then
    self.normalRewardCanClaim = {}
  end
  for _, v in pairs(reward) do
    table.insert(self.normalRewardCanClaim, v)
  end
end

ActivityTreasureHuntNewData.__init = __init
ActivityTreasureHuntNewData.__delete = __delete
ActivityTreasureHuntNewData.ParseData = ParseData
ActivityTreasureHuntNewData.ResetLevelInfo = ResetLevelInfo
ActivityTreasureHuntNewData.AddOneDigRecord = AddOneDigRecord
ActivityTreasureHuntNewData.UpdateSuperReward = UpdateSuperReward
ActivityTreasureHuntNewData.AddToCanClaimReward = AddToCanClaimReward
return ActivityTreasureHuntNewData
