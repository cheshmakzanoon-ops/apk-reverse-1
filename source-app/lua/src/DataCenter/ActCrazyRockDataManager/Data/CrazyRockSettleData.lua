local CrazyRockSettleData = BaseClass("CrazyRockSettleData")

function CrazyRockSettleData:__init()
  self.activityId = 0
  self.songId = 0
  self.reward = {}
  self.score = 0
  self.rank = 0
  self.surpass = 0
  self.hisTopRank = 0
  self.isNew = false
end

function CrazyRockSettleData:__delete()
  self.activityId = nil
  self.songId = nil
  self.reward = nil
  self.score = nil
  self.rank = nil
  self.surpass = nil
  self.hisTopRank = nil
  self.isNew = nil
end

function CrazyRockSettleData:ParsSettleInfo(info)
  if not info then
    Logger.LogError("info is nil")
    return
  end
  self.activityId = info.activityId or 0
  self.songId = info.songId or 0
  local reFormatReward = info.reward
  reFormatReward = reFormatReward and DataCenter.RewardManager:ReturnRewardParamForMessage(info.reward)
  self.reward = info.reward
  self.clientReward = reFormatReward
  self.score = info.score or 0
  self.rank = info.rank or 0
  self.surpass = info.surpass or 0
  if info.surpass then
    self.surpass = Mathf.DecimalFormat(tonumber(info.surpass) / 100) .. "%"
  end
  self.hisTopRank = info.hisTopRank or 0
  self.isNew = info.isNew == 1
end

return CrazyRockSettleData
