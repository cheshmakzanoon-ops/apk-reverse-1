local BattlefieldDsbDuelActBattleHistoryInfo = BaseClass("BattlefieldDsbDuelActBattleHistoryInfo")

function BattlefieldDsbDuelActBattleHistoryInfo:__init()
  self.battleTime = 0
  self.teamId = 0
  self.results = {}
  self.mvp = {}
  self.emptyRoles = 0
end

function BattlefieldDsbDuelActBattleHistoryInfo:__delete()
  self.battleTime = nil
  self.teamId = nil
  self.results = nil
  self.mvp = nil
  self.emptyRoles = nil
end

function BattlefieldDsbDuelActBattleHistoryInfo:UpdateData(message, mvp)
  if not message then
    return
  end
  self.battleTime = message.battleTime or 0
  self.teamId = message.teamId or 0
  if mvp then
    self.mvp = {}
    self.mvp.name = mvp.name or ""
    self.mvp.uid = mvp.uid or ""
    self.mvp.pic = mvp.pic or ""
    self.mvp.picVer = mvp.picVer or 0
    self.mvp.abbr = mvp.abbr or ""
  end
  if message.results then
    self.emptyRoles = BattlefieldDsbConst.RoleType.MAX - #message.results
    self.results = {}
    for _, resultData in ipairs(message.results) do
      local result = {}
      result.allianceId = resultData.allianceId or ""
      result.abbr = resultData.abbr or ""
      result.name = resultData.name or ""
      result.icon = resultData.icon or ""
      result.server = resultData.server or 0
      result.battleAddScore = resultData.battleAddScore or 0
      result.battleScore = resultData.battleScore or 0
      result.oriScore = resultData.oriScore or 0
      result.member = resultData.member or 0
      result.rank = resultData.rank or 0
      result.group = resultData.group or 1
      result.role = resultData.role or 1
      result.winAddExtraScore = resultData.winAddExtraScore or 0
      result.emptyRoles = self.emptyRoles
      table.insert(self.results, result)
    end
  end
end

function BattlefieldDsbDuelActBattleHistoryInfo:GetBattleTime()
  return self.battleTime
end

function BattlefieldDsbDuelActBattleHistoryInfo:GetTeamId()
  return self.teamId
end

function BattlefieldDsbDuelActBattleHistoryInfo:GetResults()
  return self.results
end

function BattlefieldDsbDuelActBattleHistoryInfo:GetResultCount()
  return #self.results
end

function BattlefieldDsbDuelActBattleHistoryInfo:GetResultByIndex(index)
  if index < 1 or index > #self.results then
    return nil
  end
  return self.results[index]
end

function BattlefieldDsbDuelActBattleHistoryInfo:GetResultMvp()
  return self.mvp
end

function BattlefieldDsbDuelActBattleHistoryInfo:GetWinnerResult()
  local topRank = 999999
  local winner
  for _, result in pairs(self.results) do
    if topRank > result.rank then
      topRank = result.rank
      winner = result
    end
  end
  return winner
end

function BattlefieldDsbDuelActBattleHistoryInfo:GetSelfResult()
  local selfAllianceId = LuaEntry.Player:GetAllianceUid()
  for _, result in pairs(self.results) do
    if result.allianceId == selfAllianceId then
      return result
    end
  end
  return nil
end

function BattlefieldDsbDuelActBattleHistoryInfo:GetSelfTeamRole()
  local selfAllianceId = LuaEntry.Player:GetAllianceUid()
  for _, result in pairs(self.results) do
    if result.allianceId == selfAllianceId then
      return result.role
    end
  end
  return 1
end

function BattlefieldDsbDuelActBattleHistoryInfo:IsWinner(allianceId)
  local winner = self:GetWinnerResult()
  return winner and winner.allianceId == allianceId
end

function BattlefieldDsbDuelActBattleHistoryInfo:IsSelfWinner()
  local selfAllianceId = LuaEntry.Player:GetAllianceUid()
  return self:IsWinner(selfAllianceId)
end

return BattlefieldDsbDuelActBattleHistoryInfo
