local base = require("DataCenter.LWBeginnerDirectorManager.LWBeginnerDirectorChapterBase")
local LWBeginnerDirectorChapterBigWorldKillZombieStage = BaseClass("LWBeginnerDirectorChapterBigWorldKillZombieStage", base)

function LWBeginnerDirectorChapterBigWorldKillZombieStage:__init()
  self.directorScript = {
    {
      Id = 1,
      PointType = BeginnerScriptPointType.GuideFLow,
      Params = {6006},
      Conditions = {
        [BeginnerScriptPointTriggerType.Time] = {0}
      }
    },
    {
      Id = 2,
      PointType = BeginnerScriptPointType.GuideFLow,
      Params = {6007},
      Conditions = {
        [BeginnerScriptPointTriggerType.TaskAllReceived] = {1}
      }
    }
  }
  self.chapterName = "LWBeginnerDirectorChapterBigWorldKillZombieStage"
end

function LWBeginnerDirectorChapterBigWorldKillZombieStage:__delete()
  self.directorScript = nil
end

return LWBeginnerDirectorChapterBigWorldKillZombieStage
