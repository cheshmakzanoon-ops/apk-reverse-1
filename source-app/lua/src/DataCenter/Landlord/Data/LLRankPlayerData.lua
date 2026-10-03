local LLRankPlayerData = BaseClass("LLRankPlayerData")

function LLRankPlayerData:__init()
  self.rank = 0
  self.uid = ""
  self.name = ""
  self.pic = ""
  self.picVer = 0
  self.picFrame = 0
  self.serverId = 0
  self.allianceId = ""
  self.allianceName = ""
  self.abbr = ""
  self.mainBuildingLevel = 0
  self.score = 0
  self.myRank = 0
  self.power = 0
end

function LLRankPlayerData:__delete()
end

function LLRankPlayerData:ParseData(msg)
  self.rank = msg.rank or 0
  self.uid = msg.uid or ""
  self.name = msg.name or ""
  self.pic = msg.pic or ""
  self.picVer = msg.picVer or 0
  self.picFrame = msg.picFrame or 0
  self.serverId = msg.serverId or 0
  self.allianceId = msg.allianceId or ""
  self.allianceName = msg.allianceName or ""
  self.abbr = msg.abbr or ""
  self.mainBuildingLevel = msg.mainBuildingLevel or 0
  self.score = msg.score or 0
  self.myRank = msg.myRank or 0
  self.power = msg.power or 0
end

return LLRankPlayerData
