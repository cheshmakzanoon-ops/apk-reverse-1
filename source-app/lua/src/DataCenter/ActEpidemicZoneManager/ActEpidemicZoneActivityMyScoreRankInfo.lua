local ActEpidemicZoneActivityMyScoreRankInfo = BaseClass("ActEpidemicZoneActivityMyScoreRankInfo")

function ActEpidemicZoneActivityMyScoreRankInfo:__init()
  self.score = 0
  self.cooperationScore = 0
  self.battleScore = 0
  self.tacticsScore = 0
  self.scoreRank = 0
  self.cooperationRank = 0
  self.battleRank = 0
  self.tacticsRank = 0
end

function ActEpidemicZoneActivityMyScoreRankInfo:__delete()
end

function ActEpidemicZoneActivityMyScoreRankInfo:Update(msg)
  self.score = msg.score
  self.cooperationScore = msg.cooperationScore
  self.battleScore = msg.battleScore
  self.tacticsScore = msg.tacticsScore
  self.scoreRank = msg.scoreRank
  self.cooperationRank = msg.cooperationRank
  self.battleRank = msg.battleRank
  self.tacticsRank = msg.tacticsRank
end

function ActEpidemicZoneActivityMyScoreRankInfo:Description()
  return PrettyPrintTable(self)
end

return ActEpidemicZoneActivityMyScoreRankInfo
