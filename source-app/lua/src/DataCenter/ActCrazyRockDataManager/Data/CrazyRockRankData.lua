local CrazyRockRankData = BaseClass("CrazyRockRankData")

function CrazyRockRankData:__init()
  self.activityId = 0
  self.owner = {}
  self.rankArr = {}
end

function CrazyRockRankData:__delete()
  self.activityId = nil
  self.owner = nil
  self.rankArr = nil
end

function CrazyRockRankData:ParsRankInfo(rankInfo)
  if not rankInfo then
    Logger.LogError("rankInfo is nil")
    return
  end
  self.activityId = rankInfo.activityId or 0
  if not rankInfo.owner then
    Logger.LogError("rankInfo.owner is nil")
    return
  end
  local selfRank = rankInfo.owner.rank
  local selfScore = rankInfo.owner.score
  local selfAccuracyRate = rankInfo.owner.accuracyRate
  self.owner.rank = selfRank or 0
  self.owner.score = selfScore or 0
  self.owner.accuracyRate = selfAccuracyRate or 0
  if not rankInfo.rankArr then
    Logger.LogError("rankInfo.rankArr is nil")
    return
  end
  self.rankArr = rankInfo.rankArr
end

return CrazyRockRankData
