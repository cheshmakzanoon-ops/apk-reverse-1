local SeasonTrendAllianceRankData = BaseClass("SeasonTrendAllianceRankData")

local function __init(self)
  self.uid = ""
  self.allianceAbbr = ""
  self.allianceName = ""
  self.abbr = ""
  self.srcServer = nil
  self.rank = 0
  self.icon = ""
  self.score = 0
  self.wasteland_time = 0
end

local function __delete(self)
  self.uid = nil
  self.allianceAbbr = nil
  self.allianceName = nil
  self.abbr = nil
  self.srcServer = nil
  self.rank = nil
  self.icon = nil
  self.score = nil
  self.wasteland_time = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.allianceId ~= nil then
    self.uid = message.allianceId
  end
  if message.abbr ~= nil then
    self.allianceAbbr = message.abbr
    self.abbr = message.abbr
  end
  if message.name ~= nil then
    self.allianceName = message.name
  end
  if message.icon ~= nil then
    self.icon = message.icon
  end
  if message.serverId then
    self.srcServer = message.serverId
  end
  if message.score then
    self.score = message.score
  end
  if message.rank then
    self.rank = message.rank
  end
  if message.wasteland_time then
    self.wasteland_time = message.wasteland_time
  end
end

local function SetRank(self, rank)
  self.rank = rank
end

SeasonTrendAllianceRankData.__init = __init
SeasonTrendAllianceRankData.__delete = __delete
SeasonTrendAllianceRankData.ParseData = ParseData
SeasonTrendAllianceRankData.SetRank = SetRank
return SeasonTrendAllianceRankData
