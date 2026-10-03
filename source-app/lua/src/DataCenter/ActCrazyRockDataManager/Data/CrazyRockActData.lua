local CrazyRockActData = BaseClass("CrazyRockActData")

function CrazyRockActData:__init()
  self.activityId = 0
  self.historyTopScore = -1
  self.scoreRewardArr = {}
  self.offset = 0
end

function CrazyRockActData:__delete()
  self.activityId = nil
  self.historyTopScore = nil
  self.scoreRewardArr = nil
  self.offset = nil
end

function CrazyRockActData:ParsActData(actData)
  if not actData then
    Logger.LogError("actData is nil")
    return
  end
  self.activityId = actData.activityId or 0
  self.historyTopScore = actData.hisTopScore or -1
  self.scoreRewardArr = actData.scoreRewardArr or {}
  self:UpdateOffset(actData.offset)
end

function CrazyRockActData:UpdateOffset(offset)
  self.offset = offset or 0
end

function CrazyRockActData:UpdateHistoryTopScore(score)
  if not score then
    Logger.LogError("score is invalid")
    return
  end
  self.historyTopScore = score
  EventManager:GetInstance():Broadcast(EventId.MusicGameUpdateScore)
end

return CrazyRockActData
