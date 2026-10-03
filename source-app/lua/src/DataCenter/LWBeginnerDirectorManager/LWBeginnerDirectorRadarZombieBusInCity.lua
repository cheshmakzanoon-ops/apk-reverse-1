local base = require("DataCenter.LWBeginnerDirectorManager.LWBeginnerDirectorChapterBase")
local LWBeginnerDirectorRadarZombieBusInCity = BaseClass("LWBeginnerDirectorRadarZombieBusInCity", base)

function LWBeginnerDirectorRadarZombieBusInCity:__init()
  self.directorScript = {}
  self.chapterName = "LWBeginnerDirectorRadarZombieBusInCity"
end

function LWBeginnerDirectorRadarZombieBusInCity:__delete()
  self.directorScript = nil
end

return LWBeginnerDirectorRadarZombieBusInCity
