local VsInfoArr = BaseClass("VsInfoArr")

local function __init(self)
  self.allianceId = 0
  self.serverId = 0
  self.name = ""
  self.icon = ""
  self.abbr = ""
  self.mainNum = 0
  self.battleNum = 0
  self.side = 0
  self.strength = 0
  self.score = 0
  self.power = 0
  self.armyPower = 0
  self.currPlayerNum = 0
  self.pointAdd = 0
end

local function __delete(self)
  self.allianceId = 0
  self.serverId = 0
  self.name = ""
  self.icon = ""
  self.abbr = ""
  self.mainNum = 0
  self.battleNum = 0
  self.side = 0
  self.strength = 0
  self.score = 0
  self.power = 0
  self.armyPower = 0
  self.currPlayerNum = 0
  self.pointAdd = 0
  self.allianceGroupId = ""
end

function VsInfoArr:ParseData(message)
  if message == nil then
    return
  end
  if message.power ~= nil then
    self.power = message.power
  end
  if message.armyPower ~= nil then
    self.armyPower = message.armyPower
  end
  if message.allianceId ~= nil then
    self.allianceId = message.allianceId
  end
  if message.serverId ~= nil then
    self.serverId = message.serverId
  end
  if message.name ~= nil then
    self.name = message.name
  end
  if message.icon ~= nil then
    self.icon = message.icon
  end
  if message.signUp ~= nil then
    self.signUp = message.signUp
  end
  if message.abbr ~= nil then
    self.abbr = message.abbr
  end
  if message.mainNum ~= nil then
    self.mainNum = message.mainNum
  end
  if message.battleNum ~= nil then
    self.battleNum = message.battleNum
  end
  if message.side ~= nil then
    self.side = message.side
  end
  if message.strength then
    self.strength = message.strength
  end
  if message.score then
    self.score = message.score
  end
  if message.currPlayerNum then
    self.currPlayerNum = message.currPlayerNum
  end
  if message.pointAdd then
    self.pointAdd = message.pointAdd or 0
  end
  if message.allianceGroupId then
    self.allianceGroupId = message.allianceGroupId
  end
end

function VsInfoArr:GetFullName()
  return "[" .. self.abbr .. "] " .. self.name
end

function VsInfoArr:Description()
  local sb = StringBuilder.New()
  self.allianceId = 0
  self.serverId = 0
  self.name = ""
  self.icon = ""
  self.abbr = ""
  self.mainNum = 0
  self.battleNum = 0
  self.side = 0
  self.strength = 0
  self.score = 0
  self.power = 0
  self.armyPower = 0
  self.currPlayerNum = 0
  self.pointAdd = 0
  sb:AppendLine("---\229\175\185\233\152\181\228\191\161\230\129\175---")
  sb:AppendLine(string.format("\232\129\148\231\155\159id:%s", self.allianceId))
  sb:AppendLine(string.format("\232\129\148\231\155\159serverId:%s", self.serverId))
  sb:AppendLine(string.format("\232\129\148\231\155\159name:%s", self.name))
  sb:AppendLine(string.format("\232\129\148\231\155\159abbr:%s", self.abbr))
  sb:AppendLine(string.format("\228\184\187\229\138\155\228\186\186\230\149\176:%s", self.mainNum))
  sb:AppendLine(string.format("\230\136\152\229\156\186\229\134\133\228\186\186\230\149\176:%s", self.battleNum))
  sb:AppendLine(string.format("\229\143\130\232\181\155\228\186\186\230\149\176:%s", self.currPlayerNum))
  sb:AppendLine(string.format("side:%s", self.side))
  sb:AppendLine(string.format("score:%s", self.score))
  return sb:ToString()
end

VsInfoArr.__init = __init
VsInfoArr.__delete = __delete
return VsInfoArr
