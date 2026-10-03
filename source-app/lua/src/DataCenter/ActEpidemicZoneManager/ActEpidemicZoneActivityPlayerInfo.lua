local ActEpidemicZoneActivityPlayerInfo = BaseClass("ActEpidemicZoneActivityPlayerInfo")

function ActEpidemicZoneActivityPlayerInfo:__init(uid)
  self.uid = uid
  self.group = 0
  self.state = 0
  self.apply = 0
  self.power = 0
  self.rank = 0
  self.chooseTimeList = {}
end

function ActEpidemicZoneActivityPlayerInfo:__delete()
end

function ActEpidemicZoneActivityPlayerInfo:Update(_role)
end

function ActEpidemicZoneActivityPlayerInfo:UpdateFromMsg(user)
  self.group = user.group
  self.power = user.power
  self.state = user.state
  self.apply = user.apply
  self.name = user.name
  self.abbr = user.abbr
  self.headSkinId = user.headSkinId
  self.headSkinEt = user.headSkinEt
  self.lv = user.lv
  self.chooseTimeList = {}
  if user.chooseTimeList then
    table.insertto(self.chooseTimeList, user.chooseTimeList)
  end
end

function ActEpidemicZoneActivityPlayerInfo:UpdateAllianceMember(member)
  self.power = member.power or 0
  self.name = member.name
  self.online = member.online
end

function ActEpidemicZoneActivityPlayerInfo:RefreshGroupAndState(group, state)
  self.group = group
  self.state = state
end

function ActEpidemicZoneActivityPlayerInfo:IsContainerBattleTime(battlePeriod)
  for _, v in ipairs(self.chooseTimeList or {}) do
    if v == battlePeriod then
      return true
    end
  end
  return false
end

function ActEpidemicZoneActivityPlayerInfo:Description()
  local sb = StringBuilder.New()
  sb:AppendFormat("name:%s, uid:%s, rank:%s, group:%s, state:%s, apply:%s, online:%s", self.name, self.uid, self.rank, self.group, self.state, self.apply, self.online)
  return sb:ToString()
end

return ActEpidemicZoneActivityPlayerInfo
