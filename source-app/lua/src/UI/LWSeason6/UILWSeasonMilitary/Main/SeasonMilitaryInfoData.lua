local SeasonMilitaryInfoData = BaseClass("SeasonMilitaryInfoData")

function SeasonMilitaryInfoData:__init()
end

function SeasonMilitaryInfoData:__delete()
  self:Reset()
end

function SeasonMilitaryInfoData:Reset()
  self.Payload = nil
  self.Level = nil
  self.Group = nil
  self.Score = nil
  self.Rank = nil
  self.LastDayRank = nil
  self.ClaimNum = nil
  self.TaskProgress = {}
  self.IsSettleIng = false
  self.Cell = nil
end

function SeasonMilitaryInfoData:HandleInfo(payload)
  self:Reset()
  self.Payload = payload
  self.Level = checknumber(payload.militaryLevel)
  self.Cell = DataCenter.SeasonMilitaryManager:GetLevelCellTmp(self:GetLevel())
  self.Score = checknumber(payload.totalMilitaryScore)
  self.Rank = checknumber(payload.totalMilitaryRank)
  self.LastDayRank = checknumber(payload.lastDayRank)
  if self.Cell ~= nil then
    self.Group = checknumber(self.Cell.level_group)
  end
  self:HandleClaimNum(payload.dailyRewardNum)
  self:HandleTaskProgress(payload.militaryConditionArr)
  self.IsSettleIng = payload.isDailySettleIng
end

function SeasonMilitaryInfoData:HandleClaimNum(claimNum)
  self.ClaimNum = checknumber(claimNum)
  self.ClaimNumUpdateTime = UITimeManager:GetInstance():GetServerSeconds()
end

function SeasonMilitaryInfoData:HandleTaskProgress(arr)
  self.TaskProgress = self.TaskProgress or {}
  if not table.IsNullOrEmpty(arr) then
    for _, conditionData in pairs(arr) do
      self.TaskProgress[checknumber(conditionData.conditionType)] = checknumber(conditionData.conditionNum)
    end
  end
end

function SeasonMilitaryInfoData:HandleLevelUp(payload)
  if payload == nil then
    return
  end
  self.Level = checknumber(payload.militaryLevel)
  self.Cell = DataCenter.SeasonMilitaryManager:GetLevelCellTmp(self:GetLevel())
  if self.Cell ~= nil then
    self.Group = checknumber(self.Cell.level_group)
  end
  self.Score = checknumber(payload.totalMilitaryScore)
  self:HandleClaimNum(payload.dailyRewardNum)
end

function SeasonMilitaryInfoData:GetRealClaimNum()
  local now = UITimeManager:GetInstance():GetServerSeconds()
  if not UITimeManager:GetInstance():IsSameDayForServer(checknumber(self.ClaimNumUpdateTime), now) then
    return 0
  end
  return checknumber(self.ClaimNum)
end

function SeasonMilitaryInfoData:CanClaim()
  return self:GetRealClaimNum() < 1
end

function SeasonMilitaryInfoData:GetLevel()
  return Mathf.Max(1, checknumber(self.Level))
end

function SeasonMilitaryInfoData:GetGroup()
  return Mathf.Max(1, checknumber(self.Group))
end

function SeasonMilitaryInfoData:GetScore()
  return checknumber(self.Score)
end

function SeasonMilitaryInfoData:GetRank()
  return checknumber(self.Rank)
end

function SeasonMilitaryInfoData:GetLastDayRank()
  return checknumber(self.LastDayRank)
end

function SeasonMilitaryInfoData:GetTaskValue(taskType)
  return table.TryGetValue(self.TaskProgress, checknumber(taskType), 0)
end

return SeasonMilitaryInfoData
