local BattlefieldDsbDuelBattleRole = BaseClass("BattlefieldDsbDuelBattleRole")
local Localization = CS.GameEntry.Localization

function BattlefieldDsbDuelBattleRole:__init(role)
  self.role = role
  self.rank = 0
  self.speed = 0
  self.memberCount = 0
  self.allianceId = ""
  self.allianceName = ""
  self.allianceAbbr = ""
  self.allianceIcon = ""
  self.allianceServer = 0
  self.battleResultScore = 0
  self.score = 0
  self.occupiedScore = 0
  self.resourceScore = 0
  self.plunderScore = 0
  BattlefieldDsbDuelUtils.Log("\229\136\157\229\167\139\229\140\150\228\186\134\230\136\152\229\156\186\232\167\146\232\137\178:%s", role)
end

function BattlefieldDsbDuelBattleRole:__delete()
  self.role = nil
  self.rank = nil
  self.speed = nil
  self.memberCount = nil
  self.allianceId = nil
  self.allianceName = nil
  self.allianceAbbr = nil
  self.allianceIcon = nil
  self.allianceServer = nil
  self.battleResultScore = nil
  self.score = nil
  self.occupiedScore = nil
  self.resourceScore = nil
  self.plunderScore = nil
end

function BattlefieldDsbDuelBattleRole:UpdateFromEnterMsg(info)
  self.memberCount = info.count
  self.score = info.score
  self.speed = info.speed
  self.allianceId = info.allianceId
  self.allianceName = info.name
  self.allianceAbbr = info.abbr
  self.allianceIcon = info.icon
  self.allianceServer = info.serverId
  BattlefieldDsbDuelUtils.Log("\230\136\152\229\156\186\232\167\146\232\137\178:%s\228\187\142\232\191\155\229\133\165\230\136\152\229\156\186\230\182\136\230\129\175\228\184\173\230\155\180\230\150\176\228\186\134\230\149\176\230\141\174", self.role)
end

function BattlefieldDsbDuelBattleRole:UpdateFromUpdateScoreMsg(msg)
  self.score = msg.score
  self.speed = msg.speed
  self.memberCount = msg.count
  BattlefieldDsbDuelUtils.Log("\230\136\152\229\156\186\232\167\146\232\137\178:%s\228\187\142\230\136\152\229\156\186\231\167\175\229\136\134\230\155\180\230\150\176\230\182\136\230\129\175\228\184\173\229\136\183\230\150\176\228\186\134\230\149\176\230\141\174", self.role)
end

function BattlefieldDsbDuelBattleRole:Description()
  local sb = StringBuilder.New()
  sb:AppendFormatLine("role:%s, member:%s, allianceAbbr:%s", self.role, self.memberCount, self.allianceAbbr)
  sb:AppendFormatLine("battleResultScore:%s, score:%s, occupiedScore:%s, resourceScore:%s, plunderScore:%s", self.battleResultScore, self.score, self.occupiedScore, self.resourceScore, self.plunderScore)
  return sb:ToString()
end

return BattlefieldDsbDuelBattleRole
