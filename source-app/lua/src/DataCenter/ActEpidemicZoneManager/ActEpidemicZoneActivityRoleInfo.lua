local ActEpidemicZoneActivityRoleInfo = BaseClass("ActEpidemicZoneActivityRoleInfo")

function ActEpidemicZoneActivityRoleInfo:__init()
  self.side = EpidemicBattleSide.Default
  self.role = EpidemicZoneRole.Default
  self.allianceId = nil
  self.oneself = nil
  self.serverId = nil
  self.name = nil
  self.abbr = nil
  self.icon = nil
  self.skills = nil
  self.arbiter = nil
  self.randomSkillId = -1
end

function ActEpidemicZoneActivityRoleInfo:__delete()
  self.side = nil
  self.allianceId = nil
  self.oneself = nil
  self.serverId = nil
  self.name = nil
  self.abbr = nil
  self.icon = nil
  self.skills = nil
  self.arbiter = nil
end

function ActEpidemicZoneActivityRoleInfo:Update(_role)
  self.side = _role.side or EpidemicBattleSide.Default
  self.role = self.side
  if self.role > EpidemicZoneRole.Farmer then
    self.role = EpidemicZoneRole.Farmer
  end
  self.allianceId = _role.allianceId
  self.oneself = LuaEntry.Player:GetAllianceUid() == _role.allianceId
  self.serverId = _role.serverId
  self.name = _role.allianceName
  self.abbr = _role.abbr
  self.icon = _role.icon
  if _role.skills then
    self.skills = {}
    for __, _skill in ipairs(_role.skills) do
      table.insert(self.skills, _skill)
      if self.role == EpidemicZoneRole.Lord then
        local temp = DataCenter.ActEpidemicZoneManager:GetTemplateSkillById(_skill)
        if temp and temp.lordRandomPassive then
          self.randomSkillId = _skill
        end
      end
    end
  else
    self.skills = nil
  end
  if _role.arbiter then
    self.arbiter = {}
    self.arbiter.uid = _role.arbiter.uid
    self.arbiter.name = _role.arbiter.name
    self.arbiter.abbr = _role.arbiter.abbr
    self.arbiter.pic = _role.arbiter.pic
    self.arbiter.picVer = _role.arbiter.picVer
    self.arbiter.allianceId = _role.arbiter.allianceId
    self.arbiter.serverId = _role.arbiter.serverId
    self.arbiter.headSkinId = _role.arbiter.headSkinId
    self.arbiter.headSkinET = _role.arbiter.headSkinET
    self.arbiter.arbiterCdTime = _role.arbiter.arbiterCdTime
  else
    self.arbiter = nil
  end
end

function ActEpidemicZoneActivityRoleInfo:Description()
  local sb = StringBuilder.New()
  local sideConvert = {
    [EpidemicBattleSide.Default] = "\230\151\160(0)",
    [EpidemicBattleSide.Lord] = "\229\156\176\228\184\187(1)",
    [EpidemicBattleSide.FarmerL] = "\229\134\156\230\176\145(\229\183\166)(2)",
    [EpidemicBattleSide.FarmerR] = "\229\134\156\230\176\145(\229\143\179)(2)"
  }
  local roleConvert = {
    [EpidemicZoneRole.Default] = "\230\151\160(0)",
    [EpidemicZoneRole.Lord] = "\229\156\176\228\184\187(1)",
    [EpidemicZoneRole.Farmer] = "\229\134\156\230\176\145(2)"
  }
  sb:AppendFormatLine("side:%s\239\188\140role:%s, \229\144\141\231\167\176:%s[%s], \232\135\170\229\183\177:[%s]", sideConvert[self.side] or self.side, roleConvert[self.role] or self.role, self.name, self.abbr, self.oneself and "\226\136\154" or "\195\151")
  sb:AppendFormatLine("sId:%s, aId", self.serverId, self.allianceId)
  sb:AppendFormatLine("\230\151\151\229\184\156:%s", self.icon)
  sb:AppendFormatLine("\230\138\128\232\131\189\230\149\176:%s", self.skills and #self.skills or 0)
  sb:AppendFormatLine("\233\154\143\230\156\186\232\162\171\229\138\168(\229\156\176\228\184\187):%s", self.randomSkillId)
  sb:AppendFormatLine("\232\163\129\229\134\179\232\128\133:%s", self.arbiter and self.arbiter.name or "-")
  sb:AppendFormatLine("\232\163\129\229\134\179\232\128\133\229\134\183\229\141\180:%s", self.arbiter and self.arbiter.arbiterCdTime or 0)
  return sb:ToString()
end

return ActEpidemicZoneActivityRoleInfo
