local AllianceDonateRankDataManager = BaseClass("AllianceDonateRankDataManager")

local function __init(self)
  self.rankDayList = {}
  self.rankWeekList = {}
  self.dayRefreshTime = 0
  self.weekRefreshTime = 0
end

local function __delete(self)
  self.rankDayList = nil
  self.rankWeekList = nil
  self.dayRefreshTime = nil
  self.weekRefreshTime = nil
end

local function UpdateData(self, message)
  if message.dailyRank2Reward then
    self.rankDayList = message.dailyRank2Reward
  end
  if message.weeklyRank2Reward then
    self.rankWeekList = message.weeklyRank2Reward
  end
  if message.dayEndTime then
    self.dayRefreshTime = message.dayEndTime
  end
  if message.weekEndTime then
    self.weekRefreshTime = message.weekEndTime
  end
end

local function UpdateRankDayList(self, message)
end

local function UpdateRankWeekList(self, message)
end

local function UpdateRankHistoryList(self, message)
end

local function GetSelfRankDataByType(self, type)
end

local function GetAllianceRankListByType(self, type)
end

local function GetAllianceRefreshTimeByType(self, type)
end

AllianceDonateRankDataManager.__init = __init
AllianceDonateRankDataManager.__delete = __delete
AllianceDonateRankDataManager.UpdateRankDayList = UpdateRankDayList
AllianceDonateRankDataManager.UpdateRankWeekList = UpdateRankWeekList
AllianceDonateRankDataManager.UpdateRankHistoryList = UpdateRankHistoryList
AllianceDonateRankDataManager.GetSelfRankDataByType = GetSelfRankDataByType
AllianceDonateRankDataManager.GetAllianceRankListByType = GetAllianceRankListByType
AllianceDonateRankDataManager.GetAllianceRefreshTimeByType = GetAllianceRefreshTimeByType
AllianceDonateRankDataManager.UpdateData = UpdateData
return AllianceDonateRankDataManager
