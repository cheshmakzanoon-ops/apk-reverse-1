local OccupyRewardInfo = BaseClass("OccupyRewardInfo")

function OccupyRewardInfo:__init()
  self.cityId = nil
  self.firstAllianceReward = nil
  self.firstReward = nil
  self.rewardComplete = nil
  self.starArr = nil
  self.ranks = nil
end

function OccupyRewardInfo:__delete()
  self.cityId = nil
  self.firstAllianceReward = nil
  self.firstReward = nil
  self.rewardComplete = true
  self.starArr = nil
  self.ranks = nil
end

function OccupyRewardInfo:ParseData(message)
  if message == nil then
    return
  end
  if message.cityId then
    self.cityId = message.cityId
  end
  if message.firstAllianceReward then
    self.firstAllianceReward = message.firstAllianceReward
  end
  if message.firstReward then
    self.firstReward = message.firstReward
  end
  if message.rewardComplete then
    self.rewardComplete = message.rewardComplete
  end
  if message.starArr then
    self.starArr = message.starArr
  end
  if message.ranks then
    self.ranks = message.ranks
  end
end

function OccupyRewardInfo:HaveRewardToGet()
  return not self.rewardComplete
end

function OccupyRewardInfo:HaveFreeRewardToGet()
  return (self.firstAllianceReward or self.firstReward) and not self.rewardComplete
end

function OccupyRewardInfo:HaveStarRewardToGet()
  for _, v in pairs(self.starArr) do
    if not v.rewardComplete then
      return v
    end
  end
  return false
end

return OccupyRewardInfo
