local SeasonCampDestroyServerInfo = BaseClass("SeasonCampDestroyServerInfo")

function SeasonCampDestroyServerInfo:__init(mgr)
  self.mgr = mgr
  self.index = 0
  self.camp = 0
  self.server = 0
  self.city = 0
  self.ruins = 0
  self.isMyServer = false
  self.allianceRank = nil
end

function SeasonCampDestroyServerInfo:__delete()
  self.mgr = nil
  self.index = nil
  self.camp = nil
  self.server = nil
  self.city = nil
  self.ruins = nil
  self.isMyServer = nil
  self.allianceRank = nil
end

function SeasonCampDestroyServerInfo:Update(info)
  self.mgr = DataCenter.SeasonCampDestroyManager
  self.index = info.gridId
  self.camp = info.campId
  self.server = info.serverId
  self.city = info.city or 0
  self.ruins = info.ruins or 0
  self.isMyServer = info.isMyServer or false
end

function SeasonCampDestroyServerInfo:UpdateServerDetail(info)
  if not info then
    return
  end
  self.camp = info.campId or self.camp
  self.city = info.totalCityCount or self.city
  self.ruins = info.destroyedCityCount or self.ruins
  if info.rankInfo then
    self.allianceRank = {}
    for _, v in ipairs(info.rankInfo) do
      local item = {}
      item.rank = v.rank
      item.damage = tonumber(v.score) or 0
      item.serverId = info.targetServerId
      item.camp = info.campId
      if v.alliance then
        item.allianceId = v.alliance.allianceId
        item.allianceName = v.alliance.name
        item.allianceAbbr = v.alliance.abbr
        item.allianceIcon = v.alliance.icon
      end
      table.insert(self.allianceRank, item)
    end
  end
end

function SeasonCampDestroyServerInfo:RequestServerDetail()
  if self.mgr then
    self.mgr:SendGetServerInfo(self.server)
  end
end

function SeasonCampDestroyServerInfo:GetAllianceRank()
  return self.allianceRank
end

function SeasonCampDestroyServerInfo:Description()
  local myFlag = self.isMyServer and "*" or " "
  return string.format("[Grid:%s]%s Server:%s Camp:%s City:%s Ruins:%s", self.index, myFlag, self.server, self.camp, self.city, self.ruins)
end

return SeasonCampDestroyServerInfo
