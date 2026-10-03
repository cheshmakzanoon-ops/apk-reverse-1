local ActEpidemicZoneActivityBattleHistoryInfo = BaseClass("ActEpidemicZoneActivityBattleHistoryInfo")

function ActEpidemicZoneActivityBattleHistoryInfo:__init()
  self.battleTime = 0
  self.isWin = false
  self.mvp = nil
  self.members = {}
  self.roles = {}
  self.myRole = nil
end

function ActEpidemicZoneActivityBattleHistoryInfo:__delete()
end

function ActEpidemicZoneActivityBattleHistoryInfo:Update(msg)
  self.battleTime = msg.battleTime
  self.isWin = msg.isWin
  self.members = {}
  self.roles = {}
  if msg.mvp then
    self.mvp = {}
    self.mvp.uid = msg.mvp.uid
    self.mvp.name = msg.mvp.name
    self.mvp.serverId = msg.mvp.serverId
    self.mvp.pic = msg.mvp.pic
    self.mvp.picVer = msg.mvp.picVer
  end
  local myAlliance = LuaEntry.Player.allianceId
  local farmScore, farmMember
  for k, member in ipairs(msg.alliances) do
    local _ = {
      allianceId = member.allianceId,
      oneself = member.allianceId == myAlliance,
      name = member.name,
      abbr = member.abbr,
      icon = member.icon,
      score = member.score,
      server = member.server,
      memberCount = member.memberCount,
      side = member.side,
      role = ActEpidemicUtils.GetRole(member.side),
      group = member.group
    }
    if not farmScore and _.role == EpidemicZoneRole.Farmer then
      farmScore = member.score or 0
      farmMember = member.memberCount or 0
    end
    if _.oneself then
      self.myRole = _.role
    end
    self.members[_.side] = _
    local _r = self.roles[_.role]
    if not _r then
      _r = {}
      self.roles[_.role] = _r
      _r.memberCount = 0
      _r.score = 0
      _r.sideCount = 0
    end
    _r.memberCount = _r.memberCount + _.memberCount
    _r.score = _r.score + _.score
    _r.sideCount = _r.sideCount + 1
  end
  local farm = self.roles[EpidemicZoneRole.Farmer]
  if farm then
    farm.memberCount = farmMember or 0
    farm.score = farmScore or 0
  end
end

return ActEpidemicZoneActivityBattleHistoryInfo
