local ScratchOffGameActivityParamTemplate = BaseClass("ScratchOffGameActivityParamTemplate")

local function __init(self)
  self.activityId = 0
  self.totalLotteryCount = 0
  self.maxLotteryCount = 0
  self.oneLotteryCount = 0
  self.tenLotteryCount = 0
  self.score = 0
  self.chooseIndex = 0
  self.extraRewardScore = 0
  self.diamondPool = 0
end

local function __delete(self)
  self.activityId = nil
  self.totalLotteryCount = nil
  self.maxLotteryCount = nil
  self.oneLotteryCount = nil
  self.tenLotteryCount = nil
  self.score = nil
  self.chooseIndex = nil
  self.extraRewardScore = nil
  self.diamondPool = nil
end

local function ParamData(self, msg)
  if msg == nil then
    return
  end
  if msg.activityId then
    self.activityId = msg.activityId
    local id = DataCenter.ScratchOffGameManager:GetScratchIdByActivityId(self.activityId)
    self.maxLotteryCount = GetTableData("activity_scratch", id, "draw_max")
    self.extraRewardScore = GetTableData("activity_scratch", id, "score_reward_extra")
  end
  if msg.scratchInfo then
    self.totalLotteryCount = msg.scratchInfo.totalLotteryCount
    self.oneLotteryCount = msg.scratchInfo.oneLotteryCount
    self.tenLotteryCount = msg.scratchInfo.tenLotteryCount
    self.score = msg.scratchInfo.score
    self.chooseIndex = math.max(1, msg.scratchInfo.chooseIndex)
  end
  if msg.diamondPool then
    self.diamondPool = msg.diamondPool
  end
end

local function GetRemainLotteryCount(self)
  local remainCount = self.maxLotteryCount - self.oneLotteryCount - 10 * self.tenLotteryCount
  return remainCount
end

ScratchOffGameActivityParamTemplate.__init = __init
ScratchOffGameActivityParamTemplate.__delete = __delete
ScratchOffGameActivityParamTemplate.ParamData = ParamData
ScratchOffGameActivityParamTemplate.GetRemainLotteryCount = GetRemainLotteryCount
return ScratchOffGameActivityParamTemplate
