local BattlefieldDsbDuelMyInfo = BaseClass("BattlefieldDsbDuelMyInfo")

function BattlefieldDsbDuelMyInfo:__init()
  self.selfTeamId = BattlefieldDsbConst.TeamType.None
  self.selfSignState = BattlefieldDsbConst.BF_DSB_TEAM_STATE.NotSignUp
  self.selfPlayerState = BattlefieldDsbConst.BF_DSB_PLAYER_STATE.None
  self.selfRoleId = BattlefieldDsbConst.RoleType.None
  self.selfLastEnterBattleTime = 0
  self.selfGroupId = 0
  self.selfScore = {}
  self.selfScore.score = 0
  self.selfScore.battleScore = 0
  self.selfScore.cooperationScore = 0
  self.selfScore.tacticsScore = 0
  self.selfRank = 0
  self.allianceInfo = nil
end

function BattlefieldDsbDuelMyInfo:__delete()
end

function BattlefieldDsbDuelMyInfo:UpdateFromActInfo(actInfo)
  if not actInfo then
    return
  end
  local selfTeamInfo = actInfo:GetSelfTeamInfo()
  if not selfTeamInfo then
    self.selfTeamId = BattlefieldDsbConst.TeamType.None
    self.selfSignState = BattlefieldDsbConst.BF_DSB_TEAM_STATE.NotSignUp
    self.selfPlayerState = BattlefieldDsbConst.BF_DSB_PLAYER_STATE.None
  else
    self.selfTeamId = selfTeamInfo:GetTeamId()
    self.selfSignState = selfTeamInfo:GetState()
    self.selfPlayerState = selfTeamInfo:GetSelfAssigned()
  end
  self.selfTeamId = actInfo:GetSelfTeam()
  self.selfLastEnterBattleTime = actInfo.lastEnterBattleTime
end

function BattlefieldDsbDuelMyInfo:UpdateFromBattleInfo(actInfo)
  if not actInfo then
    return
  end
  local selfBattleInfo = actInfo:GetSelfAllianceInfo()
  if selfBattleInfo then
    self.selfRoleId = selfBattleInfo:GetRole()
    self.selfGroupId = selfBattleInfo:GetGroup()
    self.allianceInfo = {}
    self.allianceInfo.team = selfBattleInfo.team
    self.allianceInfo.role = selfBattleInfo.role
    self.allianceInfo.score = selfBattleInfo.battleScore
    self.allianceInfo.rank = selfBattleInfo.rank
    self.allianceInfo.member = selfBattleInfo.battleMember
  end
  EventManager:GetInstance():Broadcast(EventId.DsbDuelBattleMyInfoChanged)
end

function BattlefieldDsbDuelMyInfo:UpdateFromBattlePlayerInfo(battleInfo)
  if not battleInfo then
    return
  end
  local selfInfo = battleInfo:GetSelfPlayerInfo()
  if not selfInfo then
    return
  end
  self.selfScore.score = selfInfo.score
  self.selfScore.battleScore = selfInfo.battleScore
  self.selfScore.cooperationScore = selfInfo.cooperationScore
  self.selfScore.tacticsScore = selfInfo.tacticsScore
  self.selfRank = selfInfo.rank
end

function BattlefieldDsbDuelMyInfo:UpdateFromEnterMsg(battleInfo)
  self:RefreshAllianceInfoFromBattleInfo(battleInfo)
end

function BattlefieldDsbDuelMyInfo:UpdateFromScoreUpdateMsg(battleInfo)
  self:RefreshAllianceInfoFromBattleInfo(battleInfo)
end

function BattlefieldDsbDuelMyInfo:RefreshAllianceInfoFromBattleInfo(battleInfo)
  if not battleInfo then
    return
  end
  local allianceRole = battleInfo:GetMyRole()
  if not allianceRole then
    return
  end
  self.allianceInfo = {}
  self.allianceInfo.team = battleInfo:GetTeam()
  self.allianceInfo.role = allianceRole:GetRoleID()
  self.allianceInfo.score = allianceRole.score
  self.allianceInfo.rank = battleInfo:GetMyRank()
  self.allianceInfo.member = allianceRole.count
