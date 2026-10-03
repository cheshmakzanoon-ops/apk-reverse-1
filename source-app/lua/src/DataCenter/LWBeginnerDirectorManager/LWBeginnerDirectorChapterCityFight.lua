local base = require("DataCenter.LWBeginnerDirectorManager.LWBeginnerDirectorChapterBase")
local LWBeginnerDirectorChapterCityFight = BaseClass("LWBeginnerDirectorChapterCityFight", base)

function LWBeginnerDirectorChapterCityFight:__init()
  self.directorScript = {
    {
      Id = 1,
      PointType = BeginnerScriptPointType.GuideFLow,
      Params = {6008},
      Conditions = {
        [BeginnerScriptPointTriggerType.Time] = {0}
      }
    }
  }
  self.chapterName = "LWBeginnerDirectorChapterCityFight"
end

function LWBeginnerDirectorChapterCityFight:__delete()
  self.directorScript = nil
end

return LWBeginnerDirectorChapterCityFight
