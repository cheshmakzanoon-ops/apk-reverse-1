local base = require("DataCenter.LWBeginnerDirectorManager.LWBeginnerDirectorChapterBase")
local LWBeginnerDirectorChapterCityFight2 = BaseClass("LWBeginnerDirectorChapterCityFight2", base)

function LWBeginnerDirectorChapterCityFight2:__init()
  self.directorScript = {
    {
      Id = 1,
      PointType = BeginnerScriptPointType.GuideFLow,
      Params = {6009},
      Conditions = {
        [BeginnerScriptPointTriggerType.Time] = {0}
      }
    }
  }
  self.chapterName = "LWBeginnerDirectorChapterCityFight2"
end

function LWBeginnerDirectorChapterCityFight2:__delete()
  self.directorScript = nil
end

return LWBeginnerDirectorChapterCityFight2
