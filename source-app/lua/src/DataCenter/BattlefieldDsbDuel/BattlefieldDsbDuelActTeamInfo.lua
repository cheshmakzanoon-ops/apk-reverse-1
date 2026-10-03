local BattlefieldDsbDuelActTeamInfo = BaseClass("BattlefieldDsbDuelActTeamInfo")
local BattlefieldDsbDuelActTeamAllianceInfo = require("DataCenter.BattlefieldDsbDuel.BattlefieldDsbDuelActTeamAllianceInfo")

function BattlefieldDsbDuelActTeamInfo:__init(teamId)
  self.state = 0
  self.selfAssigned = 0
  self.battleServerId = 0
  self.battleWorldId = 0
  self.group = 0
  self.rank1 = 0
  self.rank2 = 0
  self.lastPower = 0
  self.lastRank = 0
  self.lastScore = 0
  self.lastSmallScore = 0
  self.score = 0
  self.smallScore = 0
  self.power = 0
  self.matchInfo = {}
  self.teamId = teamId
  self.role2AllianceInfo = {}
end

function BattlefieldDsbDuelActTeamInfo:__delete()
  self.state = nil
  self.selfAssigned = nil
  self.battleServerId = nil
  self.battleWorldId = nil
  self.group = nil
  self.rank1 = nil
  self.rank2 = nil
  self.lastPower = nil
  self.lastRank = nil
  self.lastScore = nil
  self.lastSmallScore = nil
  self.score = nil
  self.smallScore = nil
  self.power = nil
  self.matchInfo = nil
  self.teamId = nil
  self.role2AllianceInfo = nil
end

function BattlefieldDsbDuelActTeamInfo:UpdateData(message)
  if not message then
    return
  end
  self.state = message.state or 0
  self.selfAssigned = message.selfAssigned or 0
  self.battleServerId = message.battleServerId or 0
  self.battleWorldId = message.battleWorldId or 0
  self.group = tonumber(message.group) or 0
  self.rank1 = tonumber(message.rank1) or 0
  self.rank2 = tonumber(message.rank2) or 0
  self.lastPower = message.lastPower or 0
  self.lastRank = tonumber(message.lastRank) or 0
  self.lastScore = tonumber(message.lastScore) or 0
  self.lastSmallScore = tonumber(message.lastSmallScore) or 0
  self.score = tonumber(message.score) or 0
  self.smallScore = tonumber(message.smallScore) or 0
  self.power = message.power or 0
  if message.matchInfo and self.matchInfo then
    self.matchInfo = {}
    self.role2AllianceInfo = {}
    for k, v in ipairs(message.matchInfo) do
      local allianceInfo = BattlefieldDsbDuelActTeamAllianceInfo.New()
      allianceInfo:UpdateData(v)
      table.insert(self.matchInfo, allianceInfo)
      self.role2AllianceInfo[allianceInfo:GetRole()] = allianceInfo
    end
  end
end

function BattlefieldDsbDuelActTeamInfo:GetState()
  return self.state
end

function BattlefieldDsbDuelActTeamInfo:SetState(state)
  self.state = state
end

function BattlefieldDsbDuelActTeamInfo:IsSignUp()
  return self.state == 1
end

function BattlefieldDsbDuelActTeamInfo:IsGiveUp()
  return self.state == 2
end

function BattlefieldDsbDuelActTeamInfo:IsBye()
  return self.state == 3
end

function BattlefieldDsbDuelActTeamInfo:IsMatched()
  return self.state == 4
end

function BattlefieldDsbDuelActTeamInfo:GetSelfAssigned()
  return self.selfAssigned
end

function BattlefieldDsbDuelActTeamInfo:IsMainForce()
  return self.selfAssigned == 1
end

function BattlefieldDsbDuelActTeamInfo:IsSubstitute()
  return self.selfAssigned == 2
end

function BattlefieldDsbDuelActTeamInfo:GetBattleServerId()
  return self.battleServerId
end

function BattlefieldDsbDuelActTeamInfo:GetBattleWorldId()
  return self.battleWorldId
end

function BattlefieldDsbDuelActTeamInfo:GetGroup()
  return self.group
end

function BattlefieldDsbDuelActTeamInfo:GetGroupRank()
  return self.rank1
end

function BattlefieldDsbDuelActTeamInfo:GetTotalRank()
  return self.rank2
end

function BattlefieldDsbDuelActTeamInfo:GetMatchAllianceInfo()
  return self.matchInfo
end

function BattlefieldDsbDuelActTeamInfo:GetMatchAllianceInfoByRole(role)
  return self.role2AllianceInfo and self.role2AllianceInfo[role] or BattlefieldDsbConst.EmptyRole
end

function BattlefieldDsbDuelActTeamInfo:GetTeamId()
  return self.teamId
end

function BattlefieldDsbDuelActTeamInfo:GetSelfTeamRole()
  if not table.IsNullOrEmpty(self.matchInfo) then
    local allianceId = LuaEntry.Player:GetAllianceUid()
    for k, v in ipairs(self.matchInfo) do
      if v:GetAllianceId() == allianceId then
        return v:GetRole()
      end
    end
  end
end

return BattlefieldDsbDuelActTeamInfo
