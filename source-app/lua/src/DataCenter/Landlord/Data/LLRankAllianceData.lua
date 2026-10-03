local LLRankAllianceData = BaseClass("LLRankAllianceData")

function LLRankAllianceData:__init()
  self.serverId = 0
  self.rank = 0
  self.allianceId = ""
  self.allianceName = ""
  self.abbr = ""
  self.icon = ""
  self.score = 0
  self.scorePercent = 0
end

function LLRankAllianceData:__delete()
end

function LLRankAllianceData:ParseData(msg)
  self.serverId = msg.serverId or 0
  self.rank = msg.rank or 0
  self.allianceId = msg.allianceId or ""
  self.allianceName = msg.allianceName or ""
  self.abbr = msg.abbr or ""
  self.icon = msg.icon or ""
  self.score = msg.score or 0
  self.scorePercent = msg.scorePercent or 0
end

return LLRankAllianceData
