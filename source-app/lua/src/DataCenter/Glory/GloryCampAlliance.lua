local GloryCampAlliance = BaseClass("GloryCampAlliance")

local function __init(self)
  self.allianceId = ""
  self.country = ""
  self.serverId = 0
  self.allianceName = ""
  self.icon = ""
  self.abbr = ""
  self.curMember = 0
  self.power = 0
  self.camp = 0
end

local function ParseAllianceData(self, message)
  if message.allianceId then
    self.allianceId = message.allianceId
  end
  if message.country then
    self.country = message.country
  end
  if message.serverId then
    self.serverId = message.serverId
  end
  if message.allianceName then
    self.allianceName = message.allianceName
  end
  if message.icon then
    self.icon = message.icon
  end
  if message.abbr then
    self.abbr = message.abbr
  end
  if message.curMember then
    self.curMember = message.curMember
  end
  if message.power then
    self.power = message.power
  end
  if message.camp then
    self.camp = message.camp
  end
end

GloryCampAlliance.__init = __init
GloryCampAlliance.ParseAllianceData = ParseAllianceData
return GloryCampAlliance
