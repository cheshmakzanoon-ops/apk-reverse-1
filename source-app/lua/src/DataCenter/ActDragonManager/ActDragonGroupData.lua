local ActDragonGroupData = BaseClass("ActDragonGroupData")
local VsInfoArr = require("DataCenter.ActDragonManager.VsInfoArr")

function ActDragonGroupData:__init()
  self.group = 0
  self.battlePeriod = 0
  self.lastBattlePeriod = 0
  self.assigned = 0
  self.signUp = 0
  self.matchResult = 0
  self.battleServerId = 0
  self.worldId = 0
  self.vsInfoArr = {}
  self.timeInfo = {}
  self.exitDragon = false
end

function ActDragonGroupData:__delete()
  self.group = 0
  self.battlePeriod = 0
  self.lastBattlePeriod = 0
  self.assigned = 0
  self.signUp = 0
  self.matchResult = 0
  self.battleServerId = 0
  self.worldId = 0
  self.vsInfoArr = {}
  self.timeInfo = {}
  self.exitDragon = false
end

function ActDragonGroupData:ParseData(message, groupIdx)
  if message == nil then
    return
  end
  self.group = groupIdx
  if message.battlePeriod ~= nil then
    self.battlePeriod = message.battlePeriod
  end
  if message.lastBattlePeriod ~= nil then
    self.lastBattlePeriod = message.lastBattlePeriod
  end
  if message.assigned ~= nil then
    self.assigned = message.assigned
  end
  if message.signUp ~= nil then
    self.signUp = message.signUp
  end
  if message.matchResult ~= nil then
    self.matchResult = message.matchResult
  end
  if message.battleServerId ~= nil then
    self.battleServerId = message.battleServerId
  end
  if message.worldId ~= nil then
    self.worldId = message.worldId
  end
  if message.vsInfoArr ~= nil then
    local arr = message.vsInfoArr
    for i, v in ipairs(arr) do
      local oneData = VsInfoArr.New()
      oneData:ParseData(v)
      self.vsInfoArr[i] = oneData
    end
  end
  if message.timeInfo ~= nil then
    self.timeInfo = message.timeInfo
  end
  if message.exitDragon ~= nil then
    self.exitDragon = message.exitDragon
  end
end

function ActDragonGroupData:IsInGroup()
  return (self.assigned == 1 or self.assigned == 2) and self.signUp == 1
end

function ActDragonGroupData:IsInMatch()
  return self.matchResult == 1
end

function ActDragonGroupData:GetMyAllianceGroupId()
  local allianceId = LuaEntry.Player:GetAllianceUid()
  for _, v in ipairs(self.vsInfoArr) do
    if v.allianceId == allianceId then
      return v.allianceGroupId
    end
  end
  return nil
end

function ActDragonGroupData:Description()
  local sb = StringBuilder.New()
  local time = UITimeManager:GetInstance()
  sb:AppendLine(string.format("---\233\152\159\228\188\141%s\228\191\161\230\129\175---", self.group))
  sb:AppendLine(string.format("\230\156\172\231\187\132\232\162\171\230\140\135\230\180\190\231\138\182\230\128\129:%s", self.battlePeriod))
  sb:AppendLine(string.format("\230\156\172\231\187\132\228\184\138\228\184\128\230\172\161\232\162\171\230\140\135\230\180\190\231\138\182\230\128\129:%s", self.lastBattlePeriod))
  sb:AppendLine(string.format("\230\138\165\229\144\141\229\156\186\230\172\161:%s", self.assigned))
  sb:AppendLine(string.format("\230\152\175\229\144\166\230\138\165\229\144\141:%s", self.signUp))
  sb:AppendLine(string.format("\229\140\185\233\133\141\231\187\147\230\158\156:%s", self.matchResult))
  sb:AppendLine(string.format("\230\136\152\229\156\186\230\156\141:%s", self.battleServerId))
  sb:AppendLine(string.format("\230\136\152\229\156\186\230\156\141world:%s", self.worldId))
  sb:AppendLine(string.format("\230\152\175\229\144\166\229\183\178\233\128\128\229\135\186\230\136\152\229\156\186:%s", self.exitDragon))
  sb:AppendLine("---\229\143\140\230\150\185\232\129\148\231\155\159\228\191\161\230\129\175---")
  for _, v in pairs(self.vsInfoArr) do
    sb:AppendLine(v:Description())
  end
  sb:AppendLine("---\230\136\152\230\150\151\230\151\182\233\151\180\228\191\161\230\129\175---")
  sb:AppendLine(string.format("\229\135\134\229\164\135\229\188\128\229\167\139\230\151\182\233\151\180:%s", time:TimeStampToTimeForServer(self.prepTime or 0)))
  sb:AppendLine(string.format("\230\136\152\229\156\186\229\188\128\229\167\139\230\151\182\233\151\180:%s", time:TimeStampToTimeForServer(self.battleOpenTime or 0)))
  sb:AppendLine(string.format("\230\136\152\229\156\186\231\187\147\230\157\159\230\151\182\233\151\180:%s", time:TimeStampToTimeForServer(self.endTime or 0)))
  sb:AppendLine()
  return sb:ToString()
end

return ActDragonGroupData