end

function BattlefieldDsbDuelMyInfo:Description()
  local sb = StringBuilder.New()
  sb:AppendFormatLine("--\230\159\165\231\156\139 BattlefieldDsbDuelMyInfo--")
  sb:AppendFormatLine("\230\136\145\232\135\170\229\183\177\231\154\132\230\131\133\229\134\181:")
  sb:AppendFormatLine("\233\152\159\228\188\141id:%s", self.selfTeamId)
  sb:AppendFormatLine("\230\138\165\229\144\141\231\138\182\230\128\129:%s", self.selfSignState)
  sb:AppendFormatLine("\230\138\165\229\144\141\232\186\171\228\187\189:%s", self.selfPlayerState)
  sb:AppendFormatLine("Role:%s", self.selfRoleId)
  sb:AppendFormatLine("Group:%s", self.selfGroupId)
  if self.selfLastEnterBattleTime == 0 then
    sb:AppendFormatLine("\228\184\138\230\172\161\232\191\155\229\133\165\230\136\152\229\156\186\231\154\132\230\151\182\233\151\180:\230\151\160")
  elseif self.selfLastEnterBattleTime < 0 then
    sb:AppendFormatLine("\228\184\138\230\172\161\232\191\155\229\133\165\230\136\152\229\156\186\231\154\132\230\151\182\233\151\180:\229\183\178\231\166\187\229\188\128\230\136\152\229\156\186")
  else
    sb:AppendFormatLine("\228\184\138\230\172\161\232\191\155\229\133\165\230\136\152\229\156\186\231\154\132\230\151\182\233\151\180:%s", UITimeManager:GetInstance():TimeStampToTimeForServer(self.selfLastEnterBattleTime * 1000))
  end
  sb:AppendFormatLine("\230\142\146\229\144\141(\230\156\128\232\191\145\232\175\183\230\177\130\232\175\183\230\177\130\229\136\176\231\154\132):%s", self.selfRank)
  if self.selfScore then
    sb:AppendFormatLine("\231\167\175\229\136\134\228\191\161\230\129\175")
    sb:AppendFormatLine("--\230\128\187\231\167\175\229\136\134(score):%s", self.selfScore.score)
    sb:AppendFormatLine("--\230\136\152\230\150\151(battleScore):%s", self.selfScore.battleScore)
    sb:AppendFormatLine("--\229\141\143\229\138\169(cooperationScore):%s", self.selfScore.cooperationScore)
    sb:AppendFormatLine("--\230\136\152\231\149\165(tacticsScore):%s", self.selfScore.tacticsScore)
  end
  sb:AppendFormatLine("--------------------------------")
  sb:AppendFormatLine("\230\136\152\229\156\186\229\134\133\230\136\145\231\154\132\232\129\148\231\155\159\231\154\132\230\131\133\229\134\181")
  if self.allianceInfo == nil then
    sb:AppendFormatLine("\230\151\160")
  else
    sb:AppendFormatLine("\230\152\175\229\144\166\228\185\159\230\152\175\230\136\145\229\156\168\231\154\132\233\152\159\228\188\141:%s", self.allianceInfo.team == self.selfTeamId)
    sb:AppendFormatLine("team:%s", self.allianceInfo.team)
    sb:AppendFormatLine("role:%s", self.allianceInfo.role)
    sb:AppendFormatLine("score:%s", self.allianceInfo.score)
    sb:AppendFormatLine("rank:%s", self.allianceInfo.rank)
    sb:AppendFormatLine("member:%s", self.allianceInfo.member)
  end
  return sb:ToString()
end

return BattlefieldDsbDuelMyInfo
