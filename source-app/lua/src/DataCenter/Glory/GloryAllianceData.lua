local GloryAllianceData = BaseClass("GloryAllianceData")

local function __init(self)
  self.allianceId = ""
  self.abbr = ""
  self.name = ""
  self.icon = ""
  self.serverId = 0
  self.rank = 0
  self.score = 0
  self.power = 0
  self.vsAllianceId = ""
  self.startTime = 0
  self.endTime = 0
  self.avoidWarInfo = {setTime = 0, avoidTimeInfo = ""}
end

local function ParseServerData(self, serverData)
  if serverData.allianceId then
    self.allianceId = serverData.allianceId
  end
  if serverData.abbr then
    self.abbr = serverData.abbr
  end
  if serverData.name then
    self.name = serverData.name
  end
  if serverData.icon then
    self.icon = serverData.icon
  end
  if serverData.serverId then
    self.serverId = serverData.serverId
  end
  if serverData.rank then
    self.rank = serverData.rank
  end
  if serverData.score then
    self.score = serverData.score
  end
  if serverData.power then
    self.power = serverData.power
  end
  if serverData.vsAllianceId then
    self.vsAllianceId = serverData.vsAllianceId
  end
  if serverData.startTime then
    self.startTime = serverData.startTime
  end
  if serverData.endTime then
    self.endTime = serverData.endTime
  end
  if serverData.avoidWarInfo then
    self.avoidWarInfo = serverData.avoidWarInfo
  end
end

GloryAllianceData.__init = __init
GloryAllianceData.ParseServerData = ParseServerData
return GloryAllianceData
