local base = require("DataCenter.LWBeginnerDirectorManager.LWBeginnerDirectorChapterBase")
local LWBeginnerDirectorChapterCityFight3 = BaseClass("LWBeginnerDirectorChapterCityFight3", base)

function LWBeginnerDirectorChapterCityFight3:__init()
  self.directorScript = {
    {
      Id = 1,
      PointType = BeginnerScriptPointType.GuideFLow,
      Params = {6010},
      Conditions = {
        [BeginnerScriptPointTriggerType.Time] = {0}
      }
    }
  }
  self.chapterName = "LWBeginnerDirectorChapterCityFight3"
end

function LWBeginnerDirectorChapterCityFight3:__delete()
  self.directorScript = nil
end

return LWBeginnerDirectorChapterCityFight3
