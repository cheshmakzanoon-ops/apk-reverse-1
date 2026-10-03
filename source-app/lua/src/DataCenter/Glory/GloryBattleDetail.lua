local GloryBattleDetail = BaseClass("GloryBattleDetail")

local function __init(self)
  self.t = 0
  self.p = {}
  self.allianceId = ""
  self.ct = 0
end

local function ParseServerData(self, serverData)
  if serverData.t then
    self.t = serverData.t
  end
  if serverData.p then
    self.p = serverData.p
  end
  if serverData.allianceId then
    self.allianceId = serverData.allianceId
  end
  if serverData.ct then
    self.ct = serverData.ct
  end
end

GloryBattleDetail.__init = __init
GloryBattleDetail.ParseServerData = ParseServerData
return GloryBattleDetail
