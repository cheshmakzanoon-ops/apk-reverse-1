local ActDragonData = BaseClass("ActDragonData")
local ActDragonGroupData = require("DataCenter.ActDragonManager.ActDragonGroupData")

function ActDragonData:__init()
  self.group1 = nil
  self.group2 = nil
  self.hadTeam2 = 0
  self.stopSignUpTime = 0
  self.marchEndTime = 0
  self.battleOpenTime = 0
  self.groupOpenCDEndTime = 0
  self.sCfgId = 0
  self.season = 0
  self.seasonMapInfo = nil
  self.editorUid = nil
end

function ActDragonData:__delete()
  self.group1 = nil
  self.group2 = nil
  self.hadTeam2 = 0
  self.stopSignUpTime = 0
  self.marchEndTime = 0
  self.battleOpenTime = 0
  self.groupOpenCDEndTime = 0
  self.sCfgId = 0
  self.season = 0
  self.seasonMapInfo = nil
  self.editorUid = nil
end

function ActDragonData:ParseData(message)
  if message == nil then
    return
  end
  self.sCfgId = message.battleFieldConfigId or 0
  self.season = message.season or 0
  if message.group1 then
    self.group1 = ActDragonGroupData.New()
    self.group1:ParseData(message.group1, 1)
  end
  if message.group2 then
    self.group2 = ActDragonGroupData.New()
    self.group2:ParseData(message.group2, 2)
  end
  if message.hadTeam2 then
    self.hadTeam2 = message.hadTeam2
  end
  if message.stopSignUpTime then
    self.stopSignUpTime = message.stopSignUpTime
  end
  if message.marchEndTime then
    self.marchEndTime = message.marchEndTime
  end
  if message.battleOpenTime then
    self.battleOpenTime = message.battleOpenTime
  end
  if message.actEndTime ~= nil then
    self.actEndTime = message.actEndTime
  end
  if message.groupOpenCDEndTime ~= nil then
    self.groupOpenCDEndTime = message.groupOpenCDEndTime
  end
  self.editorUid = message.editorUid or nil
  if self.group1 == nil and message.battlePeriod ~= nil and message.assigned ~= nil and message.signUp ~= nil then
    self.group1 = ActDragonGroupData.New()
    self.group1:ParseData(message, 1)
    self.hadTeam2 = 0
  end
  if self.hadTeam2 == 1 and self.group2 and self.group2.signUp ~= 1 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= self.stopSignUpTime then
      self.hadTeam2 = 2
    end
  end
end

function ActDragonData:GetMyGroup()
  if self.group1 and self.group1:IsInGroup() then
    return self.group1
  end
  if self.group2 and self.group2:IsInGroup() then
    return self.group2
  end
  return nil
end

function ActDragonData:GetGroup(idx)
  if idx == 1 then
    return self.group1
  end
  if idx == 2 then
    return self.group2
  end
  return nil
end

function ActDragonData:HasMatchResult()
  if self.group1 and self.group1:IsInMatch() then
    return true
  end
  if self.group2 and self.group2:IsInMatch() then
    return true
  end
  return false
end

function ActDragonData:CleanMatch()
  if self.group1 then
    self.group1.matchResult = 0
  end
  if self.group2 then
    self.group2.matchResult = 0
  end
end

function ActDragonData:UpdateBattlePeriod(message)
  local group = message.group
  local tarGroup
  if group == 1 then
    tarGroup = self.group1
  elseif group == 2 then
    tarGroup = self.group2
  end
  if tarGroup then
    tarGroup.battlePeriod = message.battlePeriod
    tarGroup.signUp = 1
  end
end

function ActDragonData:GetAllianceById(id)
  if self.group1 then
    for _, v in ipairs(self.group1.vsInfoArr) do
      if v.allianceId == id then
        return v
      end
    end
  end
  if self.group2 then
    for _, v in ipairs(self.group2.vsInfoArr) do
      if v.allianceId == id then
        return v
      end
    end
  end
  return nil
end

function ActDragonData:GetAlliances()
  local allianceIds = {}
  if self.group1 then
    for _, v in ipairs(self.group1.vsInfoArr) do
      allianceIds[v.allianceId] = v
    end
  end
  if self.group2 then
    for _, v in ipairs(self.group2.vsInfoArr) do
      allianceIds[v.allianceId] = v
    end
  end
  return allianceIds
end

function ActDragonData:GetAllianceName(allianceId)
  local allianceIds = self:GetAlliances()
  for k, v in pairs(allianceIds) do
    if k == allianceId then
      return v:GetFullName()
    end
  end
  return ""
end

function ActDragonData:Description()
  local sb = StringBuilder.New()
  local time = UITimeManager:GetInstance()
  sb:AppendLine("---\230\180\187\229\138\168\228\191\161\230\129\175---")
  sb:AppendLine(string.format("\232\181\155\229\173\163:%s", self.season))
  sb:AppendLine(string.format("\230\138\165\229\144\141\230\136\170\230\173\162\230\151\182\233\151\180:%s", time:TimeStampToTimeForServer(self.stopSignUpTime)))
  sb:AppendLine(string.format("\229\140\185\233\133\141\231\187\147\230\157\159\230\151\182\233\151\180:%s", time:TimeStampToTimeForServer(self.marchEndTime)))
  sb:AppendLine(string.format("\229\188\128\229\167\139\229\140\185\233\133\141:%s", time:TimeStampToTimeForServer(self.battleOpenTime)))
  sb:AppendLine(string.format("\233\152\159\228\188\1412\230\148\190\229\188\131cd\231\187\147\230\157\159\230\151\182\233\151\180:%s", time:TimeStampToTimeForServer(self.groupOpenCDEndTime)))
  if self.group1 ~= nil then
    sb:AppendLine(self.group1:Description())
  end
  if self.group2 ~= nil then
    sb:AppendLine(self.group2:Description())
  end
  sb:AppendLine()
  return sb:ToString()
end

return ActDragonData
