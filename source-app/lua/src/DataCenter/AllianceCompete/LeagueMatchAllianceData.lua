local LeagueMatchAllianceData = BaseClass("LeagueMatchAllianceData")

function LeagueMatchAllianceData:__init()
  self.allianceId = ""
  self.serverId = 0
  self.abbr = ""
  self.name = ""
  self.group = ""
  self.rankType = 1
  self.position = 0
  self.roundResult = ""
  self.fake = 0
  self.upOrDown = 0
  self.icon = "1"
  self.country = ""
  self.fightPower = 0
  self.leaderName = ""
  self.winTimes = 0
  self.rank = 0
end

function LeagueMatchAllianceData:__delete()
  self.allianceId = nil
  self.serverId = nil
  self.abbr = nil
  self.name = nil
  self.group = nil
  self.rankType = nil
  self.position = nil
  self.roundResult = nil
  self.fake = nil
  self.upOrDown = nil
  self.country = nil
  self.icon = nil
  self.fightPower = nil
  self.leaderName = ""
  self.winTimes = nil
end

function LeagueMatchAllianceData:ParseData(message, i)
  if message == nil then
    return
  end
  self.rank = i
  if message.allianceId then
    self.allianceId = message.allianceId
  end
  if message.serverId then
    self.serverId = message.serverId
  end
  if message.abbr then
    self.abbr = message.abbr
  end
  if message.name then
    self.name = message.name
  end
  if message.group then
    self.group = message.group
  end
  if message.rankType then
    self.rankType = message.rankType
  end
  if message.position then
    self.position = message.position
  end
  if message.roundResult then
    self.roundResult = message.roundResult
    self:SetWinTimes(self.roundResult)
  end
  if message.fake then
    self.fake = message.fake
  end
  if message.upOrDown then
    self.upOrDown = message.upOrDown
  end
  if message.country ~= nil then
    self.country = message.country
  end
  if message.icon ~= nil then
    self.icon = string.IsNullOrEmpty(message.icon) and "1" or message.icon
  end
  if message.fightpower ~= nil then
    self.fightPower = message.fightpower
  end
  if message.learderName ~= nil then
    self.leaderName = message.learderName
  end
end

function LeagueMatchAllianceData:SetWinTimes(strResult)
  self.winTimes = 0
  local arr = string.split(strResult, ";")
  for i, v in ipairs(arr) do
    if v == "1" then
      self.winTimes = self.winTimes + 1
    end
  end
end

function LeagueMatchAllianceData:GetCountryFlagPath()
  local template = self:GetCountryFlagTemplate()
  local img = template:GetNationFlagPath()
  return img
end

function LeagueMatchAllianceData:GetCountryFlagTemplate()
  local country = string.IsNullOrEmpty(self.country) and DefaultNation or self.country
  local temp = DataCenter.NationTemplateManager:GetNationTemplate(country)
  return temp
end

return LeagueMatchAllianceData
