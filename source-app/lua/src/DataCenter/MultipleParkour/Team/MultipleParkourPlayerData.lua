local MultipleParkourPlayerData = BaseClass("MultipleParkourPlayerData")

function MultipleParkourPlayerData:Update(message)
  self.playerId = message.playerId
  self.sid = message.sid
  self.level = message.level
  self.teamId = message.teamId
  self.headSkinId = message.headSkinId
  self.pic = message.pic
  self.picver = message.picVer
  self.allianceId = message.allianceId or 0
  self.name = message.name
  self.score = message.score
  self.lastScore = self.score
  self.select = message.select
  self.mySelf = self.playerId == LuaEntry.Player:GetUid()
  self.selectTimes = message.operationNum or 0
  self.numberId = tonumber(self.playerId)
  self.dead = false
end

function MultipleParkourPlayerData:UpdateLevel(message, level)
  self.select = message.select
end

function MultipleParkourPlayerData:UpdateSelect(select)
  self.select = select
end

function MultipleParkourPlayerData:UpdateTeamIndex(index)
  self.teamIndex = index
end

function MultipleParkourPlayerData:UpdateClientScore(score)
  self.lastScore = self.score
  self.score = score
  if not self.dead then
    self.dead = self.lastScore > 0 and score <= 0
  end
end

function MultipleParkourPlayerData:UpdateServerScore(score)
  self.lastScore = self.score
  self.score = score
  if not self.dead then
    self.dead = self.lastScore > 0 and score <= 0
  end
end

function MultipleParkourPlayerData:UpdateSelectTimes(times)
  self.selectTimes = times or 0
end

function MultipleParkourPlayerData:GetShowScore()
  return self.score
end

return MultipleParkourPlayerData
