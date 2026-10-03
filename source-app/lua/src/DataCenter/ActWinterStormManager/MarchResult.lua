local MarchResult = BaseClass("MarchResult")
local TeamArr = require("DataCenter.ActWinterStormManager.TeamArr")

function MarchResult:__init()
  self.battleServerId = 0
  self.worldId = 0
  self.marchReadyTimeout = 0
  self.marchReadyCount = 0
  self.marchId = 0
  self.battleBeginTime = 0
  self.battleEndTime = 0
  self.team = {}
  self.my_side = 0
  self.teamRed = {}
  self.teamBlue = {}
end

function MarchResult:__delete()
  self.battleServerId = 0
  self.worldId = 0
  self.marchReadyTimeout = 0
  self.marchReadyCount = 0
  self.marchId = 0
  self.battleBeginTime = 0
  self.battleEndTime = 0
  self.team = {}
  self.my_side = 0
  self.teamRed = {}
  self.teamBlue = {}
end

function MarchResult:ParseData(message)
  if message == nil then
    return
  end
  if message.battleServerId ~= nil then
    self.battleServerId = message.battleServerId
  end
  if message.worldId ~= nil then
    self.worldId = message.worldId
  end
  if message.marchReadyTimeout ~= nil then
    self.marchReadyTimeout = message.marchReadyTimeout
  end
  if message.marchReadyCount ~= nil then
    self.marchReadyCount = message.marchReadyCount
  end
  if message.marchId ~= nil then
    self.marchId = message.marchId
  end
  if message.battleBeginTime ~= nil then
    self.battleBeginTime = message.battleBeginTime
  end
  if message.battleEndTime ~= nil then
    self.battleEndTime = message.battleEndTime
  end
  self:ParseTeamData(message.team)
end

function MarchResult:ParseTeamData(team)
  if team == nil then
    return
  end
  self.team = {}
  self.teamRed = {}
  self.teamBlue = {}
  self:UpdateTeamData(team)
end

function MarchResult:InsertTeam(oneData)
  if oneData == nil then
    return
  end
  local list = oneData.side == 1 and self.teamRed or self.teamBlue
  if list == nil then
    return
  end
  local tUid = oneData.uid
  for _, v in ipairs(list) do
    if v.uid == tUid then
      return
    end
  end
  table.insert(list, oneData)
end

function MarchResult:UpdateTeamData(team)
  if team == nil then
    return
  end
  for _, v in ipairs(team) do
    local uid = v.uid
    local oneData = self:GetTeamArr(uid)
    if oneData == nil then
      oneData = TeamArr.New()
    end
    oneData:ParseData(v)
    self:InsertTeam(oneData)
    self.team[oneData.uid] = oneData
    if oneData.uid == LuaEntry.Player:GetUid() then
      self.my_side = oneData.side
    end
  end
end

function MarchResult:GetMySide()
  return self.my_side
end

function MarchResult:GetTeamList(bRed)
  return bRed and self.teamRed or self.teamBlue
end

function MarchResult:GetTeamListSortByScore(bRed)
  local team = bRed and self.teamRed or self.teamBlue
  if table.IsNullOrEmpty(team) then
    return nil
  end
  local list = {}
  table.insertto(list, team)
  table.sort(list, function(a, b)
    local sA = a:GetTotalScore()
    local sB = b:GetTotalScore()
    return sA > sB
  end)
  return list
end

function MarchResult:GetTeamArr(uid)
  if string.IsNullOrEmpty(uid) then
    return nil
  end
  return self.team[uid]
end

return MarchResult
