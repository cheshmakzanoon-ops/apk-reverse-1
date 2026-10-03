local SeasonSelectLocationActData = BaseClass("SeasonSelectLocationActData")

function SeasonSelectLocationActData:__init(actData)
  self.ActData = actData
  self.StartTime = actData.startTime
  self.EndTime = actData.endTime
  self.SelectDuration = checknumber(actData.para)
  self.SelectEndTime = self.StartTime + checknumber(self.SelectDuration) * OneDayTime * 1000
  self.GameId = actData.para_1
  self.SetCd = checknumber(actData.para_2)
end

function SeasonSelectLocationActData:__delete()
end

function SeasonSelectLocationActData:IsSelectStage()
  local now = UITimeManager:GetInstance():GetServerTime()
  return now >= self.StartTime and now < self.SelectEndTime
end

function SeasonSelectLocationActData:IsEndShowStage()
  local now = UITimeManager:GetInstance():GetServerTime()
  return now >= self.SelectEndTime and now < self.EndTime
end

return SeasonSelectLocationActData
