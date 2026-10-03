local SeasonCampDestroyCampInfo = BaseClass("SeasonCampDestroyCampInfo")
local SeasonCampDestroyServerInfo = require("UI.LWSeason6.SeasonCampDestroy.Data.SeasonCampDestroyServerInfo")

function SeasonCampDestroyCampInfo:__init(mgr)
  self.mgr = mgr
  self.type = 0
  self.score = 0
end

function SeasonCampDestroyCampInfo:__delete()
  self.mgr = nil
  self.type = nil
  self.score = nil
end

function SeasonCampDestroyCampInfo:Update(info)
  self.type = info.campId
  self.score = info.value
end

function SeasonCampDestroyCampInfo:Description()
  return string.format("[Camp:%s] Score:%s", self.type, self.score)
end

return SeasonCampDestroyCampInfo
